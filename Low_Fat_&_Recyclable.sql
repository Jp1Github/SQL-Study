/* Recyclable and Low Fat Products
Ranked as Easy
Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+
product_id is the primary key (column with unique values) for this table.
low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 
Write a solution to find the ids of products that are both low fat and recyclable.
Return the result table in any order.
The result format is in the following example.

Example 1:

Input: 
Products table:
+-------------+----------+------------+
| product_id  | low_fats | recyclable |
+-------------+----------+------------+
| 0           | Y        | N          |
| 1           | Y        | Y          |
| 2           | N        | Y          |
| 3           | Y        | Y          |
| 4           | N        | N          |
+-------------+----------+------------+
Output: 
+-------------+
| product_id  |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: Only products 1 and 3 are both low fat and recyclable.
*/

-- Use the Schema in MySQL
USE leetcode_sql;

-- Create a TABLE
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
			 product_id SMALLINT,
			 low_fats CHAR,
			 recyclable CHAR
)
;

-- Insert the values
INSERT INTO Products (
	product_id,
    low_fats,
    recyclable
)
VALUES
	(0, 'Y', 'N'),
    (1, 'Y', 'Y'),
    (2, 'N', 'Y'),
    (3, 'Y', 'Y'),
    (4, 'N', 'N')
;

SELECT *
FROM Products;

-- Find the product_id with both low_fats and recyclable

-- Using the &&. Only works in MySQL
SELECT product_id
FROM Products
WHERE low_fats ='Y' && recyclable ='Y'
;

-- Using the AND. Works on MySQL and SQL Server Management Studio
SELECT product_id
FROM Products
WHERE low_fats ='Y' AND recyclable ='Y' 
;