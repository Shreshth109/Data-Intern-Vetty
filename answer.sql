USE ecommerce_test; 

-- Q1: Count purchases per month excluding refunded orders
-- Purchases are grouped by month and counted, filtered by refund and sorted
SELECT 
    MONTH(purchase_time) AS purchase_month,
    COUNT(*) AS total_purchases
FROM transactions
WHERE refund_time IS NULL
GROUP BY 1
ORDER BY 1;

-- Q2: Count stores with >=5 transactions in Oct-2020 (ignore refunds or not explicitly stated)
-- Filter transactions belonging to October 2020, then group by store_id.
-- Using HAVING COUNT(*) >= 5 checks which stores reached at least 5 orders.
SELECT store_id, COUNT(*) AS total_orders
FROM transactions
WHERE DATE_TRUNC('month', purchase_time) = '2020-10-01'
GROUP BY store_id
HAVING COUNT(*) >= 5;
