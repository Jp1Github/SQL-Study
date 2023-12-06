/* Not Boring Movies
Source: Leetcode SQL 50
Ranked as Easy
RDBMS: MySQL
Table: Cinema
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
id is the primary key (column with unique values) for this table.
Each row contains information about the name of a movie, its genre, and its rating.
rating is a 2 decimal places float in the range [0, 10]
 
Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
Return the result table ordered by rating in descending order.
The result format is in the following example.

Example 1:

Input: 
Cinema table:
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |
+----+------------+-------------+--------+
Output: 
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |
+----+------------+-------------+--------+
Explanation: 
We have three movies with odd-numbered IDs: 1, 3, and 5. The movie with ID = 3 is boring so we do not include it in the answer.
*/

-- Use Schema
USE leetcode_sql;

-- Create a Cinema table
DROP TABLE IF EXISTS Cinema;
CREATE TABLE Cinema (
	id INT,
    	movie VARCHAR(20),
   	description VARCHAR(50),
    	rating FLOAT
)
;
-- Insert values to Cinema table
INSERT INTO Cinema (
		id,
		movie,
		description,
		rating
) 
VALUES
	(1, 'War',    	  'great 3D',     8.9),
	(2, 'Science',    'fiction',      8.5),
	(3, 'irish',      'boring',       6.2), 
	(4, 'Ice song',   'Fantacy',      8.6),
	(5, 'House card', 'Interesting',  9.1)
;

/* Check if the Signup table is properly populated */
SELECT * FROM Cinema;

/* 1st Solution */
SELECT  id,
	movie,
        description,
        rating
FROM Cinema AS c
WHERE MOD(id, 2)!= 0 AND description != 'boring'
-- In Leetcode the result table should be ordered by rating in descending order
ORDER BY rating DESC
;

/*
Output
# 	id	movie			description		rating
	5	House card		Interesting		9.1
	1	War			great 3D		8.9
*/

/* 2nd Alternative */
SELECT 	t1.id,
	t1.movie,
        t1.description,
        t1.rating
FROM (
	SELECT id,
	       movie,
       	       description,
               rating,
               MOD(id, 2) AS odd_even
	FROM Cinema
	WHERE description <> 'boring'
    ORDER BY rating DESC
    ) AS t1
WHERE odd_even =1
;

/*
Output
# 	id	movie			description		rating
	5	House card		Interesting		9.1
	1	War			great 3D		8.9
*/
