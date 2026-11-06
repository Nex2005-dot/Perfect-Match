"""Optional Supabase PostgreSQL connection helper.
The main Flask application currently uses its own database connection.
"""
import os
import psycopg2
from psycopg2.extras import RealDictCursor


def get_db_and_cursor():
    database_url = os.environ.get("DATABASE_URL")
    if not database_url:
        raise RuntimeError("Set DATABASE_URL to your Supabase PostgreSQL connection URI")
    conn = psycopg2.connect(database_url, sslmode="require")
    return conn, conn.cursor(cursor_factory=RealDictCursor)


if __name__ == "__main__":
    conn, cur = get_db_and_cursor()
    try:
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
        print([row["table_name"] for row in cur.fetchall()])
    finally:
        cur.close()
        conn.close()
