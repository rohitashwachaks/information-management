--------------------------------------------------------------------
-- Example 1: Script that contains an anonymous PL/SQL block
--------------------------------------------------------------------
-- this allows to turn on the output, so we can see it
-- you only need to run this one time
SET SERVEROUTPUT ON;

-- Begin an anonymous PL/SQL block
DECLARE
  sum_balance_due_var NUMBER(9, 2);
BEGIN
  SELECT SUM(invoice_total - payment_total - credit_total)
  INTO sum_balance_due_var
  FROM invoices 
  WHERE vendor_id = 95;

  IF sum_balance_due_var > 0 THEN
-- DBMS_OUTPUT.PUT_LINE is a function that prints a nice line
    DBMS_OUTPUT.PUT_LINE('Balance due: $' || ROUND(sum_balance_due_var, 2));
  ELSE
    DBMS_OUTPUT.PUT_LINE('Balance paid in full');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured in the script');
END;
/
-- This forward slash is actually important
-- A forward slash is used to execute the SQL statement or PL/SQL block that is currently in the buffer
-- End an anonymous PL/SQL block




-------------------------------------------------------------------
-- Example 2: How to make sure server output to allow use of PUT_LINE function
-------------------------------------------------------------------
SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Test SQL Developer');
END;
/




--------------------------------------------------------------------
-- Example 3: Script that uses variables
--------------------------------------------------------------------

SET SERVEROUTPUT ON;

DECLARE
  --max_invoice_total NUMBER;
  max_invoice_total  invoices.invoice_total%TYPE;
  --min_invoice_total NUMBER;
  min_invoice_total  invoices.invoice_total%TYPE;
  percent_difference NUMBER;
  count_invoice_id   NUMBER;
  vendor_id_var      NUMBER := 95;
BEGIN  
  SELECT MAX(invoice_total), MIN(invoice_total), COUNT(invoice_id)
  INTO max_invoice_total, min_invoice_total, count_invoice_id
  FROM invoices WHERE vendor_id = vendor_id_var;

  percent_difference := (max_invoice_total - min_invoice_total) / 
                         min_invoice_total * 100;
  
  DBMS_OUTPUT.PUT_LINE('Maximum invoice: $' || max_invoice_total);
  DBMS_OUTPUT.PUT_LINE('Minimum invoice: $' || min_invoice_total);
  DBMS_OUTPUT.PUT_LINE('Percent difference: %' || 
                        ROUND(percent_difference, 2));
  DBMS_OUTPUT.PUT_LINE('Number of invoices: ' || count_invoice_id);
END;
/


--------------------------------------------------------------------
-- Example 4: How to code an IF statement
--------------------------------------------------------------------

DECLARE
  first_invoice_due_date DATE;
BEGIN  
  SELECT MIN(invoice_due_date)
  INTO first_invoice_due_date
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

  IF first_invoice_due_date < SYSDATE() THEN
    DBMS_OUTPUT.PUT_LINE('Outstanding invoices overdue!');
  ELSIF first_invoice_due_date = SYSDATE() THEN
    DBMS_OUTPUT.PUT_LINE('Outstanding invoices are due today!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No invoices are overdue.');
  END IF;

-- the IF statement rewritten as a Searched CASE statement

--  CASE  
--    WHEN first_invoice_due_date < SYSDATE() THEN
--      DBMS_OUTPUT.PUT_LINE('Outstanding invoices overdue!');
--    WHEN first_invoice_due_date = SYSDATE() THEN
--      DBMS_OUTPUT.PUT_LINE('Outstanding invoices are due today!');
--    ELSE
--      DBMS_OUTPUT.PUT_LINE('No invoices are overdue.');
--  END CASE;

  
END;
/

-- update for current numbers to change output
SELECT MIN(invoice_due_date) FROM invoices;

UPDATE invoices
SET invoice_due_date = ADD_MONTHS(invoice_due_date, 10);

ROLLBACK;


--------------------------------------------------------------------
-- Example 5: How to code a CASE statement
--------------------------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
  terms_id_var NUMBER;
BEGIN  
  SELECT terms_id 
  INTO terms_id_var 
  FROM invoices 
  WHERE invoice_id = 4;

  CASE terms_id_var
    WHEN 1 THEN 
      DBMS_OUTPUT.PUT_LINE('Net due 10 days');      
    WHEN 2 THEN 
      DBMS_OUTPUT.PUT_LINE('Net due 20 days');      
    WHEN 3 THEN 
      DBMS_OUTPUT.PUT_LINE('Net due 30 days');      
    ELSE
      DBMS_OUTPUT.PUT_LINE('Net due more than 30 days');      
  END CASE;

-- rewritten as a Searched CASE statement
--  CASE 
--    WHEN terms_id_var = 1 THEN 
--      DBMS_OUTPUT.PUT_LINE('Net due 10 days');      
--    WHEN terms_id_var = 2 THEN 
--      DBMS_OUTPUT.PUT_LINE('Net due 20 days');      
--    WHEN terms_id_var = 3 THEN 
--      DBMS_OUTPUT.PUT_LINE('Net due 30 days');      
--    ELSE
--      DBMS_OUTPUT.PUT_LINE('Net due more than 30 days');      
--  END CASE;

END;
/



--------------------------------------------------------------------
-- Example 6: How to code a loops
--------------------------------------------------------------------

