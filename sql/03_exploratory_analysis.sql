-- ============================================================
-- E-COMMERCE SALES ANALYTICS
-- ============================================================
-- Purpose:
-- Explore the cleaned dataset to understand customers,
-- products, sales activity, regions, and transaction patterns.
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- 1. DATASET OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM ecommerce_sales;


-- ============================================================
-- 2. DATE RANGE
-- ============================================================

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM ecommerce_sales;


-- ============================================================
-- 3. PRODUCT CATEGORIES
-- ============================================================

SELECT
    category,
    COUNT(*) AS transactions
FROM ecommerce_sales
GROUP BY category
ORDER BY transactions DESC;


-- ============================================================
-- 4. REGIONAL DISTRIBUTION
-- ============================================================

SELECT
    region,
    COUNT(*) AS transactions
FROM ecommerce_sales
GROUP BY region
ORDER BY transactions DESC;


-- ============================================================
-- 5. PAYMENT METHODS
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS transactions
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY transactions DESC;


-- ============================================================
-- 6. CUSTOMER DEMOGRAPHICS
-- ============================================================

SELECT
    customer_gender,
    COUNT(DISTINCT customer_id) AS customers
FROM ecommerce_sales
GROUP BY customer_gender
ORDER BY customers DESC;


-- Customer age statistics
SELECT
    MIN(customer_age) AS minimum_age,
    MAX(customer_age) AS maximum_age,
    ROUND(AVG(customer_age), 1) AS average_age
FROM ecommerce_sales;


-- ============================================================
-- 7. SALES BY YEAR
-- ============================================================

SELECT
    YEAR(order_date) AS order_year,
    COUNT(*) AS transactions,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM ecommerce_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- ============================================================
-- 8. SALES BY MONTH
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS transactions,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM ecommerce_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


-- ============================================================
-- 9. SALES BY CATEGORY
-- ============================================================

SELECT
    category,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 10. SALES BY REGION
-- ============================================================

SELECT
    region,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;


-- ============================================================
-- 11. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(
        SUM(total_amount) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales;


-- ============================================================
-- 12. RETURN DISTRIBUTION
-- ============================================================

SELECT
    returned,
    COUNT(*) AS transactions
FROM ecommerce_sales
GROUP BY returned;


-- ============================================================
-- 13. DELIVERY PERFORMANCE
-- ============================================================

SELECT
    ROUND(AVG(delivery_time_days), 2)
        AS average_delivery_days,
    MIN(delivery_time_days)
        AS fastest_delivery,
    MAX(delivery_time_days)
        AS slowest_delivery
FROM ecommerce_sales;


-- ============================================================
-- 14. TOP CUSTOMERS
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_spent
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================
-- 15. TOP PRODUCTS
-- ============================================================

SELECT
    product_id,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM ecommerce_sales
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;
