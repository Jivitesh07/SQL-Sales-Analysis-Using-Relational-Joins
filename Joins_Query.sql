-- Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Amit Sharma', 'North'),
(2, 'Riya Verma', 'South'),
(3, 'John Mathew', 'East'),
(4, 'Neha Singh', 'West'),
(5, 'Arjun Patel', 'South');

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Office Supplies');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

INSERT INTO products VALUES
(101, 'Laptop', 1),
(102, 'Mobile Phone', 1),
(103, 'Office Chair', 2),
(104, 'Desk', 2),
(105, 'Printer', 3);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders VALUES
(1001, 1, '2023-01-10'),
(1002, 2, '2023-02-15'),
(1003, 1, '2023-03-20'),
(1004, 3, '2023-04-18');

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 60000),
(2, 1001, 102, 1, 20000),
(3, 1002, 105, 2, 15000),
(4, 1003, 103, 1, 12000),
(5, 1004, 104, 1, 18000);

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM products;
SELECT * FROM categories;

SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.region
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;

SELECT
    c.customer_id,
    c.customer_name,
    c.region
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;

SELECT
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
INNER JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;

SELECT
    c.region,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE c.region = 'South'
GROUP BY c.region;

SELECT
    o.order_date,
    SUM(oi.quantity * oi.unit_price) AS daily_sales
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY o.order_date
ORDER BY o.order_date;

SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 3;