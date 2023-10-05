/* Article Views
Source: Leetcode SQL 50
Ranked as Easy
Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
This table contains all the tweets in a social media app.
 
Write a solution to find the IDs of the invalid tweets. 
The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
Return the result table in any order.
The result format is in the following example.

Example 1:

Input: 
Tweets table:
+----------+----------------------------------+
| tweet_id | content                          |
+----------+----------------------------------+
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |
+----------+----------------------------------+
Output: 
+----------+
| tweet_id |
+----------+
| 2        |
+----------+
Explanation: 
Tweet 1 has length = 14. It is a valid tweet.
Tweet 2 has length = 32. It is an invalid tweet.
*/

-- Use Schema
USE leetcode_sql;

-- Drop Tweets table if exist
DROP TABLE IF EXISTS Tweets;

-- Create a table
CREATE TABLE Tweets (
	tweet_id INT,
    content VARCHAR(100)
)
;

-- Insert values to Tweets table
INSERT INTO Tweets (
	tweet_id,
    content
) 
VALUES
	(1, 'Vote for Biden'),
    (2, 'Let us make America great again')
;

-- See the tweet length of each id
SELECT  tweet_id, 
		-- CHAR_LENGTH(content) AS tweet_len -- For MySQL
		LEN(content) AS tweet_len -- For MySQL
FROM Tweets
;

-- Query the invalid tweet id
SELECT tweet_id
FROM Tweets
-- WHERE CHAR_LENGTH(content) > 15 -- For MySQL
WHERE LEN(content) > 15 -- For SQL Server Management Studio
;

-- Using CTE
WITH CTE AS (
	SELECT tweet_id AS id
	FROM Tweets
	-- WHERE CHAR_LENGTH(content) > 15 -- For MySQL
	-- WHERE LEN(content) > 15 -- For SQL Server Management Studio
)

SELECT id
FROM CTE
;

-- 
WITH CTE AS (
	SELECT tweet_id AS tweet_id
	FROM Tweets
	-- WHERE CHAR_LENGTH(content) > 15 -- For MySQL
	WHERE LEN(content) > 15 -- For SQL Server Management Studio
)

SELECT tweet_id
FROM CTE
;