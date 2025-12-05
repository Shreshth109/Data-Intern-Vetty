USE ecommerce_test; 

-- Q1: Count purchases per month excluding refunded orders
SELECT 
    MONTH(purchase_time) AS purchase_month,
    COUNT(*) AS total_purchases
FROM transactions
WHERE refund_time IS NULL
GROUP BY 1
ORDER BY 1;