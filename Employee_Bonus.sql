/* Employee Bonus
Source: Leetcode SQL 50
Ranked as Easy
RDBMS: MySQL
Table: Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the column with unique values for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 
Table: Bonus
+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the column of unique values for this table.
empId is a foreign key (reference column) to empId from the Employee table.
Each row of this table contains the id of an employee and their respective bonus.
 
Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
Return the result table in any order.
The result format is in the following example.
Example 1:
Input: 
Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
Output: 
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+
*/

-- Use Schema
USE leetcode_sql;

-- Drop Employee table if exist
DROP TABLE IF EXISTS Employee;

-- Create a table Employee
CREATE TABLE Employee (
	 empId INT,
   	 name VARCHAR(10),
   	 supervisor INT,
    	 salary INT
)
;
-- Insert values to Employee table
INSERT INTO Employee (
	empId,
    	name,
    	supervisor,
    	salary
) 
VALUES
	 (3, 'Brad', NULL, 4000),
    	 (1, 'John', 3, 1000),
   	 (2, 'Dan', 3, 2000),
   	 (4, 'Thomas', 3, 4000)
;
-- Check if the Employee table is populated
SELECT 	empId, 
 	name,
       	supervisor,
       	salary
FROM Employee
;

-- Drop Bonus table if exist
DROP TABLE IF EXISTS Bonus;

-- Create Bonus table
CREATE TABLE Bonus (
	 empId INT,
   	 bonus INT
)
;
-- Insert values in the Bonus table
INSERT INTO Bonus(
	empId,
    	bonus
)
VALUES
	(2, 500),
    	(4, 2000)
;
-- Check if the Bonus table is properly populated
SELECT empId, bonus
FROM Bonus
;

/* Solution -- Accepted in Leetcode
*/
SELECT 	emp.name,
	 -- emp.salary,
	bonus.bonus
FROM Employee AS emp
LEFT JOIN Bonus AS bonus ON emp.empId = bonus.empId
WHERE bonus.bonus IS NULL OR bonus.bonus < 1000
;

-- 2nd alternative
SELECT DISTINCT(emp.name), 
	   b.bonus
FROM Employee AS emp
LEFT JOIN (
	    SELECT empId, bonus
	    FROM bonus
-- WHERE bonus < 1000  
	  ) AS b ON b.empId = emp.empId
WHERE b.bonus IS NULL OR b.bonus < 1000

