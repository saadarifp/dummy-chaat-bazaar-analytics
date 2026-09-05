"""Day 9 Task 3 - reconcile three SQL findings against an independent Pandas pass.

SQL numbers come from chaat_bazaar_day9.db (the normalised model).
Pandas numbers are computed straight from restaurant_sales_750.csv.
If they disagree, the rule is: do not edit numbers, find out why.
"""
from pathlib import Path
import sqlite3
import pandas as pd

HERE = Path(__file__).parent
con = sqlite3.connect(HERE / "chaat_bazaar_day9.db")
con.executescript("""
DROP VIEW IF EXISTS v_orders;
CREATE VIEW v_orders AS
SELECT o.*, substr(o.order_date,1,7) AS month, b.branch_name AS branch,
       p.category AS category, c.channel_name AS channel
FROM orders o JOIN branches b ON b.branch_id=o.branch_id
JOIN products p ON p.product_id=o.product_id
JOIN channels c ON c.channel_id=o.channel_id;
""")

df = pd.read_csv(HERE / "restaurant_sales_750.csv", parse_dates=["Date"])
df["month"] = df["Date"].dt.strftime("%Y-%m")


def compare(name, sql_df, pd_df):
    sql_df = sql_df.round(2).reset_index(drop=True)
    pd_df = pd_df.round(2).reset_index(drop=True)
    match = sql_df.equals(pd_df)
    print(f"\n{'='*64}\n{name}\n{'='*64}")
    print("SQL:\n", sql_df.to_string(index=False))
    print("Pandas:\n", pd_df.to_string(index=False))
    print("RECONCILES:", "PASS" if match else "FAIL")
    return match


# --- Finding 1: monthly cost structure (commission %, discount %, net margin) ---
sql1 = pd.read_sql("""
    SELECT month,
           ROUND(SUM(commission)*100.0/SUM(gross_sales),2) AS comm_pct,
           ROUND(SUM(discount)*100.0/SUM(gross_sales),2)   AS disc_pct,
           ROUND(SUM(net_sales)*100.0/SUM(gross_sales),2)  AS net_margin_pct
    FROM v_orders GROUP BY month ORDER BY month
""", con)
g = df.groupby("month")
pd1 = pd.DataFrame({
    "month": g.size().index,
    "comm_pct": (g.Commission.sum() / g.Gross_Sales.sum() * 100).round(2).values,
    "disc_pct": (g.Discount.sum() / g.Gross_Sales.sum() * 100).round(2).values,
    "net_margin_pct": (g.Net_Sales.sum() / g.Gross_Sales.sum() * 100).round(2).values,
})

# --- Finding 3: net sales excluding Deira, and same-branch growth ---
sql3 = pd.read_sql("""
    SELECT month,
           ROUND(SUM(net_sales),2)                                            AS company_net,
           ROUND(SUM(CASE WHEN branch<>'Deira' THEN net_sales ELSE 0 END),2)   AS net_ex_deira
    FROM v_orders GROUP BY month ORDER BY month
""", con)
pd3 = df.groupby("month").apply(
    lambda x: pd.Series({
        "company_net": round(x.Net_Sales.sum(), 2),
        "net_ex_deira": round(x.loc[x.Branch != "Deira", "Net_Sales"].sum(), 2),
    }), include_groups=False
).reset_index()

# --- Finding 4: Karama monthly orders, AOV, items per order ---
sql4 = pd.read_sql("""
    SELECT month, COUNT(*) AS orders,
           ROUND(SUM(net_sales)*1.0/COUNT(*),2) AS aov,
           ROUND(SUM(quantity)*1.0/COUNT(*),2)  AS items_per_order
    FROM v_orders WHERE branch='Karama' GROUP BY month ORDER BY month
""", con)
k = df[df.Branch == "Karama"].groupby("month")
pd4 = pd.DataFrame({
    "month": k.size().index,
    "orders": k.size().values,
    "aov": (k.Net_Sales.sum() / k.size()).round(2).values,
    "items_per_order": (k.Quantity.sum() / k.size()).round(2).values,
})

results = [
    compare("Finding 1 - monthly cost structure", sql1, pd1),
    compare("Finding 3 - net sales excluding Deira", sql3, pd3),
    compare("Finding 4 - Karama orders / AOV / items per order", sql4, pd4),
]
con.close()
print("\n" + ("ALL THREE RECONCILE - PASS" if all(results) else "MISMATCH - investigate"))
raise SystemExit(0 if all(results) else 1)
