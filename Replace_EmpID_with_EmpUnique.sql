/* Replace employee number with unique identifier
Source: Leetcode SQL 50
Ranked as Easy
Table: Employees
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.
 
Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
Return the result table in any order.
The result format is in the following example.
Example 1:

Input: 
Employees table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Alice    |
| 7  | Bob      |
| 11 | Meir     |
| 90 | Winston  |
| 3  | Jonathan |
+----+----------+
EmployeeUNI table:
+----+-----------+
| id | unique_id |
+----+-----------+
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |
+----+-----------+
Output: 
+-----------+----------+
| unique_id | name     |
+-----------+----------+
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |
+-----------+----------+
Explanation: 
Alice and Bob do not have a unique ID, We will show null instead.
The unique ID of Meir is 2.
The unique ID of Winston is 3.
The unique ID of Jonathan is 1.
*/

-- Use Schema
USE leetcode_sql;

-- Drop Employees and EmployeeUNI table if exist
DROP TABLE IF EXISTS Employees; 
DROP TABLE IF EXISTS EmployeeUNI; 

-- Create Employees table
CREATE TABLE Employees(
	id INT,
    name VARCHAR(10)
)
;

-- Create the EmployeeUNI table
CREATE TABLE EmployeeUNI(
	id INT,
    unique_id INT
)
;

-- Insert the value in the Employee table
INSERT INTO Employees(
	id,
    name
)
VALUES
	(1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Wiston'),
    (3, 'Jonathan')
;

-- Check if the Employee table is properly created
SELECT id, name
FROM Employees
;

-- Insert values in the EmployeeUNI table
INSERT INTO EmployeeUNI(
	id,
    unique_id
)
VALUES
	(3, 1),
    (11, 2),
    (90, 3)
;

-- Check if the EmployeeUNI table is properly created
SELECT id, unique_id
FROM EmployeeUNI
;

-- Query
SELECT EmpUni.unique_id , Emp.name
FROM Employees AS Emp
LEFT JOIN EmployeeUNI AS EmpUni
	ON Emp.id = EmpUni.id
;
