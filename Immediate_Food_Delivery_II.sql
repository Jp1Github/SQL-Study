/* Immediate Food Delivery II
Ranked as Medium
Source: Leetcode SQL 50
Table: Delivery
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 
If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
The result format is in the following example.

Example 1:
Input: 
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
Output: 
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.
*/

-- Use Schema
USE leetcode_sql;

-- Create a Delivery table
DROP TABLE IF EXISTS Delivery;
CREATE TABLE Delivery (
	delivery_id INT,
    	customer_id INT,
    	order_date DATE,
    	customer_pref_delivery_date DATE
)
;

-- Insert values to Delivery table
INSERT INTO Delivery (
	delivery_id,
    	customer_id,
    	order_date,
    	customer_pref_delivery_date
    )
VALUES
	(1,	1, 	'2019-08-01', 	'2019-08-02'),
	(2,	2, 	'2019-08-02', 	'2019-08-02'),
	(3,	1, 	'2019-08-11', 	'2019-08-12'),
	(4,	3, 	'2019-08-24', 	'2019-08-24'),
	(5,	3, 	'2019-08-21', 	'2019-08-22'),
	(6,	2, 	'2019-08-11', 	'2019-08-13'),  
	(7,	4, 	'2019-08-09', 	'2019-08-09')
;	

/* Check if the Delivery table is properly populated */
SELECT * FROM Delivery;

/* 1st step. Solution */
SELECT 
	customer_id,
	MIN(order_date) AS min_order_date,
    	MIN(customer_pref_delivery_date) AS min_delivery_date
FROM Delivery
GROUP BY customer_id
;
/*
Output:
# customer_id		      min_order_date			    min_delivery_date
	1			2019-08-01			2019-08-02 --> Scheduled
	2			2019-08-02			2019-08-02 --> Immediate
	3			2019-08-21			2019-08-22 --> Scheduled
	4			2019-08-09			2019-08-09 --> Immediate
Two (2) immediate divide by the total count 4 and the immediate result is 0.5 * 100 = 50%.
Use the above query as a subquery for the below code.
*/

/* 2nd Step */
SELECT
	IF(t1.min_order_date = t1.min_delivery_date, 1, 0) AS immediate_delivery
FROM
	(SELECT 
		customer_id,
		MIN(order_date) AS min_order_date,
		MIN(customer_pref_delivery_date) AS min_delivery_date
	FROM Delivery
	GROUP BY customer_id ) AS t1
;
/*
# immediate_delivery
0
1 --> True
0
1 -- True
Add the True immediate delivery
*/

/* 3rd Step */
SELECT
	(
	  ROUND(
	     SUM(
		IF(t1.min_order_date = t1.min_delivery_date, 
		   1, 0
		)
	      ) / COUNT(t1.customer_id) ,
              2 -- Note on the round number change it to 4 to work in Leetcode!!
	    ) *100
	) AS immediate_percentage 
FROM
     (
	SELECT 
	   customer_id,
	   MIN(order_date) AS min_order_date,
	   MIN(customer_pref_delivery_date) AS min_delivery_date
       FROM Delivery
       GROUP BY customer_id 
     ) AS t1
;
/*
Output:
# immediate_percentage
50.00
*/

/* Alternate use a CASE statement */
SELECT
	(
	  ROUND(
	     SUM( 
	        CASE
	            WHEN t1.min_order_date = t1.min_delivery_date THEN 1 
                    ELSE 0 
              END ) / COUNT(t1.customer_id) ,
            2 -- Note on the round number change it to 4 to work in Leetcode!!
	   ) *100
        ) AS immediate_percentage
FROM
	(
	  SELECT 
		customer_id,
		MIN(order_date) AS min_order_date,
		MIN(customer_pref_delivery_date) AS min_delivery_date
	  FROM Delivery
	 GROUP BY customer_id 
      ) AS t1
;

/* Alternative use of the DATEDIFF Function*/
SELECT
	(
	  ROUND(
	     SUM( 
	       CASE
		  WHEN DATEDIFF(t1.min_order_date, t1.min_delivery_date)=0 THEN 1 
                  ELSE 0 
               END )
		/ COUNT(t1.customer_id) ,
        -- COUNT(t1.delivery_id
        2
       ) *100
    ) AS immediate_percentage -- Note on the round number change it to 4 to work in Leetcode!!
FROM
   (
     SELECT 
	-- delivery_id 
	customer_id,
	MIN(order_date) AS min_order_date,
	MIN(customer_pref_delivery_date) AS min_delivery_date
     FROM Delivery
     GROUP BY customer_id 
  ) AS t1
;
