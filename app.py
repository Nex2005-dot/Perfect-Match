"""
PERFECT MATCH - Backend (Student Version)
=========================================
Tech: Python + Flask + PostgreSQL (Supabase) + Pillow (image handling)

What it does:
  1. Serves your HTML/CSS/JS files from the  frontend/  folder
  2. Register / Login / Logout (passwords are hashed, login uses a session cookie)
  3. Checks that a photo has exactly ONE face (OpenCV), then analyzes it
     -> skin tone, undertone, skin type, makeup palette
  4. Saves / lists / deletes analyses (history page)
  5. Profile: update name+email, change password, delete account

Run it:
    pip install -r requirements.txt
    python app.py
    open http://127.0.0.1:5000
"""

import base64
import colorsys
import io
import json
import os
import re
import psycopg2
from psycopg2.extras import RealDictCursor
import uuid
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from functools import wraps
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

import cv2                      # face detection (opencv-python-headless)
import numpy as np
from flask import Flask, g, jsonify, request, send_from_directory, session
from PIL import Image
from werkzeug.security import check_password_hash, generate_password_hash

# ------------------------------------------------------------------
# 1. SETUP
# ------------------------------------------------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

FRONTEND_DIR = os.path.join(BASE_DIR, "frontend")

app = Flask(__name__, static_folder=None)
app.secret_key = os.environ.get("SECRET_KEY", "change-this-secret-before-deploying")
app.config["MAX_CONTENT_LENGTH"] = 15 * 1024 * 1024  # reject requests > 15 MB

EMAIL_PATTERN = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")


# ------------------------------------------------------------------
# 2. DATABASE (PostgreSQL / Supabase)
# ------------------------------------------------------------------
class DB:
    """PostgreSQL wrapper retaining the application's ? parameter syntax."""
    def __init__(self, conn):
        self.conn = conn

    def execute(self, sql, params=()):
        cur = self.conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(sql.replace("?", "%s"), tuple(params))
        return cur

    def commit(self):
        self.conn.commit()

    def close(self):
        self.conn.close()


def connect_postgres():
    database_url = os.environ.get("DATABASE_URL")
    if not database_url:
        raise RuntimeError("DATABASE_URL is missing. Set it to your Supabase PostgreSQL connection URI.")
    return psycopg2.connect(database_url, sslmode="require")


def get_db():
    """Open one database connection per request."""
    if "db" not in g:
        g.db = DB(connect_postgres())
    return g.db


@app.teardown_appcontext
def close_db(error=None):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def init_db():
    """Ensure the saved analyses table exists without overwriting imported data."""
    conn = connect_postgres()
    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute("""
                    CREATE TABLE IF NOT EXISTS public.analyses (
                        id VARCHAR(20) PRIMARY KEY,
                        user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
                        created_at VARCHAR(25) NOT NULL,
                        skin_tone VARCHAR(100) NOT NULL,
                        skin_type VARCHAR(50) NOT NULL,
                        undertone VARCHAR(20) NOT NULL,
                        confidence INTEGER NOT NULL,
                        palette_json TEXT NOT NULL,
                        image_data TEXT NULL
                    )
                """)
                cur.execute("ALTER TABLE public.analyses ADD COLUMN IF NOT EXISTS image_data TEXT")
    finally:
        conn.close()


# ------------------------------------------------------------------
# 3. SMALL HELPERS
# ------------------------------------------------------------------
def error(message, status=400, code=None):
    """JSON error. 'code' lets the frontend show a specific message (e.g. "no_face")."""
    body = {"error": message}
    if code:
        body["code"] = code
    return jsonify(body), status


def pretty_date(iso_string):
    """'2026-09-08T10:30:00' -> 'September 8, 2026' (same style as the frontend)."""
    dt = datetime.fromisoformat(str(iso_string))
    return f"{dt:%B} {dt.day}, {dt.year}"


def login_required(view):
    """Put @login_required above a route to block people who aren't logged in."""
    @wraps(view)
    def wrapper(*args, **kwargs):
        if "user_id" not in session:
            return error("Please log in first.", 401)
        return view(*args, **kwargs)
    return wrapper


def current_user_row():
    return get_db().execute(
        "SELECT * FROM users WHERE id = ?", (session.get("user_id"),)
    ).fetchone()


def user_to_dict(row):
    """Same shape as the user object your app.js already expects."""
    total = get_db().execute(
        "SELECT COUNT(*) AS n FROM analyses WHERE user_id = ?", (row["id"],)
    ).fetchone()["n"]
    parts = [row["first_name"], row["middle_name"], row["last_name"], row["name_extension"]]
    return {
        "id": row["id"],
        "fullName": " ".join(p for p in parts if p),
        "username": row["username"],
        "email": row["email"],
        "createdAt": str(row["created_at"])[:10],
        "totalAnalyses": total,
    }


