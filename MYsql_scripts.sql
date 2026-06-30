-- ================================================================
-- PHASE 5 — BASIC SQL (Only Customers & Sellers Tables)
-- ================================================================
--  Then inside MySQL run:
--into this folder: C:\ProgramData\MySQL\MySQL Server 9.7\Uploads\
-- and run the following command in MySQL Workbench:

DROP DATABASE IF EXISTS olist_ecommerce;

CREATE DATABASE olist_ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE olist_ecommerce;

-- ================================================================
-- CREATE TABLES (Your original tables)
-- ================================================================

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

-- ================================================================
-- LOAD DATA (Your original paths)
-- ================================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/olist_customers_dataset.csv' INTO
TABLE customers FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/olist_sellers_dataset.csv' INTO
TABLE sellers FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- ================================================================
-- ROW COUNTS
-- ================================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'sellers', COUNT(*)
FROM sellers;

-- ================================================================
-- PHASE 5 QUERIES
-- ================================================================

-- 2. Simple SELECT with WHERE filters

-- Query 1
SELECT
    customer_id,
    customer_city,
    customer_state
FROM customers
WHERE
    customer_state = 'SP'
ORDER BY customer_city;
-- Business question: Which customers are located in São Paulo state?

-- Query 2
SELECT
    seller_id,
    seller_city,
    seller_state
FROM sellers
WHERE
    seller_state IN ('SP', 'RJ', 'MG')
ORDER BY seller_id;
-- Business question: Which sellers are based in the top three states?

-- 3. JOIN queries (3 examples using the two tables)

-- Join 1: Customers and Sellers in the same city
SELECT
    c.customer_city,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(DISTINCT s.seller_id) AS num_sellers
FROM customers c
    JOIN sellers s ON c.customer_city = s.seller_city
GROUP BY
    c.customer_city
ORDER BY num_customers DESC
LIMIT 10;
-- Business question: In which cities do we have both many customers and sellers?

-- Join 2
SELECT DISTINCT
    c.customer_state,
    s.seller_state
FROM customers c
    JOIN sellers s ON c.customer_state = s.seller_state;
-- Business question: Which states have both customers and sellers present?

-- Join 3
SELECT c.customer_city, COUNT(DISTINCT c.customer_id) AS total_customers
FROM customers c
    LEFT JOIN sellers s ON c.customer_city = s.seller_city
GROUP BY
    c.customer_city
HAVING
    COUNT(DISTINCT s.seller_id) = 0
ORDER BY total_customers DESC
LIMIT 10;
-- Business question: Which cities have customers but no sellers?

-- 4. GROUP BY with Aggregate functions (3 examples)

-- Group 1
SELECT
    customer_state,
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_city) AS unique_cities
FROM customers
GROUP BY
    customer_state
ORDER BY total_customers DESC;
-- Business question: How many customers and cities per state?

-- Group 2
SELECT
    seller_state,
    COUNT(*) AS total_sellers,
    COUNT(DISTINCT seller_city) AS unique_cities
FROM sellers
GROUP BY
    seller_state
ORDER BY total_sellers DESC;
-- Business question: How many sellers and cities per state?

-- Group 3
SELECT customer_city, COUNT(*) AS customer_count
FROM customers
GROUP BY
    customer_city
HAVING
    COUNT(*) > 1000
ORDER BY customer_count DESC;
-- Business question: Which cities have the highest number of customers?