-- Day 2 Mini Challenge: Chaat Bazaar sales table
-- Table: sales (date, branch, item, quantity, gross_sales, discount, net_sales)
-- Note: run against data/chaat_bazaar_sales_dummy.csv loaded as "sales"

-- 1. All sales records
SELECT * FROM sales;

-- 2. Only JVC branch records
SELECT * FROM sales
WHERE Branch = 'JVC';

-- 3. Orders with net sales above AED 100
SELECT * FROM sales
WHERE Net_Sales > 100;

-- 4. Sales between two dates
SELECT * FROM sales
WHERE Order_Date BETWEEN '2026-07-10' AND '2026-07-20';

-- 5. Unique branch names
SELECT DISTINCT Branch FROM sales;

-- 6. Sales sorted highest to lowest
SELECT * FROM sales
ORDER BY Net_Sales DESC;

-- 7. Top 10 sales transactions
SELECT * FROM sales
ORDER BY Net_Sales DESC
LIMIT 10;

-- Bonus (combines 3 + 6 + 7): top 10 orders above AED 100
SELECT Order_ID, Branch, Item_Name, Net_Sales FROM sales
WHERE Net_Sales > 100
ORDER BY Net_Sales DESC
LIMIT 10;
