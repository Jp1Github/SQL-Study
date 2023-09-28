/* Find Customer Referee
Ranked as Easy
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 
Find the names of the customer that are not referred by the customer with id = 2.
Return the result table in any order.
The result format is in the following example.

Example 1:

Input: 
Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
Output: 
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
*/

-- Use the Schema
USE leetcode_sql;

-- Drop the Customer table if there is an existing one
DROP TABLE IF EXISTS Customer;

-- Create the Customer table
-- Used TINYINT instead of INT to reduce memory since value is only one digit
CREATE TABLE Customer (
	id TINYINT,
    name VARCHAR(10),
    referee_id TINYINT
)
;

-- Insert values into the Customer table
INSERT INTO Customer (
	id,
    name,
    referee_id
)
VALUES 
	(1, 'Will', NULL),
    (2, 'Jane', NULL),
    (3, 'Alex', 2),
    (4, 'Bill', NULL),
    (5, 'Zack', 1),
    (6, 'Mark', 2)    
;

/* Using the != operator. Works on both MySQL 
  and SQL Server Management Studio */
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL
;

/* Using the <> and || as OR. This only work in MySQL 
   not in SQL Server Management Studio */
SELECT name
FROM Customer
WHERE referee_id <> 2 || referee_id IS NULL
;


-- Below code runs faster. For MySQL
WITH CTE 
AS (
	SELECT name
    FROM Customer
    WHERE referee_id <> 2 || referee_id IS NULL
)

SELECT name
FROM CTE
;

-- Below code runs faster. For SQL Server Management Studio
WITH CTE 
AS (
	SELECT name
    FROM Customer
    WHERE referee_id <> 2 OR referee_id IS NULL
)

SELECT name
FROM CTE
;
