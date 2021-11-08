-------------------------------------------------------------
-- How to work with inner join
-------------------------------------------------------------

--Inner join of two tables using explicit syntax
SELECT invoice_number, vendor_name
FROM vendors INNER JOIN invoices 
	ON vendors.vendor_id = invoices.vendor_id
ORDER BY invoice_number;


--inner join with aliases for all tables
SELECT 	invoice_number, 
	vendor_name, 
	invoice_due_date,
    	(invoice_total - payment_total - credit_total) AS balance_due
FROM vendors v JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE (invoice_total - payment_total - credit_total) > 0
ORDER BY invoice_due_date DESC;


--inner join with table alias for only one table
SELECT invoice_number, line_item_amt, line_item_description
FROM invoices JOIN invoice_line_items line_items
    ON invoices.invoice_id = line_items.invoice_id
WHERE account_number = 540
ORDER BY invoice_date;


-----Compound inner joins 
--example 1 (includes both a join condition and filter condition in the JOIN)
SELECT invoice_number, invoice_date,
    invoice_total, line_item_amt
FROM invoices i JOIN invoice_line_items li
    ON (i.invoice_id = li.invoice_id) AND
       (i.invoice_total > li.line_item_amt)
ORDER BY invoice_number;

--example 2 (includes only a join condition in JOIN and puts filter condition in the WHERE) - BEST PRACTICE
SELECT invoice_number, invoice_date,
    invoice_total, line_item_amt
FROM invoices i JOIN invoice_line_items li
    ON i.invoice_id = li.invoice_id
WHERE i.invoice_total > li.line_item_amt
ORDER BY invoice_number;



-- Self join
SELECT DISTINCT v1.vendor_name, v1.vendor_city,
    v1.vendor_state
FROM vendors v1 JOIN vendors v2
    ON (v1.vendor_city = v2.vendor_city) AND
       (v1.vendor_state = v2.vendor_state) AND
       (v1.vendor_id <> v2.vendor_id)
ORDER BY v1.vendor_state, v1.vendor_city;


-- Join of more than 2 tables
SELECT vendor_name, invoice_number, invoice_date,
    line_item_amt, account_description
FROM vendors v
    JOIN invoices i 
        ON v.vendor_id = i.vendor_id
    JOIN invoice_line_items li 
        ON i.invoice_id = li.invoice_id
    JOIN general_ledger_accounts gl 
        ON li.account_number = gl.account_number
WHERE (invoice_total - payment_total - credit_total) > 0
ORDER BY vendor_name, line_item_amt DESC;


-- Implicit syntax in an inner join
SELECT invoice_number, vendor_name
FROM vendors v, invoices i
WHERE v.vendor_id = i.vendor_id
ORDER BY invoice_number;


-- Implicit sytax that joins 4 tables
SELECT vendor_name, invoice_number, invoice_date,
    line_item_amt, account_description
FROM  vendors v, invoices i, invoice_line_items  li, 
    general_ledger_accounts gl
WHERE v.vendor_id = i.vendor_id
  AND i.invoice_id = li.invoice_id
  AND li.account_number = gl.account_number
  AND (invoice_total - payment_total - credit_total) > 0
ORDER BY vendor_name, line_item_amt DESC;



-------------------------------------------------------------
-- How to work with OUTER join
-------------------------------------------------------------
---OUTER JOINS
SELECT vendor_name, invoice_number, invoice_total
FROM vendors LEFT JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;


--LEFT JOIN
SELECT department_name AS dept_name, 
    d.department_number AS dept_no,
    last_name
FROM departments d 
    LEFT JOIN employees e
    ON d.department_number =
       e.department_number
ORDER BY department_name;


--RIGHT JOIN
SELECT department_name AS dept_name, 
    e.department_number AS dept_no,
    last_name
FROM departments d 
    RIGHT JOIN employees e
    ON d.department_number = 
       e.department_number
ORDER BY department_name;


--FULL JOIN
SELECT department_name AS dept_name, 
    d.department_number AS d_dept_no,
    e.department_number AS e_dept_no, 
    last_name
FROM departments d 
    FULL JOIN employees e
    ON d.department_number =
       e.department_number
ORDER BY department_name;


--- OUTER JOINING MORE THAN TWO TABLES - LEFT
SELECT department_name, 
    last_name, 
    project_number AS proj_no
FROM departments d
    LEFT JOIN employees e
        ON d.department_number = e.department_number
    LEFT JOIN projects p
        ON e.employee_id = p.employee_id
ORDER BY department_name, last_name, 
    project_number;
    
    
--- OUTER JOINING MORE THAN TWO TABLES - FULL
SELECT department_name, last_name, 
    project_number AS proj_no
FROM departments d
    FULL JOIN employees e
        ON d.department_number = e.department_number
    FULL JOIN projects p
        ON e.employee_id = p.employee_id
ORDER BY department_name;


--COMBINING INNER AND OUTER JOIN
SELECT department_name AS dept_name, last_name, project_number
FROM departments dpt
    JOIN employees emp
        ON dpt.department_number = emp.department_number
    LEFT JOIN projects prj
        ON emp.employee_id = prj.employee_id
ORDER BY department_name;


-------------------------------------------------------------
-- How to work with UNION of two or more queries
-------------------------------------------------------------

--UNION from two different tables
 SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total 
 FROM active_invoices
 WHERE invoice_date >= '01-JUN-2014'
UNION
 SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
 FROM paid_invoices
 WHERE invoice_date >= '01-JUN-2014'
ORDER BY invoice_total DESC;


--UNION FROM THE SAME TABLE
    SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total
    FROM invoices
    WHERE (invoice_total - payment_total - credit_total) > 0
UNION
    SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
    FROM invoices
    where (invoice_total - payment_total - credit_total) <= 0
ORDER BY invoice_total DESC;



--UNION FROM SAME JOINED TABLES
    SELECT invoice_number, vendor_name, '33% Payment' AS payment_type,
        invoice_total AS total, (invoice_total * 0.333) AS payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total > 10000
UNION
    SELECT invoice_number, vendor_name, '50% Payment' AS payment_type,
        invoice_total AS total, (invoice_total * 0.5) AS payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total BETWEEN 500 AND 10000
UNION
    SELECT invoice_number, vendor_name, 'Full amount' AS payment_type,
        invoice_total AS Total, invoice_total AS Payment
    FROM invoices JOIN vendors
        ON invoices.vendor_id = vendors.vendor_id
    WHERE invoice_total < 500
ORDER BY payment_type, vendor_name, invoice_number;


-------------------------------------------------------------
-- How to use MINUS and INTERSET
-------------------------------------------------------------

--MINUS
 SELECT customer_first_name, customer_last_name
    FROM customers_ex
MINUS
    SELECT first_name, last_name
    FROM employees
ORDER BY customer_last_name;


--MINUS to compare a list of values between two tables  ***Example not in the book***
select vendor_id
from vendors
 minus
select distinct vendor_id
from invoices;


--INTERSECT
    SELECT customer_first_name, customer_last_name 
    FROM customers_ex
INTERSECT
    SELECT first_name, last_name 
    FROM employees;
    
--INTERSECT of vendor_ids on Vendors and Invoices
select vendor_id
from vendors
 INTERSECT
select distinct vendor_id
from invoices;