DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS aggregators;

CREATE TABLE branches (Branch_ID INTEGER PRIMARY KEY, Branch_Name TEXT, Emirate TEXT, Status TEXT);
CREATE TABLE aggregators (Aggregator_ID INTEGER PRIMARY KEY, Aggregator_Name TEXT, Commission_Rate REAL);
CREATE TABLE products (Product_ID INTEGER PRIMARY KEY, Item_Name TEXT, Category TEXT, Unit_Price REAL);
CREATE TABLE orders (
  Order_ID TEXT PRIMARY KEY,
  Order_Date TEXT,
  Branch_ID INTEGER REFERENCES branches(Branch_ID),
  Aggregator_ID INTEGER REFERENCES aggregators(Aggregator_ID),
  Product_ID INTEGER REFERENCES products(Product_ID),
  Order_Type TEXT, Quantity INTEGER,
  Gross_Sales REAL, Discount REAL, Commission REAL, Net_Sales REAL);
CREATE TABLE sales (Order_Date TEXT, Branch TEXT, Order_ID TEXT, Order_Type TEXT, Aggregator TEXT, Item_Name TEXT, Category TEXT, Quantity INTEGER, Gross_Sales REAL, Discount REAL, Commission REAL, Net_Sales REAL);

.mode csv
.import --skip 1 data/branches.csv branches
.import --skip 1 data/aggregators.csv aggregators
.import --skip 1 data/products.csv products
.import --skip 1 data/orders.csv orders
.import --skip 1 data/chaat_bazaar_sales_dummy.csv sales
.mode column
.headers on
SELECT 'branches' AS tbl, COUNT(*) AS rows FROM branches
UNION ALL SELECT 'aggregators', COUNT(*) FROM aggregators
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'sales', COUNT(*) FROM sales;
SELECT typeof(Net_Sales) AS net_sales_type FROM sales LIMIT 1;
