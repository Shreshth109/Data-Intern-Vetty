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
WHERE MONTH(purchase_time) = '2020-10-01'
GROUP BY store_id
HAVING COUNT(*) >= 5;


-- Q3: Shortest refund interval per store (only refunded orders)
-- We calculate the difference between 
-- refund_time and purchase_time for refunded orders and convert it to minutes. Using MIN() gives each store’s smallest refund processing time.
SELECT store_id, MIN(TIMESTAMPDIFF(MINUTE, purchase_time, refund_time)) AS min_refund_minutes
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;

-- Q4: Find each store's first order gross transaction value
-- Window function ROW_NUMBER() orders each store’s purchases by time. 
-- The first ranked row (rn=1) represents the store’s earliest purchase, 
-- so we return its value.
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY purchase_time) AS rn
    FROM transactions
)
SELECT store_id, gross_transaction_value
FROM ranked
WHERE rn = 1;


-- Q5: Most ordered item on buyers' first purchase
-- Determine each buyer’s earliest purchase, join it with 
-- the items table, group by item name, and count occurrences. 
-- The one with the highest count is the most popular first-purchase item.
WITH buyer_first AS (
    SELECT buyer_id, MIN(purchase_time) AS first_purchase
    FROM transactions
    GROUP BY buyer_id
),
join_items AS (
    SELECT t.*, i.item_name
    FROM transactions t
    JOIN buyer_first bf 
        ON t.buyer_id = bf.buyer_id AND t.purchase_time = bf.first_purchase
    JOIN items i 
        ON t.item_id = i.item_id AND t.store_id = i.store_id
)
SELECT item_name, COUNT(*) AS order_count
FROM join_items
GROUP BY item_name
ORDER BY order_count DESC
LIMIT 1;

-- Q6: Add a flag indicating if refund can be processed (within 72 hours)
-- We check if the difference between purchase and refund times is ≤ 72 hours. 
-- If true, assign a flag 1, else 0. Null refunds are automatically flagged as 0.
SELECT
    buyer_id,
    purchase_time,
    refund_time,
    store_id,
    item_id,
    gross_transaction_value,
    CASE
        WHEN refund_time IS NOT NULL AND TIMESTAMPDIFF(HOUR, purchase_time, refund_time) <= 72 THEN 1 -- refund can be processed
        ELSE 0 -- refund cannot be processed (or no refund)
    END AS refund_processable_flag
FROM
    transactions;

-- Q7: Rank purchases per buyer and select only the second non-refunded purchase
-- Ignore refunded orders, then assign a row number per buyer based on purchase 
-- time. The record with rank 2 represents the second successful purchase and is filtered.
WITH ranked_purchases AS (
    SELECT
        t.*,
        ROW_NUMBER() OVER (
            PARTITION BY buyer_id
            ORDER BY purchase_time
        ) AS purchase_rank
    FROM transactions t
    WHERE refund_time IS NULL      -- ignore refunded purchases
)
SELECT *
FROM ranked_purchases
WHERE purchase_rank = 2;




