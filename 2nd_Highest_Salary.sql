--USE [SQL Practice];
/* Code is written using MySQL. It uses the LIMIT function and may not work
in other RDBMS */

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
  id int, 
  name VARCHAR(10), 
  salary int
);

-- Insert a values
INSERT INTO Employee (id, name, salary) 
VALUES 
  (1, 'Jay', 100), 
  (2, 'Pete', 100), 
  (3, 'Zoey', 100);
INSERT INTO Employee 
VALUES 
  (4, 'Bart', 200), 
  (5, 'Cool', 300);
INSERT INTO Employee 
VALUES 
  (6, 'Sim', 400);

-- Use in MySQL if throwing an error due to safe updates
SHOW VARIABLES LIKE 'sql_safe_updates';
SET 
  sql_safe_updates = 0;
-- Zero value turn off the safe update. To turn it back on use 1.
-- Delete a record
DELETE FROM 
  Employee 
WHERE 
  id = 4 
  or id = 5 
  or id = 6;
SELECT 
  * 
FROM 
  Employee;



-- Solution breakdown

/*
1. Get the distinct salary.
*/
SELECT DISTINCT(salary) 
FROM 
  Employee;

/*
2. Create something to check if the distinct count is more than 1 distinct record
else there is no 2nd highest salary
*/
SELECT 
  COUNT(
    DISTINCT(salary)
  ) AS cnt 
FROM 
  Employee;


/*
3. Get the 2nd highest
*/
-- Using the COUNT as a check mechanism and then create a CTE
WITH CTE AS (
  SELECT 
    COUNT(
      DISTINCT(salary)
    ) AS cnt 
  FROM 
    Employee
) 

-- Then use a CASE statement
SELECT 
  CASE -- if cnt is just 1 record it means there is no second highest salary.
    WHEN cnt = 1 THEN NULL -- This is created if requirement is to return a record has NULL
  ELSE (
    SELECT 
      DISTINCT(salary) 
    FROM 
      employee 
    ORDER BY 
      salary DESC 
    LIMIT 
      1, 1
  ) END AS '2nd_highest_salary' 
FROM 
  CTE;


-----------------------------------------------------------------------------------------------------------------
-- ALTERNATIVE to get the second highest is using the RANK() and create a CTE
-- WITH CTE AS (SELECT DISTINCT(SALARY), DENSE_RANK() OVER(ORDER BY SALARY DESC) sal_rnk FROM Employee limit 1,1)
WITH CTE AS (
  SELECT 
    DISTINCT(SALARY), 
    DENSE_RANK() 
    OVER(
        ORDER BY 
        SALARY DESC
    ) AS sal_rnk 
  FROM 
    Employee
) 

SELECT 
  CASE 
    WHEN sal_rnk <> 2 THEN NULL 
    ELSE salary 
  END AS second_highest_salary 
FROM 
  CTE -- If CTE returns one row and does not satisfy sal_rnk<> 2 then it return one row only
  -- But if there is several rows return by CTE it will check with all rows
  -- And return NULL for those rows if it does not satisfy the criteria above
  -- To eliminate include the LIMIT in the CTE
LIMIT 
  1, 1;


-- If CTE returns only one row and with the LIMIT clause no rows will be returned (will not return rows with NULL)
-- ---------------------------
WITH CTE AS (
  SELECT 
    DISTINCT(SALARY), 
    DENSE_RANK() OVER(
  ORDER BY 
        SALARY DESC
    ) AS sal_rnk 
  FROM 
    Employee
) 
SELECT 
  CASE 
    WHEN sal_rnk = 2 THEN salary ELSE NULL 
  END AS '2nd highest salary' 
FROM 
  CTE -- If one row return it will return one null row. If three rows was return therefore it will check with all the row
  -- and return a null row if does not satisfy the criteria sal_rnk = 2
  -- To limit a result extend a WHERE clause 
WHERE 
  sal_rnk = 2;
