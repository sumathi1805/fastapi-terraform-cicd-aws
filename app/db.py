import mysql.connector
import os
import time

def get_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "mysql-db"),
        user=os.getenv("DB_USER", "appuser"),
        password=os.getenv("DB_PASS", "apppass"),
        database=os.getenv("DB_NAME", "appdb")
    )

def init_db():
    max_attempts = 10
    wait_seconds = 3
    for attempt in range(1, max_attempts + 1):
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    username VARCHAR(100),
                    password VARCHAR(100)
                )
            """)
            conn.commit()
            cursor.close()
            conn.close()
            print("✅ DB initialized successfully")
            return
        except mysql.connector.Error as e:
            print(f"Waiting for DB... attempt {attempt}/{max_attempts}, error: {e}")
            time.sleep(wait_seconds)
    print("❌ DB not ready after retries, exiting gracefully")

def save_user(username, password):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO users (username, password) VALUES (%s, %s)",
        (username, password)
    )
    conn.commit()
    cursor.close()
    conn.close()
