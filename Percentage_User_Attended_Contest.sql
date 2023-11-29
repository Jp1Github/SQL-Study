/* Percentage of Users Attended a Contest
Ranked as Easy
Source: Leetcode SQL 50
Table: Users
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the name and the id of a user.
 
Table: Register
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a user and the contest they registered into.
 
Write a solution to find the percentage of the users registered in each contest rounded to two decimals.
Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.
The result format is in the following example.
 
Example 1:
Input: 
Users table:
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+
Register table:
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
Output: 
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
Explanation: 
All the users registered in contests 208, 209, and 210. The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%
*/

-- Use Schema
USE leetcode_sql;

-- Create a Users table
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
	user_id INT,
    	user_name VARCHAR(10)
)
;
-- Insert values to Users table
INSERT INTO Users (
	user_id,
	user_name
    )
VALUES
    (6, 'Alice'),
    (2, 'Bob'),
    (7, 'Alex')
  ;

/* Check if the Users table is properly populated */
SELECT * FROM Users;

-- Create a Register table
DROP TABLE IF EXISTS Register;
CREATE TABLE Register (
	contest_id INT,
    	user_id INT
)
;

-- Insert values to Register table
INSERT INTO Register (
	contest_id,
    	user_id
) 
VALUES
	 (215,	6), 
 	 (209,	2), 
 	 (208,	2),
 	 (210,	6), 
 	 (208,	6), 
 	 (209,	7), 
 	 (209,	6), 
 	 (215,	7), 
 	 (208,	7),
	 (210,	2),
	 (207,	2),
	 (210,  7)
;

/* Check if the Employee table is properly populated */
SELECT * FROM Register;

SELECT contest_id,
	COUNT(user_id) AS cnt
FROM Register
GROUP BY contest_id
ORDER BY cnt DESC
;


/* 1st Solution */
SELECT 	contest_id,
		ROUND(
		    (COUNT(user_id)
		    /
                -- Return the number of user id from the Users table
                -- Subquery is dynamic!
                (SELECT COUNT(user_id) 
		 FROM Users) * 100 -- to convert to percentage
                  ), 2 -- Round to 2 decimal points
			) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC
;

/* 2nd Solution using a CTE */
WITH CTE AS (
	SELECT COUNT(user_id) AS cnt
	FROM Users
)

SELECT contest_id,
       ROUND((COUNT(user_id) / (SELECT cnt FROM CTE)*100),2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC
;
