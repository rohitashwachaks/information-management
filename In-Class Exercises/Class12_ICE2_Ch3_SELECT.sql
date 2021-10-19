------------------------------------------------------------------------------
---------SELECT INTRO
------------------------------------------------------------------------------

--Select statement that retrieves all the data from Invoices table
SELECT *
FROM invoices;

--Select statement that retrieves three columns from each row, sorted in ascending order by invoice_total
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
ORDER BY invoice_total;

--Select statement that retrieves two columns and a calculated value
SELECT invoice_id, invoice_total, credit_total, payment_total, (credit_total + payment_total)  
FROM invoices
WHERE invoice_id = 17;

--Select statement that retrieves all invoices between a given set of dates
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_date BETWEEN '01-MAY-2014' AND '31-MAY-2014'
ORDER BY invoice_date;

--Select statement that returns an empty result set
SELECT invoice_number, invoice_date, invoice_total 
FROM invoices
WHERE invoice_total > 50000;



------------------------------------------------------------------------------
---------How to name columns in a result set
------------------------------------------------------------------------------

--select statement that names a column with AS keyword
SELECT  invoice_number AS "Invoice Number", 
        invoice_date AS "Date",
        invoice_total AS "total of invoice"
FROM invoices;

--select statement that names a column but omits AS keyword
SELECT  invoice_number  "Invoice Number", 
        invoice_date  "Date",
        invoice_total  "total of invoice"
FROM invoices;

--What happens if we don't provide a name for a column?
SELECT 	invoice_number, 
        invoice_date, 
        invoice_total,
    	(invoice_total - payment_total - credit_total) as "balance due"
FROM invoices;





------------------------------------------------------------------------------
---------How to code with string expressions
------------------------------------------------------------------------------

--how to concat string data
SELECT vendor_city, vendor_state, vendor_city || vendor_state as "City_State"
FROM vendors;


--how to format strings using literal values
SELECT 	vendor_name,
    	vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors;


--how to include apostrophes in a literal value
SELECT vendor_name || '''s address: ',
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code
FROM vendors;




------------------------------------------------------------------------------
---------How to code with artithmetic expressions
------------------------------------------------------------------------------

--a statement that calculates the balance due to vendor
SELECT invoice_total, payment_total, credit_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices;
 

--a statement that uses parentheses to control the sequence of operations
SELECT invoice_id,
    invoice_id + 7 * 3 AS order_of_precedence,
    (invoice_id + 7) * 3 AS add_first
FROM invoices
ORDER BY invoice_id;
--NOTE: Standard PEMDAS rules apply here



------------------------------------------------------------------------------
---------How to code with scalar functions
------------------------------------------------------------------------------

--Example of SUBSTR function
SELECT vendor_contact_first_name, vendor_contact_last_name,
    SUBSTR( vendor_contact_first_name, 1, 1) ||
    SUBSTR( vendor_contact_last_name, 1, 1) AS initials
FROM vendors;


--example of TO_CHAR function which converts non-strings to characters for parsing/editing
SELECT 'Invoice: # ' || invoice_number || ', dated ' || 
    TO_CHAR(payment_date, 'MM/DD/YYYY') || 
    ' for $' || TO_CHAR(payment_total) AS "Invoice Text"
FROM invoices;


--SYSDATE and ROUND functions
SELECT invoice_date, 
    SYSDATE AS today, 
--    sysdate - invoice_date,
    ROUND(SYSDATE - invoice_date)  AS invoice_age_in_days
FROM invoices;


--Statement that uses the MOD function
--Helpful when you want to figure out if a number is odd or even
SELECT invoice_id,
    MOD(invoice_id, 2) AS remainder
FROM invoices
ORDER BY invoice_id;



------------------------------------------------------------------------------
---------How to use the Dual table
------------------------------------------------------------------------------

--Example of using the DUAL table
SELECT 'test'  AS test_string, 
       10-7    AS test_calculation, 
       SYSDATE AS test_date,
       (10+10)*2 as "testing"
from dual;





------------------------------------------------------------------------------
---------How to use the DISTINCT keyword to remove dups
------------------------------------------------------------------------------

--statement that returns all rows
SELECT vendor_city, vendor_state
FROM vendors
ORDER BY vendor_city;

--statement that returns only distinct row values aka...removes duplicate rows
SELECT DISTINCT vendor_city, vendor_state
FROM vendors
ORDER BY vendor_city;



------------------------------------------------------------------------------
---------How to use the ROWNUM pseudo column
------------------------------------------------------------------------------

--limiting results by ROWNUM pseudo column
SELECT vendor_id, invoice_total
FROM invoices
WHERE ROWNUM <= 10;

--SORT after the WHERE clause and columns are selected.
--NOTE: Let's talk about order or operations in a SQL statement
SELECT vendor_id, invoice_total
FROM invoices
WHERE ROWNUM <= 5
ORDER BY invoice_total DESC;

--SORT before the WHERE clause
SELECT vendor_id, invoice_total
FROM (SELECT * FROM invoices
      ORDER BY invoice_total DESC)
WHERE ROWNUM <= 5;

