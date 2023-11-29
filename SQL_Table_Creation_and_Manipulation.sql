/* SQL Practice using the MySQL Workbench and SQL Server Management Studio. 
Created a fictional table for practice */

-- USE SQLTutorial;
USE Practice;

Create a table employee.In SQL Server reference a table "dbo.table_name"; however, "dbo" can be omitted
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    	employeeID INT,
    	firstName VARCHAR(50),
    	lastName VARCHAR(50),
    	date_Of_Birth DATE,
    	gender VARCHAR (10),
	position_ID INT
);


-- Creating table employeePosition (Position ID and Job Title)
DROP TABLE IF EXISTS employeePosition;
CREATE TABLE employeePosition (
    	position_ID INT,
    	jobTitle VARCHAR(50)
);


/* Populate the  following Tables. Using INSERT INTO table_name VALUES.
Wrote insert INTO statement all the column name to be explicit!. This can be omitted but not a good practice!
-- Employee Table */
INSERT INTO Employee (
	-- INSERT dbo.Employee (-- This does not work with MySQL 
    	employeeID,
    	firstName,
    	lastName,
    	date_Of_Birth,
    	gender,
	position_ID 
    )
VALUES
	(1, 'Jaycee', 'Hall', '2001-01-28', 'Female', 2),
	(2, 'Sue', 'Matterson', '2000-04-12', 'Female', 1),
	(3, 'Chris', 'Faber', '1999-11-16', 'Male', 1),
	(4, 'Peggy', 'Anderson', '2000-06-27', 'Female', 3),
	(5, 'Liz', 'Benson', '2002-05-10', 'Female', 3)
;


-- Populate employeePosition Table.
-- This work both MySQL and SQL Server. But the "dbo.employeePosition" does not work with MySQL  )
INSERT INTO employeePosition (
    position_ID,
    jobTitle
)
VALUES
	(1, 'Assembler'),
	(3, 'Office Staff'),
	(4, 'Receptionist'),
	(5, 'HR'),
	(6, 'Accountant'),
	(7, 'Jr. Salesman'),
	(8, 'Sr. Salesman'),
	(9, 'Manager'),
	(10, 'Sr. Manager'),
	(11, 'Regional Manager'),
	(12, 'Consultant'),
	(13, 'Gen. Mgr'),
	(14, 'Vice Pres'),
	(15, 'CEO')
;

--------------------------------------------------
/* SELECT Query. */
SELECT * 
FROM Employee;


--------------------------------------------------
/* Rename a table. */
-- Works for MySQL. Does not work  with SQL Server
ALTER TABLE Employee RENAME Emp_Table;
-- OR
RENAME TABLE emp_table TO Employee;

-- For SQL Server
EXEC sp_rename 'Employee', 'Emp_Table';
EXEC sp_rename 'Emp_Table', 'Employee';


--------------------------------------------------
/* Update a row. Changing the name from Chris to Christopher. */
-- Works with MySQL and SQL Server
UPDATE Employee
	SET firstName = 'Christopher' -- Does not work if using double quotes "Christopher"
	WHERE employeeId = 3 ;

-- Below does not work with MySQL "dbo.Employee"
UPDATE dbo.Employee
	SET position_ID = 3 
	WHERE lastName = 'Faber' ;


--------------------------------------------------
/* Add a column. */
-- MySQL
ALTER TABLE Employee 
ADD COLUMN email CHAR(50);

-- SQL Server. No need to specify the COLUMN
ALTER TABLE EMPLOYEE 
ADD email NVARCHAR(50)
DEFAULT NULL;


--------------------------------------------------
/* Rename a column. */
ALTER TABLE EMPLOYEE
RENAME COLUMN email TO email_add;

-- SQL Server
EXEC sp_rename 'dbo.Employee.email', 'email_add', 'COLUMN';
EXEC sp_rename 'dbo.Employee.email_add', 'email', 'COLUMN';


--------------------------------------------------
/* For MySQL. Drop or remove a column. */
ALTER TABLE Employee
DROP COLUMN email_add;

-- SQL Server requires that you first drop or drop the contraint.
/*Just copy the message output and put it after the CONSTRAINT statement!

Output message sample below
The object 'DF__Employee__email__2BFE89A6' is dependent on column 'email'.
ALTER TABLE DROP COLUMN email failed because one or more objects access this column.*/

ALTER TABLE Employee
DROP CONSTRAINT DF__Employee__email__2BFE89A6, 
COLUMN email;


--------------------------------------------------
/* Change the column datatype. */
-- MySQL
ALTER TABLE Employee
-- MODIFY firstName TEXT;
MODIFY firstName CHAR(10);

-- For MySQL to check the table datatype.
DESCRIBE employee;

-- SQL Server
ALTER TABLE Employee
ALTER COLUMN firstName NVARCHAR(50);


--------------------------------------------------
/* Copy a table to a new table with all its schema */
-- MySQL
CREATE TABLE newEmpTable 
AS
SELECT * FROM Employee;

-- SQL Server
SELECT * 
INTO newEmpTable
FROM Employee;


--------------------------------------------------
/* Copy the table structure. No data values */
-- MySQL
CREATE TABLE newEmpTable LIKE Employee;

-- SQL Server copy the table structure.
SELECT * INTO newEmpTable
FROM Employee
WHERE 1 = 2; -- This condition is require else it will copy the rows data.


--------------------------------------------------
/* Deleting a table. 
The DROP command is under the Data Definition Language used to delete object from the database.
While the DELETE is under the Data Manipulation Language. Both work with MySQL and SQL Server. */

DROP TABLE newEmpTable;

-- Without the WHERE statement it will delete all rows. Slow compared to the DROP statement.
DELETE newEmpTable;


/* Truncate removes all rows from a table or specified partitions of a table, 
without logging the individual row deletions.
It is somewhat similar to the DELETE statement without a WHERE clause. 
However, TRUNCATE statement runs faster and uses fewer system and transaction log resources. */

TRUNCATE TABLE newEmpTable;


/*
MySQL 
--SHOW DATABASES; -- Shows the databases in the current server.
--SHOW TABLES FROM table_name; -- Show all the tables in that particular database (schema)

/* Show the information or schema about a table column 
-- SHOW COLUMNS FROM table_name;
-- DESCRIBE database.table_name;
-- DESCRIBE table_name;

-- SHOW WARNINGS;
-- SHOW VARIABLES like '%time_zone%';

-- SET sql_safe_updates = 0 (OFF) if MySQL restrict updating the table.
-- SHOW VARIABLES like 'sql_safe_updates';
*/



/* SQL Server SSMS
--Show the schema
SELECT NAME
FROM SYS.SCHEMAS

SELECT *
FROM SYS.SCHEMAS

--Show database files
SELECT NAME --*
FROM SYS.DATABASE_FILES;


-- Host information
SELECT *
FROM SYS.DM_OS_HOST_INFO

--Show the table name under the current database
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES;

--Show the table columns
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
*/
