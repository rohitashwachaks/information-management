--Use this if you’re having trouble getting your tables to drop with other scripts.  
--NOTE: after you run this you could still have more objects you created that need to be dropped with your own DROP statements.

--In-Class Practice and Textbook database objects 
DROP SEQUENCE vendor_id_seq; 
DROP SEQUENCE invoice_id_seq;

DROP TABLE invoice_archive;
DROP TABLE invoice_line_items;
DROP TABLE invoices;
DROP TABLE vendor_contacts;
DROP TABLE vendors;
DROP TABLE terms;
DROP TABLE general_ledger_accounts;

DROP TABLE active_invoices;
DROP TABLE color_sample;
DROP TABLE CUSTOMERS_EX;
DROP TABLE date_sample;
DROP TABLE departments;
DROP TABLE employees;
DROP TABLE float_sample;
DROP TABLE null_sample;
DROP TABLE paid_invoices;
DROP TABLE projects;
DROP TABLE string_sample;

DROP TABLE order_details;
DROP TABLE orders;
DROP TABLE items;
DROP TABLE CUSTOMERS_OM;

DROP SEQUENCE category_id_seq;
DROP SEQUENCE product_id_seq;
DROP SEQUENCE customer_id_seq;
DROP SEQUENCE address_id_seq;
DROP SEQUENCE order_id_seq;
DROP SEQUENCE item_id_seq;
DROP SEQUENCE admin_id_seq;

DROP TABLE administrators;
DROP TABLE order_items;
DROP TABLE orders_mgs;
DROP TABLE products;
DROP TABLE categories;
DROP TABLE addresses;
DROP TABLE customers_mgs;
   

--DROP OTHER TABLES
Drop table members_committees;
Drop table member_committees;
Drop table member;
Drop table committee;
Drop table members;
Drop table committees;
--DROP STATEMENTS FOR ALL UBC TABLES 
BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE ubc_member_committees';
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE ubc_members';
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/


BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE ubc_committees';
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END;
/


--DROP any homework tables
--none


--DROP any sequences
BEGIN
  --Deletes all user created sequences
  FOR i IN (SELECT us.sequence_name FROM USER_SEQUENCES us) LOOP
    EXECUTE IMMEDIATE 'drop sequence '|| i.sequence_name ||'';
  END LOOP;

END;
/



--DROP ETL Tables
DROP TABLE customers_DW;
DROP TABLE customer_DW;;


--Final reminder to check for remaining tables for manual dropping
SET SERVEROUT ON;
CLEAR SCREEN;

BEGIN
dbms_output.put_line ('Script is complete');
dbms_output.put_line ('NOTE: Refresh your left-hand menu to confirm all tables are gone.');
dbms_output.put_line ('If tables still exist...write statements to drop these manually');
END;
/
