-- Answer key for In-class exercise: SELECT statements

-- Basic Select
-- 1. Select all records from the Vendor table
SELECT * FROM vendors;

-- 2. Select ID, name, address, city, state, zip from vendors. 
SELECT vendor_id, vendor_name, vendor_address1, vendor_city, vendor_state, vendor_zip_code 
FROM vendors;

-- String Expressions
-- 3. Select all vendors but concatenate Address into this format: Address; City, State  Zip  Don�t include alias this time 
SELECT vendor_id, vendor_name, vendor_address1 || '; ' || vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code
FROM vendors;

-- 4. Add a column alias to this newly created column called �Vendor Address�
SELECT vendor_id, vendor_name, vendor_address1 || '; ' || vendor_city || ', ' || vendor_state || ' ' ||  vendor_zip_code AS vendor_address
FROM vendors;

-- Arithmetic Expressions
-- 5. Using the Invoices table, pull vendor_id, invoice total, payment total, and difference of invoice_total  & payment_total.  Rename calculate calculated to �Amount Owed� 
SELECT vendor_id, invoice_total, payment_total, invoice_total - payment_total
FROM invoices;

-- 6. Rename calculated to "amount owed"
SELECT vendor_id, invoice_total, payment_total, invoice_total - payment_total AS amount_owed
FROM invoices;

-- 7. Add in a WHERE clause that results in only the first 5 rows being returned

SELECT vendor_id, invoice_total, payment_total, invoice_total - payment_total AS amount_owed
FROM invoices
WHERE ROWNUM<=5;

-- DUAL
-- 8. Go select * from dual.  
SELECT * FROM dual;

-- 9. Now mess around with the dual table.
SELECT 'HELLO', 'MY NAME IS Clint', 18*37
FROM dual;

-- Scalar Functions
-- 10. Dual table for scalar functions:
SELECT SYSDATE, 18*37, MOD(5231,17), TO_CHAR(SYSDATE, 'MM/DD/YYYY'), TO_CHAR(SYSDATE, 'DD/MM/YYYY')
FROM dual;

-- 11. Using Invoices table, select invoice_id, invoice_number, invoice_total, invoice_date, and a calculated column called �Days til Due� that returns the number of days until the invoice_date. Hint: Use SYSDATE function.  Also show days as a whole number using a 2nd function
SELECT invoice_id, invoice_number, invoice_total, invoice_date, ROUND(invoice_due_date - SYSDATE) AS days_until_due
FROM invoices;

-- 12. Select the average invoice amount from invoices using the AVG function. Round to 2 decimal places.
SELECT AVG(invoice_total)
FROM invoices;

SELECT ROUND(AVG(invoice_total),2)
FROM invoices;

-- 13. Using Customers_OM, select customer initials into one column and in another, a formatted phone number (e.g. 212-555-4800).  TIP: First write this out in pseudo code to determine functions you need and logic.
SELECT SUBSTR(customer_first_name,1,1) || SUBSTR(customer_last_name,1,1) as initials, 
SUBSTR(customer_phone,1,3) || '-' || SUBSTR(customer_phone,4,3) || '-' || SUBSTR(customer_phone,7,4) AS phone_num
FROM Customers_OM;

-- DISTINCT
-- 14. What is the distinct number of vendors in Vendors table
SELECT DISTINCT vendor_id, vendor_name 
FROM Vendors
ORDER BY vendor_name;

-- 15. What is the distinct number of vendor_IDs on invoices.  TIP: First gather a list of vendor_ids in Invoices table and then add in the distinct keyword.
SELECT DISTINCT vendor_id FROM Invoices;

-- 16. Use the MOD function to determine if a number is even or odd.
SELECT MOD(23482,2) AS remainder
FROM dual;

SELECT MOD(23481,2) AS remainder
FROM dual;

-- 17. Using Invoices table, select invoice_id, invoice_number, invoice_total, invoice_date, and a calculated column called "Weeks til Due� that returns the number of weeks until the invoice_date. 
-- Add a column that lists the remainder of days, such that weeks_til_due + remainder_days = days_til_due.
SELECT invoice_id, invoice_number, invoice_total, invoice_date, ROUND(invoice_due_date - SYSDATE) AS days_until_due, 
ROUND(ROUND(invoice_due_date - SYSDATE)/7) AS weeks_until_due, MOD(ROUND(invoice_due_date - SYSDATE),7) AS remainder
FROM invoices;

-- 18.	Using the Invoices table, use a select statement to output one column of text that lists the Invoice number, date due, and payment total. (Hint: use the TO_CHAR function)
SELECT 'Invoice: ' || invoice_number || ',dated ' || TO_CHAR(invoice_due_date, 'MM/DD/YYYY') || ' with payment total of ' || TO_CHAR(payment_total) AS Invoice_Text
FROM invoices;