SET SERVEROUTPUT ON;

BEGIN  
  DBMS_OUTPUT.PUT_LINE('Begin FOR loop');
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('i: ' || i);
  END LOOP;
END;
/

--NOTE: While and Simple loops are not in scope but feel free to explore if you're curious

--DECLARE
--  i INTEGER;
--BEGIN  
--  DBMS_OUTPUT.PUT_LINE('Begin WHILE loop');
--  i := 1;
--  WHILE i < 4 LOOP
--    DBMS_OUTPUT.PUT_LINE('i: ' || i);
--    i := i + 1;
--  END LOOP;
--
--END;
--/
--
--DECLARE
--  i INTEGER;
--BEGIN  
--  DBMS_OUTPUT.PUT_LINE('Begin simple loop');
--  i := 1;
--  LOOP
--    DBMS_OUTPUT.PUT_LINE('i: ' || i);
--    i := i + 1;
--    IF i >= 4 THEN
--      EXIT;
--    END IF;
--  END LOOP;
--
--END;
--/



-----------------------------------------------------------------------
-- Example 7: How to use a cursor
-----------------------------------------------------------------------

SET SERVEROUTPUT ON;

DECLARE
  CURSOR invoices_cursor IS
    SELECT invoice_id, invoice_total  
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;

  invoice_row invoices%ROWTYPE;
BEGIN  
  FOR invoice_row IN invoices_cursor LOOP   
  
    IF (invoice_row.invoice_total > 1000) THEN
      UPDATE invoices
      SET credit_total = credit_total + (invoice_total * .1)
      WHERE invoice_id = invoice_row.invoice_id;

      DBMS_OUTPUT.PUT_LINE('1 row updated where invoice_id = ' || 
                            invoice_row.invoice_id);
    END IF; 

  END LOOP;
  
  -- remove ROLLBACK to view changes
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('ROLLBACK succeeded.');

END;
/


--SELECT * FROM invoices 
--WHERE invoice_total > 1000 AND invoice_total - payment_total - credit_total > 0;
--
--UPDATE invoices
--SET credit_total = credit_total + (invoice_total * .1)
--WHERE invoice_total - payment_total - credit_total > 0
--AND invoice_total > 1000;
--
--ROLLBACK;




-----------------------------------------------------------------------
-- Example 8: How to use collections
-----------------------------------------------------------------------
-- a varray with BULK COLLECT and COUNT
DECLARE
  TYPE names_table      IS TABLE OF VARCHAR2(40);
  vendor_names          names_table;
BEGIN
  SELECT vendor_name
  BULK COLLECT INTO vendor_names
  FROM vendors
  WHERE rownum < 8
  ORDER BY vendor_id;

  FOR i IN 1..vendor_names.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Vendor name ' || i || ': ' || vendor_names(i));
  END LOOP;
END;
/


-----------------------------------------------------------------------
-- Example 9: How to handle exceptions
-----------------------------------------------------------------------
--INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
--
--select * 
--from general_ledger_accounts
--order by account_number;
--
--delete
--from general_ledger_accounts
--where account_number = 130;

SET SERVEROUTPUT ON;

BEGIN  
  INSERT INTO general_ledger_accounts VALUES (130, 'Cash');

  DBMS_OUTPUT.PUT_LINE('1 row inserted.');
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('You attempted to insert a duplicate value.');

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An unexpected exception occurred.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


-----------------------------------------------------------------------
-- Example 10: How to execute code correctly without displaying an error
-----------------------------------------------------------------------
BEGIN  
  EXECUTE IMMEDIATE 'DROP TABLE test1';
EXCEPTION
  WHEN OTHERS THEN 
    NULL;
END;
/

CREATE TABLE test1 (test_id NUMBER);


-----------------------------------------------------------------------
-- Example 11: How we use bind and substitution variables
-----------------------------------------------------------------------

SET SERVEROUTPUT ON;

-- Use the VARIABLE keyword to declare a bind variable
VARIABLE invoice_id_value NUMBER;
     
-- Use a PL/SQL block to set the value of a bind variable
-- to the value that's entered for a substitution variable
BEGIN
  :invoice_id_value := &invoice_id;
END;
/

-- Use a bind variable in a SELECT statement
SELECT invoice_id, invoice_number
FROM invoices
WHERE invoice_id = :invoice_id_value;
     
-- Use a bind variable in another PL/SQL block
BEGIN
  DBMS_OUTPUT.PUT_LINE('invoice_id_value: ' || :invoice_id_value);
END;
/


--------------------------------------------------------------------
-- Example 12: How to make dynamic SQL using substitution variables
--------------------------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
  invoice_id_var NUMBER;
  terms_id_var NUMBER;
  dynamic_sql VARCHAR2(400);
BEGIN
  invoice_id_var := &invoice_id;
  terms_id_var := &terms_id;
  
  dynamic_sql := 'UPDATE invoices ' ||
                 'SET terms_id = ' || terms_id_var || ' ' ||
                 'WHERE invoice_id = ' || invoice_id_var;

  DBMS_OUTPUT.PUT_LINE('dynamic_sql: ' || dynamic_sql);
  
  EXECUTE IMMEDIATE dynamic_sql;
END;
/


                 
SELECT invoice_id, terms_id FROM invoices WHERE invoice_id = 114;