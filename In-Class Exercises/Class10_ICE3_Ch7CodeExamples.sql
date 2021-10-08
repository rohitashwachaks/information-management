------------------------------------------------------------------------------
---------HOW TO CREATE TEST TABLES
------------------------------------------------------------------------------
-- a little cleanup (if needed)
DROP TABLE invoices_copy;

--statement that creates a complete copy of invoices table
CREATE TABLE invoices_copy AS
SELECT *
FROM invoices;

DROP TABLE invoices_copy;

-- if you want to create 
CREATE TABLE invoices_copy AS
SELECT *
FROM invoices
WHERE (invoice_total = payment_total - credit_total);

-- Oops, I set all the invoice totals by mistake
UPDATE invoices_copy
SET invoice_total = 0;

-- Let's rollback (it doesn't completely save until I commit)
-- Only for DML (it doesn't apply to DDL commands)
ROLLBACK;

COMMIT;

--statement that creates partial copy of invoices table
CREATE TABLE old_invoices AS
SELECT *
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;

--Statement that creates a table with summary rows from invoices table
CREATE TABLE vendor_balances AS
SELECT vendor_id, SUM(invoice_total) AS sum_of_invoices
FROM invoices
WHERE (invoice_total - payment_total - credit_total) <> 0
GROUP BY vendor_id;


--statement that deletes a table
DROP TABLE invoices_copy;
DROP TABLE vendor_balances;


------------------------------------------------------------------------------
---------HOW TO COMMIT AND ROLLBACK CHANGES
------------------------------------------------------------------------------
--insert that adds a new row to invoices table
INSERT INTO invoices
VALUES (115, 97, '456789', '01-AUG-14', 8344.50, 0, 0, 1, '31-AUG-14', NULL);

SELECT * FROM invoices;

ROLLBACK;

INSERT INTO invoices
VALUES (115, 97, '456789', '01-AUG-14', 8344.50, 0, 0, 1, '31-AUG-14', NULL);

--commits change
COMMIT;

--rolls back change (like an undo before save)
ROLLBACK;


------------------------------------------------------------------------------
---------HOW TO INSERT NEW ROWS
------------------------------------------------------------------------------
--Insert without using column list
INSERT INTO invoices
VALUES (115, 97, '456789', '01-AUG-14', 8344.50, 0, 0, 1, '31-AUG-14', NULL);

--Insert without using column list
INSERT INTO invoices
    (invoice_id, vendor_id, invoice_number, invoice_total, payment_total, credit_total, terms_id, invoice_date, invoice_due_date)
VALUES
    (115, 97, '456789', 8344.50, 0, 0, 1, '01-AUG-14', '31-AUG-14');
    
    

------------------------------------------------------------------------------
---------HOW TO INSERT DEFAULT OR NULL VALUES
------------------------------------------------------------------------------    

CREATE TABLE color_sample
(	
  color_id      NUMBER                        NOT NULL, 
  color_number  NUMBER          DEFAULT 0     NOT NULL, 
  color_name    VARCHAR2(10), 
  CONSTRAINT color_sample_pk PRIMARY KEY (color_id)
);

SELECT * FROM color_sample; 
 
INSERT INTO color_sample (color_id, color_number) 
VALUES (1, 606);
 
INSERT INTO color_sample (color_id, color_name)
VALUES (2, 'Yellow');

INSERT INTO color_sample
VALUES (3, DEFAULT, 'Orange');

INSERT INTO color_sample
VALUES (4, 808, NULL);

INSERT INTO color_sample
VALUES (5, DEFAULT, NULL);

SELECT * FROM color_sample;

--what if I rollback here?


--What if I commit here?


--STOP HERE
------------------------------------------------------------------------------
---------HOW TO USE A SUBQUERY TO INSERT MULTIPLE ROWS
------------------------------------------------------------------------------ 
--inserts paid invoices to the invoice_archive table
INSERT INTO invoice_archive
SELECT *
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;


--Same as above except it uses a column list
INSERT INTO invoice_archive
    (invoice_id, vendor_id, invoice_number, invoice_total, credit_total, payment_total, terms_id, invoice_date, invoice_due_date)
SELECT
    invoice_id, vendor_id, invoice_number, invoice_total, credit_total, payment_total, terms_id, invoice_date, invoice_due_date
FROM invoices
WHERE invoice_total - payment_total - credit_total = 0;


------------------------------------------------------------------------------
---------HOW TO UPDATE EXISTING ROWS OF DATA
------------------------------------------------------------------------------ 
--update two column values for a single row
UPDATE invoices
SET payment_date = '21-SEP-14', 
    payment_total = 19351.18
WHERE invoice_number = '97/522';

--update a single column for many rows
UPDATE invoices
SET terms_id = 1
WHERE vendor_id = 95;

--update a single column using artihmetic expression
UPDATE invoices
SET credit_total = credit_total + 100
WHERE invoice_number = '97/522';



------------------------------------------------------------------------------
---------USING A SUBQUERY IN AN UPDATE STATEMENT
------------------------------------------------------------------------------ 
--assign the max invoice_due_date from invoices to specific invoice
UPDATE invoices
SET credit_total = credit_total + 100,
    invoice_due_date = (SELECT MAX(invoice_due_date) FROM invoices)
WHERE invoice_number = '97/522';

--update all invoices based on a select for a certain vendor
--NOTE: useful when spanning multiple tables
UPDATE invoices
SET terms_id = 1
WHERE vendor_id =
   (SELECT vendor_id
    FROM vendors
    WHERE vendor_name = 'Pacific Bell');
    
--update all invoices based on a select for many records
UPDATE invoices
SET terms_id = 1
WHERE vendor_id IN
   (SELECT vendor_id
    FROM vendors
    WHERE vendor_state IN ('CA', 'AZ', 'NV'));
    
    

------------------------------------------------------------------------------
---------HOW TO DELETE EXISTING ROWS OF DATA
------------------------------------------------------------------------------ 
--delete of a specific row
DELETE FROM invoice_line_items
WHERE invoice_id = 100 AND invoice_sequence = 1;

--delete of multiple rows
DELETE FROM invoice_line_items
WHERE invoice_id = 114;

--delete with a subquery.  Again...useful when spanning two tables
DELETE FROM invoice_line_items
WHERE invoice_id IN
    (SELECT invoice_id
    FROM invoices
    WHERE vendor_id = 115);