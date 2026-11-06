import mysql.connector
from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__, static_folder='static', static_url_path='')

# Configuration dictionary to avoid repeating code
db_config = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': '',
    'database': 'perfect_match'
}

def get_db_and_cursor():
    """Returns a tuple of (connection, cursor) so both stay alive together."""
    conn = mysql.connector.connect(**db_config)
    cur = conn.cursor()
    return conn, cur

# 1. Fetch the active connection and its cursor together
conn, cur = get_db_and_cursor()

# 2. Execute your query
cur.execute("SHOW TABLES")
print([t[0] for t in cur.fetchall()])

# 3. Clean up and close both properly
cur.close()
conn.close()
