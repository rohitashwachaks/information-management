--Step 1 ANSWER - sequence with increment of 10
CREATE SEQUENCE member_id_seq
  START WITH 10 increment by 1;

--Step 2 - Run this test SQL and it should insert 3 rows
INSERT INTO members
VALUES (member_id_seq.NEXTVAL , 'Tayfun', 'Keskin', '1826 Easy Street', 'Austin', 'TX', '512-123-4567');
INSERT INTO members
VALUES (member_id_seq.NEXTVAL , 'Michael', 'Jordan', '8391 Bulls Rd', 'Chicago', 'IL', '123-234-3455');
INSERT INTO members
VALUES (member_id_seq.NEXTVAL , 'Bugs', 'Bunny', '987 Looney Ln', 'Toon Town', 'NY', '');

select * from members;

--STEP 4
drop table members;

CREATE TABLE members 
(
  member_id     NUMBER         default member_id_seq.nextval PRIMARY KEY, 
  first_name    VARCHAR2(50)   NOT NULL, 
  last_name     VARCHAR2(50)   NOT NULL, 
  address       VARCHAR2(50)   NOT NULL, 
  city          VARCHAR2(25)   NOT NULL, 
  state         CHAR(2)        DEFAULT 'TX', 
  phone         VARCHAR2(20)
);

-- Step 5 - run test inserts to see if sequence defaults correctly
INSERT INTO members (first_name, last_name, address, city, state, phone)
VALUES ('Bart', 'Simpson', '432 Kwyjibo Dr', 'Springfield', 'IL', '578-233-9876');
INSERT INTO members (first_name, last_name, address, city, state, phone)
VALUES ('Jay', 'Hartzell', '1897 Horns Blvd', 'Austin', 'TX', '');
INSERT INTO members (first_name, last_name, address, city, state, phone)
VALUES ('Melissa', 'Jefferson', '987 Looney Ln', 'Toon Town', 'NY', '');

--Step 6  drop sequence
drop sequence member_id_seq;

--------------Indexes

CREATE INDEX invoices_vendor_id_ix
  ON invoices (vendor_id);
  
CREATE INDEX invoices_invoice_date_ix
  on invoices (invoice_date desc);

--indexes below

CREATE TABLE invoices
(
  invoice_id            NUMBER, 
  vendor_id             NUMBER          NOT NULL,
  invoice_number        VARCHAR2(50)    NOT NULL,
  invoice_date          DATE            NOT NULL,
  invoice_total         NUMBER(9,2)     NOT NULL,
  payment_total         NUMBER(9,2)                 DEFAULT 0,
  credit_total          NUMBER(9,2)                 DEFAULT 0,
  terms_id              NUMBER          NOT NULL,
  invoice_due_date      DATE            NOT NULL,
  payment_date          DATE,
  CONSTRAINT invoices_pk 
    PRIMARY KEY (invoice_id),
  CONSTRAINT invoices_fk_vendors
    FOREIGN KEY (vendor_id) 
    REFERENCES vendors (vendor_id) 
);

create INDEX invoice_vendor_id_ix
ON invoices(vendor_id);

CREATE TABLE invoice_line_items
(
  invoice_id              NUMBER        NOT NULL,
  invoice_line_number     NUMBER        NOT NULL,
  account_number          NUMBER        NOT NULL,
  line_item_amt           NUMBER(9,2)   NOT NULL,
  line_item_description   VARCHAR2(100) NOT NULL,
  CONSTRAINT line_items_pk 
    PRIMARY KEY (invoice_id, invoice_line_number),
  CONSTRAINT line_items_fk_invoices
    FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id)
);

--create an sequence for vendor_id starting at 10 and increment by 5

--Create a vendor_table with vendor_id_seq as default for vendor_id primary key
  --vendor_id                     NUMBER          DEFAULT     vendor_id_seq.NEXTVAL  PRIMARY KEY,

--test this insert
INSERT INTO vendors 
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number) 
VALUES (vendor_id_seq.NEXTVAL,'US Postal Service','Attn:  Supt. Window Services','PO Box 7005','Madison','WI','53707','(800) 555-1205','Alberto','Francesco',1,552);

-- Creating indexes
CREATE INDEX invoices_vendor_id_ix
  ON invoices (vendor_id);

CREATE INDEX invoices_invoice_date_ix
  ON invoices (invoice_date DESC);
