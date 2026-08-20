-- Day 4: Data Validation. Zero rows returned = check passes.

-- V1. Duplicate Order_ID
SELECT Order_ID, COUNT(*) FROM orders GROUP BY Order_ID HAVING COUNT(*) > 1;

-- V2. Missing Order_ID
SELECT * FROM orders WHERE Order_ID IS NULL OR TRIM(Order_ID) = '';

-- V3. Missing Branch
SELECT * FROM orders WHERE Branch_ID IS NULL;

-- V4. Negative Gross Sales
SELECT * FROM orders WHERE Gross_Sales < 0;

-- V5. Negative Net Sales
SELECT * FROM orders WHERE Net_Sales < 0;

-- V6. Net Sales greater than Gross Sales
SELECT Order_ID, Gross_Sales, Net_Sales FROM orders WHERE Net_Sales > Gross_Sales;

-- V7. Commission greater than Gross Sales
SELECT Order_ID, Gross_Sales, Commission FROM orders WHERE Commission > Gross_Sales;

-- V8. Invalid branch (order points to a Branch_ID that does not exist)
SELECT o.Order_ID, o.Branch_ID FROM orders o
LEFT JOIN branches b ON o.Branch_ID = b.Branch_ID
WHERE b.Branch_ID IS NULL;

-- V9. Impossible quantity
SELECT * FROM orders WHERE Quantity <= 0 OR Quantity > 100;

-- V10. Duplicate records (entire row repeated)
SELECT Order_Date, Branch_ID, Product_ID, Quantity, Gross_Sales, COUNT(*)
FROM orders
GROUP BY Order_Date, Branch_ID, Product_ID, Quantity, Gross_Sales
HAVING COUNT(*) > 1;

-- V11. Column type check (the Day 3 lesson): Net_Sales must be numeric
SELECT typeof(Net_Sales) AS stored_type, COUNT(*)
FROM sales GROUP BY typeof(Net_Sales) HAVING typeof(Net_Sales) = 'text';
