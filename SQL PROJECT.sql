CREATE DATABASE superstore_project;
USE superstore_project;
SELECT * FROM  superstore;
ALTER TABLE `sql superstore`
RENAME TO superstore;
SELECT COUNT(DISTINCT `Customer ID`)
FROM superstore;
SELECT COUNT(DISTINCT `Product id`) FROM superstore;
SELECT region, COUNT(`order id`)
FROM superstore
GROUP BY region;
SELECT SUM(sales) AS total_sales
FROM superstore;
SELECT SUM(profit) AS total_profit
FROM superstore;
SELECT category, SUM(sales)
FROM superstore
GROUP BY category;
SELECT category, SUM(profit)
FROM superstore
GROUP BY category;
SELECT region, SUM(sales)
FROM superstore
GROUP BY region;
SELECT `product name`, SUM(sales) AS total_sales
FROM superstore
GROUP BY `product name`
ORDER BY total_sales DESC
LIMIT 10;
SELECT `product name`, SUM(profit) AS total_profit
FROM superstore
GROUP BY `product name`
ORDER BY total_profit DESC
LIMIT 10;
SELECT `product name`, SUM(quantity) AS total_quantity
FROM superstore
GROUP BY `product name`
ORDER BY total_quantity DESC
LIMIT 10;
SELECT `customer name`, SUM(sales) AS total_spent
FROM superstore
GROUP BY `customer name`
ORDER BY total_spent DESC
LIMIT 10;
SELECT `customer name`, SUM(profit) AS total_profit
FROM superstore
GROUP BY `customer name`
ORDER BY total_profit DESC
LIMIT 10;
SELECT city, SUM(sales) AS total_sales
FROM superstore
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;
SELECT state, SUM(profit) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_profit DESC
LIMIT 10;
SELECT 
YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS year,
MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')) AS month,
SUM(Sales) AS total_sales
FROM superstore
GROUP BY year, month
ORDER BY year, month;
ALTER TABLE superstore
ADD order_date_fixed DATE;
UPDATE superstore
SET order_date_fixed = STR_TO_DATE(`Order Date`, '%d-%m-%Y');
CREATE TABLE customers AS
SELECT DISTINCT
`Customer ID`,
`Customer Name`,
Segment,
City,
State,
Region
FROM superstore;
CREATE TABLE products AS
SELECT DISTINCT
`Product ID`,
`Product Name`,
Category,
`Sub-Category`
FROM superstore;
CREATE TABLE orders AS
SELECT
`Order ID`,
`Order Date`,
`Ship Date`,
`Ship Mode`,
`Customer ID`,
`Product ID`,
Sales,
Quantity,
Discount,
Profit
FROM superstore;
SELECT 
c.`Customer Name`,
o.`Order ID`,
o.Sales
FROM orders o
JOIN customers c
ON o.`Customer ID` = c.`Customer ID`;
SELECT 
p.`Product Name`,
SUM(o.Sales) AS total_sales
FROM orders o
JOIN products p
ON o.`Product ID` = p.`Product ID`
GROUP BY p.`Product Name`
ORDER BY total_sales DESC
LIMIT 10;
SELECT 
c.`Customer Name`,
SUM(o.Sales) AS total_spent
FROM orders o
JOIN customers c
ON o.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY total_spent DESC
LIMIT 10;
SELECT 
p.Category,
SUM(o.Sales) AS total_sales
FROM orders o
JOIN products p
ON o.`Product ID` = p.`Product ID`
GROUP BY p.Category;
SELECT 
c.`Customer Name`,
p.`Product Name`,
o.Sales
FROM orders o
JOIN customers c
ON o.`Customer ID` = c.`Customer ID`
JOIN products p
ON o.`Product ID` = p.`Product ID`
LIMIT 20;
SELECT 
p.Category,
p.`Product Name`,
SUM(o.Sales) AS total_sales,
RANK() OVER (PARTITION BY p.Category ORDER BY SUM(o.Sales) DESC) AS rank_in_category
FROM orders o
JOIN products p
ON o.`Product ID` = p.`Product ID`
GROUP BY p.Category, p.`Product Name`;
SELECT 
c.`Customer Name`,
SUM(o.Sales) AS total_spent
FROM orders o
JOIN customers c
ON o.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
HAVING total_spent >
(
SELECT AVG(total_sales)
FROM
(
SELECT SUM(Sales) AS total_sales
FROM orders
GROUP BY `Customer ID`
) avg_table
);
SELECT
`Order Date`,
Sales,
SUM(Sales) OVER (ORDER BY `Order Date`) AS running_total_sales
FROM orders;
SELECT
p.Category,
SUM(o.Profit) AS total_profit
FROM orders o
JOIN products p
ON o.`Product ID` = p.`Product ID`
GROUP BY p.Category
ORDER BY total_profit DESC;
SELECT *
FROM
(
SELECT
c.Region,
c.`Customer Name`,
SUM(o.Sales) AS total_sales,
RANK() OVER (PARTITION BY c.Region ORDER BY SUM(o.Sales) DESC) AS rnk
FROM orders o
JOIN customers c
ON o.`Customer ID` = c.`Customer ID`
GROUP BY c.Region, c.`Customer Name`
) ranked
WHERE rnk <= 5;
SELECT
`Order ID`,
Profit,
CASE
WHEN Profit > 200 THEN 'High Profit'
WHEN Profit BETWEEN 0 AND 200 THEN 'Medium Profit'
ELSE 'Loss'
END AS profit_category
FROM orders;
SELECT
p.`Product Name`,
SUM(o.Quantity) AS total_quantity
FROM orders o
JOIN products p
ON o.`Product ID` = p.`Product ID`
GROUP BY p.`Product Name`
ORDER BY total_quantity DESC
LIMIT 10;