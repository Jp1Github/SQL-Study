/* Confirmation Rate
Source: Leetcode SQL 50
Ranked as Medium
RDBMS: MySQL
Table: Signups
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the column of unique values for this table.
Each row contains information about the signup time for the user with ID user_id.
 

Table: Confirmations
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
user_id is a foreign key (reference column) to the Signups table.
action is an ENUM (category) of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
 
The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
Write a solution to find the confirmation rate of each user.
Return the result table in any order.
The result format is in the following example.

Example 1:

Input: 
Signups table:
+---------+---------------------+
| user_id | time_stamp          |
+---------+---------------------+
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |
+---------+---------------------+
Confirmations table:
+---------+---------------------+-----------+
| user_id | time_stamp          | action    |
+---------+---------------------+-----------+
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-07-14 14:00:00 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 12:58:28 | confirmed |
| 7       | 2021-06-14 13:59:27 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-02-28 23:59:59 | timeout   |
+---------+---------------------+-----------+
Output: 
+---------+-------------------+
| user_id | confirmation_rate |
+---------+-------------------+
| 6       | 0.00              |
| 3       | 0.00              |
| 7       | 1.00              |
| 2       | 0.50              |
+---------+-------------------+
Explanation: 
User 6 did not request any confirmation messages. The confirmation rate is 0.
User 3 made 2 requests and both timed out. The confirmation rate is 0.
User 7 made 3 requests and all were confirmed. The confirmation rate is 1.
User 2 made 2 requests where one was confirmed and the other timed out. The confirmation rate is 1 / 2 = 0.5.
*/

-- Use Schema
USE leetcode_sql;

-- Create a Signups table
DROP TABLE IF EXISTS Signups;
CREATE TABLE Signups (
	user_id INT,
	time_stamp DATETIME
)
;
-- Insert values to Signups table
INSERT INTO Signups (
	user_id,
    	time_stamp
) 
VALUES
	(3, '2020-03-21 10:16:13'),
	(7, '2020-01-04 13:57:59'),
	(2, '2020-07-29 23:09:44'),
	(6, '2020-12-09 10:39:37')
;

/* Check if the Signup table is properly populated */
SELECT * FROM Signups;


-- Create the Confirmations table
-- DROP if there is an existing Confirmations table
DROP TABLE IF EXISTS Confirmations;
CREATE TABLE Confirmations (
	user_id INT,
    	time_stamp DATETIME,
        action ENUM ('timeout', 'confirmed')
)
;

-- Insert the values in the Confirmation table
INSERT INTO Confirmations (
	user_id,
        time_stamp,
        action
)
VALUES
	(3, '2021-01-06 03:30:46', 'timeout'),
	(3, '2021-07-14 14:00:00', 'timeout'),  
	(7, '2021-06-12 11:57:29', 'confirmed'),
	(7, '2021-06-13 12:58:28', 'confirmed'),
	(7, '2021-06-14 13:59:27', 'confirmed'),
	(2, '2021-01-22 00:00:00', 'confirmed'),
	(2, '2021-02-28 23:59:59', 'timeout')
;

/* Check if the Confirmations table is properly populated */
SELECT * FROM Confirmations;

SELECT user_id, time_stamp
FROM Signups AS sign_up
;

/* Create 2 tables. One for all and other for confirmed */
SELECT 	user_id,
	-- action,
	COUNT(action) AS action_cnt
FROM Confirmations
GROUP BY user_id
; 

/* 
Ouput
# user_id	action_cnt
  3		  2
  7		  3
  2		  2

*/

-- 2nd table confirmed
SELECT  user_id,
	COUNT(action) AS cnt_confirmed
FROM Confirmations
WHERE action = 'confirmed'
GROUP BY user_id
;
/*
Output
# user_id	cnt_confirmed
  7			3
  2			1
*/

-- Self Join the table
SELECT  t1.user_id,
	(t2.cnt_confirmed/t1.action_cnt) AS confirmation_rate
FROM (
	SELECT  user_id,
		 -- action,
		COUNT(action) AS action_cnt
	FROM Confirmations
	GROUP BY user_id 
	) AS t1
JOIN
	(
	SELECT  user_id,
		COUNT(action) AS cnt_confirmed
	FROM Confirmations
	WHERE action = 'confirmed'
	GROUP BY user_id
	) AS t2 ON t1.user_id = t2.user_id
;
/*
Output
# user_id	confirmation_rate
  7			1.0000
  2			0.5000
*/

-- Create a CTE the left join iwht the Signups table
WITH CTE AS
	( SELECT t1.user_id,
	(t2.cnt_confirmed/t1.action_cnt) AS confirmation_rate
FROM (
	SELECT  user_id,
		-- action,
		COUNT(action) AS action_cnt
	FROM Confirmations
	GROUP BY user_id 
	) AS t1
JOIN
	(
	SELECT  user_id,
		COUNT(action) AS cnt_confirmed
	FROM Confirmations
	WHERE action = 'confirmed'
	GROUP BY user_id
	) AS t2 ON t1.user_id = t2.user_id
)

/* Solution */
SELECT sign.user_id,
	   ROUND(COALESCE(c.confirmation_rate, 0), 2) AS confirmation_rate
FROM Signups AS sign
LEFT JOIN CTE as c ON sign.user_id = c.user_id
;
