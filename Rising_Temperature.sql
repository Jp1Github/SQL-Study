/* Rising Temperature
Source: Leetcode SQL 50
Ranked as Easy
Table: Weather
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
This table contains information about the temperature on a certain day.
 Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.
The result format is in the following example.
Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
*/

-- Use Schema
USE leetcode_sql;

-- Drop Weather table if exists
DROP TABLE IF EXISTS Weather;

-- Create Visits table;
CREATE TABLE Weather(
	id INT,
    recordDate DATE,
    temperature INT
)
;

-- Insert values to Weather table
INSERT INTO Weather(
	id,
    recordDate,
    temperature
)
VALUES
	(1, '2015-01-01', 10),
    (2, '2015-01-02', 25),
    (3, '2015-01-03', 20),
    (4, '2015-01-04', 30)
;

-- Check if the Visit table is properly populated
SELECT * FROM Weather;

SELECT *,
	LAG(temperature) OVER() AS lag_temp
FROM Weather
;

SELECT t1.id, 
	   t1.recordDate, 
       t1.temperature
FROM
	(SELECT *,
	LAG(temperature) OVER() AS lag_temp
	FROM Weather) AS t1
WHERE t1.temperature > t1.lag_temp
;

# Write your MySQL query statement below
SELECT t1.id
FROM
        (SELECT t2.*,
	 LAG(temperature) OVER(ORDER BY recordDate) AS lag_temp
	 FROM 
                (SELECT *
                FROM Weather
                ORDER BY recordDate ) t2
                ) AS t1
WHERE t1.temperature > t1.lag_temp
;
SELECT w1.id
FROM Weather AS w1
JOIN Weather AS w2
 ON w1.recordDate = w2.recordDate-1
WHERE w1.temperature > w2.temperature-1
;

/* In Leetcode there are 14 several sample test case.
And the recordDate and id are not sorted and there are missing records or gaps on the record date.
Below record works because when scanning each row of the temperature the
recordDate should check if the date 1 day before has a recorded temperature.
Condition will not compare if date difference is more than 1 day.
*/

-- Drop Weather2 table if exist
DROP TABLE IF EXISTS Weather2;

-- Create another table
CREATE TABLE Weather2(
	id INT,
    recordDate DATE,
    temperature INT
)
;

-- Insert values to Weather2 table with gap in the dates
INSERT INTO Weather2(
	id,
    recordDate,
    temperature
)
VALUES
    (2, '2000-02-02', -3),
    (3, '2000-02-03', 5),
    -- Below date values are reversed
 --    (6, '2000-02-08', 8),
--     (5, '2000-02-07', 1),
    -- Below date has a gap
    (8, '2000-02-11', 12),
    (9, '2000-02-14', 18),
    (11, '2000-02-15', 20)
;

-- Query the solution
SELECT w1.id
FROM Weather2 w1
JOIN Weather2 w2
WHERE w1.temperature > w2.temperature
        AND DATEDIFF(w1.recordDate, w2.recordDate)=1