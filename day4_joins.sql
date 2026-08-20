-- ============================================================
-- Day 4: SQL JOINs
-- Tables: orders (fact) | branches, aggregators, products (dimensions)
-- Note: branches includes 'Deira' (Opening Soon) with zero orders,
--       so LEFT JOIN queries have a real unmatched row to find.
-- ============================================================

-- ---------- SECTION 1: JOINS (15 queries) ----------

-- J1. Orders + branch name (INNER JOIN)
SELECT o.Order_ID, o.Order_Date, b.Branch_Name, o.Net_Sales
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID;

-- J2. Orders + aggregator name
SELECT o.Order_ID, a.Aggregator_Name, o.Net_Sales
FROM orders o
INNER JOIN aggregators a ON o.Aggregator_ID = a.Aggregator_ID;

-- J3. Orders + branch + aggregator (3-table join)
SELECT o.Order_ID, b.Branch_Name, a.Aggregator_Name, p.Item_Name, o.Net_Sales
FROM orders o
INNER JOIN branches    b ON o.Branch_ID     = b.Branch_ID
INNER JOIN aggregators a ON o.Aggregator_ID = a.Aggregator_ID
INNER JOIN products    p ON o.Product_ID    = p.Product_ID;

-- J4. Sales by branch (JOIN + GROUP BY)
SELECT b.Branch_Name, ROUND(SUM(o.Net_Sales), 2) AS Total_Net_Sales
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name
ORDER BY Total_Net_Sales DESC;

-- J5. Sales by aggregator
SELECT a.Aggregator_Name, ROUND(SUM(o.Net_Sales), 2) AS Total_Net_Sales
FROM orders o
INNER JOIN aggregators a ON o.Aggregator_ID = a.Aggregator_ID
GROUP BY a.Aggregator_Name
ORDER BY Total_Net_Sales DESC;

-- J6. Orders per branch — LEFT JOIN so Deira shows with 0
SELECT b.Branch_Name, COUNT(o.Order_ID) AS Number_of_Orders
FROM branches b
LEFT JOIN orders o ON b.Branch_ID = o.Branch_ID
GROUP BY b.Branch_Name
ORDER BY Number_of_Orders DESC;

-- J7. Branches with NO orders (the classic LEFT JOIN ... IS NULL pattern)
SELECT b.Branch_Name, b.Status
FROM branches b
LEFT JOIN orders o ON b.Branch_ID = o.Branch_ID
WHERE o.Order_ID IS NULL;

-- J8. Average order value by branch
SELECT b.Branch_Name, ROUND(AVG(o.Net_Sales), 2) AS Avg_Order_Value
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name
ORDER BY Avg_Order_Value DESC;

-- J9. Top product by branch (window function over a 3-table join)
WITH branch_products AS (
    SELECT b.Branch_Name, p.Item_Name,
           SUM(o.Net_Sales) AS Net_Sales,
           RANK() OVER (PARTITION BY b.Branch_Name ORDER BY SUM(o.Net_Sales) DESC) AS rnk
    FROM orders o
    INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
    INNER JOIN products p ON o.Product_ID = p.Product_ID
    GROUP BY b.Branch_Name, p.Item_Name
)
SELECT Branch_Name, Item_Name, ROUND(Net_Sales, 2) AS Net_Sales
FROM branch_products WHERE rnk = 1;

-- J10. Commission by aggregator, with the contracted rate alongside
SELECT a.Aggregator_Name, a.Commission_Rate,
       ROUND(SUM(o.Commission), 2) AS Total_Commission
FROM orders o
INNER JOIN aggregators a ON o.Aggregator_ID = a.Aggregator_ID
GROUP BY a.Aggregator_Name, a.Commission_Rate
ORDER BY Total_Commission DESC;

-- J11. Gross vs net sales by branch
SELECT b.Branch_Name,
       ROUND(SUM(o.Gross_Sales), 2) AS Gross_Sales,
       ROUND(SUM(o.Net_Sales), 2)   AS Net_Sales,
       ROUND(SUM(o.Gross_Sales) - SUM(o.Net_Sales), 2) AS Lost_to_Discounts_and_Commission
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name
ORDER BY Net_Sales DESC;

-- J12. Branches with more than 5 orders (JOIN + HAVING)
SELECT b.Branch_Name, COUNT(*) AS Number_of_Orders
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name
HAVING COUNT(*) > 5
ORDER BY Number_of_Orders DESC;

-- J13. Top 3 branches by net sales
SELECT b.Branch_Name, ROUND(SUM(o.Net_Sales), 2) AS Total_Net_Sales
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name
ORDER BY Total_Net_Sales DESC
LIMIT 3;

-- J14. Product + category + sales
SELECT p.Item_Name, p.Category,
       SUM(o.Quantity)            AS Quantity_Sold,
       ROUND(SUM(o.Net_Sales), 2) AS Net_Sales
FROM orders o
INNER JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY p.Item_Name, p.Category
ORDER BY Net_Sales DESC;

-- J15. Branch sales ranking (JOIN + window function)
SELECT RANK() OVER (ORDER BY SUM(o.Net_Sales) DESC) AS Sales_Rank,
       b.Branch_Name,
       ROUND(SUM(o.Net_Sales), 2) AS Total_Net_Sales
FROM orders o
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY b.Branch_Name;

-- NOTE on RIGHT / FULL OUTER JOIN:
-- SQLite (3.39+) supports both. A RIGHT JOIN keeps all rows from the
-- right table; orders RIGHT JOIN branches = branches LEFT JOIN orders,
-- which is J6/J7 above. FULL OUTER keeps unmatched rows from BOTH sides.
-- In practice most analysts rewrite RIGHT JOINs as LEFT JOINs by
-- swapping table order — done here.


-- J16. Orders + products
SELECT o.Order_ID, p.Item_Name, p.Category, o.Quantity, o.Net_Sales
FROM orders o
INNER JOIN products p ON o.Product_ID = p.Product_ID;

-- J17. Sales by product AND branch
SELECT p.Item_Name, b.Branch_Name, ROUND(SUM(o.Net_Sales), 2) AS Net_Sales
FROM orders o
INNER JOIN products p ON o.Product_ID = p.Product_ID
INNER JOIN branches b ON o.Branch_ID = b.Branch_ID
GROUP BY p.Item_Name, b.Branch_Name
ORDER BY Net_Sales DESC;
