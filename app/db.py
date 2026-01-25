import mysql.connector
import os

DB_PASS = os.getenv("DB_PASS")

def save_user(username, password):
    db = mysql.connector.connect(
        host="mysql-db",
        user="root",
        password=DB_PASS,
        database="mydb"
    )
    cursor = db.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            username VARCHAR(50),
            password VARCHAR(50)
        )
    """)
    cursor.execute(
        "INSERT INTO users VALUES (%s, %s)",
        (username, password)
    )
    db.commit()
    cursor.close()
    db.close()
