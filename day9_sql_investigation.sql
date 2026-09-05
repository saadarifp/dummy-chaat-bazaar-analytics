-- Day 9 Task 2 - SQL business investigation
-- Question from management: "Sales increased, but is the improvement healthy?"
-- No query list was given. These are the queries I chose to answer it.
-- Run against chaat_bazaar_day9.db (built by day9_build_database.py).
--
-- A convenience view that re-joins the model back to readable names and
-- adds a month key, so the investigation queries stay short.
DROP VIEW IF EXISTS v_orders;
CREATE VIEW v_orders AS
SELECT o.order_id,
       o.order_date,
       substr(o.order_date, 1, 7)      AS month,
       b.branch_name                   AS branch,
       p.product_name                  AS product,
       p.category                      AS category,
       c.channel_name                  AS channel,
       o.order_type,
       o.quantity,
       o.gross_sales,
       o.discount,
       o.commission,
       o.net_sales
FROM orders o
JOIN branches b ON b.branch_id  = o.branch_id
JOIN products p ON p.product_id = o.product_id
JOIN channels c ON c.channel_id = o.channel_id;

-- ============================================================
-- 0. The headline management is reacting to: is sales actually up?
-- ============================================================
SELECT month,
       COUNT(*)                                   AS orders,
       ROUND(SUM(gross_sales), 0)                 AS gross,
       ROUND(SUM(net_sales), 0)                   AS net,
       ROUND(SUM(net_sales) * 1.0 / COUNT(*), 2)  AS aov,
       ROUND((SUM(gross_sales) - SUM(net_sales)) * 100.0
             / SUM(gross_sales), 2)               AS leakage_pct,
       ROUND(SUM(net_sales) * 100.0
             / SUM(gross_sales), 2)               AS net_margin_pct
FROM v_orders
GROUP BY month
ORDER BY month;
-- Read: net 13,473 -> 13,340 -> 14,262. Jun->Aug +5.9%, but July DIPPED.

