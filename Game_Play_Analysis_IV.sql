/* Immediate Food Delivery II
Ranked as Medium
Source: Leetcode SQL 50
Table: Activity
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 
Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
The result format is in the following example.

Example 1:
Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
*/

-- Use Schema
USE leetcode_sql;

-- Create a Activity table
DROP TABLE IF EXISTS Activity;
CREATE TABLE Activity (
	player_id INT,
    	device_id INT,
    	event_date DATE,
   	game_played INT
)
;

-- Insert values to Activity table
INSERT INTO Activity (
	player_id,
    	device_id,
    	event_date,
    	game_played
    )
VALUES
	(1,	2,	'2016-03-01',	5),   
	(1,	2,	'2016-03-02',	6),   
	(2,	3,	'2017-06-25',	1),   
	(3,	1,	'2016-03-02',	0),   
	(3,	4,	'2018-07-03',	5)
;	

/* Check if the Delivery table is properly populated */
SELECT * FROM Activity;

/* 1st step Solution */
SELECT
    player_id,
    MIN(event_date) AS first_log
FROM Activity
GROUP BY player_id
;
/*
# player_id		first_log
	1		2016-03-01
	2		2017-06-25
	3		2016-03-02
*/

SELECT COUNT(DISTINCT(player_id)) AS Total_Distinct_player FROM Activity;

/* Second do a self inner join */
SELECT 
	-- COUNT(DISTINCT(t1.player_id)) AS num_first_log_players
	t1.player_id,
        t1.event_date,
        t2.first_log
FROM Activity AS t1
JOIN 
	(SELECT
		player_id,
		MIN(event_date) AS first_log
	FROM Activity
	GROUP BY player_id) AS t2
    ON t1.player_id = t2.player_id -- AND DATEDIFF(t1.event_date, t2.first_log)=1
;
/* 
# player_id		event_date		first_log
	1		2016-03-01		2016-03-01
	1		2016-03-02		2016-03-01
	2		2017-06-25		2017-06-25
	3		2016-03-02		2016-03-02
	3		2018-07-03		2016-03-02
*/

/* Third add the AND DATEDIFF = 1 */
SELECT 
    -- COUNT(DISTINCT(t1.player_id)) AS num_first_log_players
    t1.player_id,
    t1.event_date,
    t2.first_log
FROM Activity AS t1
JOIN 
	(SELECT
		player_id,
		MIN(event_date) AS first_log
	FROM Activity
	GROUP BY player_id) AS t2
    ON t1.player_id = t2.player_id AND DATEDIFF(t1.event_date, t2.first_log)=1
;

/* Output
1	2016-03-02	2016-03-01
*/

/* Final Solution */
SELECT 
	ROUND(
			(SELECT 
				COUNT(DISTINCT(t1.player_id)) AS num_first_log_players
				-- 	t1.player_id,
				--     t1.event_date,
				--     t2.first_log,
				--     t1.event_date - t2.first_log AS diff
			FROM Activity AS t1
			JOIN 
			(SELECT
				player_id,
				MIN(event_date) AS first_log
			FROM Activity
			GROUP BY player_id) AS t2
				 ON t1.player_id = t2.player_id AND DATEDIFF(t1.event_date, t2.first_log)=1)
			/ 
            (SELECT COUNT(DISTINCT(player_id)) FROM Activity), 2) AS fraction
	;


/* Alternative. Not tested on Leetcode*/
CREATE VIEW temp_table AS 
SELECT  t1.player_id,
	t1.first_log,
        t1.event_date,
	DATEDIFF(t1.event_date, t1.first_log) AS date_diff
FROM 
	(SELECT
		player_id,
        	event_date,
		MIN(event_date) OVER(PARTITION BY player_id) AS first_log
	FROM Activity) AS t1
-- WHERE DATEDIFF(t1.event_date, t1.first_log) = 1 -- Uncomment if want only date_diff with 1 only.
;
-- DROP VIEW temp_table;
/*
# player_id		first_log		event_date		date_diff
1			2016-03-01		2016-03-01		  0
1			2016-03-01		2016-03-02		  1
2			2017-06-25		2017-06-25		  0
3			2016-03-02		2016-03-02		  0
3			2016-03-02		2018-07-03		853
*/

SELECT (
	ROUND (
		(SELECT COUNT(*) 
		  FROM temp_table)
		/ 
    		(SELECT COUNT(DISTINCT(player_id)) 
    		 FROM activity),2)
	        ) AS fraction;
;

/* 
Output:
# fraction
0.33
*/
/* ------------- */


/* Other solution. Solution using SELF JOIN - Only passed one test case */
SELECT 
	ROUND( a1.player_id
	/ (SELECT COUNT(DISTINCT(player_id)) FROM Activity), 2
	) AS fraction
FROM Activity AS a1
JOIN Activity AS a2
	ON a1.player_id = a2.player_id AND a1.device_id = a2.device_id
WHERE a1.event_date <> a2.event_date AND ABS(a1.event_date - a2.event_date) =1
GROUP BY a1.player_id
;
/* Output --> Only passed one test case in Leetcode
fraction
0.33
*/







