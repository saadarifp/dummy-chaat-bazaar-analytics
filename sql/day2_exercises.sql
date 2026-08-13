-- Day 2 SQL Exercises (15) — covers SELECT, FROM, WHERE, DISTINCT,
-- ORDER BY, LIMIT, AND/OR, IN, BETWEEN, LIKE
-- Run against data/chaat_bazaar_sales_dummy.csv loaded as "sales"

-- 1. SELECT specific columns
SELECT Order_ID, Item_Name, Net_Sales FROM sales;

-- 2. WHERE with equality
SELECT * FROM sales WHERE Category = 'Chaat';

-- 3. WHERE with inequality
SELECT * FROM sales WHERE Quantity >= 4;

-- 4. AND — Talabat delivery orders from Karama
SELECT * FROM sales
WHERE Aggregator = 'Talabat' AND Branch = 'Karama';

-- 5. OR — orders from either JVC or Barsha
SELECT * FROM sales
WHERE Branch = 'JVC' OR Branch = 'Barsha';

-- 6. IN — cleaner version of exercise 5, plus Muweilah
SELECT * FROM sales
WHERE Branch IN ('JVC', 'Barsha', 'Muweilah');

-- 7. BETWEEN on numbers — mid-range orders
SELECT * FROM sales
WHERE Net_Sales BETWEEN 30 AND 80;

-- 8. LIKE — every item containing 'Puri'
SELECT * FROM sales
WHERE Item_Name LIKE '%Puri%';

-- 9. LIKE with a starting pattern — items beginning with 'Masala'
SELECT * FROM sales
WHERE Item_Name LIKE 'Masala%';

-- 10. DISTINCT — unique categories sold
SELECT DISTINCT Category FROM sales;

-- 11. DISTINCT on two columns — which aggregators each branch uses
SELECT DISTINCT Branch, Aggregator FROM sales
ORDER BY Branch;

-- 12. ORDER BY ascending (default) — oldest orders first
SELECT Order_Date, Order_ID, Net_Sales FROM sales
ORDER BY Order_Date;

-- 13. ORDER BY two columns — branch A-Z, then sales high to low within each
SELECT Branch, Item_Name, Net_Sales FROM sales
ORDER BY Branch ASC, Net_Sales DESC;

-- 14. LIMIT — the 5 smallest orders
SELECT Order_ID, Item_Name, Net_Sales FROM sales
ORDER BY Net_Sales ASC
LIMIT 5;

-- 15. Everything combined — top 3 discounted delivery orders from Chaat
--     or Mains categories, most recent shown with their discount
SELECT Order_Date, Branch, Item_Name, Category, Discount, Net_Sales
FROM sales
WHERE Discount > 0
  AND Order_Type = 'Delivery'
  AND Category IN ('Chaat', 'Mains')
ORDER BY Discount DESC
LIMIT 3;