# ------------------------------------------------------------------
# 4. AUTH ROUTES
# ------------------------------------------------------------------
@app.post("/api/logout")
def logout():
    session.clear()
    return jsonify({"message": "Logged out."})


@app.post("/api/forgot-password")
def forgot_password():
    # Student version: we don't send real emails. We always give the same
    # answer so nobody can use this to find out which emails are registered.
    return jsonify({"message": "If that email exists, a reset link has been sent."})


# ------------------------------------------------------------------
# 5. PROFILE ROUTES
# ------------------------------------------------------------------
@app.get("/api/me")
def me():
    """Frontend calls this on page load to know if someone is logged in."""
    if "user_id" not in session:
        return jsonify({"user": None})
    user = current_user_row()
    if user is None:                       # account was deleted
        session.clear()
        return jsonify({"user": None})
    return jsonify({"user": user_to_dict(user)})


@app.put("/api/me")
@login_required
def update_profile():
    data = request.get_json(silent=True) or {}
    name = (data.get("fullName") or "").strip()
    email = (data.get("email") or "").strip().lower()

    if len(name) < 2:
        return error("Name must be at least 2 characters.")
    if not EMAIL_PATTERN.match(email):
        return error("Please enter a valid email address.")

    db = get_db()
    taken = db.execute(
        "SELECT id FROM users WHERE email = ? AND id != ?", (email, session["user_id"])
    ).fetchone()
    if taken:
        return error("That email is already used by another account.", 409)

    first, _, last = name.partition(" ")      # "Ana Dela Cruz" -> "Ana" + "Dela Cruz"
    db.execute(
        "UPDATE users SET first_name = ?, middle_name = NULL, last_name = ?, "
        "name_extension = NULL, email = ? WHERE id = ?",
        (first, last or first, email, session["user_id"]),
    )
    db.commit()
    return jsonify({"user": user_to_dict(current_user_row())})


@app.put("/api/password")
@login_required
def change_password():
    data = request.get_json(silent=True) or {}
    current = data.get("currentPassword") or ""
    new = data.get("newPassword") or ""

    user = current_user_row()
    if not check_password_hash(user["password"], current):
        return error("Current password is incorrect.", 401)
    if len(new) < 8:
        return error("New password must be at least 8 characters.")

    db = get_db()
    db.execute(
        "UPDATE users SET password = ? WHERE id = ?",
        (generate_password_hash(new), user["id"]),
    )
    db.commit()
    return jsonify({"message": "Password updated."})


@app.delete("/api/me")
@login_required
def delete_account():
    db = get_db()
    db.execute("DELETE FROM users WHERE id = ?", (session["user_id"],))  # analyses go too (CASCADE)
    db.commit()
    session.clear()
    return jsonify({"message": "Account deleted."})


# ------------------------------------------------------------------
# 6. SKIN ANALYSIS
# ------------------------------------------------------------------
# NOTE FOR YOUR DEFENSE / PAPER:
# This is a simple, rule-based approach (average color of the face area).
# It is NOT a medical tool, and results change with lighting. Before analyzing,
# we make sure the photo really contains ONE face (OpenCV Haar cascade), and
# we sample the skin from inside that face. A more advanced version could use
# MediaPipe to find the exact cheeks/forehead.

class PhotoError(ValueError):
    """A problem with the photo that the user can fix. 'code' tells the frontend which message to show."""
    def __init__(self, message, code="invalid_image"):
        super().__init__(message)
        self.code = code


# Load the face detector once when the server starts (not on every request).
_cascade_path = os.path.join(cv2.data.haarcascades, "haarcascade_frontalface_alt2.xml")
FACE_CASCADE = cv2.CascadeClassifier(_cascade_path)
if FACE_CASCADE.empty():
    raise RuntimeError("Could not load the OpenCV face detector: " + _cascade_path)


def detect_faces(img):
    """Return a list of (x, y, w, h) boxes - one per face found in a PIL image."""
    gray = cv2.cvtColor(np.array(img.convert("RGB")), cv2.COLOR_RGB2GRAY)
    gray = cv2.equalizeHist(gray)                      # helps with dim / uneven light
    min_side = int(min(gray.shape[:2]) * 0.15)         # ignore tiny "faces" in the background
    found = FACE_CASCADE.detectMultiScale(
        gray, scaleFactor=1.1, minNeighbors=5, minSize=(max(40, min_side), max(40, min_side))
    )
    faces = [tuple(int(v) for v in f) for f in found]
    if len(faces) > 1:
        # Keep only faces that are about as big as the biggest one. Tiny extra boxes
        # are usually false alarms (posters, patterns) and should not count as people.
        biggest = max(w * h for _, _, w, h in faces)
        faces = [f for f in faces if f[2] * f[3] >= biggest * 0.35]
    return faces


