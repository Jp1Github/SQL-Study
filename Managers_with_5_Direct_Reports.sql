/* Managers with at Least 5 Direct Reports
Source: Leetcode SQL 50
Ranked as Medium
RDBMS: MySQL
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 
Write a solution to find managers with at least five direct reports.
Return the result table in any order.
The result format is in the following example.

Example 1:
Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
*/
-- Use Schema
USE leetcode_sql;

-- Create a table Employee
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
	id INT,
	name VARCHAR(10),
    department VARCHAR(5),
    managerID INT
)
;
-- Insert values to Students table
INSERT INTO Employee (
	id,
    name,
    department,
    managerID
) 
VALUES
	(101, 'John', 'A', NULL),
    (102, 'Dan', 'A', 101),
    (103, 'James', 'A', 101),
    (104, 'Amy', 'A', 101),
    (105, 'Anne', 'A', 101),
    (106, 'Ron', 'B', 101)
;
-- Check if the Employee table is populated
SELECT 	managerID, 
		COUNT(managerID) AS cnt_mgrId
FROM Employee
GROUP BY managerID
;
/*
Output of above code
managerID,	 cnt_mgrId
NULL			0
101				5
*/

SELECT e1.name
FROM Employee AS e1
-- Join with a subquery of managerId count
JOIN (SELECT managerID, 
		COUNT(managerID) AS cnt_mgrId
      FROM Employee
      GROUP BY managerID) AS e2
	ON e1.id = e2.managerID
-- Filter subquey join with managerID count greater or equal to 5
WHERE cnt_mgrID >= 5
;

/* Another Alternative is create a CTE */
WITH CTE AS (
			SELECT 	managerID, 
					COUNT(managerID) AS cnt_mgrId
			FROM Employee
			GROUP BY managerID
)

-- Then make the join
SELECT e1.name
FROM Employee AS e1
JOIN CTE as cte
	ON e1.id = cte.managerID
WHERE cte.cnt_mgrId >= 5
;