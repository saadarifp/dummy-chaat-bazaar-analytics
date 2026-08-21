-- Day 5: Subqueries and CTEs
-- Run against chaat_bazaar.db after rebuild_db.sql

-- 1. Branches above average branch sales (CTE + subquery)
WITH branch_sales AS (
    SELECT b.Branch_Name, SUM(o.Net_Sales) AS Total_Net_Sales
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT Branch_Name, ROUND(Total_Net_Sales, 2) AS Total_Net_Sales
FROM branch_sales
WHERE Total_Net_Sales > (SELECT AVG(Total_Net_Sales) FROM branch_sales);

-- 2. Orders above overall average order value (plain subquery)
SELECT Order_ID, Net_Sales
FROM orders
WHERE Net_Sales > (SELECT AVG(Net_Sales) FROM orders)
ORDER BY Net_Sales DESC;

-- 3. Products generating above-average product revenue
WITH product_sales AS (
    SELECT p.Item_Name, SUM(o.Net_Sales) AS Revenue
    FROM orders o JOIN products p ON o.Product_ID = p.Product_ID
    GROUP BY p.Item_Name
)
SELECT Item_Name, ROUND(Revenue, 2) AS Revenue
FROM product_sales
WHERE Revenue > (SELECT AVG(Revenue) FROM product_sales)
ORDER BY Revenue DESC;

-- 4. Highest-selling product in the company
WITH product_sales AS (
    SELECT p.Item_Name, SUM(o.Net_Sales) AS Revenue
    FROM orders o JOIN products p ON o.Product_ID = p.Product_ID
    GROUP BY p.Item_Name
)
SELECT Item_Name, ROUND(Revenue, 2) AS Revenue
FROM product_sales
WHERE Revenue = (SELECT MAX(Revenue) FROM product_sales);

-- 5. Aggregator with highest total commission
WITH agg_comm AS (
    SELECT a.Aggregator_Name, SUM(o.Commission) AS Total_Commission
    FROM orders o JOIN aggregators a ON o.Aggregator_ID = a.Aggregator_ID
    GROUP BY a.Aggregator_Name
)
SELECT Aggregator_Name, ROUND(Total_Commission, 2) AS Total_Commission
FROM agg_comm
WHERE Total_Commission = (SELECT MAX(Total_Commission) FROM agg_comm);

-- 6. Branch with highest average order value
WITH branch_avg AS (
    SELECT b.Branch_Name, AVG(o.Net_Sales) AS Avg_Order_Value
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT Branch_Name, ROUND(Avg_Order_Value, 2) AS Avg_Order_Value
FROM branch_avg
WHERE Avg_Order_Value = (SELECT MAX(Avg_Order_Value) FROM branch_avg);

-- 7. CTE calculating sales by branch
WITH branch_sales AS (
    SELECT b.Branch_Name, SUM(o.Net_Sales) AS Total_Net_Sales, COUNT(*) AS Orders
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT Branch_Name, ROUND(Total_Net_Sales, 2) AS Total_Net_Sales, Orders
FROM branch_sales
ORDER BY Total_Net_Sales DESC;

-- 8. CTE ranking branches by sales
WITH branch_sales AS (
    SELECT b.Branch_Name, SUM(o.Net_Sales) AS Total_Net_Sales
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT RANK() OVER (ORDER BY Total_Net_Sales DESC) AS Sales_Rank,
       Branch_Name, ROUND(Total_Net_Sales, 2) AS Total_Net_Sales
FROM branch_sales;

-- 9. Each branch's % contribution to total company sales
WITH branch_sales AS (
    SELECT b.Branch_Name, SUM(o.Net_Sales) AS Total_Net_Sales
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT Branch_Name,
       ROUND(Total_Net_Sales, 2) AS Total_Net_Sales,
       ROUND(Total_Net_Sales * 100.0 / (SELECT SUM(Total_Net_Sales) FROM branch_sales), 2) AS Pct_of_Company
FROM branch_sales
ORDER BY Pct_of_Company DESC;

-- 10. Products responsible for the top 50% of revenue
-- Logic: rank products by revenue, take a running (cumulative) total,
-- keep products until the running total crosses 50% of company revenue.
WITH product_sales AS (
    SELECT p.Item_Name, SUM(o.Net_Sales) AS Revenue
    FROM orders o JOIN products p ON o.Product_ID = p.Product_ID
    GROUP BY p.Item_Name
),
running AS (
    SELECT Item_Name, Revenue,
           SUM(Revenue) OVER (ORDER BY Revenue DESC) AS Cumulative_Revenue,
           SUM(Revenue) OVER () AS Company_Revenue
    FROM product_sales
)
SELECT Item_Name,
       ROUND(Revenue, 2) AS Revenue,
       ROUND(Cumulative_Revenue * 100.0 / Company_Revenue, 2) AS Cumulative_Pct
FROM running
WHERE Cumulative_Revenue - Revenue < Company_Revenue * 0.5
ORDER BY Revenue DESC;
