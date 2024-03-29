/* Joining Table
This is a problem code from Leetcode to combine two (2) tables.
Ranked as EASY.

Table : Person
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |
+-------------+---------+
personId is the primary key column for this table.
This table contains information about the ID of some persons and their first and last names.

Table : Address
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
+-------------+---------+
addressId is the primary key column for this table.
Each row of this table contains information about the city and state of one person with ID = PersonId.

Write an SQL query to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.

Return the result table in any order.

The query result format is in the following example.

Example 1:

Input: 
Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
Output: 
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
Explanation: 
There is no address in the address table for the personId = 1 so we return null in their city and state.
addressId = 1 contains information about the address of personId = 2.

*/
--USE SQL PRACTICE;
use practice;

DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Address;

/* Create Table Person and Address */

CREATE TABLE Person (
	personId INT,
	lastName VARCHAR(5),
	firstName VARCHAR(5)
);

CREATE TABLE Address (
	addressId INT,
	personID INT,
	city VARCHAR(15),
	state VARCHAR(15)
);


/* Insert values in table */
INSERT INTO Person (
	personId,
	lastName,
	firstName
)
VALUES
	(1, 'Wang', 'Allen'),
	(2, 'Alice','Bob');


INSERT INTO Address (
	addressId,
	personId,
	city,
	state
)
VALUES
	(1, 2, 'New York City', 'New York'),
	(2, 3, 'Leetcode', 'California');


/* Code using LEFT JOIN */
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person AS p
	LEFT JOIN Address AS a
		ON p.personId = a.personId ;
	

/* Code using Subquery in SELECT */
SELECT firstName, lastName, 
	(SELECT city 
		FROM Address AS a 
		WHERE a.personId = p.personId
		) AS city,
	(SELECT state 
		FROM Address AS a 
		WHERE a.personId = p.personId
		) AS state
FROM Person AS p ;


/* Complicated code using LEFT JOIN, RIGHT JOIN and INTERSECT. */
SELECT firstName, lastName, p.personID, a.city, a.state
FROM Person AS p
LEFT JOIN Address AS a ON p.personId = a.personID
INTERSECT
SELECT 
	firstName,
	lastName, 
	p.personID, 
	a.city, 
	a.state 
FROM Address AS a
RIGHT JOIN Person AS p ON p.personId = a.personID ;

