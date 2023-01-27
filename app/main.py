from typing import Any
from flask import Flask, render_template, request

import mysql.connector
from mysql.connector.pooling import CMySQLConnection


app: Flask = Flask(__name__)

# DATABASE INFO
MYSQL_USER = "root"
MYSQL_PASS = ""
MYSQL_DB = "ERG_A"

cnx: None | CMySQLConnection | mysql.connector.MySQLConnection = (
    mysql.connector.connect(
        user=MYSQL_USER,
        password=MYSQL_PASS,
        host="localhost",
        database=MYSQL_DB,
    )
)

cursor = cnx.cursor()


@app.route("/", methods=["GET"])
def root():
    return render_template("main.html")


# Δημιουργήστε μια σελίδα στην οποία θα παρουσιάζονται όλες οι παραγγελίες των προϊόντων .
@app.route("/orders", methods=["GET"])
def orders():
    return render_template("orders.html", orders=get_orders())


# Δημιουργήστε μια σελίδα στην οποία, ο χρήστης μπορεί να επιλέγει
# μία παραγγελία και στην συνέχεια να του εμφανίζονται τα προϊόντα της παραγγελίας
@app.route("/view_order", methods=["GET", "POST"])
def date_sales():
    order = []
    id: str | None = ""
    is_found = False
    if request.method == "POST":
        is_found = True
        id = request.form.get("order_id")
        order = get_order(id)

    return render_template("view_order.html", order=order, found=is_found)


@app.route("/date_sales", methods=["GET", "POST"])
def view_order():
    order = []
    id: str | None = ""
    is_found = False
    total_price = 0
    if request.method == "POST":
        id = request.form.get("order_id")
        date = request.form.get("date")
        order = get_order_by_datetime(id, date)
        is_found = True

    return render_template("date_sales.html", order=order, found=is_found)


# ---- Helper Functions ----
def get_order(id: str) -> Any:
    query: str = f"SELECT ORDERS.QUANTITY, PRODUCT.NAME FROM PRODUCT JOIN ORDERS ON ORDERS.PRODUCT_ID = PRODUCT.ID AND ORDERS.ORDER_ID={id};"
    cursor.execute(query)
    return cursor.fetchall()


def get_order_by_datetime(id: str, date: str) -> Any:
    query: str = f"SELECT COUNT(*), SUM(ORDERS.TOTAL_COST)FROM ORDERS WHERE PRODUCT_ID={id} AND ORDERS.PURCHASE_DATE='{date}';"
    cursor.execute(query)
    return cursor.fetchall()


def get_orders() -> Any:
    query: str = "SELECT * FROM ORDERS"
    cursor.execute(query)
    return cursor.fetchall()


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=80)
    cursor.close()
