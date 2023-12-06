/* Customer visited but no transaction
Source: Leetcode SQL 50
Ranked as Easy
Table: Visits
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.
This table contains information about the customers who visited the mall.
 
Table: Transactions
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
This table contains information about the transactions made during the visit_id.
 
Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
Return the result table sorted in any order.
The result format is in the following example.
Example 1:
Input: 
Visits
+----------+-------------+
| visit_id | customer_id |
+----------+-------------+
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |
+----------+-------------+
Transactions
+----------------+----------+--------+
| transaction_id | visit_id | amount |
+----------------+----------+--------+
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
+----------------+----------+--------+
Output: 
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
Explanation: 
Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
Customer with id = 30 visited the mall once and did not make any transactions.
Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
Customer with id = 96 visited the mall once and did not make any transactions.
As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.
*/

-- Use Schema
USE leetcode_sql;

-- Drop Visits table if exists
DROP TABLE IF EXISTS Visits;

-- Create Visits table;
CREATE TABLE Visits(
	visit_id INT,
    	customer_id INT
)
;

-- Insert values to Visit table
INSERT INTO Visits(
	visit_id,
    	customer_id
)
VALUES
    (1, 23),
    (2, 9),
    (4, 30),
    (5, 54),
    (6, 96),
    (7, 54),
    (8, 54)
;

-- Check if the Visit table is properly populated
SELECT * FROM Visits;

-- Drop Transactions table if exist
DROP TABLE IF EXISTS Transactions;

-- Create Transactions table
CREATE TABLE Transactions(
	transaction_id INT,
    	visit_id INT,
    	amount INT
)
;

-- Insert values to Transaction table
INSERT INTO Transactions(
	transaction_id,
    	visit_id,
    	amount
)
VALUES
    (2, 5, 310),
    (3, 5, 300),
    (9, 5, 200),
    (12, 1, 910),
    (13, 2, 970)
;

-- Check if the Transaction table is properly populated
SELECT * FROM Transactions;
SELECT * FROM Visits;

/* First solution is using the LEFT JOIN and checking if the 
Visits table visit_id is not in the Transaction table visit_id olumn
*/
-- Join the Visits and Transaction table
SELECT visits.customer_id,
       COUNT(visits.visit_id) AS count_no_trans
FROM Visits AS visits
LEFT JOIN Transactions AS transactions
	ON visits.visit_id = transactions.visit_id
WHERE visits.visit_id NOT IN (SELECT visit_id FROM transactions)
GROUP BY visits.customer_id
ORDER BY count_no_trans DESC, customer_id ASC
;

/* First solution is using the LEFT JOIN and checking if the 
Visits table visit_id is not in the Transaction table visit_id olumn
*/
SELECT visits.customer_id,
	COUNT(visits.customer_id)
FROM Visits AS visits
LEFT JOIN Transactions AS transactions
	ON visits.visit_id = transactions.visit_id
WHERE transactions.amount IS NULL
GROUP BY visits.customer_id
;

/* Second solution is using the LEFT and RIGHT JOIN. MySQL does not have
the FULL OUTER JOIN. Make sure to alias the visit_id properly becuase it will cause
an error "Duplicate column name 'visit_id'"
*/
SELECT t1.customer_id, 
	-- 	COUNT(t1.transaction_id)
    	COUNT(t1.customer_id) AS count_no_trans
FROM
    -- Use subquery
    -- MySQL has no FULL OUTER JOIN. Below code is similar for it.
	(SELECT visits.visit_id, 
		visits.customer_id, 
		-- transactions.visit_id, Comment out because causing error 'Duplicate column name 'visit_id'
        transactions.transaction_id, 
        transactions.amount
	FROM Visits AS visits
	LEFT JOIN Transactions AS transactions
		ON visits.visit_id = transactions.visit_id
	UNION
	SELECT -- visits.visit_id, -- Comment out because causing error 'Duplicate column name 'visit_id'  
		visits.customer_id, 
		transactions.visit_id, 
        transactions.transaction_id, 
        transactions.amount
	FROM Visits AS visits
	RIGHT JOIN Transactions AS transactions
	ON visits.visit_id = transactions.visit_id
     -- WHERE transactions.visit_id IS NULL) AS t1
     ) AS t1
-- With the SELECT t1.customer_id will pull out the transaction that is NULL
WHERE t1.transaction_id IS NULL
GROUP BY t1.customer_id
ORDER BY count_no_trans DESC
;

/* Results
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
*/

-- Want to see the result of the FULL JOIN
SELECT visits.visit_id, 
	visits.customer_id, 
	-- transactions.visit_id, Comment out because causing error 'Duplicate column name 'visit_id'
        transactions.transaction_id, 
        transactions.amount
FROM Visits AS visits
LEFT JOIN Transactions AS transactions
	ON visits.visit_id = transactions.visit_id
UNION
SELECT -- visits.visit_id, -- Comment out because causing error 'Duplicate column name 'visit_id'  
		visits.customer_id, 
		transactions.visit_id, 
        transactions.transaction_id, 
        transactions.amount
FROM Visits AS visits
RIGHT JOIN Transactions AS transactions
	ON visits.visit_id = transactions.visit_id
