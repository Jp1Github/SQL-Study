/* Monthly Transaction I
Ranked as Medium
Source: Leetcode SQL 50
Table: Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 
Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
Return the result table in any order.
The query result format is in the following example.

Example 1:
Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/

-- Use Schema
USE leetcode_sql;

-- Create a Transactions table
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
	id INT,
    	country VARCHAR(10),
    	state ENUM("approved", "declined"),
    	amount INT,
    	trans_date DATE
)
;

-- Insert values to Queries table
INSERT INTO Transactions (
     id,
    country,
    state,
    amount,
    trans_date
    )
VALUES
	(121,	'US',	'approved',	1000,	'2018-12-18'),
	(122,	'US',	'declined',	2000,	'2018-12-19'),
	(123,	'US',	'approved',	2000,	'2019-01-01'),
	(124,   'DE',	'approved',	2000,	'2019-01-07')
;	

/* Check if the Queries table is properly populated */
SELECT * FROM Transactions;

/* 1st. Solution */
SELECT 
	DATE_FORMAT(trans_date,'%Y-%m') AS month,
	country, 
        COUNT(state) AS trans_count,
        SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
        SUM(amount) AS trans_total_amount,
        SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country
;

/* Alternative - Breaking down into 2 tables. NOTE: Will not work in Leetcode!!! */
-- AS the 1st table including approved and decline
CREATE VIEW CTE_1 AS 
	SELECT 
		DATE_FORMAT(trans_date,'%Y-%m') AS month,
		country, 
        COUNT(state) AS trans_count,
        SUM(amount) AS trans_total_amount
	FROM Transactions
	GROUP BY month, country
;
-- 2nd table including only the approved
CREATE VIEW CTE_2 AS
	SELECT
		DATE_FORMAT(trans_date,'%Y-%m') AS month,
		country,
        SUM(amount) AS approved_total_amount,
        COUNT(state) AS approved_count
	FROM Transactions
	WHERE state = 'approved'
	GROUP BY month, country 
;

/* Then combine the 2 views together by month and country */
SELECT 
    c1.month,
    c1.country,
    c1.trans_count,
    c2.approved_count,
    c1.trans_total_amount,
    c2.approved_total_amount
FROM CTE_1 AS c1
JOIN CTE_2 AS c2
	ON c1.month = c2.month AND c1.country = c2.country
    -- ON c1.month = c2.month -- Will put another rows of data
;
