"""Day 9 Task 1 - database.

Loads the 988-row dataset (restaurant_sales_750.csv) into SQLite as a small
star-ish model instead of one wide table:

    branches (branch_id, branch_name)
    products (product_id, product_name, category)
    channels (channel_id, channel_name)     -- the Aggregator column, incl. "Direct"
    orders   (order_id PK, order_date, branch_id FK, product_id FK,
              channel_id FK, order_type, quantity, gross_sales, discount,
              commission, net_sales)

Then it proves the load with five checks and prints PASS/FAIL for each:
    988 orders loaded
    no duplicate Order_ID
    no orphan Branch IDs
    no orphan Product IDs
    no orphan Channel IDs
"""
from pathlib import Path
import sqlite3
import pandas as pd

CSV = Path(__file__).with_name("restaurant_sales_750.csv")
DB = Path(__file__).with_name("chaat_bazaar_day9.db")

SCHEMA = """
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS channels;

CREATE TABLE branches (
    branch_id   INTEGER PRIMARY KEY,
    branch_name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL UNIQUE,
    category     TEXT NOT NULL
);

CREATE TABLE channels (
    channel_id   INTEGER PRIMARY KEY,
    channel_name TEXT NOT NULL UNIQUE
);

CREATE TABLE orders (
    order_id    TEXT PRIMARY KEY,
    order_date  TEXT NOT NULL,
    branch_id   INTEGER NOT NULL REFERENCES branches(branch_id),
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    channel_id  INTEGER NOT NULL REFERENCES channels(channel_id),
    order_type  TEXT NOT NULL,
    quantity    INTEGER NOT NULL,
    gross_sales REAL NOT NULL,
    discount    REAL NOT NULL,
    commission  REAL NOT NULL,
    net_sales   REAL NOT NULL
);
"""


def build():
    df = pd.read_csv(CSV, parse_dates=["Date"])
    df["Date"] = df["Date"].dt.strftime("%Y-%m-%d")

    # Dimension tables: stable ids from the sorted set of distinct values.
    branches = (pd.DataFrame({"branch_name": sorted(df["Branch"].unique())})
                .reset_index(names="branch_id"))
    branches["branch_id"] += 1

    products = (df[["Product", "Category"]].drop_duplicates()
                .sort_values("Product")
                .rename(columns={"Product": "product_name", "Category": "category"})
                .reset_index(drop=True).reset_index(names="product_id"))
    products["product_id"] += 1

    channels = (pd.DataFrame({"channel_name": sorted(df["Aggregator"].unique())})
                .reset_index(names="channel_id"))
    channels["channel_id"] += 1

    # Fact table: swap the text keys for the dimension ids.
    orders = df.merge(branches, left_on="Branch", right_on="branch_name") \
               .merge(products[["product_id", "product_name"]],
                      left_on="Product", right_on="product_name") \
               .merge(channels, left_on="Aggregator", right_on="channel_name")
    orders = orders.rename(columns={
        "Order_ID": "order_id", "Date": "order_date", "Order_Type": "order_type",
        "Quantity": "quantity", "Gross_Sales": "gross_sales", "Discount": "discount",
        "Commission": "commission", "Net_Sales": "net_sales",
    })[[
        "order_id", "order_date", "branch_id", "product_id", "channel_id",
        "order_type", "quantity", "gross_sales", "discount", "commission", "net_sales",
    ]]

    if DB.exists():
        DB.unlink()
    con = sqlite3.connect(DB)
    con.executescript(SCHEMA)
    branches.to_sql("branches", con, if_exists="append", index=False)
    products.to_sql("products", con, if_exists="append", index=False)
    channels.to_sql("channels", con, if_exists="append", index=False)
    orders.to_sql("orders", con, if_exists="append", index=False)
    con.commit()
    return con, len(df)


def check(con, label, sql, expected):
    got = con.execute(sql).fetchone()[0]
    ok = got == expected
    print(f"  [{'PASS' if ok else 'FAIL'}] {label:32s} got {got}, expected {expected}")
    return ok


def prove(con, csv_rows):
    print("\nProof:")
    orphan = """
        SELECT COUNT(*) FROM orders o
        LEFT JOIN {tbl} d ON o.{col} = d.{col}
        WHERE d.{col} IS NULL
    """
    results = [
        check(con, "988 orders loaded",
              "SELECT COUNT(*) FROM orders", csv_rows),
        check(con, "no duplicate Order_ID",
              "SELECT COUNT(*) - COUNT(DISTINCT order_id) FROM orders", 0),
        check(con, "no orphan Branch IDs",
              orphan.format(tbl="branches", col="branch_id"), 0),
        check(con, "no orphan Product IDs",
              orphan.format(tbl="products", col="product_id"), 0),
        check(con, "no orphan Channel IDs",
              orphan.format(tbl="channels", col="channel_id"), 0),
    ]
    # Bonus: the money identity should survive the round-trip.
    bad = con.execute(
        "SELECT COUNT(*) FROM orders "
        "WHERE ABS(gross_sales - discount - commission - net_sales) > 0.01"
    ).fetchone()[0]
    print(f"  [{'PASS' if bad == 0 else 'FAIL'}] {'gross-disc-comm = net':32s} "
          f"{bad} rows break the identity")

    # SQLite has type affinity, not enforcement: a text value in a REAL column
    # loads without error and then reads as 0 in SUM(). Catch it explicitly.
    # (See day9_debugging.py for the failure this guards against.)
    mistyped = con.execute("""
        SELECT COUNT(*) FROM orders WHERE
            typeof(quantity)    NOT IN ('integer')            OR
            typeof(gross_sales) NOT IN ('real', 'integer')    OR
            typeof(discount)    NOT IN ('real', 'integer')    OR
            typeof(commission)  NOT IN ('real', 'integer')    OR
            typeof(net_sales)   NOT IN ('real', 'integer')
    """).fetchone()[0]
    print(f"  [{'PASS' if mistyped == 0 else 'FAIL'}] {'numeric columns are numeric':32s} "
          f"{mistyped} rows have a text value in a number column")
    return all(results) and bad == 0 and mistyped == 0


if __name__ == "__main__":
    con, csv_rows = build()
    for tbl in ("branches", "products", "channels", "orders"):
        n = con.execute(f"SELECT COUNT(*) FROM {tbl}").fetchone()[0]
        print(f"  {tbl:10s} {n:4d} rows")
    ok = prove(con, csv_rows)
    con.close()
    print("\n" + ("ALL CHECKS PASS - database ready" if ok
                  else "CHECKS FAILED - do not trust this database"))
    raise SystemExit(0 if ok else 1)
