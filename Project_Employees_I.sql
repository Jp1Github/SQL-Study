/* Project Employees I
Source: Leetcode SQL 50
Ranked as Easy
RDBMS: MySQL
Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 
Table: Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
Each row of this table contains information about one employee.
 
Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
Return the result table in any order.
The query result format is in the following example.

Example 1:
Input: 
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output: 
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
Explanation: The average experience years for the first project is 
(3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50
*/

-- Use Schema
USE leetcode_sql;

-- Create a Project table
DROP TABLE IF EXISTS Project;
CREATE TABLE Project (
	project_id INT,
    employee_id INT
)
;
-- Insert values to Project table
INSERT INTO Project (
	project_id,
	employee_id
    )
VALUES
	(1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4)
  ;

/* Check if the Project table is properly populated */
SELECT * FROM Project;

-- Create a Employee table
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
	employee_id INT,
    name VARCHAR(10),
	experience_years INT
)
;

-- Insert values to Employee table
INSERT INTO Employee (
	employee_id,
    name,
	experience_years
) 
VALUES
	(1,	'Khaled', 3), 
	(2,	'Ali',  2),  
	(3,	'John', 1), 
	(4,	'Doe',  2) 
;

/* Check if the Employee table is properly populated */
SELECT * FROM Employee;

/* Combine the two table. In the Project table is only the employee number
and the experience_years are in the Employee table. We have to combined both
tables */
SELECT p.project_id,
		p.employee_id,
        e.name,
        e.experience_years
FROM Project AS p
JOIN Employee AS e
	ON p.employee_id = e.employee_id
;
/*
project_id, 	employee_id, 		name, 		experience_years
1					1				Khaled			3
1					2				Ali				2
1					3				John			1
2					1				Khaled			3
2					4				Doe				2
*/

/* The above result we can do an aggregation and using GROUP BY project_id */
SELECT 	p.project_id,
		COUNT(e.employee_id) AS employee_count,
        SUM(e.experience_years) AS sum_of_employees_years,
        (SUM(e.experience_years)/COUNT(e.employee_id)) AS average_years
FROM Project AS p
JOIN Employee AS e
	ON p.employee_id = e.employee_id
GROUP BY p.project_id
;
/*
project_id, 	employee_count, 	sum_of_employees_years, 	average_years
	1				3					6						2.0000
	2				2					5						2.5000
*/


/* 1st Solution */
SELECT 	p.project_id,
		-- In leetcode it is specified average_years rounded to 2 digits.
        ROUND((SUM(e.experience_years)/COUNT(e.employee_id)),2) AS average_years
FROM Project AS p
JOIN Employee AS e
	ON p.employee_id = e.employee_id
GROUP BY p.project_id
;

/*2nd Solution - Same as above but less code */
SELECT 	p.project_id,
        ROUND(AVG(e.experience_years),2) AS average_years
FROM Project AS p
JOIN Employee AS e
	ON p.employee_id = e.employee_id
GROUP BY p.project_id
;

/* 
Output
Output: 
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
*/

/* 3rd Solution - Using CTE and window function OVER() however the code is long */
WITH CTE AS (
	SELECT 	p.project_id,
			p.employee_id,
			e.name,
	        SUM(e.employee_id) OVER(PARTITION BY p.project_id) AS sum_of_emp_experience,
			COUNT(e.employee_id) OVER(PARTITION BY p.project_id) AS emp_cnt
	FROM Project AS p
	JOIN Employee AS e
		ON p.employee_id = e.employee_id
	)

SELECT 	DISTINCT(project_id),
		ROUND((sum_of_emp_experience/emp_cnt),2) AS average_years
FROM CTE
;
