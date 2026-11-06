# Perfect Match

Perfect Match is a small Flask web application that suggests makeup colors based on a photo and lets users preview shades on their photo.

## Run the app

1. Install Python and MySQL.
2. Open a terminal in this project folder.
3. Install the Python packages:

   ```text
   pip install -r requirements.txt
   ```

4. Set up the MySQL database and user tables using `perfect_match.sql`.
5. Set your MySQL connection details and a private Flask secret key as environment variables:
   - `DB_HOST`
   - `DB_USER`
   - `DB_PASSWORD`
   - `DB_NAME`
   - `SECRET_KEY`

   In PowerShell, replace the example password and secret with your own values:

   ```powershell
   $env:DB_HOST = "localhost"
   $env:DB_USER = "root"
   $env:DB_PASSWORD = "your-mysql-password"
   $env:DB_NAME = "perfect_match"
   $env:SECRET_KEY = "your-private-secret"
   ```

   Run the next command in the same PowerShell window.

6. Start the website:

   ```text
   python app.py
   ```

7. Open `http://127.0.0.1:5000` in your browser.

## Makeup suggestions and custom colors

The try-on page offers five face-shape choices with makeup placement tips. Face shape is selected by the user; the app does not guess it from a photo.

Foundation, concealer, color corrector, blush, lipstick, and eyeshadow each have five color choices. Guests see two colors and three locked choices per category. Logging in unlocks all five.

Logged-in users can also load color swatches from the [Makeup API](https://makeup-api.herokuapp.com/) through the Flask `/api/shades` endpoint. The app selects colors close to its existing palette and keeps the same five-choice limit. It uses foundation, blush, concealer, lipstick, and eyeshadow data when the catalog has usable colors. It uses built-in suggestions when API colors are missing. The API calls are cached for 15 minutes and run in parallel.

**No API key is required or used.** The source code has a comment at the API request showing this. Do not place passwords or private keys in the Python source file.

Users can also choose a custom hex color and name inside any makeup control. Custom shades are saved in the current browser tab session; they are not stored in the account or database. Try-on suggestions are cosmetic guidance, not guaranteed shade matches or medical advice.
