DESCRIBE ecommerce_sales;

SELECT *
FROM ecommerce_sales_34500
LIMIT 10;

rename table ecommerce_sales_34500
to ecommerce_sales;


SELECT COUNT(*)
FROM ecommerce_sales
WHERE order_date IS NULL
   OR order_date = '';

SELECT order_date
FROM ecommerce_sales
WHERE STR_TO_DATE(order_date, '%Y-%m-%d') IS NULL;

ALTER table ecommerce_sales
MODIFY COLUMN order_date DATE;

DESCRIBE ecommerce_sales;

SELECT 
	order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month
FROM ecommerce_sales
LIMIT 5;
