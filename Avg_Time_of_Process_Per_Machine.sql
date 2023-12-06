/* Average_Time_of_Process_Per_Machine
Source: Leetcode SQL 50
Ranked as Easy
RDBMS: MySQL
Table: Activity
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM (category) of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
 
There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.
The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.
The result format is in the following example.

Example 1:

Input: 
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
Output: 
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
Explanation: 
There are 3 machines running 2 processes each.
Machine 0's average time is ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
Machine 1's average time is ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
Machine 2's average time is ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456
*/

-- Use schema database
USE leetcode_sql;

-- Drop Activity table if exist
DROP TABLE IF EXISTS Activity;

-- Creat Activity table
CREATE TABLE Activity(
	machine_id INT,
   	process_id INT,
    	activity_type ENUM('start', 'end') NOT NULL,
    	timestamp FLOAT(5, 3)
)
;

-- Insert values to Activity table
INSERT INTO Activity(
	machine_id,
    	process_id,
    	activity_type,
    	timestamp
)
VALUES
    (0, 0, 'start', 0.712),
    (0, 0, 'end', 1.520),
    (0, 1, 'start', 3.140),
    (0, 1, 'end', 4.120),
    (1, 0, 'start', 0.550),
    (1, 0, 'end', 1.550),
    (1, 1, 'start', 0.430),
    (1, 1, 'end', 1.420),
    (2, 0, 'start', 4.100),
    (2, 0, 'end', 4.512),
    (2, 1, 'start', 2.500),
    (2, 1, 'end', 5.00)
;

-- Check if the table is properly populated
SELECT * FROM Activity;

-- Put in same line the start and end timestamp and substract it.
SELECT  activity_start.machine_id,
	activity_start.process_id,
	activity_start.timestamp AS timestamp_start,
	activity_end.timestamp AS timestamp_end,
	(activity_end.timestamp-activity_start.timestamp) AS diff_time
FROM Activity AS activity_start
JOIN Activity AS activity_end
	-- Joining with the activity type start and end.
	ON activity_start.activity_type = 'start' 
	AND activity_end.activity_type = 'end'
	AND activity_start.process_id = activity_end.process_id
	AND activity_start.machine_id = activity_end.machine_id
	-- AND activity_end.timestamp < activity_start.timestamp -- Will result in empty table result
	-- AND activity_start.activity_type <> activity_end.activity_type -- Redundant with activity_type = start & end statement
ORDER BY activity_start.machine_id ASC
;
/* Result of above
machine_id	process_id		timestamp_start		timestamp_end		diff_time
0		  0			  0.712			  1.520			0.808
0		  1			  3.140			  4.120			0.980
1		  0			  0.550			  1.550			1.000
1		  1			  0.430			  1.420			0.990
2		  0			  4.100			  4.512			0.412
2		  1			  2.500			  5.000			2.500
*/


/*
After putting the same line the timestamp_start and timestamp_end and put the 
difference. Then we can aggregate the diff_time.
*/
SELECT activity_start.machine_id,
       ROUND(AVG(activity_end.timestamp-activity_start.timestamp),3) AS processing_time   
FROM Activity AS activity_start
JOIN Activity AS activity_end
	ON activity_start.activity_type = 'start' 
	AND activity_end.activity_type = 'end'
       	AND activity_start.process_id = activity_end.process_id
	AND activity_start.machine_id = activity_end.machine_id
   -- Need below because of the aggregation at the SELECT statement
GROUP BY activity_start.machine_id
ORDER BY activity_start.machine_id ASC
;

/*
2nd Alternative using subquery at the FROM statement
*/
SELECT * FROM Activity;

SELECT 	activity_start.machine_id,
	activity_start.process_id,
	activity_start.timestamp AS timestamp_start, 
        activity_end.timestamp AS timestamp_end,
        (activity_end.timestamp - activity_start.timestamp) AS time_diff
FROM 
	(SELECT * 
    	FROM Activity
    	WHERE activity_type = 'start') AS activity_start
    ,
    	(SELECT *
    	FROM Activity
    	WHERE activity_type = 'end') AS activity_end
WHERE activity_start.machine_id = activity_end.machine_id
AND activity_start.process_id = activity_end.process_id
ORDER BY activity_start.machine_id ASC
;

/* 
After the above code use the aggregation AVG and ROUND by 3 digits
*/
SELECT 	activity_start.machine_id,
	-- activity_start.process_id,
	-- activity_start.timestamp AS timestamp_start, 
        -- activity_end.timestamp AS timestamp_end,
        ROUND(AVG(activity_end.timestamp - activity_start.timestamp),3) AS processing_time
FROM 
	(SELECT * 
    	FROM Activity
    	WHERE activity_type = 'start') AS activity_start
    ,
    	(SELECT *
    	FROM Activity
    	WHERE activity_type = 'end') AS activity_end
WHERE activity_start.machine_id = activity_end.machine_id
AND activity_start.process_id = activity_end.process_id
GROUP BY activity_start.machine_id
ORDER BY activity_start.machine_id ASC
;
