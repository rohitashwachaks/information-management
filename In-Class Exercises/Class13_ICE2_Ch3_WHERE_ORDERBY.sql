--------------------------------------------------------------
--  COMPARISON OPERATORS
--------------------------------------------------------------
--Vendors located in Iowa
SELECT * 
FROM VENDORS
WHERE VENDOR_STATE = 'IA';

--Invoices with a balance due
select * 
from invoices
where invoice_total - payment_total - credit_total > 0;

--variation of previous query
select * 
from invoices
where invoice_total > payment_total + credit_total;

--Invoices on or before a specified date
select * 
from invoices
where invoice_date <= '30-Nov-20';
--where invoice_date <= '01-MAY-14';

-- invoices with credits that don't equal zero
select * 
from invoices
where credit_total <> 0;


--------------------------------------------------------------
--  AND, OR, AND NOT LOGICAL OPERATORS
--------------------------------------------------------------
--search with AND operator
select * 
from vendors
where vendor_state = 'NJ' AND vendor_city = 'Washington';

--search with OR operator
select * 
from vendors
where vendor_state = 'NJ' OR vendor_city = 'Fresno';

--search with NOT operator
select * 
from invoices
where NOT (invoice_total >= 5000 OR NOT invoice_date <= '01-JUL-2020');

--previous rephrased to eliminate the NOT
select * 
from invoices
where invoice_total < 5000 AND invoice_date <= '01-JUL-2020';


-- A compound condition WITHOUT parentheses - We'll come back to this after reviewing basics
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_date > '01-MAY-2014'
OR invoice_total > 500
AND invoice_total - payment_total - credit_total > 0
ORDER BY invoice_number;

-- The same compound condition WITH parentheses  - We'll come back to this after reviewing basics
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE (invoice_date > '01-MAY-2014' OR invoice_total > 500)
AND invoice_total - payment_total - credit_total > 0
ORDER BY invoice_number;



--------------------------------------------------------------
--  IN OPERATOR
--------------------------------------------------------------
--IN operator with numbers
select *
from invoices
--where terms_id = 1 OR terms_id = 2 OR terms_id = 3;
where terms_id in (1,2,3);

--IN operator preceded with NOT
select vendor_name, vendor_state
from vendors
--where vendor_state <> 'CA' OR vendor_state <> 'NV' OR vendor_state <> 'OR'; 
where vendor_state NOT IN ('CA','NV','OR');

--IN operator with subquery
select * 
from invoices
where vendor_id in (select vendor_id
                    from invoices
                    where invoice_date = '01-MAY-2014');

    --just the subquery from previous query
    select vendor_id
    from invoices
    where invoice_date = '01-MAY-2014';

    --gets the same result as the subquery version 
    select * 
    from invoices
    where vendor_id in (121,123);

--------------------------------------------------------------
--  BETWEEN OPERATOR
--------------------------------------------------------------
--BETWEEN with literal values
select *
from invoices
where invoice_date BETWEEN '01-MAY-2019' AND '30-OCT-2020'; 

--BETWEEN proceeded by NOT
select *
from vendors
where vendor_zip_code NOT BETWEEN 93600 and 93799; 

--BETWEEN operator with a test expression coded as a calculated value
select * 
from invoices 
where invoice_total - payment_total - credit_total BETWEEN 200 and 500;

--BETWEEN operator with the upper and lower limits coded as calculated values
select * 
from invoices
where invoice_due_date BETWEEN SYSDATE AND (SYSDATE + 30);




--------------------------------------------------------------
--  LIKE OPERATOR
--------------------------------------------------------------
--like clause
SELECT *
FROM VENDORS
WHERE VENDOR_CITY LIKE ('San%');

SELECT *
FROM VENDORS
WHERE VENDOR_name like ('Compu_er%');



--------------------------------------------------------------
--  IS NULL OPERATOR
--------------------------------------------------------------
CREATE TABLE null_sample
(
Invoice_ID Number,
Invoice_Total Number
);

INSERT INTO null_sample VALUES (1, 125);
INSERT INTO null_sample VALUES (2, 0);
INSERT INTO null_sample VALUES (3, NULL);
INSERT INTO null_sample VALUES (4, 2199.99);
INSERT INTO null_sample VALUES (5, 0);
COMMIT;
SELECT *
FROM null_sample;

SELECT *
FROM null_sample
WHERE invoice_total = 0;

SELECT *
FROM null_sample
WHERE invoice_total <> 0;

SELECT *
FROM null_sample
WHERE invoice_total IS NULL;

SELECT *
FROM null_sample
WHERE invoice_total IS NOT NULL;


--------------------------------------------------------------
--  SORT BY COLUMN NAME
--------------------------------------------------------------
--SORT BY ONE COLUMN
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY vendor_name;

--SORT BY ONE COLUMN DESCENDING
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY vendor_name DESC;

--SORT BY THREE COLUMNS
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY vendor_state, vendor_city DESC, vendor_name DESC;


--------------------------------------------------------------
--  SORT BY COLUMN NAME
--------------------------------------------------------------
--SORT BY ALIAS
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY address, vendor_name;

--SORT BY EXPRESSION
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY vendor_contact_last_name || vendor_contact_first_name;

--SORT BY COLUMN POSITION
SELECT vendor_name,
    vendor_city || ', ' || vendor_state || ' ' || vendor_zip_code AS address
FROM vendors
ORDER BY 2 desc, 1;



--------------------------------------------------------------
--  NOT IN SCOPE FOR CLASS BUT KNOCK YOURSELF OFF IF YOU'RE CURIOUS
--------------------------------------------------------------
-- NOTE: This statement only works with Oracle 12c or later
SELECT vendor_id, invoice_total
FROM invoices
ORDER BY invoice_total DESC
FETCH FIRST 5 ROWS ONLY;


-- NOTE: This statement only works with Oracle 12c or later
SELECT invoice_id, vendor_id, invoice_total
FROM invoices
ORDER BY invoice_id
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;


-- NOTE: This statement only works with Oracle 12c or later
SELECT invoice_id, vendor_id, invoice_total
FROM invoices
ORDER BY invoice_id
OFFSET 100 ROWS FETCH NEXT 1000 ROWS ONLY;