def lighting_of(img, face):
    """'dark', 'bright' or 'ok' - based on the brightness inside the face box."""
    x, y, w, h = face
    gray = np.array(img.convert("L"))[y:y + h, x:x + w]
    mean = float(gray.mean()) if gray.size else 128
    if mean < 70:
        return "dark"
    if mean > 215:
        return "bright"
    return "ok"


def find_single_face(img):
    """Return the one face in the photo, or raise PhotoError (no_face / multiple_faces)."""
    faces = detect_faces(img)
    if len(faces) == 0:
        raise PhotoError("We couldn't detect a face. Please use a clear, front-facing photo "
                         "with your whole face visible.", "no_face")
    if len(faces) > 1:
        raise PhotoError("Multiple faces detected. Please make sure only one face appears in the photo.",
                         "multiple_faces")
    return faces[0]

def decode_image(data_url):
    """Turn 'data:image/jpeg;base64,....' (what the frontend stores) into a PIL image."""
    if not data_url or not isinstance(data_url, str):
        raise ValueError("No image received.")
    encoded = data_url.split(",", 1)[1] if "," in data_url else data_url
    try:
        raw = base64.b64decode(encoded, validate=False)
    except Exception:
        raise ValueError("Image data is not valid.")
    if len(raw) > 10 * 1024 * 1024:
        raise ValueError("Image too large. Maximum file size is 10MB.")
    try:
        img = Image.open(io.BytesIO(raw))
        if img.format not in ("JPEG", "PNG"):
            raise ValueError("Invalid image. Please upload a JPG or PNG file.")
        img = img.convert("RGB")
    except ValueError:
        raise
    except Exception:
        raise ValueError("Invalid image. Please upload a JPG or PNG file.")
    if min(img.size) < 100:
        raise ValueError("Image is too small. Please use a clearer photo.")
    img.thumbnail((500, 500))      # smaller = faster
    return img


def looks_like_skin(r, g, b):
    """Very simple rule to ignore hair, background, eyes, etc."""
    return r > 60 and r > g > b and (r - b) > 15


def analyze_skin(img, face=None):
    w, h = img.size

    if face:
        # Sample the cheeks / forehead area INSIDE the detected face.
        fx, fy, fw, fh = face
        region = img.crop((fx + int(fw * 0.20), fy + int(fh * 0.20),
                           fx + int(fw * 0.80), fy + int(fh * 0.75)))
    else:
        # Fallback: the middle area of the photo where the face should be.
        region = img.crop((int(w * 0.30), int(h * 0.25), int(w * 0.70), int(h * 0.65)))
    pixels = list(region.getdata())
    skin = [p for p in pixels if looks_like_skin(*p)]

    if len(skin) < len(pixels) * 0.2:
        raise PhotoError("We couldn't read your skin color. Face the camera in good, even lighting.", "no_skin")

    # Average skin color
    r = sum(p[0] for p in skin) / len(skin)
    g = sum(p[1] for p in skin) / len(skin)
    b = sum(p[2] for p in skin) / len(skin)
    brightness = 0.299 * r + 0.587 * g + 0.114 * b

    # --- Skin tone (by brightness) ---
    if brightness >= 200:
        skin_tone = "Fair"
    elif brightness >= 170:
        skin_tone = "Light"
    elif brightness >= 140:
        skin_tone = "Light Morena"
    elif brightness >= 105:
        skin_tone = "Morena"
    else:
        skin_tone = "Dark"

    # --- Undertone (by hue: pinkish = cool, yellowish = warm) ---
    hue_degrees = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)[0] * 360
    if hue_degrees < 15:
        undertone = "Cool"
    elif hue_degrees < 25:
        undertone = "Neutral"
    else:
        undertone = "Warm"

    # --- Skin type (by how many "shiny" pixels there are) ---
    shiny = sum(1 for p in skin if (0.299 * p[0] + 0.587 * p[1] + 0.114 * p[2]) > brightness + 35)
    shine_ratio = shiny / len(skin)
    if shine_ratio < 0.02:
        skin_type = "Dry"
    elif shine_ratio < 0.06:
        skin_type = "Normal"
    elif shine_ratio < 0.14:
        skin_type = "Combination"
    else:
        skin_type = "Oily"

    # --- Confidence (lower it when the photo is hard to read) ---
    confidence = 90
    whole_brightness = sum(img.convert("L").getdata()) / (w * h)
    if whole_brightness < 70 or whole_brightness > 215:
        confidence -= 25                                   # too dark / too bright
    if len(skin) < len(pixels) * 0.5:
        confidence -= 10                                   # little skin visible
    confidence = max(50, min(95, confidence))

    return skin_tone, skin_type, undertone, confidence


