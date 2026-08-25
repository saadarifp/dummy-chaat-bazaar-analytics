-- Day 6: Window Function Challenge
-- The questions gave no functions. Choices and reasons in comments.

-- 1. Rank branches by sales
-- RANK() because ties should share a position.
WITH branch_sales AS (
    SELECT b.Branch_Name, SUM(o.Net_Sales) AS Total_Net_Sales
    FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_Name
)
SELECT RANK() OVER (ORDER BY Total_Net_Sales DESC) AS Sales_Rank,
       Branch_Name, ROUND(Total_Net_Sales, 2) AS Total_Net_Sales
FROM branch_sales;

-- 2. Rank products inside each branch
-- PARTITION BY restarts the ranking per branch.
SELECT b.Branch_Name,
       RANK() OVER (PARTITION BY b.Branch_Name ORDER BY SUM(o.Net_Sales) DESC) AS Rank_In_Branch,
       p.Item_Name,
       ROUND(SUM(o.Net_Sales), 2) AS Net_Sales
FROM orders o
JOIN branches b ON o.Branch_ID = b.Branch_ID
JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY b.Branch_Name, p.Item_Name
ORDER BY b.Branch_Name, Rank_In_Branch;

-- 3. Running company sales
-- SUM() OVER an ordered window = cumulative total. Order_ID breaks date ties
-- so the running total is deterministic.
SELECT Order_Date, Order_ID, Net_Sales,
       ROUND(SUM(Net_Sales) OVER (ORDER BY Order_Date, Order_ID), 2) AS Running_Company_Sales
FROM orders
ORDER BY Order_Date, Order_ID;

-- 4. Each order vs previous order
-- LAG() pulls the prior row's value without a self join.
SELECT Order_Date, Order_ID, Net_Sales,
       LAG(Net_Sales) OVER (ORDER BY Order_Date, Order_ID) AS Previous_Order_Value,
       ROUND(Net_Sales - LAG(Net_Sales) OVER (ORDER BY Order_Date, Order_ID), 2) AS Change_vs_Previous
FROM orders
ORDER BY Order_Date, Order_ID;

-- 5. Each order's difference from its branch average
-- AVG() OVER (PARTITION BY branch) attaches the branch average to every row
-- while keeping the rows - exactly what GROUP BY cannot do.
SELECT b.Branch_Name, o.Order_ID, o.Net_Sales,
       ROUND(AVG(o.Net_Sales) OVER (PARTITION BY o.Branch_ID), 2) AS Branch_Avg,
       ROUND(o.Net_Sales - AVG(o.Net_Sales) OVER (PARTITION BY o.Branch_ID), 2) AS Diff_From_Branch_Avg
FROM orders o JOIN branches b ON o.Branch_ID = b.Branch_ID
ORDER BY b.Branch_Name, o.Net_Sales DESC;
