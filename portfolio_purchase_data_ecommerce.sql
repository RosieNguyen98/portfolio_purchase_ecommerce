SELECT *
FROM purchase;

-- Looking at total revenue per product category
SELECT product_category, round(sum(value), 0) AS total_revenue
FROM purchase
GROUP BY product_category
-- HAVING product_category = 505
ORDER BY 1;

-- Looking at frequencies of purchasing per product categories
SELECT product_category, count(value) AS frequency
FROM purchase
GROUP BY product_category
ORDER BY 1;

-- Join purchase vs payment_method
-- DROP VIEW IF EXISTS purchase_archived
CREATE VIEW purchase_archived AS
SELECT date, customer_id, product_category, name AS payment_method, value, time_on_site, clicks_in_site
FROM purchase p
JOIN payment_method pm
    ON p.payment_method = pm.payment_method_id;

-- Looking at frequencies of using payment_method
SELECT payment_method, count(payment_method) AS frequency
FROM purchase_archived
GROUP BY 1;

-- Temp table
-- DROP TABLE IF EXISTS product_category
CREATE TABLE product_category
(
date DATE,
product_category INT,
average_value INT,
average_clicks_in_site INT,
average_time_on_site INT
);
INSERT INTO product_category
SELECT date, 
       product_category,
       round(avg(value), 0) AS average_value,
       ceiling(avg(clicks_in_site)) AS average_clicks_in_site,
       ceiling(avg(time_on_site)) AS average_time_on_site
FROM purchase_archived
GROUP BY product_category
ORDER BY 2;

-- Looking at average value per payment method
SELECT payment_method, floor(avg(value)) AS average_value
FROM purchase_archived
GROUP BY payment_method;

-- Looking at fequences of purchasing per customer
CREATE VIEW customer_history AS
SELECT date,
       customer_id,
       count(customer_id) AS repeated_purchase,
       CASE
             WHEN count(customer_id) in (1,2,3) THEN 'potential'
             ELSE 'loyal'
		END AS customer_type
FROM purchase_archived
GROUP BY customer_id