# ---- Palette data ----
PALETTES = {
    "Warm": {
        "foundation": [("Warm Ivory", "#F5DEB3", "Perfect base for warm undertones."),
                       ("Golden Beige", "#D4A76A", "Provides a seamless, natural finish."),
                       ("Soft Sand", "#C8A882", "Great for a light, everyday look."),
                       ("Honey Beige", "#BF8D5C", "A golden medium shade for a warm complexion."),
                       ("Warm Tan", "#A9774F", "A deeper golden shade for a warm complexion.")],
        "blush": [("Warm Peach", "#FFAB76", "Adds a natural, sun-kissed glow."),
                  ("Coral Flush", "#E8835A", "Brightens warm undertones beautifully."),
                  ("Rose Nude", "#D4967A", "A soft, everyday blush for warm skin."),
                  ("Apricot Glow", "#F28F62", "A lively peach shade for a warm-toned look."),
                  ("Sunset Coral", "#D96E4F", "A deeper coral shade for extra warmth.")],
        "lip": [("Warm Rose", "#B76E79", "Complements warm undertones perfectly."),
                ("Terracotta", "#C0614B", "A bold, earthy statement color."),
                ("Nude Mauve", "#A07468", "A wearable, natural everyday shade."),
                ("Berry Bronze", "#8B4049", "Great for evening looks."),
                ("Spiced Rose", "#A94F42", "A deeper rosy shade with a warm finish.")],
        "concealer": [("Warm Ivory Concealer", "#F7E4C8", "A light warm shade for brightening."),
                      ("Golden Beige Concealer", "#DDB884", "A medium warm shade for blending."),
                      ("Honey Concealer", "#C99A64", "A golden shade for warm complexions."),
                      ("Caramel Concealer", "#A9754D", "A deeper warm shade for spot coverage."),
                      ("Deep Warm Concealer", "#805333", "A rich warm shade for deeper complexions.")],
        "color_corrector": [("Peach Corrector", "#F4A47E", "Helps balance mild blue or purple discoloration."),
                            ("Orange Corrector", "#E77B3C", "A deeper option for balancing blue or purple tones."),
                            ("Green Corrector", "#8DAA76", "Helps balance visible redness."),
                            ("Lavender Corrector", "#B49BC8", "Helps balance a dull or yellow-looking cast."),
                            ("Yellow Corrector", "#E8CA67", "Helps balance mild purple discoloration.")],
        "eyeshadow": [("Bronze Glow", "#8B6252", "Enhances warm, deep eye looks."),
                      ("Champagne", "#D4B896", "A soft highlight for the lid."),
                      ("Warm Taupe", "#9C7D6A", "Excellent for crease definition."),
                      ("Copper Shimmer", "#B87333", "Adds dimension and warmth."),
                      ("Olive Bronze", "#746044", "A muted bronze shade for a warmer eye look.")],
    },
    "Cool": {
        "foundation": [("Porcelain Rose", "#F3DCD4", "A soft base for pink undertones."),
                       ("Rosy Beige", "#E3BFAE", "Natural finish that avoids looking yellow."),
                       ("Cool Sand", "#CFA593", "A balanced everyday shade."),
                       ("Cool Porcelain", "#D9B6A8", "A soft, muted base for cool undertones."),
                       ("Cool Tan", "#B88C7D", "A deeper balanced shade for cool undertones.")],
        "blush": [("Soft Pink", "#F4A7B9", "A fresh, youthful flush."),
                  ("Rose Petal", "#E08CA0", "Adds gentle color to cool skin."),
                  ("Berry Flush", "#C96F8A", "Great for a deeper cheek color."),
                  ("Cool Berry", "#C16B8B", "A richer berry blush for a cool-toned look."),
                  ("Mauve Flush", "#A95F7B", "A muted deeper blush for cool undertones.")],
        "lip": [("Cool Rose", "#D4778A", "Harmonizes with pink undertones."),
                ("Raspberry", "#B03A5B", "A bright, confident shade."),
                ("Dusty Mauve", "#9C6B80", "Soft and elegant for daily wear."),
                ("Plum Wine", "#7B3F5E", "Perfect for evening looks."),
                ("Soft Plum", "#854B68", "A muted plum shade that complements cool tones.")],
        "concealer": [("Porcelain Rose Concealer", "#F5DED7", "A light rosy shade for brightening."),
                      ("Rosy Beige Concealer", "#D8B5A8", "A balanced cool shade for blending."),
                      ("Cool Sand Concealer", "#C69A8D", "A medium cool shade for spot coverage."),
                      ("Mauve Beige Concealer", "#A98278", "A deeper muted shade for cool complexions."),
                      ("Deep Cool Concealer", "#78564D", "A rich cool shade for deeper complexions.")],
        "color_corrector": [("Peach Corrector", "#F4A47E", "Helps balance mild blue or purple discoloration."),
                            ("Orange Corrector", "#E77B3C", "A deeper option for balancing blue or purple tones."),
                            ("Green Corrector", "#8DAA76", "Helps balance visible redness."),
                            ("Lavender Corrector", "#B49BC8", "Helps balance a dull or yellow-looking cast."),
                            ("Yellow Corrector", "#E8CA67", "Helps balance mild purple discoloration.")],
        "eyeshadow": [("Plum Smoke", "#7B5EA7", "Makes cool-toned eyes stand out."),
                      ("Dusty Lavender", "#B8A5C9", "A soft wash of color."),
                      ("Cool Taupe", "#8C7B80", "Good for crease definition."),
                      ("Silver Mist", "#C0C4CC", "A subtle shimmer for the lid."),
                      ("Slate Lavender", "#8F89A5", "A deeper lavender-gray for extra definition.")],
    },
    "Neutral": {
        "foundation": [("Natural Beige", "#EBCBAE", "Works with both warm and cool tones."),
                       ("Soft Honey", "#D6AE8A", "A balanced, natural finish."),
                       ("Light Almond", "#C79E7E", "A versatile everyday shade."),
                       ("Neutral Tan", "#B89070", "A medium neutral shade for a balanced finish."),
                       ("Neutral Deep", "#9B765E", "A deeper shade for a balanced neutral finish.")],
        "blush": [("Soft Rose", "#E8A0A0", "A gentle, universal flush."),
                  ("Dusty Peach", "#E5A58F", "Natural warmth without being orange."),
                  ("Mauve Pink", "#CC8E96", "Soft color for daily wear."),
                  ("Peach Rose", "#D88778", "A balanced peach-rose shade for an everyday flush."),
                  ("Soft Berry", "#B96F7C", "A deeper balanced shade for a stronger flush.")],
        "lip": [("Rosewood", "#A8575F", "A flattering muted rose."),
                ("Soft Berry", "#A04A62", "Adds color without being harsh."),
                ("Brick Rose", "#B25D50", "A warm-leaning neutral."),
                ("Nude Pink", "#C48B88", "An easy everyday nude."),
                ("Muted Plum", "#92586A", "A soft plum shade that works with neutral tones.")],
        "concealer": [("Neutral Ivory Concealer", "#F0D9C7", "A light neutral shade for brightening."),
                      ("Natural Beige Concealer", "#D8B590", "A balanced shade for blending."),
                      ("Almond Concealer", "#C39A78", "A medium neutral shade for spot coverage."),
                      ("Neutral Tan Concealer", "#A77B5B", "A deeper shade for neutral complexions."),
                      ("Deep Neutral Concealer", "#76543E", "A rich neutral shade for deeper complexions.")],
        "color_corrector": [("Peach Corrector", "#F4A47E", "Helps balance mild blue or purple discoloration."),
                            ("Orange Corrector", "#E77B3C", "A deeper option for balancing blue or purple tones."),
                            ("Green Corrector", "#8DAA76", "Helps balance visible redness."),
                            ("Lavender Corrector", "#B49BC8", "Helps balance a dull or yellow-looking cast."),
                            ("Yellow Corrector", "#E8CA67", "Helps balance mild purple discoloration.")],
        "eyeshadow": [("Soft Brown", "#8A6A5C", "A classic, easy-to-blend shade."),
                      ("Rose Gold", "#C99A8C", "Adds a pretty shimmer."),
                      ("Mocha", "#6F4E40", "Great for defining the crease."),
                      ("Champagne Pink", "#E0C4B8", "A soft highlight shade."),
                      ("Taupe Gray", "#81756F", "A balanced gray-brown shade for subtle definition.")],
    },
}

