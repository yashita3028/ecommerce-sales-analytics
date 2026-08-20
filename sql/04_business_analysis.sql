-- ============================================================
-- E-COMMERCE SALES ANALYTICS
-- ============================================================
-- Purpose:
-- Answer business questions related to revenue, customers,
-- products, returns, profitability, and growth using SQL.
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- BUSINESS QUESTION 1
-- What is the company's overall sales performance?
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(
        SUM(total_amount) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales;


-- ============================================================
-- BUSINESS QUESTION 2
-- Which categories generate the most revenue?
-- ============================================================

SELECT
    category,
    ROUND(SUM(total_amount), 2) AS revenue,
    SUM(quantity) AS units_sold
FROM ecommerce_sales
GROUP BY category
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 3
-- Which regions generate the most revenue?
-- ============================================================

SELECT
    region,
    ROUND(SUM(total_amount), 2) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM ecommerce_sales
GROUP BY region
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 4
-- What is the return rate?
-- ============================================================

SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate_percentage
FROM ecommerce_sales;


-- ============================================================
-- BUSINESS QUESTION 5
-- Which categories have the highest return rate?
-- ============================================================

SELECT
    category,
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN returned = 'Yes' THEN 1
            ELSE 0
        END
    ) AS returned_transactions,

    ROUND(
        100.0 *
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate_percentage

FROM ecommerce_sales
GROUP BY category
ORDER BY return_rate_percentage DESC;


-- ============================================================
-- BUSINESS QUESTION 6
-- Who are the highest-value customers?
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS lifetime_value
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY lifetime_value DESC
LIMIT 10;


-- ============================================================
-- BUSINESS QUESTION 7
-- Which customers spend above the average customer spend?
-- Concept: CTE + Subquery
-- ============================================================

WITH customer_spending AS (

    SELECT
        customer_id,
        SUM(total_amount) AS total_spent
    FROM ecommerce_sales
    GROUP BY customer_id

)

SELECT
    customer_id,
    ROUND(total_spent, 2) AS total_spent
FROM customer_spending

WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM customer_spending
)

ORDER BY total_spent DESC;


-- ============================================================
-- BUSINESS QUESTION 8
-- What is monthly revenue?
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(total_amount), 2) AS revenue
FROM ecommerce_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- ============================================================
-- BUSINESS QUESTION 9
-- What is month-over-month revenue growth?
-- Concept: CTE + LAG Window Function
-- ============================================================

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_amount) AS revenue
    FROM ecommerce_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')

),

revenue_comparison AS (

    SELECT
        month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_revenue

)

SELECT
    month,

    ROUND(revenue, 2) AS revenue,

    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,

    ROUND(
        (
            (revenue - previous_month_revenue)
            / previous_month_revenue
        ) * 100,
        2
    ) AS month_over_month_growth_percentage

FROM revenue_comparison
ORDER BY month;


-- ============================================================
-- BUSINESS QUESTION 10
-- Rank products by sales within each category.
-- Concept: Window Function
-- ============================================================

WITH product_sales AS (

    SELECT
        category,
        product_id,
        SUM(total_amount) AS revenue
    FROM ecommerce_sales
    GROUP BY category, product_id

)

SELECT
    category,
    product_id,
    ROUND(revenue, 2) AS revenue,

    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS product_rank

FROM product_sales
ORDER BY category, product_rank;


-- ============================================================
-- BUSINESS QUESTION 11
-- Find the top 5 customers within each region.
-- Concept: CTE + DENSE_RANK
-- ============================================================

WITH customer_region_sales AS (

    SELECT
        region,
        customer_id,
        SUM(total_amount) AS total_spent
    FROM ecommerce_sales
    GROUP BY region, customer_id

),

ranked_customers AS (

    SELECT
        region,
        customer_id,
        total_spent,

        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY total_spent DESC
        ) AS customer_rank

    FROM customer_region_sales

)

SELECT
    region,
    customer_id,
    ROUND(total_spent, 2) AS total_spent,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 5
ORDER BY region, customer_rank;


-- ============================================================
-- BUSINESS QUESTION 12
-- How do discounts affect sales?
-- Concept: CASE
-- ============================================================

SELECT

    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN '1-10%'
        WHEN discount <= 20 THEN '11-20%'
        ELSE 'Above 20%'
    END AS discount_group,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(SUM(total_amount), 2) AS revenue,

    ROUND(AVG(total_amount), 2) AS average_transaction_value

FROM ecommerce_sales

GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN '1-10%'
        WHEN discount <= 20 THEN '11-20%'
        ELSE 'Above 20%'
    END

ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 13
-- Which payment methods generate the most revenue?
-- ============================================================

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 14
-- Which regions have the highest average order value?
-- ============================================================

SELECT
    region,

    ROUND(
        SUM(total_amount) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value

FROM ecommerce_sales
GROUP BY region
ORDER BY average_order_value DESC;


-- ============================================================
-- BUSINESS QUESTION 15
-- Compare sales performance by year.
-- ============================================================

SELECT
    YEAR(order_date) AS year,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(total_amount), 2) AS revenue,
    ROUND(AVG(total_amount), 2) AS average_transaction_value
FROM ecommerce_sales
GROUP BY YEAR(order_date)
ORDER BY year;
