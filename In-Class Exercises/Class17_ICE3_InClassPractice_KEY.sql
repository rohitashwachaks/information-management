--1A. Retrieve balance_due for vendor 95
SELECT SUM(invoice_total - payment_total - credit_total) balance_due
FROM invoices 
WHERE vendor_id = 34;

--1B. Retrieve balance_due for vendor and output if greater than 0
--CONNECT ap/ap;  --don't need to connect since we are already connected to our database
SET SERVEROUTPUT ON;
 
DECLARE
  sum_balance_due_var NUMBER(9, 2);
BEGIN
  SELECT SUM(invoice_total - payment_total - credit_total) balance_due
  INTO sum_balance_due_var
  FROM invoices 
  WHERE vendor_id = 34;

  IF sum_balance_due_var > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Balance due: $' || 
                          ROUND(sum_balance_due_var, 2));
  ELSE
    DBMS_OUTPUT.PUT_LINE('Balance paid in full');
  END IF;
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/




--2. Output a line
BEGIN 
 DBMS_OUTPUT.PUT_LINE('Hello, my name is Clint');
END;
/


--3a. A SQL script that uses variables
DECLARE
  max_invoice_total  invoices.invoice_total%TYPE;
  min_invoice_total  invoices.invoice_total%TYPE;
  percent_difference NUMBER;
  count_invoice_id   NUMBER;
  vendor_id_var      NUMBER := 95;
BEGIN  
  vendor_id_var      := 34;
  SELECT MAX(invoice_total), MIN(invoice_total), COUNT(invoice_id)
  INTO max_invoice_total, min_invoice_total, count_invoice_id
  FROM invoices 
  WHERE vendor_id = vendor_id_var;
  
  percent_difference := (max_invoice_total - min_invoice_total) / min_invoice_total * 100;

  DBMS_OUTPUT.PUT_LINE('Maximum invoice: $' || max_invoice_total);
  DBMS_OUTPUT.PUT_LINE('Minimum invoice: $' || min_invoice_total);
  DBMS_OUTPUT.PUT_LINE('Percent difference: %' || ROUND(percent_difference, 2));
  DBMS_OUTPUT.PUT_LINE('Number of invoices: ' || count_invoice_id);
END;
/




--3b.  Define a variable and output it
DECLARE
    MyAge  NUMBER := 20;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Hello, my name is Clint.');
    DBMS_OUTPUT.PUT_LINE('I am ' || MyAge || ' years old.' );
END;
/



--Set this on if you're getting error on 4 below.
SET DEFINE ON;

--4 Use a substitution variable
DECLARE
    MyAge  NUMBER := &user_defined_age;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Hello, my name is Clint.');
    DBMS_OUTPUT.PUT_LINE('I am ' || MyAge || ' years old.' );
END;
/

    
    
   
 
 
-- 5 SELECT INTO with arithmetic and output 
DECLARE 
    has_phone NUMBER;
    missing_phone  NUMBER;
BEGIN 
    select count(distinct vendor_id) as not_missing
    into has_phone
    from vendors
    where vendor_phone is not null;
    
    select count(distinct vendor_id) as missing 
    into missing_phone
    from vendors 
    where vendor_phone is null;

    DBMS_OUTPUT.PUT_LINE(has_phone || ' vendors have a phone on file');
    DBMS_OUTPUT.PUT_LINE(missing_phone || ' vendors do not have a phone on file');
    DBMS_OUTPUT.PUT_LINE(round((missing_phone / (has_phone+missing_phone)*100),2)||'% of our vendors need updated phone numbers' );
END;
/


--6 Another option using a variable to store percentage
DECLARE 
    has_phone        NUMBER;
    missing_phone    NUMBER;
    percent_have     NUMBER;
    
BEGIN 
  
    select count(distinct vendor_id) as missing 
    into has_phone
    from vendors where vendor_phone is not null;

    select count(distinct vendor_id) as missing 
    into missing_phone
    from vendors where vendor_phone is null;

    DBMS_OUTPUT.PUT_LINE(has_phone || ' vendors have a phone on file');
    DBMS_OUTPUT.PUT_LINE(missing_phone || ' vendors do not have a phone on file');
    DBMS_OUTPUT.PUT_LINE(round((missing_phone / (has_phone+missing_phone)*100),2)||'% of our vendors need updated phone numbers' );

    percent_have := round((missing_phone / (has_phone+missing_phone)*100),2);
    
    if percent_have > 10 THEN
        DBMS_OUTPUT.PUT_LINE('ALERT: Too many vendors missing phones.  Go update');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Vendor phone: no need to update');
    END IF;

END;
/


 
 

-- 7a Outputing with a FOR Loop
BEGIN
    FOR i IN 1..4 LOOP
        DBMS_OUTPUT.PUT_LINE('i: ' || i);
    END LOOP;
END;
/
 