# How much to lighten (+) or darken (-) the foundation for each skin tone
FOUNDATION_SHIFT = {"Fair": 0.25, "Light": 0.10, "Light Morena": 0.0, "Morena": -0.15, "Dark": -0.35}


def shift_hex(hex_color, amount):
    """Lighten (amount > 0, mix with white) or darken (amount < 0, mix with black)."""
    r, g, b = (int(hex_color[i:i + 2], 16) for i in (1, 3, 5))
    target = 255 if amount > 0 else 0
    r, g, b = (round(c + (target - c) * abs(amount)) for c in (r, g, b))
    return f"#{r:02X}{g:02X}{b:02X}"


def build_palette(skin_tone, undertone):
    palette = {}
    for category, colors in PALETTES[undertone].items():
        palette[category] = []
        for name, hex_color, note in colors:
            if category == "foundation":
                hex_color = shift_hex(hex_color, FOUNDATION_SHIFT[skin_tone])
            palette[category].append({"name": name, "hex": hex_color, "note": note})
    return palette


# ------------------------------------------------------------------
# MAKEUP SUGGESTION ACCESS
# Guests see two of the five suggested colors. Three are locked until login.
# ------------------------------------------------------------------
GUEST_SHADES = 2


def limit_palette_for_guest(palette):
    """Returns (limited_palette, locked_counts). 'locked' = shades hidden from the guest."""
    limited, locked = {}, {}
    for category, shades in palette.items():
        limited[category] = shades[:GUEST_SHADES]
        locked[category] = max(len(shades) - GUEST_SHADES, 0)
    return limited, locked