-- ============================================================
-- Finding 1 - growth came with a CHEAPER cost structure, not discounts
-- ============================================================
SELECT month,
       ROUND(SUM(commission) * 100.0 / SUM(gross_sales), 2) AS commission_pct_gross,
       ROUND(SUM(discount)   * 100.0 / SUM(gross_sales), 2) AS discount_pct_gross,
       ROUND(SUM(CASE WHEN discount > 0 THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 1)                                 AS pct_orders_discounted,
       ROUND(AVG(CASE WHEN discount > 0 THEN discount END), 2) AS avg_discount_when_given
FROM v_orders
GROUP BY month
ORDER BY month;
-- Read: commission 17.4 -> 15.9, discount 2.9 -> 2.4, fewer orders discounted.
-- Revenue rose while the cost of earning it fell. That is healthy.

-- ============================================================
-- Finding 2 - the mechanism: Direct channel share jumped
-- ============================================================
SELECT month,
       ROUND(SUM(CASE WHEN channel = 'Direct' THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 1)                                       AS direct_order_share,
       ROUND(SUM(CASE WHEN channel = 'Direct' THEN net_sales ELSE 0 END) * 100.0
             / SUM(net_sales), 1)                                 AS direct_net_share
FROM v_orders
GROUP BY month
ORDER BY month;

-- Direct share by branch, first month vs last month
SELECT branch,
       ROUND(SUM(CASE WHEN month = '2026-06' AND channel = 'Direct' THEN 1 ELSE 0 END) * 100.0
             / NULLIF(SUM(CASE WHEN month = '2026-06' THEN 1 ELSE 0 END), 0), 1) AS direct_share_jun,
       ROUND(SUM(CASE WHEN month = '2026-08' AND channel = 'Direct' THEN 1 ELSE 0 END) * 100.0
             / NULLIF(SUM(CASE WHEN month = '2026-08' THEN 1 ELSE 0 END), 0), 1) AS direct_share_aug
FROM v_orders
GROUP BY branch
ORDER BY direct_share_aug DESC;

-- ============================================================
-- Finding 3 - CHALLENGE: strip out the new branch and growth nearly vanishes
-- ============================================================
SELECT month,
       ROUND(SUM(net_sales), 0)                                            AS company_net,
       ROUND(SUM(CASE WHEN branch <> 'Deira' THEN net_sales ELSE 0 END), 0) AS net_ex_deira,
       ROUND(SUM(CASE WHEN branch =  'Deira' THEN net_sales ELSE 0 END), 0) AS deira_net
FROM v_orders
GROUP BY month
ORDER BY month;
-- Read: company 13,473 -> 14,262 (+5.9%). Ex-Deira 11,786 -> 11,968 (+1.5%).
-- Almost all reported growth is the Deira opening, a one-time event.

-- ============================================================
-- Finding 4 - CHALLENGE: the biggest branch is shrinking and trading
--             ticket size for order count
-- ============================================================
SELECT branch,
       ROUND(SUM(CASE WHEN month = '2026-06' THEN net_sales ELSE 0 END), 0) AS net_jun,
       ROUND(SUM(CASE WHEN month = '2026-07' THEN net_sales ELSE 0 END), 0) AS net_jul,
       ROUND(SUM(CASE WHEN month = '2026-08' THEN net_sales ELSE 0 END), 0) AS net_aug,
       ROUND((SUM(CASE WHEN month = '2026-08' THEN net_sales ELSE 0 END)
              - SUM(CASE WHEN month = '2026-06' THEN net_sales ELSE 0 END)) * 100.0
             / SUM(CASE WHEN month = '2026-06' THEN net_sales ELSE 0 END), 1) AS growth_pct
FROM v_orders
GROUP BY branch
ORDER BY growth_pct;

-- Karama month by month: orders up, value per order down
SELECT month,
       COUNT(*)                                    AS orders,
       ROUND(SUM(net_sales), 0)                     AS net,
       ROUND(SUM(net_sales) * 1.0 / COUNT(*), 2)    AS aov,
       ROUND(SUM(quantity)  * 1.0 / COUNT(*), 2)    AS items_per_order,
       ROUND(SUM(CASE WHEN category = 'Mains' THEN net_sales ELSE 0 END), 0) AS mains_net
FROM v_orders
WHERE branch = 'Karama'
GROUP BY month
ORDER BY month;
-- Read: Aug orders 104 (record) but AOV 40.40 vs 48.14, items/order 3.45 vs 3.78,
-- Mains net 1,570 -> 1,271. More, smaller, lower-value orders.

-- ============================================================
-- Finding 5 - "growth" is really one month; July fell and Deira is already cooling
-- ============================================================
SELECT month,
       ROUND(SUM(net_sales), 0)                                         AS net,
       ROUND(SUM(net_sales) - LAG(SUM(net_sales)) OVER (ORDER BY month), 0) AS mom_change,
       ROUND((SUM(net_sales) - LAG(SUM(net_sales)) OVER (ORDER BY month)) * 100.0
             / LAG(SUM(net_sales)) OVER (ORDER BY month), 1)            AS mom_pct
FROM v_orders
GROUP BY month
ORDER BY month;

-- Deira's own trend and Direct share - the new-branch tailwind is fading
SELECT month,
       COUNT(*)                                    AS orders,
       ROUND(SUM(net_sales), 0)                     AS net,
       ROUND(SUM(CASE WHEN channel = 'Direct' THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 1)                         AS direct_share
FROM v_orders
WHERE branch = 'Deira'
GROUP BY month
ORDER BY month;

-- ============================================================
-- Finding 6 - supporting: revenue is weekend (Fri/Sat) concentrated
-- SQLite: strftime('%w') gives 0=Sun..6=Sat, so Fri=5, Sat=6
-- ============================================================
WITH daily AS (
    SELECT order_date,
           CASE WHEN strftime('%w', order_date) IN ('5', '6')
                THEN 'weekend' ELSE 'weekday' END AS day_kind,
           SUM(net_sales) AS day_net
    FROM v_orders
    GROUP BY order_date
)
SELECT day_kind,
       COUNT(*)                        AS num_days,
       ROUND(AVG(day_net), 0)          AS avg_daily_net
FROM daily
GROUP BY day_kind;
-- Read: weekend ~591/day vs weekday ~390/day, +52%.
