DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS aggregators;

CREATE TABLE branches (Branch_ID INTEGER, Branch_Name TEXT, Emirate TEXT, Status TEXT);
CREATE TABLE aggregators (Aggregator_ID INTEGER, Aggregator_Name TEXT, Commission_Rate REAL);
CREATE TABLE products (Product_ID INTEGER, Item_Name TEXT, Category TEXT, Unit_Price REAL);
CREATE TABLE orders (Order_ID TEXT, Order_Date TEXT, Branch_ID INTEGER, Aggregator_ID INTEGER, Product_ID INTEGER, Order_Type TEXT, Quantity INTEGER, Gross_Sales REAL, Discount REAL, Commission REAL, Net_Sales REAL);

.mode csv
.import --skip 1 data/branches.csv branches
.import --skip 1 data/aggregators.csv aggregators
.import --skip 1 data/products.csv products
.import --skip 1 data/orders.csv orders
.mode column
.headers on
SELECT 'branches' AS tbl, COUNT(*) AS rows FROM branches
UNION ALL SELECT 'aggregators', COUNT(*) FROM aggregators
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders;