# ------------------------------------------------------------------
# OPTIONAL MAKEUP API
# This public API does not require an API key. Built-in colors still work
# when the outside service is unavailable.
# ------------------------------------------------------------------
MAKEUP_API_CACHE = {"expires_at": 0, "products": {}}
MAKEUP_API_TYPES = {
    "foundation": "foundation",
    "blush": "blush",
    "concealer": "concealer",
    "lip": "lipstick",
    "eyeshadow": "eyeshadow",
}


def get_makeup_api_products():
    """Read makeup shade colors and cache them for 15 minutes."""
    now = datetime.now().timestamp()
    if now < MAKEUP_API_CACHE["expires_at"]:
        return MAKEUP_API_CACHE["products"]

    def fetch_category(item):
        category, product_type = item
        query = urlencode({"product_type": product_type})
        api_url = "https://makeup-api.herokuapp.com/api/v1/products.json?" + query
        # No API key is used or needed for this public API.
        api_request = Request(
            api_url,
            headers={"User-Agent": "PerfectMatch/1.0 (makeup shade suggestions)"},
        )
        with urlopen(api_request, timeout=3) as response:
            return category, json.loads(response.read().decode("utf-8"))

    # These requests do not depend on one another, so run them at the same time.
    with ThreadPoolExecutor(max_workers=len(MAKEUP_API_TYPES)) as executor:
        products_by_category = dict(executor.map(fetch_category, MAKEUP_API_TYPES.items()))

    MAKEUP_API_CACHE["products"] = products_by_category
    MAKEUP_API_CACHE["expires_at"] = now + 15 * 60
    return products_by_category


def color_distance(first_hex, second_hex):
    """Compare two colors using a simple RGB distance."""
    first = [int(first_hex[index:index + 2], 16) for index in (1, 3, 5)]
    second = [int(second_hex[index:index + 2], 16) for index in (1, 3, 5)]
    return sum((first[index] - second[index]) ** 2 for index in range(3))


def choose_api_shades(products, suggested_shades, limit=5):
    """Choose up to five API shades whose colors are close to the personal palette."""
    matches = []
    for product in products:
        for color in product.get("product_colors") or []:
            hex_color = (color.get("hex_value") or "").strip()
            if not re.fullmatch(r"#[0-9a-fA-F]{6}", hex_color):
                continue
            distance = min(color_distance(hex_color, shade["hex"]) for shade in suggested_shades)
            brand = (product.get("brand") or "").strip()
            product_name = (product.get("name") or "").strip()
            matches.append({
                "name": (color.get("colour_name") or "").strip() or "Makeup shade",
                "hex": hex_color.upper(),
                "note": "From " + " ".join(part for part in (brand, product_name) if part),
                "distance": distance,
            })

    matches.sort(key=lambda shade: shade["distance"])
    selected, seen_colors = [], set()
    for shade in matches:
        if shade["hex"] in seen_colors:
            continue
        seen_colors.add(shade["hex"])
        selected.append({key: value for key, value in shade.items() if key != "distance"})
        if len(selected) == limit:
            break
    return selected


def make_thumbnail(data_url):
    """Shrinks the photo (max 480px, JPEG) so it is small enough to store in the database."""
    if not data_url or "," not in data_url:
        return None
    try:
        raw = base64.b64decode(data_url.split(",", 1)[1])
        img = Image.open(io.BytesIO(raw)).convert("RGB")
        img.thumbnail((480, 480))
        buf = io.BytesIO()
        img.save(buf, "JPEG", quality=75)
        return "data:image/jpeg;base64," + base64.b64encode(buf.getvalue()).decode()
    except Exception:
        return None


@app.post("/api/detect-face")
def detect_face_route():
    """Quick check used by the camera (live) and after upload: is there exactly one face?
    Always answers 200 with {"faces": N, "ok": true/false, "code": ..., "message": ..., "lighting": ...}."""
    data = request.get_json(silent=True) or {}
    try:
        img = decode_image(data.get("image"))
    except ValueError as e:
        return jsonify({"ok": False, "faces": 0, "code": "invalid_image", "message": str(e)})

    faces = detect_faces(img)
    if len(faces) == 0:
        return jsonify({"ok": False, "faces": 0, "code": "no_face",
                        "message": "We couldn't detect a face."})
    if len(faces) > 1:
        return jsonify({"ok": False, "faces": len(faces), "code": "multiple_faces",
                        "message": "Multiple faces detected."})
    return jsonify({"ok": True, "faces": 1, "lighting": lighting_of(img, faces[0])})


