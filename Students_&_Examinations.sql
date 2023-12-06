/* Student and Examinations
Source: Leetcode SQL 50
Ranked as Easy
RDBMS: MySQL
Table: Students
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one student in the school.
 
Table: Subjects
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key (column with unique values) for this table.
Each row of this table contains the name of one subject in the school.
 
Table: Examinations
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 
Write a solution to find the number of times each student attended each exam.
Return the result table ordered by student_id and subject_name.
The result format is in the following example.

Example 1:
Input: 
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
Output: 
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
Explanation: 
The result table should contain all students and all subjects.
Alice attended the Math exam 3 times, the Physics exam 2 times, and the Programming exam 1 time.
Bob attended the Math exam 1 time, the Programming exam 1 time, and did not attend the Physics exam.
Alex did not attend any exams.
John attended the Math exam 1 time, the Physics exam 1 time, and the Programming exam 1 time.
*/

-- Use Schema
USE leetcode_sql;

-- Drop Students, Subjects and Examinations table if exist
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Examinations;

-- Create a table Students
CREATE TABLE Students (
	student_id INT,
	student_name VARCHAR(10)
)
;
-- Insert values to Students table
INSERT INTO Students (
	student_id,
    	student_name
) 
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (13, 'John'),
    (6, 'Alex')
;
-- Check if the Students table is populated
SELECT * FROM Students
;

-- Create Subjects table
CREATE TABLE Subjects (
	subject_name VARCHAR(20)
)
;
-- Insert values in the Subject table
INSERT INTO Subjects(
	subject_name
)
VALUES
    ('Math'),
    ('Physics'),
    ('Programming')
;
-- Check if the Subject table is properly populated
SELECT * FROM Subjects
;

-- Create Examinations table
CREATE TABLE Examinations(
	student_id INT,
    	subject_name VARCHAR(20)
)
;
-- Insert values into Examinations table
INSERT INTO Examinations(
	student_id,
    	subject_name
)
VALUES
    (1, 'Math'),
    (1, 'Physics'),
    (1, 'Programming'),
    (2, 'Programming'),
    (1, 'Physics'),
    (1, 'Math'),
    (13, 'Math'),
    (13, 'Programming'),
    (13, 'Physics'),
    (2, 'Math'),
    (1, 'Math')
;
-- Check if the Examination table is properly populated
SELECT * FROM Examinations;

DROP VIEW IF EXISTS student_exam;
CREATE VIEW student_exam AS
	SELECT student_id, 
		subject_name,
        	-- COUNT(student_id)
		COUNT(subject_name) AS cnt
        	-- OVER(PARTITION BY student_id) AS cnt
	FROM Examinations
    	GROUP BY student_id,
            	 subject_name
	ORDER BY student_id
;

/* Solution -- Accepted in Leetcode */

/* 1st - Cross Join */
SELECT  student_id,
		student_name,
        subject_name
FROM Students AS students
CROSS JOIN Subjects AS sub
;
/*
Below will be the output of the above code
student_id, 			student_name, 		subject_name
1				Alice			Programming
1				Alice			Physics
1				Alice			Math
2				Bob			Programming
2				Bob			Physics
2				Bob			Math
13				John			Programming
13				John			Physics
13				John			Math
6				Alex			Programming
6				Alex			Physics
6				Alex			Math
*/

/*
2nd - Count the exam taken by each student_id
*/
SELECT 	student_id,
	subject_name
	, COUNT(student_id) AS exam_count 
	-- , COUNT(student_id) OVER(PARTITION BY student_id, subject_name)
FROM Examinations
GROUP BY student_id, subject_name
;
/* 
Output of the above code.
student_id, 	subject_name, 		exam_count
1					Math			3
1					Physics			2
1					Programming		1
2					Programming		1
2					Math			1
13					Math			1
13					Programming		1
13					Physics			1
*/

/* Solution accepted in Leetcode 
3rd - Need to combine the cross join of the Students table and Subject table.
Then perform a left join of the Examinations table.
*/
SELECT 	s.student_id,
	s.student_name,
        sub.subject_name,
	COUNT(e.student_id) AS attended_exams -- Make sure this is the correct alias as leetcode will mark as error.
FROM Students AS s 
-- The below join will perform as a cross join without the ON clause!
JOIN Subjects AS sub
LEFT JOIN Examinations AS e ON s.student_id = e.student_id
     AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id ASC
;

/*
Output:
student_id, 		student_name, 		subject_name, 		attended_exams
1			Alice			Math					3
1			Alice			Physics					2
1			Alice			Programming				1
2			Bob			Math					1
2			Bob			Physics					0
2			Bob			Programming				1
6			Alex			Math					0
6			Alex			Physics					0
6			Alex			Programming				0
13			John			Math					1
13			John			Physics					1
13			John			Programming				1
*/

/* 
Alternative create two (2) views.
Note: Will not run in Leetcode.
*/
-- Create the  student_exams view
DROP VIEW IF EXISTS student_exams;
CREATE VIEW student_exams AS
	SELECT 	student_id,
		subject_name,
		COUNT(student_id) AS exam_count 
		-- , COUNT(student_id) OVER(PARTITION BY student_id, subject_name)
FROM Examinations
GROUP BY student_id, subject_name
;

-- Check the output of the student_exams view table 
SELECT * FROM student_exams;


-- Create the student_subject view table
DROP VIEW IF EXISTS student_subject;
CREATE VIEW student_subject AS
	SELECT 	s.student_id,
		s.student_name,
            	sub.subject_name
	FROM Students AS s
	CROSS JOIN Subjects sub
;

-- Combine the two (2) table 
SELECT 	s.student_id,
	s.student_name,
        s.subject_name
        -- Use the COASLESCE to replace NULL with zero (0)
        , COALESCE(e.exam_count, 0) AS attended_exams
        -- , e.exam_count -- Output NULL if there is no found value from the left join.
FROM student_subject AS s
LEFT JOIN student_exams AS e ON s.student_id = e.student_id
     AND s.subject_name = e.subject_name
ORDER BY s.student_id, e.exam_count DESC

/*
Output:
student_id, 				student_name, 		subject_name, 		attended_exams
1					Alice			Math				3
1					Alice			Physics				2
1					Alice			Programming			1
2					Bob			Programming			1
2					Bob			Math				1
2					Bob			Physics				0
6					Alex			Programming			0
6					Alex			Physics				0
6					Alex			Math				0
13					John			Programming			1
13					John			Physics				1
13					John			Math				1
*/

/*
Output without the coalesce function.
student_id, 				student_name, 		  subject_name, 		attended_exams
1					Alice				Math				3
1					Alice				Physics				2
1					Alice				Programming			1
2					Bob				Programming			1
2					Bob				Math				1
2					Bob				Physics				NULL
6					Alex				Programming			NULL
6					Alex				Physics				NULL
6					Alex				Math				NULL
13					John				Programming			1
13					John				Physics				1
13					John				Math				1

*/

