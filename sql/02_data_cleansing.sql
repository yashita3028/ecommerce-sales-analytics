-- ============================================================
-- E-COMMERCE SALES ANALYTICS
-- ============================================================
-- Purpose:
-- Profile the raw e-commerce dataset, identify data-quality
-- issues, validate important fields, and prepare the data
-- for exploratory and business analysis.
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- 1. INITIAL DATA CHECK
-- ============================================================

-- Preview the dataset
SELECT *
FROM ecommerce_sales
LIMIT 10;


-- Check the total number of records
SELECT COUNT(*) AS total_rows
FROM ecommerce_sales;


-- Review column names and data types
DESCRIBE ecommerce_sales;


-- ============================================================
-- 2. CHECK FOR DUPLICATE ORDERS
-- ============================================================

-- Identify order IDs appearing more than once
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM ecommerce_sales
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;


-- Count the number of unique orders
SELECT
    COUNT(DISTINCT order_id) AS unique_orders
FROM ecommerce_sales;


-- ============================================================
-- 3. CHECK MISSING IDENTIFIERS
-- ============================================================

-- Missing customer IDs
SELECT COUNT(*) AS missing_customer_ids
FROM ecommerce_sales
WHERE customer_id IS NULL
   OR TRIM(customer_id) = '';


-- Missing product IDs
SELECT COUNT(*) AS missing_product_ids
FROM ecommerce_sales
WHERE product_id IS NULL
   OR TRIM(product_id) = '';


-- Missing order IDs
SELECT COUNT(*) AS missing_order_ids
FROM ecommerce_sales
WHERE order_id IS NULL
   OR TRIM(order_id) = '';


-- ============================================================
-- 4. CHECK ORDER DATE
-- ============================================================

-- Check missing or blank order dates
SELECT COUNT(*) AS missing_order_dates
FROM ecommerce_sales
WHERE order_date IS NULL;


-- NOTE:
-- We previously validated order_date while it was stored as
-- TEXT and confirmed that the values followed YYYY-MM-DD.
-- It was then converted to DATE.


-- Verify that MySQL recognizes the date
SELECT
    order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month
FROM ecommerce_sales
LIMIT 10;


-- ============================================================
-- 5. CHECK NUMERIC VALUES
-- ============================================================

-- Missing prices
SELECT COUNT(*) AS missing_prices
FROM ecommerce_sales
WHERE price IS NULL;


-- Invalid prices
SELECT *
FROM ecommerce_sales
WHERE price <= 0;


-- Missing quantities
SELECT COUNT(*) AS missing_quantities
FROM ecommerce_sales
WHERE quantity IS NULL;


-- Invalid quantities
SELECT *
FROM ecommerce_sales
WHERE quantity <= 0;


-- Missing discounts
SELECT COUNT(*) AS missing_discounts
FROM ecommerce_sales
WHERE discount IS NULL;


-- Inspect discount range
SELECT
    MIN(discount) AS minimum_discount,
    MAX(discount) AS maximum_discount
FROM ecommerce_sales;


-- ============================================================
-- 6. CHECK CATEGORICAL VALUES
-- ============================================================

-- Product categories
SELECT DISTINCT category
FROM ecommerce_sales
ORDER BY category;


-- Regions
SELECT DISTINCT region
FROM ecommerce_sales
ORDER BY region;


-- Payment methods
SELECT DISTINCT payment_method
FROM ecommerce_sales
ORDER BY payment_method;


-- Return values
SELECT DISTINCT returned
FROM ecommerce_sales;


-- Customer gender values
SELECT DISTINCT customer_gender
FROM ecommerce_sales;


-- ============================================================
-- 7. CHECK CUSTOMER AGE
-- ============================================================

SELECT
    MIN(customer_age) AS youngest_customer,
    MAX(customer_age) AS oldest_customer,
    AVG(customer_age) AS average_customer_age
FROM ecommerce_sales;


-- Identify potentially invalid ages
SELECT *
FROM ecommerce_sales
WHERE customer_age <= 0;


-- ============================================================
-- 8. FINAL VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM ecommerce_sales;