@app.post("/api/analyze")
def analyze():
    """Works for guests too. It does NOT save anything - saving is a separate step."""
    data = request.get_json(silent=True) or {}
    try:
        img = decode_image(data.get("image"))
        face = find_single_face(img)                 # no face / many faces -> error
        skin_tone, skin_type, undertone, confidence = analyze_skin(img, face)
        if lighting_of(img, face) != "ok":
            confidence = max(50, confidence - 15)    # dark or washed-out photo = less sure
    except PhotoError as e:
        return error(str(e), 422, e.code)
    except ValueError as e:
        return error(str(e), 400, "invalid_image")

    palette = build_palette(skin_tone, undertone)
    is_guest = "user_id" not in session
    locked = {}
    if is_guest:
        palette, locked = limit_palette_for_guest(palette)   # enforced here, not just in the browser

    return jsonify({
        "date": pretty_date(datetime.now().isoformat(timespec="seconds")),
        "skinTone": skin_tone,
        "skinType": skin_type,
        "undertone": undertone,
        "confidence": confidence,
        "palette": palette,
        "guest": is_guest,
        "locked": locked,
    })


@app.get("/api/shades")
@login_required
def makeup_shades():
    """Return API shade colors close to the user's personalized palette."""
    skin_tone = (request.args.get("skinTone") or "").strip()
    undertone = (request.args.get("undertone") or "").strip()
    if skin_tone not in FOUNDATION_SHIFT or undertone not in PALETTES:
        return error("Please provide a valid skin tone and undertone.")

    palette = build_palette(skin_tone, undertone)
    api_available = True
    try:
        products = get_makeup_api_products()
    except (HTTPError, OSError, TimeoutError, json.JSONDecodeError, UnicodeDecodeError) as e:
        app.logger.warning("Makeup API request failed: %s", e)
        products = {category: [] for category in MAKEUP_API_TYPES}
        api_available = False

    api_shades = {}
    for category in MAKEUP_API_TYPES:
        api_shades[category] = choose_api_shades(products[category], palette[category])
    return jsonify({
        "palette": palette,
        "shades": api_shades,
        "apiAvailable": api_available,
        "source": "Makeup API",
        "sourceUrl": "https://makeup-api.herokuapp.com/",
    })


# ------------------------------------------------------------------
# 7. HISTORY ROUTES (saved analyses)
# ------------------------------------------------------------------
def analysis_to_dict(row, full=False):
    palette = json.loads(row["palette_json"]) if isinstance(row["palette_json"], str) else row["palette_json"]
    item = {
        "id": row["id"],
        "date": pretty_date(row["created_at"]),
        "createdAt": str(row["created_at"]),
        "skinTone": row["skin_tone"],
        "skinType": row["skin_type"],
        "undertone": row["undertone"],
        "confidence": row["confidence"],
        # the 4 little color dots shown on the history cards
        "palettePreview": [palette[k][0]["hex"] for k in ("lip", "blush", "foundation", "eyeshadow")],
        "image": row.get("image_data"),
    }
    if full:
        item["palette"] = palette
    return item


