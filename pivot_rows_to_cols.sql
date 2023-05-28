-- Pivot row to columns
/*
-- Step 1. Select columns of interest in the desired result, hostid provides the y-values
and item_name provides the x-values.

*/
USE SQLTutorial;

DROP TABLE IF EXISTS rows_to_cols;
CREATE TABLE rows_to_cols(hostid INT, item_name CHAR, item_value INT);

--Insert values to a table.
INSERT INTO rows_to_cols(hostid , item_name, item_value)
VALUES
    (1, 'A', 10),
    (1, 'B', 3),
    (2, 'A', 9),
    (2, 'C', 40);

/* If you want to rename the column hostid to host_id
-- MySQL
ALTER TABLE rows_to_cols RENAME COLUMN hostid TO host_id;

--SQL Server
EXEC sp_rename 'dbo.rows_to_cols.hostid', 'host_id', 'COLUMN'
*/


-- Step 2. Extend the base table with extra columns. Creating a view
-- we typically need one column per x-VALUES. Below code will extend 3 columns
CREATE VIEW rows_to_cols_pivot 
AS 
SELECT 
	*,
	CASE 
		WHEN item_name = 'A' THEN item_value 
	END AS A,

	CASE 
		WHEN item_name = 'B' THEN ITEM_VALUE 
	END AS B,

	CASE 
		WHEN ITEM_NAME = 'C' THEN item_value 
	END AS C
FROM rows_to_cols
;

DROP VIEW rows_to_cols_pivot;

SELECT * FROM rows_to_cols_pivot;


-- Step 3. Group and aggregate the extended value. Need to group by hostid, since
-- it provides the y-values
SELECT host_id,
	SUM(A) AS A,
	SUM(B) AS B,
	SUM(C) AS C
FROM rows_to_cols_pivot
GROUP BY host_id;


-- Step 4. Going to replace any null values with zeroes so the 
-- results set is nicer than NULL
CREATE VIEW rows_to_cols_pivot_prettify 
AS 
SELECT 
	host_id,
	COALESCe(A, 0) AS A,
	COALESCE(B, 0) AS B,
	COALESCE(C, 0) AS C
FROM rows_to_cols_pivot 
;

SELECT * FROM rows_to_cols_pivot_prettify;

DROP VIEW rows_to_cols_pivot_prettify;


