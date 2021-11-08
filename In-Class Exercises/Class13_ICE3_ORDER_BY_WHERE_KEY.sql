-- IN-CLASS EXERCISE FOR ORDER BY, WHERE
-- ORDERING
-- 1. Sort ID, name, address, city, state, and zip from vendors and sort ascending
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
ORDER BY vendor_state ;



-- 2. Now sort by state Z-A
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
ORDER BY vendor_state DESC;



-- 3. Sort by state, city, and vendor name using column names
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
ORDER BY vendor_state, vendor_city, vendor_name ASC;



-- 4. Update previous query to sort by column position numbers
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
ORDER BY 4, 3, 2 ASC;



-- 5. Try adding column alias and sorting by that
SELECT vendor_id, vendor_name AS name, vendor_city as city, vendor_state as state, vendor_zip_code
FROM vendors
ORDER BY state, city, name ASC;

--Order of operation
--FROM
--WHERE  "vendor_state"
--SELECT <--
--ORDER BY "state"

-- 6. Pull data for vendors in NY and NJ wihtout using IN clause
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
WHERE vendor_state = 'NY' OR vendor_state ='NJ';  



-- 7. Make a copy of the query and update it to pull the same data but this time use the IN operator
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
WHERE vendor_state IN ('NY','NJ');



-- 8. Make an updated version that EXCLUDES those in NY and NJ
SELECT vendor_id, vendor_name, vendor_city, vendor_state, vendor_zip_code
FROM vendors
WHERE vendor_state NOT IN ('NY','NJ');



-- 9. Pull the first 7 invoices and then sort them from highest to lowest
SELECT invoice_id, invoice_total
FROM invoices
WHERE ROWNUM<=7
ORDER BY invoice_total DESC;

---- 9b. This is how you sort them AND THEN pull only the first 7
--SELECT invoice_id, invoice_total
--FROM (SELECT * FROM invoices ORDER BY invoice_total DESC)
--WHERE ROWNUM<=7;



-- 10. Select invoices with 0 balance
SELECT invoice_id, invoice_total - payment_total - credit_total AS "balance due"
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;

 
-- 11. Select customers with name 'Korah Blanca'
SELECT customer_id, customer_first_name || ' ' || customer_last_name AS cust_name
FROM Customers_OM
WHERE customer_first_name || ' ' || customer_last_name = ('Korah Blanca');

-- will not work - note that you cannot use Alias in WHERE, but you can in ORDER BY
SELECT customer_id, customer_first_name || ' ' || customer_last_name AS cust_name
FROM Customers_OM
WHERE cust_name IN ('Korah Blanca');



-- 12a. Select customers where the last name starts with 'Dam' using LIKE
SELECT customer_id, customer_first_name, customer_last_name
FROM Customers_OM
WHERE customer_last_name LIKE 'Dam%';

-- 12b. Select customers where the last name starts with 'Dam' using SUBSTR
SELECT customer_id, customer_first_name, customer_last_name
FROM Customers_OM
WHERE SUBSTR(customer_last_name,1,3) = 'Dam';



-- 13. Pull invoices that are due in the next 120 days
SELECT invoice_id, invoice_total, invoice_date
FROM invoices
WHERE invoice_date BETWEEN SYSDATE and SYSDATE+120;

 

-- 14. Update the previous query to remove invoices where payment total is not 0
SELECT invoice_id, invoice_total, invoice_date
FROM invoices
WHERE invoice_date BETWEEN SYSDATE and SYSDATE+120 
        AND payment_total <> 0;



-- 15. Select all vendors from where city is 'Sacramento' and state is 'CA'
SELECT vendor_id, vendor_name, vendor_city, vendor_state
FROM vendors
WHERE vendor_city = 'Sacramento' AND vendor_state = 'CA';



-- 16. Now use OR instead of AND - what happens?
SELECT vendor_id, vendor_name, vendor_city, vendor_state
FROM vendors
WHERE vendor_city = 'Washington' OR vendor_state = 'DC';



-- 17. What happens when you use WHERE NOT
SELECT * 
FROM vendors
WHERE NOT (vendor_state = 'DC' AND vendor_city = 'Washington');



-- 18. Select vendors where vendor phone is NULL
SELECT *
FROM vendors 
WHERE vendor_phone IS NULL;



-- 19. Select all vendors with 'Gas' in their name
SELECT *
FROM vendors
WHERE vendor_name LIKE '%Gas%';



-- 20. Select all vendors with 'gas' in their name
SELECT *
FROM vendors
WHERE vendor_name LIKE '%gas%';



-- 21. Select all vendors that start with 'B' 
SELECT * 
FROM vendors
WHERE vendor_name LIKE 'B%';



-- 22. What happens when you specify WHERE vendor_phone IS NOT NULL
SELECT *
FROM vendors 
WHERE vendor_phone IS NOT NULL;



-- 23. Select all vendors that have an invoice total greater than $1000
SELECT vendor_id, vendor_name
FROM vendors
WHERE vendor_id IN (SELECT vendor_id FROM invoices WHERE invoice_total>1000);



-- 24. Select those same vendors, but add criteria that vendor must be in CA
SELECT vendor_id, vendor_name
FROM vendors
WHERE vendor_id IN (SELECT vendor_id FROM invoices WHERE invoice_total>1000)
AND vendor_state = 'CA';



--Query using ROWNUM in WHERE
SELECT *
FROM invoices
WHERE ROWNUM <=5
ORDER BY invoice_id DESC;
--Query using FETCH after ORDER BY
SELECT *
FROM invoices
ORDER BY invoice_id DESC
FETCH FIRST 5 ROWS ONLY;
--Query using FETCH by OFFSET filter to start after 2 rows are skipped
SELECT *
FROM invoices
ORDER BY invoice_id DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;

