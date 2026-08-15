-- ============================================================
-- Day 3: Chaat Bazaar Sales Analysis
-- Covers: aggregation, GROUP BY, HAVING, CASE WHEN, CTE, RANK()
-- Run against: chaat_bazaar.db (table: sales)
-- ============================================================

-- ---------- PART A: Overall KPIs ----------

-- A1. Total gross sales, discounts, commission, net sales (company-wide)
SELECT
    ROUND(SUM(Gross_Sales), 2)  AS Total_Gross_Sales,
    ROUND(SUM(Discount), 2)     AS Total_Discounts,
    ROUND(SUM(Commission), 2)   AS Total_Commission,
    ROUND(SUM(Net_Sales), 2)    AS Total_Net_Sales,
    COUNT(*)                    AS Total_Orders
FROM sales;

-- A2. Average transaction value (overall)
SELECT ROUND(AVG(Net_Sales), 2) AS Avg_Transaction_Value FROM sales;

-- A3. Highest and lowest transactions
SELECT ROUND(MAX(Net_Sales), 2) AS Highest_Transaction,
       ROUND(MIN(Net_Sales), 2) AS Lowest_Transaction
FROM sales;

-- ---------- PART B: Branch performance ----------

-- B1. Which branch has the highest Net Sales?
SELECT Branch, ROUND(SUM(Net_Sales), 2) AS Total_Net_Sales
FROM sales
GROUP BY Branch
ORDER BY Total_Net_Sales DESC
LIMIT 1;

-- B2. Full branch summary, highest Net Sales first
SELECT
    Branch,
    ROUND(SUM(Gross_Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount), 2)    AS Discounts,
    ROUND(SUM(Commission), 2)  AS Commission,
    ROUND(SUM(Net_Sales), 2)   AS Net_Sales,
    COUNT(*)                   AS Number_of_Orders
FROM sales
GROUP BY Branch
ORDER BY Net_Sales DESC;

-- B3. Average transaction value by branch
SELECT Branch, ROUND(AVG(Net_Sales), 2) AS Avg_Transaction_Value
FROM sales
GROUP BY Branch
ORDER BY Avg_Transaction_Value DESC;

-- B4. HAVING — branches with total net sales above AED 1,000
-- (spec threshold; the 35-row dummy dataset may return no rows)
SELECT Branch, ROUND(SUM(Net_Sales), 2) AS Total_Net_Sales
FROM sales
GROUP BY Branch
HAVING SUM(Net_Sales) > 1000;

-- B4b. Same pattern scaled to this dataset: branches above AED 300
SELECT Branch, ROUND(SUM(Net_Sales), 2) AS Total_Net_Sales
FROM sales
GROUP BY Branch
HAVING SUM(Net_Sales) > 300
ORDER BY Total_Net_Sales DESC;

-- ---------- PART C: Aggregator analysis ----------

-- C1. Aggregator summary with commission percentage
SELECT
    Aggregator,
    ROUND(SUM(Gross_Sales), 2)                             AS Gross_Sales,
    ROUND(SUM(Commission), 2)                              AS Commission,
    ROUND(SUM(Net_Sales), 2)                               AS Net_Sales,
    ROUND(SUM(Commission) * 100.0 / SUM(Gross_Sales), 2)   AS Commission_Pct,
    COUNT(*)                                               AS Number_of_Orders
FROM sales
GROUP BY Aggregator
ORDER BY Commission DESC;

-- C2. Average discount by aggregator
SELECT Aggregator, ROUND(AVG(Discount), 2) AS Avg_Discount
FROM sales
GROUP BY Aggregator
ORDER BY Avg_Discount DESC;

-- ---------- PART D: Product analysis ----------

-- D1. Top 5 items by Net Sales
SELECT
    Item_Name,
    SUM(Quantity)              AS Quantity_Sold,
    ROUND(SUM(Gross_Sales), 2) AS Gross_Sales,
    ROUND(SUM(Net_Sales), 2)   AS Net_Sales
FROM sales
GROUP BY Item_Name
ORDER BY Net_Sales DESC
LIMIT 5;

-- D2. Top 5 items by Quantity sold
SELECT
    Item_Name,
    SUM(Quantity)              AS Quantity_Sold,
    ROUND(SUM(Gross_Sales), 2) AS Gross_Sales,
    ROUND(SUM(Net_Sales), 2)   AS Net_Sales
FROM sales
GROUP BY Item_Name
ORDER BY Quantity_Sold DESC
LIMIT 5;

-- D3. Lowest-performing items by Net Sales (bottom 5)
SELECT
    Item_Name,
    SUM(Quantity)              AS Quantity_Sold,
    ROUND(SUM(Gross_Sales), 2) AS Gross_Sales,
    ROUND(SUM(Net_Sales), 2)   AS Net_Sales
FROM sales
GROUP BY Item_Name
ORDER BY Net_Sales ASC
LIMIT 5;

-- D4. Best-performing category
SELECT Category, ROUND(SUM(Net_Sales), 2) AS Net_Sales
FROM sales
GROUP BY Category
ORDER BY Net_Sales DESC;

-- ---------- PART E: CASE WHEN — order value classification ----------

-- E1. Classify every order
SELECT
    Order_ID,
    Branch,
    Net_Sales,
    CASE
        WHEN Net_Sales < 30 THEN 'Low Value'
        WHEN Net_Sales <= 60 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Order_Value_Category
FROM sales;

-- E2. Count of orders in each category
SELECT
    CASE
        WHEN Net_Sales < 30 THEN 'Low Value'
        WHEN Net_Sales <= 60 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Order_Value_Category,
    COUNT(*) AS Number_of_Orders
FROM sales
GROUP BY Order_Value_Category
ORDER BY Number_of_Orders DESC;

-- ---------- PART F: CTE — branches above average ----------

-- F1. Branches performing above the average branch Net Sales
WITH branch_sales AS (
    SELECT Branch, SUM(Net_Sales) AS Total_Net_Sales
    FROM sales
    GROUP BY Branch
)
SELECT Branch, ROUND(Total_Net_Sales, 2) AS Total_Net_Sales
FROM branch_sales
WHERE Total_Net_Sales > (SELECT AVG(Total_Net_Sales) FROM branch_sales)
ORDER BY Total_Net_Sales DESC;

-- ---------- PART G: Window functions ----------

-- G1. Rank items from highest to lowest Net Sales
SELECT
    RANK() OVER (ORDER BY SUM(Net_Sales) DESC) AS Sales_Rank,
    Item_Name,
    ROUND(SUM(Net_Sales), 2) AS Net_Sales
FROM sales
GROUP BY Item_Name;

-- G2. Bonus: rank items inside each category
SELECT
    Category,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Net_Sales) DESC) AS Rank_In_Category,
    Item_Name,
    ROUND(SUM(Net_Sales), 2) AS Net_Sales
FROM sales
GROUP BY Category, Item_Name
ORDER BY Category, Rank_In_Category;
