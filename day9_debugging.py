"""Day 9 Task 8 - debugging test (reproducible).

The break: one numeric value in the source CSV is changed to text.
Row CB-2000's Net_Sales goes from "40.0" to "4O.0" (capital letter O instead
of a zero) - exactly the kind of thing a bad find-and-replace or a hand edit in
Excel produces.

Run this file. It rebuilds a broken copy of the data, loads it the same way
day9_build_database.py does, and shows that the load "succeeds" while the total
net sales silently comes out AED 36 short. Then it shows the two guards that
catch it.

The broken CSV is written next to this script and is git-ignored; it is
regenerated on every run, never committed.
"""
from pathlib import Path
import sqlite3
import pandas as pd

HERE = Path(__file__).parent
CLEAN = HERE / "restaurant_sales_750.csv"
BROKEN = HERE / "restaurant_sales_broken.csv"
CLEAN_TOTAL = 41074.95  # SUM(Net_Sales) over the untouched file


def make_broken():
    lines = CLEAN.read_text().splitlines()
    cells = lines[1].split(",")           # first data row = CB-2000
    cells[-1] = cells[-1].replace("40.0", "4O.0")   # zero -> letter O
    lines[1] = ",".join(cells)
    BROKEN.write_text("\n".join(lines) + "\n")


def load(csv_path):
    """Minimal stand-in for the real loader: same read, same typed column."""
    df = pd.read_csv(csv_path)
    con = sqlite3.connect(":memory:")
    con.execute("CREATE TABLE orders(order_id TEXT PRIMARY KEY, "
                "net_sales REAL NOT NULL)")
    (df[["Order_ID", "Net_Sales"]]
     .rename(columns={"Order_ID": "order_id", "Net_Sales": "net_sales"})
     .to_sql("orders", con, if_exists="append", index=False))
    return df, con


def main():
    make_broken()
    df, con = load(BROKEN)

    rows = con.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
    total = con.execute("SELECT SUM(net_sales) FROM orders").fetchone()[0]
    bad_type = con.execute(
        "SELECT COUNT(*) FROM orders "
        "WHERE typeof(net_sales) NOT IN ('real', 'integer')"
    ).fetchone()[0]

    print("=" * 60)
    print("1. SYMPTOM")
    print("=" * 60)
    print(f"  Load reported success. Rows inserted: {rows} (expected 988).")
    print(f"  No error, no NULL violation, no failed constraint.")
    print(f"  SUM(net_sales) = {total:.2f}")
    print(f"  Expected       = {CLEAN_TOTAL:.2f}")
    print(f"  Silently short by AED {CLEAN_TOTAL - total:.2f}")
    print(f"  pandas dtype of Net_Sales column: {df['Net_Sales'].dtype} "
          f"(should be float64)")

    print("\n" + "=" * 60)
    print("2. ROOT CAUSE")
    print("=" * 60)
    print("  One cell reads '4O.0' (letter O). pandas cannot parse the column")
    print("  as numbers, so the WHOLE column falls back to text. SQLite has")
    print("  type affinity, not type enforcement: it stores the text strings")
    print("  in the REAL column without complaint, and SUM() treats every")
    print("  non-numeric value as 0. One unreadable cell -> one row worth of")
    print("  revenue vanishes from every total, chart and KPI downstream.")

    print("\n" + "=" * 60)
    print("3. FIX")
    print("=" * 60)
    fixed = pd.to_numeric(df["Net_Sales"], errors="coerce")
    print(f"  Bad cells located: {int(fixed.isna().sum())} "
          f"(order_id {df.loc[fixed.isna(), 'Order_ID'].tolist()})")
    print("  Correct the source value (4O.0 -> 40.0) and reload. Do not")
    print("  coerce-to-zero or drop the row - that hides a data-entry error.")

    print("\n" + "=" * 60)
    print("4. PREVENTION")
    print("=" * 60)
    print("  a) Validate before load. pd.to_numeric(col, errors='raise') on")
    print("     every money column - fail the pipeline, don't warn.")
    print("  b) Assert dtypes after read_csv: df['Net_Sales'].dtype == float64.")
    print("  c) Post-load guard in SQL:")
    print("     SELECT COUNT(*) FROM orders")
    print("     WHERE typeof(net_sales) NOT IN ('real','integer');  -- must be 0")
    print(f"     -> on this broken load it returns {bad_type}, so the build fails.")
    print("  d) Reconcile the loaded total against the raw-file total")
    print("     (day9_reconciliation.py already does this).")
    print("  e) CI: run day8_data_validation.py / the checks in")
    print("     day9_build_database.py on every commit.")

    con.close()
    BROKEN.unlink()  # clean up


if __name__ == "__main__":
    main()