-- 7b Update to only include evens
BEGIN
    FOR i IN 1..6 LOOP
        if mod(i,2) = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('i: ' || i);
        END IF;
    END LOOP;
END;
/





--8  DYNAMIC SQL
DECLARE
  dynamic_sql VARCHAR2(400);
BEGIN

  dynamic_sql := 'UPDATE invoices ' ||
                 'SET terms_id = ' || 3 || ' ' ||
                 'WHERE invoice_id = ' || 1;

  DBMS_OUTPUT.PUT_LINE(dynamic_sql);
 
END;
/

 


--8b - Add in user prompts for variables
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

  EXECUTE IMMEDIATE dynamic_sql;
END;
/

 
--TEST results of 8b to confirm it updated data correctly 
select invoice_id, terms_id 
from invoices
where invoice_id = 1;





 

--9  Bulk collection into a table-------------
--9a  example
DECLARE 
    TYPE names_table IS TABLE OF VARCHAR2(40); 
    vendor_names	names_table;      --bulk collect will dynamic set the length of your list/array as it is collected
BEGIN 
    SELECT vendor_name 
    BULK COLLECT INTO vendor_names 
    FROM vendors
    WHERE rownum <= 10 ORDER BY vendor_id;     

    FOR i IN 1..vendor_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Vendor name ' || i || ': ' ||
                          vendor_names(i));
    END LOOP;
END;
/


--9b answer
DECLARE 
    TYPE payments_table IS TABLE OF NUMBER(10); 
    payment_amounts 	payments_table;      --bulk collect will dynamic set the length of your list/array as it is collected
BEGIN 
    SELECT payment_total 
    BULK COLLECT INTO payment_amounts 
    FROM invoices
    WHERE rownum <= 20 ORDER BY vendor_id;     

    FOR i IN 1..payment_amounts.COUNT LOOP
        if payment_amounts(i) > 0 then
            DBMS_OUTPUT.PUT_LINE('Payment amount ' || i || ': ' ||
                          payment_amounts(i));
        end if;
    END LOOP;
END;
/




--10           CURSOR  
--10a Example Use this to see data as it exists currently and then later after PL/SQL updates run
SELECT invoice_id, invoice_total,payment_total, credit_total
FROM invoices 
WHERE invoice_total - payment_total - credit_total > 0;

DECLARE 
    CURSOR invoices_cursor IS
        SELECT invoice_id, invoice_total 
        FROM invoices 
        WHERE invoice_total - payment_total - credit_total > 0;
    
    invoice_row invoices%ROWTYPE; 

BEGIN
    FOR invoice_row IN invoices_cursor LOOP

        IF (invoice_row.invoice_total > 5000) THEN 
            UPDATE invoices 
            SET credit_total = credit_total + (invoice_total * .10) 
            WHERE invoice_id = invoice_row.invoice_id;
            
            DBMS_OUTPUT.PUT_LINE('Credit_total increased by 10% ($' || 
                ROUND((invoice_row.invoice_total *.1),2) || 
                ') for invoice ' || invoice_row.invoice_id);
        ELSIF (invoice_row.invoice_total > 1000) THEN 
            UPDATE invoices 
            SET credit_total = credit_total + (invoice_total * .05) 
            WHERE invoice_id = invoice_row.invoice_id;
            
            DBMS_OUTPUT.PUT_LINE('Credit_total increased by  5% ($' || ROUND((invoice_row.invoice_total *.1),2) || ') for invoice ' || invoice_row.invoice_id);
            
        END IF;
    END LOOP; 

END;
/

 

--10b Here's how you can use a cursor to do #10 
DECLARE 
    CURSOR vendor_cursor IS
        SELECT vendor_id, vendor_name, vendor_state, vendor_phone
        FROM vendors 
        where vendor_phone is null;
    
    vendor_row vendors%ROWTYPE; 

BEGIN
    FOR vendor_row IN vendor_cursor LOOP
        
        IF (vendor_row.vendor_state = 'CA') THEN 
            Update vendors
            Set vendor_phone = 'Update Immediately'
            where vendor_id = vendor_row.vendor_id;
        ELSIF (vendor_row.vendor_state = 'OH') THEN 
            Update vendors
            Set vendor_phone = 'Update Immediately'
            where vendor_id = vendor_row.vendor_id;
        END IF;
        
    END LOOP; 

END;
/

-- use the statements below to check and reset your data for testing
SELECT vendor_id, vendor_name, vendor_state, vendor_phone
FROM vendors 
where vendor_phone is null;

update vendors
set vendor_phone = NULL
where vendor_phone = 'Update Immediately';


 
 
--#11 Error handling 
BEGIN  
    insert into terms VALUES (1,'Net due 10', 10);
    DBMS_OUTPUT.PUT_LINE('1 row inserted.');
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('FYI: A duplicate record error occured');
    
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FYI: Some kind of error occured');

END;
/




 
 
 
 