@app.post("/api/analyses")
@login_required
def save_analysis():
    """Logged-in users only (@login_required). Saves the result AND the photo."""
    data = request.get_json(silent=True) or {}
    palette = data.get("palette")
    required = ("skinTone", "skinType", "undertone")

    if not all(data.get(k) for k in required):
        return error("Missing analysis data.")
    if not isinstance(palette, dict) or not all(
        palette.get(k) for k in ("foundation", "blush", "lip", "eyeshadow")
    ):
        return error("Missing palette data.")

    # Logged-in users always store the FULL palette, even if they analyzed
    # the photo before logging in (when they only saw the guest shades).
    try:
        palette = build_palette(data["skinTone"], data["undertone"])
    except KeyError:
        pass                                   # unknown tone: keep what the browser sent

    analysis_id = "ana_" + uuid.uuid4().hex[:8]
    db = get_db()
    db.execute(
        """INSERT INTO analyses
           (id, user_id, created_at, skin_tone, skin_type, undertone, confidence, palette_json, image_data)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        (analysis_id, session["user_id"], datetime.now().isoformat(timespec="seconds"),
         data["skinTone"], data["skinType"], data["undertone"],
         int(data.get("confidence") or 0), json.dumps(palette),
         make_thumbnail(data.get("image"))),
    )
    db.commit()
    row = db.execute("SELECT * FROM analyses WHERE id = ?", (analysis_id,)).fetchone()
    return jsonify({"analysis": analysis_to_dict(row, full=True)}), 201


@app.get("/api/analyses")
@login_required
def list_analyses():
    """Optional query strings:  ?undertone=warm  ?q=morena  ?sort=newest|oldest|tone"""
    undertone = (request.args.get("undertone") or "").strip().lower()
    search = (request.args.get("q") or "").strip().lower()
    sort = request.args.get("sort", "newest")

    sql = "SELECT * FROM analyses WHERE user_id = ?"
    params = [session["user_id"]]

    if undertone and undertone != "all":
        sql += " AND LOWER(undertone) = ?"
        params.append(undertone)
    if search:
        sql += " AND (LOWER(skin_tone) LIKE ? OR LOWER(skin_type) LIKE ? OR LOWER(undertone) LIKE ?)"
        params += [f"%{search}%"] * 3

    order = {"newest": "created_at DESC", "oldest": "created_at ASC", "tone": "skin_tone ASC"}
    sql += " ORDER BY " + order.get(sort, "created_at DESC")   # only our own strings go in here

    rows = get_db().execute(sql, params).fetchall()
    return jsonify({"total": len(rows), "analyses": [analysis_to_dict(r) for r in rows]})


@app.get("/api/analyses/<analysis_id>")
@login_required
def get_analysis(analysis_id):
    row = get_db().execute(
        "SELECT * FROM analyses WHERE id = ? AND user_id = ?", (analysis_id, session["user_id"])
    ).fetchone()
    if row is None:
        return error("Analysis not found.", 404)
    return jsonify({"analysis": analysis_to_dict(row, full=True)})


@app.delete("/api/analyses/<analysis_id>")
@login_required
def delete_analysis(analysis_id):
    db = get_db()
    cur = db.execute(
        "DELETE FROM analyses WHERE id = ? AND user_id = ?", (analysis_id, session["user_id"])
    )
    db.commit()
    if cur.rowcount == 0:
        return error("Analysis not found.", 404)
    return jsonify({"message": "Analysis deleted."})


@app.delete("/api/analyses")
@login_required
def clear_history():
    db = get_db()
    db.execute("DELETE FROM analyses WHERE user_id = ?", (session["user_id"],))
    db.commit()
    return jsonify({"message": "History cleared."})


# ------------------------------------------------------------------
# 8. SERVE THE FRONTEND
# ------------------------------------------------------------------
@app.get("/")
def home():
    return send_from_directory(FRONTEND_DIR, "index.html")


@app.get("/<path:filename>")
def static_files(filename):
    if filename.startswith("api/"):
        return error("Not found.", 404)
    return send_from_directory(FRONTEND_DIR, filename)   # safe against ../ tricks


@app.errorhandler(413)
def too_large(e):
    return error("Image too large. Maximum file size is 10MB.", 413)


# Database tables were imported into Supabase; initialize only if needed.
init_db()

# ------------------------------------------------------------------
# 9. REGISTER + LOGIN (PostgreSQL)
# ------------------------------------------------------------------
@app.post("/api/register")
def register():
    data = request.get_json(silent=True) or {}
    first = (data.get("firstName") or "").strip()
    middle = (data.get("middleName") or "").strip() or None
    last = (data.get("lastName") or "").strip()
    ext = (data.get("nameExtension") or "").strip() or None
    username = (data.get("username") or "").strip()
    email = (data.get("email") or "").strip().lower()
    password = data.get("password") or ""

    if len(first) < 2 or len(last) < 2:
        return error("Please enter your first and last name.")
    if len(username) < 3:
        return error("Username must be at least 3 characters.")
    if not EMAIL_PATTERN.match(email):
        return error("Please enter a valid email address.")
    if len(password) < 8:
        return error("Password must be at least 8 characters.")

    db = get_db()

    if db.execute("SELECT id FROM users WHERE email = ?", (email,)).fetchone():
        body = {"error": "That email is already registered.", "field": "email"}
        return jsonify(body), 409
    if db.execute("SELECT id FROM users WHERE username = ?", (username,)).fetchone():
        body = {"error": "That username is taken.", "field": "username"}
        return jsonify(body), 409

    cursor = db.execute(
        "INSERT INTO users (first_name, middle_name, last_name, name_extension, "
        "username, email, password) VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING id",
        (first, middle, last, ext, username, email, generate_password_hash(password)),
    )
    new_user_id = cursor.fetchone()["id"]
    db.commit()

    session["user_id"] = new_user_id
    return jsonify({"user": user_to_dict(current_user_row())}), 201


@app.post("/api/login")
def login():
    data = request.get_json(silent=True) or {}
    email = (data.get("email") or "").strip().lower()
    password = data.get("password") or ""

    user = get_db().execute("SELECT * FROM users WHERE email = ?", (email,)).fetchone()

    # Same message for a wrong email or a wrong password (safer)
    if user is None or not check_password_hash(user["password"], password):
        return error("Invalid email or password.", 401)

    session["user_id"] = user["id"]
    return jsonify({"user": user_to_dict(user)})


if __name__ == "__main__":
    app.run(debug=True)