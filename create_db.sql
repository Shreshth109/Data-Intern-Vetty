CREATE DATABASE IF NOT EXISTS ecommerce_test;
USE ecommerce_test; 


-- Items Table
CREATE TABLE items (
    store_id VARCHAR(5),
    item_id VARCHAR(5),
    item_category VARCHAR(50),
    item_name VARCHAR(50),
    PRIMARY KEY (store_id, item_id)
);

-- Transactions Table
CREATE TABLE transactions (
    buyer_id INT,
    purchase_time TIMESTAMP,
    refund_time TIMESTAMP NULL,
    store_id VARCHAR(5),
    item_id VARCHAR(5),
    gross_transaction_value INT,
    FOREIGN KEY (store_id, item_id) REFERENCES items(store_id, item_id)
);


INSERT INTO items (store_id, item_id, item_category, item_name) VALUES
('a','a1','pants', 'denim pants'),
('a','a2','tops', 'blouse'),
('b','b1','table','coffee table'),
('b','b2','chair','lounge chair'),
('b','b3','chair','armchair'),
('c','c1','jewelry','bracelet'),
('d','d3','furniture','desk'),
('e','e7','electronics','airpods'),
('g','g6','electronics','smartwatch');


INSERT INTO transactions VALUES
(3, '2019-09-19 21:19:06', NULL, 'a', 'a1', 58),
(12, '2019-10-20 20:10:14', '2019-12-15 23:19:06', 'b', 'b2', 475),
(3, '2019-09-23 12:09:35', '2019-09-27 02:55:02', 'g', 'g6', 501),
(20, '2020-02-01 23:59:46', '2020-09-02 21:22:06', 'a', 'a2', 255),
(2, '2020-04-30 20:19:06', NULL, 'd', 'd3', 250),
(18, '2020-02-12 20:22:06', NULL, 'c', 'c1', 91),
(8, '2020-04-06 12:10:22', NULL, 'b', 'b3', 24),
(15, '2020-05-12 09:20:55', NULL, 'e', 'e7', 264),
(1, '2020-06-19 11:14:22', NULL, 'a', 'a1', 99),
(6, '2020-06-20 17:50:01', '2020-06-22 18:51:03', 'b', 'b1', 380),
(3, '2020-07-19 10:32:11', NULL, 'c', 'c1', 145),
(15, '2020-08-21 15:05:29', NULL, 'b', 'b2', 500),
(7, '2020-09-03 08:25:46', NULL, 'g', 'g6', 200),
(20, '2020-10-03 12:46:59', NULL, 'a', 'a2', 260),
(3, '2020-10-05 09:20:44', NULL, 'b', 'b3', 210),
(3, '2020-10-06 14:22:17', NULL, 'e', 'e7', 350),
(3, '2020-10-11 07:31:22', NULL, 'd', 'd3', 450),
(3, '2020-10-17 22:44:43', NULL, 'a', 'a1', 99),
(3, '2020-10-27 17:11:03', NULL, 'c', 'c1', 88);

