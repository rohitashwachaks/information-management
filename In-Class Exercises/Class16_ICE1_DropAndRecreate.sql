--HIT COMMAND + A  or CTRL+A to select all text in this script and then paste it into SQL Developer then run it as a script.  You may get errors stating you’re trying to drop an object that doesn’t exist.  You can ignore these.  Make sure your create statements ran and you have data in the tables
 
------------------------------------------------------------------------------------------------
--------------  START of the Accounts Payable and other textbook tables
------------------------------------------------------------------------------------------------  
 


------------------------------------------------------------------------------------------------
----  drop and create AP tables
------------------------------------------------------------------------------------------------  
 
BEGIN 
    EXECUTE IMMEDIATE 'DROP SEQUENCE vendor_id_seq'; 
EXCEPTION 
    WHEN OTHERS THEN NULL; 
END; 
/


BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE invoice_id_seq';EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE invoice_archive';EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE invoice_line_items';EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE invoices'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE vendor_contacts'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE vendors'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE terms'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE general_ledger_accounts'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/


 
 
CREATE TABLE general_ledger_accounts
(
  account_number            NUMBER              NOT NULL,
  account_description   VARCHAR2(50)        NOT NULL,
  CONSTRAINT gl_accounts_pk
        PRIMARY KEY (account_number),
  CONSTRAINT gl_account_description_uq
        UNIQUE (account_description)
);
 
CREATE TABLE terms
(
  terms_id                  NUMBER              NOT NULL,
  terms_description     VARCHAR2(50)        NOT NULL,
  terms_due_days            NUMBER              NOT NULL,
  CONSTRAINT terms_pk
        PRIMARY KEY (terms_id)
);
 
CREATE TABLE vendors
(
  vendor_id                         NUMBER              NOT NULL,
  vendor_name                       VARCHAR2(50)        NOT NULL,
  vendor_address1               VARCHAR2(50),
  vendor_address2               VARCHAR2(50),
  vendor_city                       VARCHAR2(50)        NOT NULL,
  vendor_state                      CHAR(2)             NOT NULL,
  vendor_zip_code               VARCHAR2(20)        NOT NULL,
  vendor_phone                      VARCHAR2(50),
  vendor_contact_last_name      VARCHAR2(50),
  vendor_contact_first_name     VARCHAR2(50),
  default_terms_id              NUMBER              NOT NULL,
  default_account_number        NUMBER              NOT NULL,
  CONSTRAINT vendors_pk
        PRIMARY KEY (vendor_id),
  CONSTRAINT vendors_vendor_name_uq
        UNIQUE (vendor_name),
  CONSTRAINT vendors_fk_terms
        FOREIGN KEY (default_terms_id)
        REFERENCES terms (terms_id),
  CONSTRAINT vendors_fk_accounts
        FOREIGN KEY (default_account_number)
        REFERENCES general_ledger_accounts (account_number)
);
 
CREATE TABLE invoices
(
  invoice_id                NUMBER,
  vendor_id                 NUMBER              NOT NULL,
  invoice_number        VARCHAR2(50)        NOT NULL,
  invoice_date              DATE                NOT NULL,
  invoice_total         NUMBER(9,2)         NOT NULL,
  payment_total         NUMBER(9,2)                     DEFAULT 0,
  credit_total              NUMBER(9,2)                     DEFAULT 0,
  terms_id                  NUMBER              NOT NULL,
  invoice_due_date          DATE                NOT NULL,
  payment_date              DATE,
  CONSTRAINT invoices_pk
        PRIMARY KEY (invoice_id),
  CONSTRAINT invoices_fk_vendors
        FOREIGN KEY (vendor_id)
        REFERENCES vendors (vendor_id),
  CONSTRAINT invoices_fk_terms
        FOREIGN KEY (terms_id)
        REFERENCES terms (terms_id)
);
 
CREATE TABLE invoice_line_items
(
  invoice_id                  NUMBER            NOT NULL,
  invoice_sequence        NUMBER            NOT NULL,
  account_number          NUMBER            NOT NULL,
  line_item_amt           NUMBER(9,2)   NOT NULL,
  line_item_description   VARCHAR2(100) NOT NULL,
  CONSTRAINT line_items_pk
        PRIMARY KEY (invoice_id, invoice_sequence),
  CONSTRAINT line_items_fk_invoices
        FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id),
  CONSTRAINT line_items_fk_acounts
        FOREIGN KEY (account_number) REFERENCES general_ledger_accounts (account_number)
);
 
-- Create the indexes
CREATE INDEX vendors_terms_id_ix
  ON vendors (default_terms_id);
CREATE INDEX vendors_account_number_ix
  ON vendors (default_account_number);
 
CREATE INDEX invoices_invoice_date_ix
  ON invoices (invoice_date DESC);
CREATE INDEX invoices_vendor_id_ix
  ON invoices (vendor_id);
CREATE INDEX invoices_terms_id_ix
  ON invoices (terms_id);
CREATE INDEX line_items_account_number_ix
  ON invoice_line_items (account_number);
 
-- Create the sequences
CREATE SEQUENCE vendor_id_seq
  START WITH 124;
CREATE SEQUENCE invoice_id_seq
  START WITH 115; 
 
-- Create the test tables that aren't explicitly
-- related to the previous five tables
CREATE TABLE vendor_contacts
(
  vendor_id           NUMBER            NOT NULL,
  last_name           VARCHAR2(50)  NOT NULL,
  first_name          VARCHAR2(50)  NOT NULL
);
 
CREATE TABLE invoice_archive
(
  invoice_id              NUMBER              NOT NULL,
  vendor_id               NUMBER              NOT NULL,
  invoice_number      VARCHAR2(50)    NOT NULL,
  invoice_date            DATE                NOT NULL,
  invoice_total           NUMBER              NOT NULL,
  payment_total           NUMBER              NOT NULL,
  credit_total            NUMBER              NOT NULL,
  terms_id                NUMBER              NOT NULL,
  invoice_due_date        DATE                NOT NULL,
  payment_date            DATE
);
 
-- Disable substitution variable prompting
SET DEFINE OFF;
 
-- INSERT INTO general_ledger_accounts
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (100,'Cash');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (110,'Accounts Receivable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (120,'Book Inventory');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (150,'Furniture');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (160,'Computer Equipment');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (162,'Capitalized Lease');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (167,'Software');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (170,'Other Equipment');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (181,'Book Development');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (200,'Accounts Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (205,'Royalties Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (221,'401K Employee Contributions');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (230,'Sales Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (234,'Medicare Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (235,'Income Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (237,'State Payroll Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (238,'Employee FICA Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (239,'Employer FICA Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (241,'Employer FUTA Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (242,'Employee SDI Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (243,'Employer UCI Taxes Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (251,'IBM Credit Corporation Payable');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (280,'Capital Stock');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (290,'Retained Earnings');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (300,'Retail Sales');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (301,'College Sales');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (302,'Trade Sales');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (306,'Consignment Sales');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (310,'Compositing Revenue');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (394,'Book Club Royalties');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (400,'Book Printing Costs');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (403,'Book Production Costs');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (500,'Salaries and Wages');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (505,'FICA');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (506,'FUTA');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (507,'UCI');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (508,'Medicare');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (510,'Group Insurance');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (520,'Building Lease');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (521,'Utilities');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (522,'Telephone');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (523,'Building Maintenance');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (527,'Computer Equipment Maintenance');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (528,'IBM Lease');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (532,'Equipment Rental');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (536,'Card Deck Advertising');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (540,'Direct Mail Advertising');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (541,'Space Advertising');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (546,'Exhibits and Shows');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (548,'Web Site Production and Fees');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (550,'Packaging Materials');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (551,'Business Forms');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (552,'Postage');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (553,'Freight');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (555,'Collection Agency Fees');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (556,'Credit Card Handling');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (565,'Bank Fees');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (568,'Auto License Fee');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (569,'Auto Expense');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (570,'Office Supplies');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (572,'Books, Dues, and Subscriptions');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (574,'Business Licenses and Taxes');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (576,'PC Software');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (580,'Meals');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (582,'Travel and Accomodations');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (589,'Outside Services');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (590,'Business Insurance');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (591,'Accounting');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (610,'Charitable Contributions');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (611,'Profit Sharing Contributions');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (620,'Interest Paid to Banks');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (621,'Other Interest');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (630,'Federal Corporation Income Taxes');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (631,'State Corporation Income Taxes');
INSERT INTO general_ledger_accounts (account_number,account_description)
VALUES (632,'Sales Tax');
 
-- INSERT INTO terms
INSERT INTO terms (terms_id,terms_description,terms_due_days) VALUES (1,'Net due 10 days',10);
INSERT INTO terms (terms_id,terms_description,terms_due_days) VALUES (2,'Net due 20 days',20);
INSERT INTO terms (terms_id,terms_description,terms_due_days) VALUES (3,'Net due 30 days',30);
INSERT INTO terms (terms_id,terms_description,terms_due_days) VALUES (4,'Net due 60 days',60);
INSERT INTO terms (terms_id,terms_description,terms_due_days) VALUES (5,'Net due 90 days',90);
 
-- INSERT INTO vendors
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (1,'US Postal Service','Attn:  Supt. Window Services','PO Box 7005','Madison','WI','53707','(800) 555-1205','Alberto','Francesco',1,552);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (2,'National Information Data Ctr','PO Box 96621',NULL,'Washington','DC','20090','(301) 555-8950','Irvin','Ania',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (3,'Register of Copyrights','Library Of Congress',NULL,'Washington','DC','20559',NULL,'Liana','Lukas',3,403);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (4,'Jobtrak','1990 Westwood Blvd Ste 260',NULL,'Los Angeles','CA','90025','(800) 555-8725','Quinn','Kenzie',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (5,'Newbrige Book Clubs','3000 Cindel Drive',NULL,'Washington','NJ','07882','(800) 555-9980','Marks','Michelle',4,394);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (6,'California Chamber Of Commerce','3255 Ramos Cir',NULL,'Sacramento','CA','95827','(916) 555-6670','Mauro','Anton',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (7,'Towne Advertiser''s Mailing Svcs','Kevin Minder','3441 W Macarthur Blvd','Santa Ana','CA','92704',NULL,'Maegen','Ted',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (8,'BFI Industries','PO Box 9369',NULL,'Fresno','CA','93792','(559) 555-1551','Kaleigh','Erick',3,521);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (9,'Pacific Gas & Electric','Box 52001',NULL,'San Francisco','CA','94152','(800) 555-6081','Anthoni','Kaitlyn',3,521);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (10,'Robbins Mobile Lock And Key','4669 N Fresno',NULL,'Fresno','CA','93726','(559) 555-9375','Leigh','Bill',2,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (11,'Bill Marvin Electric Inc','4583 E Home',NULL,'Fresno','CA','93703','(559) 555-5106','Hostlery','Kaitlin',2,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (12,'City Of Fresno','PO Box 2069',NULL,'Fresno','CA','93718','(559) 555-9999','Mayte','Kendall',3,574);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (13,'Golden Eagle Insurance Co','PO Box 85826',NULL,'San Diego','CA','92186',NULL,'Blanca','Korah',3,590);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (14,'Expedata Inc','4420 N. First Street, Suite 108',NULL,'Fresno','CA','93726','(559) 555-9586','Quintin','Marvin',3,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (15,'ASC Signs','1528 N Sierra Vista',NULL,'Fresno','CA','93703',NULL,'Darien','Elisabeth',1,546);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (16,'Internal Revenue Service',NULL,NULL,'Fresno','CA','93888',NULL,'Aileen','Joan',1,235);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (17,'Blanchard & Johnson Associates','27371 Valderas',NULL,'Mission Viejo','CA','92691','(214) 555-3647','Keeton','Gonzalo',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (18,'Fresno Photoengraving Company','1952 "H" Street','P.O. Box 1952','Fresno','CA','93718','(559) 555-3005','Chaddick','Derek',3,403);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (19,'Crown Printing','1730 "H" St',NULL,'Fresno','CA','93721','(559) 555-7473','Randrup','Leann',2,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (20,'Diversified Printing & Pub','2632 Saturn St',NULL,'Brea','CA','92621','(714) 555-4541','Lane','Vanesa',3,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (21,'The Library Ltd','7700 Forsyth',NULL,'St Louis','MO','63105','(314) 555-8834','Marques','Malia',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (22,'Micro Center','1555 W Lane Ave',NULL,'Columbus','OH','43221','(614) 555-4435','Evan','Emily',2,160);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (23,'Yale Industrial Trucks-Fresno','3711 W Franklin',NULL,'Fresno','CA','93706','(559) 555-2993','Alexis','Alexandro',3,532);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (24,'Zee Medical Service Co','4221 W Sierra Madre #104',NULL,'Washington','IA','52353',NULL,'Hallie','Juliana',3,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (25,'California Data Marketing','2818 E Hamilton',NULL,'Fresno','CA','93721','(559) 555-3801','Jonessen','Moises',4,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (26,'Small Press','121 E Front St - 4th Floor',NULL,'Traverse City','MI','49684',NULL,'Colette','Dusty',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (27,'Rich Advertising','12 Daniel Road',NULL,'Fairfield','NJ','07004','(201) 555-9742','Neil','Ingrid',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (29,'Vision Envelope & Printing','PO Box 3100',NULL,'Gardena','CA','90247','(310) 555-7062','Raven','Jamari',3,551);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (30,'Costco','Fresno Warehouse','4500 W Shaw','Fresno','CA','93711',NULL,'Jaquan','Aaron',3,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (31,'Enterprise Communications Inc','1483 Chain Bridge Rd, Ste 202',NULL,'Mclean','VA','22101','(770) 555-9558','Lawrence','Eileen',2,536);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (32,'RR Bowker','PO Box 31',NULL,'East Brunswick','NJ','08810','(800) 555-8110','Essence','Marjorie',3,532);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (33,'Nielson','Ohio Valley Litho Division','Location #0470','Cincinnati','OH','45264',NULL,'Brooklynn','Keely',2,541);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (34,'IBM','PO Box 61000',NULL,'San Francisco','CA','94161','(800) 555-4426','Camron','Trentin',1,160);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (35,'Cal State Termite','PO Box 956',NULL,'Selma','CA','93662','(559) 555-1534','Hunter','Demetrius',2,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (36,'Graylift','PO Box 2808',NULL,'Fresno','CA','93745','(559) 555-6621','Sydney','Deangelo',3,532);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (37,'Blue Cross','PO Box 9061',NULL,'Oxnard','CA','93031','(800) 555-0912','Eliana','Nikolas',3,510);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (38,'Venture Communications Int''l','60 Madison Ave',NULL,'New York','NY','10010','(212) 555-4800','Neftaly','Thalia',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (39,'Custom Printing Company','PO Box 7028',NULL,'St Louis','MO','63177','(301) 555-1494','Myles','Harley',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (40,'Nat Assoc of College Stores','500 East Lorain Street',NULL,'Oberlin','OH','44074',NULL,'Bernard','Lucy',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (41,'Shields Design','415 E Olive Ave',NULL,'Fresno','CA','93728','(559) 555-8060','Kerry','Rowan',2,403);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (42,'Opamp Technical Books','1033 N Sycamore Ave.',NULL,'Los Angeles','CA','90038','(213) 555-4322','Paris','Gideon',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (43,'Capital Resource Credit','PO Box 39046',NULL,'Minneapolis','MN','55439','(612) 555-0057','Maxwell','Jayda',3,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (44,'Courier Companies, Inc','PO Box 5317',NULL,'Boston','MA','02206','(508) 555-6351','Antavius','Troy',4,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (45,'Naylor Publications Inc','PO Box 40513',NULL,'Jacksonville','FL','32231','(800) 555-6041','Gerald','Kristofer',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (46,'Open Horizons Publishing','Book Marketing Update','PO Box 205','Fairfield','IA','52556','(515) 555-6130','Damien','Deborah',2,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (47,'Baker & Taylor Books','Five Lakepointe Plaza, Ste 500','2709 Water Ridge Parkway','Charlotte','NC','28217','(704) 555-3500','Bernardo','Brittnee',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (48,'Fresno County Tax Collector','PO Box 1192',NULL,'Fresno','CA','93715','(559) 555-3482','Brenton','Kila',3,574);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (49,'Mcgraw Hill Companies','PO Box 87373',NULL,'Chicago','IL','60680','(614) 555-3663','Holbrooke','Rashad',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (50,'Publishers Weekly','Box 1979',NULL,'Marion','OH','43305','(800) 555-1669','Carrollton','Priscilla',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (51,'Blue Shield of California','PO Box 7021',NULL,'Anaheim','CA','92850','(415) 555-5103','Smith','Kylie',3,510);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (52,'Aztek Label','Accounts Payable','1150 N Tustin Ave','Anaheim','CA','92807','(714) 555-9000','Griffin','Brian',3,551);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (53,'Gary McKeighan Insurance','3649 W Beechwood Ave #101',NULL,'Fresno','CA','93711','(559) 555-2420','Jair','Caitlin',3,590);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (54,'Ph Photographic Services','2384 E Gettysburg',NULL,'Fresno','CA','93726','(559) 555-0765','Cheyenne','Kaylea',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (55,'Quality Education Data','PO Box 95857',NULL,'Chicago','IL','60694','(800) 555-5811','Misael','Kayle',2,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (56,'Springhouse Corp','PO Box 7247-7051',NULL,'Philadelphia','PA','19170','(215) 555-8700','Maeve','Clarence',3,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (57,'The Windows Deck','117 W Micheltorena Top Floor',NULL,'Santa Barbara','CA','93101','(800) 555-3353','Wood','Liam',3,536);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (58,'Fresno Rack & Shelving Inc','4718 N Bendel Ave',NULL,'Fresno','CA','93722',NULL,'Baylee','Dakota',2,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (59,'Publishers Marketing Assoc','627 Aviation Way',NULL,'Manhatttan Beach','CA','90266','(310) 555-2732','Walker','Jovon',3,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (60,'The Mailers Guide Co','PO Box 1550',NULL,'New Rochelle','NY','10802',NULL,'Lacy','Karina',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (61,'American Booksellers Assoc','828 S Broadway',NULL,'Tarrytown','NY','10591','(800) 555-0037','Angelica','Nashalie',3,574);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (62,'Cmg Information Services','PO Box 2283',NULL,'Boston','MA','02107','(508) 555-7000','Randall','Yash',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (63,'Lou Gentile''s Flower Basket','722 E Olive Ave',NULL,'Fresno','CA','93728','(559) 555-6643','Anum','Trisha',1,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (64,'Texaco','PO Box 6070',NULL,'Inglewood','CA','90312',NULL,'Oren','Grace',3,582);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (65,'The Drawing Board','PO Box 4758',NULL,'Carol Stream','IL','60197',NULL,'Mckayla','Jeffery',2,551);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (66,'Ascom Hasler Mailing Systems','PO Box 895',NULL,'Shelton','CT','06484',NULL,'Lewis','Darnell',3,532);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (67,'Bill Jones','Secretary Of State','PO Box 944230','Sacramento','CA','94244',NULL,'Deasia','Tristin',3,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (68,'Computer Library','3502 W Greenway #7',NULL,'Phoenix','AZ','85023','(602) 547-0331','Aryn','Leroy',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (69,'Frank E Wilber Co','2437 N Sunnyside',NULL,'Fresno','CA','93727','(559) 555-1881','Millerton','Johnathon',3,532);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (70,'Fresno Credit Bureau','PO Box 942',NULL,'Fresno','CA','93714','(559) 555-7900','Braydon','Anne',2,555);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (71,'The Fresno Bee','1626 E Street',NULL,'Fresno','CA','93786','(559) 555-4442','Colton','Leah',2,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (72,'Data Reproductions Corp','4545 Glenmeade Lane',NULL,'Auburn Hills','MI','48326','(810) 555-3700','Arodondo','Cesar',3,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (73,'Executive Office Products','353 E Shaw Ave',NULL,'Fresno','CA','93710','(559) 555-1704','Danielson','Rachael',2,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (74,'Leslie Company','PO Box 610',NULL,'Olathe','KS','66061','(800) 255-6210','Alondra','Zev',3,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (75,'Retirement Plan Consultants','6435 North Palm Ave, Ste 101',NULL,'Fresno','CA','93704','(559) 555-7070','Edgardo','Salina',3,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (76,'Simon Direct Inc','4 Cornwall Dr Ste 102',NULL,'East Brunswick','NJ','08816','(908) 555-7222','Bradlee','Daniel',2,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (77,'State Board Of Equalization','PO Box 942808',NULL,'Sacramento','CA','94208','(916) 555-4911','Dean','Julissa',1,631);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (78,'The Presort Center','1627 "E" Street',NULL,'Fresno','CA','93706','(559) 555-6151','Marissa','Kyle',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (79,'Valprint','PO Box 12332',NULL,'Fresno','CA','93777','(559) 555-3112','Warren','Quentin',3,551);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (80,'Cardinal Business Media, Inc.','P O Box 7247-7844',NULL,'Philadelphia','PA','19170','(215) 555-1500','Eulalia','Kelsey',2,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (81,'Wang Laboratories, Inc.','P.O. Box 21209',NULL,'Pasadena','CA','91185','(800) 555-0344','Kapil','Robert',2,160);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (82,'Reiter''s Scientific & Pro Books','2021 K Street Nw',NULL,'Washington','DC','20006','(202) 555-5561','Rodolfo','Carlee',2,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (83,'Ingram','PO Box 845361',NULL,'Dallas','TX','75284',NULL,'Yobani','Trey',2,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (84,'Boucher Communications Inc','1300 Virginia Dr. Ste 400',NULL,'Fort Washington','PA','19034','(215) 555-8000','Carson','Julian',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (85,'Champion Printing Company','3250 Spring Grove Ave',NULL,'Cincinnati','OH','45225','(800) 555-1957','Clifford','Jillian',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (86,'Computerworld','Department #1872','PO Box 61000','San Francisco','CA','94161','(617) 555-0700','Lloyd','Angel',1,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (87,'DMV Renewal','PO Box 942894',NULL,'Sacramento','CA','94294',NULL,'Josey','Lorena',4,568);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (88,'Edward Data Services','4775 E Miami River Rd',NULL,'Cleves','OH','45002','(513) 555-3043','Helena','Jeanette',1,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (89,'Evans Executone Inc','4918 Taylor Ct',NULL,'Turlock','CA','95380',NULL,'Royce','Hannah',1,522);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (90,'Wakefield Co','295 W Cromwell Ave Ste 106',NULL,'Fresno','CA','93711','(559) 555-4744','Rothman','Nathanael',2,170);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (91,'McKesson Water Products','P O Box 7126',NULL,'Pasadena','CA','91109','(800) 555-7009','Destin','Luciano',2,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (92,'Zip Print & Copy Center','PO Box 12332',NULL,'Fresno','CA','93777','(233) 555-6400','Javen','Justin',2,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (93,'AT&T','PO Box 78225',NULL,'Phoenix','AZ','85062',NULL,'Wesley','Alisha',3,522);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (94,'Abbey Office Furnishings','4150 W Shaw Ave',NULL,'Fresno','CA','93722','(559) 555-8300','Francis','Kyra',2,150);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (95,'Pacific Bell',NULL,NULL,'Sacramento','CA','95887','(209) 555-7500','Nickalus','Kurt',2,522);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (96,'Wells Fargo Bank','Business Mastercard','P.O. Box 29479','Phoenix','AZ','85038','(947) 555-3900','Damion','Mikayla',2,160);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (97,'Compuserve','Dept L-742',NULL,'Columbus','OH','43260','(614) 555-8600','Armando','Jan',2,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (98,'American Express','Box 0001',NULL,'Los Angeles','CA','90096','(800) 555-3344','Story','Kirsten',2,160);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (99,'Bertelsmann Industry Svcs. Inc','28210 N Avenue Stanford',NULL,'Valencia','CA','91355','(805) 555-0584','Potter','Lance',3,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (100,'Cahners Publishing Company','Citibank Lock Box 4026','8725 W Sahara Zone 1127','The Lake','NV','89163','(301) 555-2162','Jacobsen','Samuel',4,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (101,'California Business Machines','Gallery Plz','5091 N Fresno','Fresno','CA','93710','(559) 555-5570','Rohansen','Anders',2,170);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (102,'Coffee Break Service','PO Box 1091',NULL,'Fresno','CA','93714','(559) 555-8700','Smitzen','Jeffrey',4,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (103,'Dean Witter Reynolds','9 River Pk Pl E 400',NULL,'Boston','MA','02134','(508) 555-8737','Johnson','Vance',5,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (104,'Digital Dreamworks','5070 N Sixth Ste. 71',NULL,'Fresno','CA','93711',NULL,'Elmert','Ron',3,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (105,'Dristas Groom & McCormick','7112 N Fresno St Ste 200',NULL,'Fresno','CA','93720','(559) 555-8484','Aaronsen','Thom',3,591);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (106,'Ford Motor Credit Company','Dept 0419',NULL,'Los Angeles','CA','90084','(800) 555-7000','Snyder','Karen',3,582);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (107,'Franchise Tax Board','PO Box 942857',NULL,'Sacramento','CA','94257',NULL,'Prado','Anita',4,507);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (108,'Gostanian General Building','427 W Bedford #102',NULL,'Fresno','CA','93711','(559) 555-5100','Bragg','Walter',4,523);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (109,'Kent H Landsberg Co','File No 72686','PO Box 61000','San Francisco','CA','94160','(916) 555-8100','Stevens','Wendy',3,540);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (110,'Malloy Lithographing Inc','5411 Jackson Road','PO Box 1124','Ann Arbor','MI','48106','(313) 555-6113','Regging','Abe',3,400);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (111,'Net Asset, Llc','1315 Van Ness Ave Ste. 103',NULL,'Fresno','CA','93721',NULL,'Kraggin','Laura',1,572);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (112,'Office Depot','File No 81901',NULL,'Los Angeles','CA','90074','(800) 555-1711','Pinsippi','Val',3,570);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (113,'Pollstar','4697 W Jacquelyn Ave',NULL,'Fresno','CA','93722','(559) 555-2631','Aranovitch','Robert',5,520);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (114,'Postmaster','Postage Due Technician','1900 E Street','Fresno','CA','93706','(559) 555-7785','Finklestein','Fyodor',1,552);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (115,'Roadway Package System, Inc','Dept La 21095',NULL,'Pasadena','CA','91185',NULL,'Smith','Sam',4,553);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (116,'State of California','Employment Development Dept','PO Box 826276','Sacramento','CA','94230','(209) 555-5132','Articunia','Mercedez',1,631);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (117,'Suburban Propane','2874 S Cherry Ave',NULL,'Fresno','CA','93706','(559) 555-2770','Spivak','Harold',3,521);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (118,'Unocal','P.O. Box 860070',NULL,'Pasadena','CA','91186','(415) 555-7600','Bluzinski','Rachael',3,582);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (119,'Yesmed, Inc','PO Box 2061',NULL,'Fresno','CA','93718','(559) 555-0600','Hernandez','Reba',2,589);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (120,'Dataforms/West','1617 W. Shaw Avenue','Suite F','Fresno','CA','93711',NULL,'Church','Charlie',3,551);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (121,'Zylka Design','3467 W Shaw Ave #103',NULL,'Fresno','CA','93711','(559) 555-8625','Ronaldsen','Jaime',3,403);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (122,'United Parcel Service','P.O. Box 505820',NULL,'Reno','NV','88905','(800) 555-0855','Beauregard','Violet',3,553);
INSERT INTO vendors
(vendor_id,vendor_name,vendor_address1,vendor_address2,vendor_city,vendor_state,vendor_zip_code,vendor_phone,vendor_contact_last_name,vendor_contact_first_name,default_terms_id,default_account_number)
VALUES (123,'Federal Express Corporation','P.O. Box 1140','Dept A','Memphis','TN','38101','(800) 555-4091','Bucket','Charlie',3,553);
 
-- INSERT INTO vendor_contacts
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(5,'Davison','Michelle');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(12,'Mayteh','Kendall');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(17,'Onandonga','Bruce');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(44,'Antavius','Anthony');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(76,'Bradlee','Danny');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(94,'Suscipe','Reynaldo');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(101,'O''Sullivan','Geraldine');
INSERT INTO vendor_contacts (vendor_id,last_name,first_name) VALUES
(123,'Bucket','Charles');
 




-- INSERT INTO invoices
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(1,34,'QP58872',TO_DATE('25-NOV-20','DD-MON-RR'),116.54,116.54,0,4,TO_DATE('22-JAN-21','DD-MON-RR'),TO_DATE('11-JAN-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(2,34,'Q545443',TO_DATE('14-DEC-20','DD-MON-RR'),1083.58,1083.58,0,4,TO_DATE('23-FEB-21','DD-MON-RR'),TO_DATE('14-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(3,110,'P-0608',TO_DATE('11-JAN-21','DD-MON-RR'),20551.18,0,1200,5,TO_DATE('30-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(4,110,'P-0259',TO_DATE('16-JAN-21','DD-MON-RR'),26881.4,26881.4,0,3,TO_DATE('16-FEB-21','DD-MON-RR'),TO_DATE('12-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(5,81,'MABO1489',TO_DATE('16-JAN-21','DD-MON-RR'),936.93,936.93,0,3,TO_DATE('16-FEB-21','DD-MON-RR'),TO_DATE('13-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(6,122,'989319-497',TO_DATE('17-JAN-21','DD-MON-RR'),2312.2,0,0,4,TO_DATE('26-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(7,82,'C73-24',TO_DATE('17-JAN-21','DD-MON-RR'),600,600,0,2,TO_DATE('10-FEB-21','DD-MON-RR'),TO_DATE('05-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(8,122,'989319-487',TO_DATE('18-JAN-21','DD-MON-RR'),1927.54,0,0,4,TO_DATE('19-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(9,122,'989319-477',TO_DATE('19-JAN-21','DD-MON-RR'),2184.11,2184.11,0,4,TO_DATE('12-MAR-21','DD-MON-RR'),TO_DATE('07-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(10,122,'989319-467',TO_DATE('24-JAN-21','DD-MON-RR'),2318.03,2318.03,0,4,TO_DATE('05-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(11,122,'989319-457',TO_DATE('24-JAN-21','DD-MON-RR'),3813.33,3813.33,0,3,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('20-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(12,122,'989319-447',TO_DATE('24-JAN-21','DD-MON-RR'),3689.99,3689.99,0,3,TO_DATE('22-FEB-21','DD-MON-RR'),TO_DATE('12-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(13,122,'989319-437',TO_DATE('24-JAN-21','DD-MON-RR'),2765.36,2765.36,0,2,TO_DATE('15-FEB-21','DD-MON-RR'),TO_DATE('03-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(14,122,'989319-427',TO_DATE('25-JAN-21','DD-MON-RR'),2115.81,2115.81,0,1,TO_DATE('08-FEB-21','DD-MON-RR'),TO_DATE('01-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(15,121,'97/553B',TO_DATE('26-JAN-21','DD-MON-RR'),313.55,0,0,4,TO_DATE('09-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(16,122,'989319-417',TO_DATE('26-JAN-21','DD-MON-RR'),2051.59,2051.59,0,1,TO_DATE('01-FEB-21','DD-MON-RR'),TO_DATE('28-JAN-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(17,90,'97-1024A',TO_DATE('26-JAN-21','DD-MON-RR'),356.48,356.48,0,3,TO_DATE('09-MAR-21','DD-MON-RR'),TO_DATE('09-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(18,121,'97/553',TO_DATE('27-JAN-21','DD-MON-RR'),904.14,0,0,4,TO_DATE('09-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(19,121,'97/522',TO_DATE('30-JAN-21','DD-MON-RR'),1962.13,0,200,4,TO_DATE('10-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(20,121,'97/503',TO_DATE('30-JAN-21','DD-MON-RR'),639.77,639.77,0,4,TO_DATE('11-MAR-21','DD-MON-RR'),TO_DATE('05-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(21,121,'97/488',TO_DATE('30-JAN-21','DD-MON-RR'),601.95,601.95,0,3,TO_DATE('03-MAR-21','DD-MON-RR'),TO_DATE('27-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(22,121,'97/486',TO_DATE('30-JAN-21','DD-MON-RR'),953.1,953.1,0,2,TO_DATE('21-FEB-21','DD-MON-RR'),TO_DATE('13-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(23,121,'97/465',TO_DATE('01-FEB-21','DD-MON-RR'),565.15,565.15,0,1,TO_DATE('14-FEB-21','DD-MON-RR'),TO_DATE('05-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(24,121,'97/222',TO_DATE('01-FEB-21','DD-MON-RR'),1000.46,1000.46,0,3,TO_DATE('03-MAR-21','DD-MON-RR'),TO_DATE('25-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(25,123,'4-342-8069',TO_DATE('01-FEB-21','DD-MON-RR'),10,10,0,4,TO_DATE('10-MAR-21','DD-MON-RR'),TO_DATE('27-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(26,123,'4-327-7357',TO_DATE('01-FEB-21','DD-MON-RR'),162.75,162.75,0,3,TO_DATE('27-FEB-21','DD-MON-RR'),TO_DATE('21-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(27,123,'4-321-2596',TO_DATE('01-FEB-21','DD-MON-RR'),10,10,0,2,TO_DATE('20-FEB-21','DD-MON-RR'),TO_DATE('11-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(28,123,'7548906-20',TO_DATE('01-FEB-21','DD-MON-RR'),27,27,0,3,TO_DATE('06-MAR-21','DD-MON-RR'),TO_DATE('26-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(29,123,'4-314-3057',TO_DATE('02-FEB-21','DD-MON-RR'),13.75,13.75,0,1,TO_DATE('13-FEB-21','DD-MON-RR'),TO_DATE('07-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(30,94,'203339-19',TO_DATE('02-FEB-21','DD-MON-RR'),17.5,0,0,3,TO_DATE('13-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(31,123,'2-000-2993',TO_DATE('03-FEB-21','DD-MON-RR'),144.7,144.7,0,1,TO_DATE('06-FEB-21','DD-MON-RR'),TO_DATE('04-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(32,89,'125520-1',TO_DATE('05-FEB-21','DD-MON-RR'),95,95,0,3,TO_DATE('08-MAR-21','DD-MON-RR'),TO_DATE('22-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(33,123,'1-202-2978',TO_DATE('06-FEB-21','DD-MON-RR'),33,33,0,1,TO_DATE('20-FEB-21','DD-MON-RR'),TO_DATE('13-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(34,110,'0-2436',TO_DATE('07-FEB-21','DD-MON-RR'),10976.06,0,0,4,TO_DATE('17-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(35,123,'1-200-5164',TO_DATE('07-FEB-21','DD-MON-RR'),63.4,63.4,0,1,TO_DATE('13-FEB-21','DD-MON-RR'),TO_DATE('10-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(36,110,'0-2060',TO_DATE('08-FEB-21','DD-MON-RR'),23517.58,21221.63,2295.95,3,TO_DATE('09-MAR-21','DD-MON-RR'),TO_DATE('10-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(37,110,'0-2058',TO_DATE('08-FEB-21','DD-MON-RR'),37966.19,37966.19,0,3,TO_DATE('09-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(38,123,'963253272',TO_DATE('09-FEB-21','DD-MON-RR'),61.5,0,0,4,TO_DATE('29-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(39,123,'963253271',TO_DATE('09-FEB-21','DD-MON-RR'),158,0,0,4,TO_DATE('28-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(40,123,'963253269',TO_DATE('09-FEB-21','DD-MON-RR'),26.75,0,0,4,TO_DATE('25-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(41,123,'963253267',TO_DATE('09-FEB-21','DD-MON-RR'),23.5,0,0,4,TO_DATE('24-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(42,97,'21-4748363',TO_DATE('09-FEB-21','DD-MON-RR'),9.95,0,0,4,TO_DATE('25-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(43,97,'21-4923721',TO_DATE('09-FEB-21','DD-MON-RR'),9.95,9.95,0,1,TO_DATE('21-FEB-21','DD-MON-RR'),TO_DATE('13-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(44,123,'963253264',TO_DATE('10-FEB-21','DD-MON-RR'),52.25,0,0,4,TO_DATE('23-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(45,123,'963253263',TO_DATE('10-FEB-21','DD-MON-RR'),109.5,0,0,4,TO_DATE('22-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(46,123,'963253261',TO_DATE('10-FEB-21','DD-MON-RR'),42.75,42.75,0,3,TO_DATE('16-MAR-21','DD-MON-RR'),TO_DATE('10-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(47,123,'963253260',TO_DATE('10-FEB-21','DD-MON-RR'),36,36,0,3,TO_DATE('15-MAR-21','DD-MON-RR'),TO_DATE('06-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(48,123,'963253258',TO_DATE('10-FEB-21','DD-MON-RR'),111,111,0,3,TO_DATE('11-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(49,123,'963253256',TO_DATE('10-FEB-21','DD-MON-RR'),53.25,53.25,0,3,TO_DATE('10-MAR-21','DD-MON-RR'),TO_DATE('27-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(50,123,'963253255',TO_DATE('11-FEB-21','DD-MON-RR'),53.75,53.75,0,3,TO_DATE('09-MAR-21','DD-MON-RR'),TO_DATE('03-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(51,123,'963253254',TO_DATE('11-FEB-21','DD-MON-RR'),108.5,108.5,0,3,TO_DATE('08-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(52,123,'963253252',TO_DATE('11-FEB-21','DD-MON-RR'),38.75,38.75,0,3,TO_DATE('07-MAR-21','DD-MON-RR'),TO_DATE('27-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(53,123,'963253251',TO_DATE('11-FEB-21','DD-MON-RR'),15.5,15.5,0,3,TO_DATE('04-MAR-21','DD-MON-RR'),TO_DATE('21-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(54,123,'963253249',TO_DATE('12-FEB-21','DD-MON-RR'),127.75,127.75,0,2,TO_DATE('03-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(55,123,'963253248',TO_DATE('13-FEB-21','DD-MON-RR'),241,241,0,2,TO_DATE('02-MAR-21','DD-MON-RR'),TO_DATE('24-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(56,123,'963253246',TO_DATE('13-FEB-21','DD-MON-RR'),129,129,0,2,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('20-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(57,123,'963253245',TO_DATE('13-FEB-21','DD-MON-RR'),40.75,40.75,0,2,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('14-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(58,123,'963253244',TO_DATE('13-FEB-21','DD-MON-RR'),60,60,0,2,TO_DATE('27-FEB-21','DD-MON-RR'),TO_DATE('21-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(59,123,'963253242',TO_DATE('13-FEB-21','DD-MON-RR'),104,104,0,2,TO_DATE('26-FEB-21','DD-MON-RR'),TO_DATE('17-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(60,123,'963253240',TO_DATE('23-FEB-21','DD-MON-RR'),67,67,0,1,TO_DATE('03-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(61,123,'963253239',TO_DATE('23-FEB-21','DD-MON-RR'),147.25,147.25,0,1,TO_DATE('02-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(62,123,'963253237',TO_DATE('23-FEB-21','DD-MON-RR'),172.5,172.5,0,1,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('24-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(63,123,'963253235',TO_DATE('14-FEB-21','DD-MON-RR'),108.25,108.25,0,1,TO_DATE('20-FEB-21','DD-MON-RR'),TO_DATE('17-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(64,123,'963253234',TO_DATE('14-FEB-21','DD-MON-RR'),138.75,138.75,0,1,TO_DATE('19-FEB-21','DD-MON-RR'),TO_DATE('16-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(65,123,'963253232',TO_DATE('14-FEB-21','DD-MON-RR'),127.75,127.75,0,1,TO_DATE('18-FEB-21','DD-MON-RR'),TO_DATE('16-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(66,123,'963253230',TO_DATE('15-FEB-21','DD-MON-RR'),739.2,739.2,0,1,TO_DATE('17-FEB-21','DD-MON-RR'),TO_DATE('16-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(67,123,'43966316',TO_DATE('17-FEB-21','DD-MON-RR'),10,0,0,3,TO_DATE('19-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(68,123,'263253273',TO_DATE('17-FEB-21','DD-MON-RR'),30.75,0,0,4,TO_DATE('29-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(69,37,'547479217',TO_DATE('17-FEB-21','DD-MON-RR'),116,0,0,3,TO_DATE('22-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(70,123,'263253270',TO_DATE('18-FEB-21','DD-MON-RR'),67.92,0,0,3,TO_DATE('25-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(71,123,'263253268',TO_DATE('18-FEB-21','DD-MON-RR'),59.97,0,0,3,TO_DATE('24-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(72,123,'263253265',TO_DATE('18-FEB-21','DD-MON-RR'),26.25,0,0,3,TO_DATE('23-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(73,123,'263253257',TO_DATE('18-FEB-21','DD-MON-RR'),22.57,22.57,0,2,TO_DATE('10-MAR-21','DD-MON-RR'),TO_DATE('27-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(74,123,'263253253',TO_DATE('18-FEB-21','DD-MON-RR'),31.95,31.95,0,2,TO_DATE('07-MAR-21','DD-MON-RR'),TO_DATE('01-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(75,123,'263253250',TO_DATE('19-FEB-21','DD-MON-RR'),42.67,42.67,0,2,TO_DATE('03-MAR-21','DD-MON-RR'),TO_DATE('25-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(76,123,'263253243',TO_DATE('20-FEB-21','DD-MON-RR'),44.44,44.44,0,1,TO_DATE('26-FEB-21','DD-MON-RR'),TO_DATE('23-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(77,123,'263253241',TO_DATE('20-FEB-21','DD-MON-RR'),40.2,40.2,0,1,TO_DATE('25-FEB-21','DD-MON-RR'),TO_DATE('22-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(78,123,'94007069',TO_DATE('22-FEB-21','DD-MON-RR'),400,400,0,3,TO_DATE('01-APR-21','DD-MON-RR'),TO_DATE('25-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(79,123,'963253262',TO_DATE('22-FEB-21','DD-MON-RR'),42.5,0,0,3,TO_DATE('21-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(80,105,'94007005',TO_DATE('23-FEB-21','DD-MON-RR'),220,220,0,1,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('26-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(81,83,'31359783',TO_DATE('23-FEB-21','DD-MON-RR'),1575,0,0,2,TO_DATE('09-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(82,115,'25022117',TO_DATE('24-FEB-21','DD-MON-RR'),6,0,0,3,TO_DATE('21-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(83,115,'24946731',TO_DATE('25-FEB-21','DD-MON-RR'),25.67,25.67,0,2,TO_DATE('14-MAR-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(84,115,'24863706',TO_DATE('27-FEB-21','DD-MON-RR'),6,6,0,1,TO_DATE('07-MAR-21','DD-MON-RR'),TO_DATE('01-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(85,115,'24780512',TO_DATE('28-FEB-21','DD-MON-RR'),6,6,0,1,TO_DATE('28-FEB-21','DD-MON-RR'),TO_DATE('28-FEB-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(86,88,'972110',TO_DATE('28-FEB-21','DD-MON-RR'),207.78,207.78,0,1,TO_DATE('06-MAR-21','DD-MON-RR'),TO_DATE('02-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(87,100,'587056',TO_DATE('28-FEB-21','DD-MON-RR'),2184.5,2184.5,0,3,TO_DATE('28-MAR-21','DD-MON-RR'),TO_DATE('22-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(88,86,'367447',TO_DATE('28-FEB-21','DD-MON-RR'),2433,0,0,3,TO_DATE('30-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(89,99,'509786',TO_DATE('28-FEB-21','DD-MON-RR'),6940.25,6940.25,0,2,TO_DATE('16-MAR-21','DD-MON-RR'),TO_DATE('08-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(90,108,'121897',TO_DATE('01-MAR-21','DD-MON-RR'),450,450,0,2,TO_DATE('19-MAR-21','DD-MON-RR'),TO_DATE('14-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(91,80,'134116',TO_DATE('01-MAR-21','DD-MON-RR'),90.36,0,0,3,TO_DATE('02-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(92,80,'133560',TO_DATE('01-MAR-21','DD-MON-RR'),175,175,0,2,TO_DATE('20-MAR-21','DD-MON-RR'),TO_DATE('03-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(93,104,'P02-3772',TO_DATE('03-MAR-21','DD-MON-RR'),7125.34,7125.34,0,2,TO_DATE('18-MAR-21','DD-MON-RR'),TO_DATE('08-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(94,106,'9982771',TO_DATE('03-MAR-21','DD-MON-RR'),503.2,0,0,2,TO_DATE('18-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(95,107,'RTR-72-3662-X',TO_DATE('04-MAR-21','DD-MON-RR'),1600,1600,0,2,TO_DATE('18-MAR-21','DD-MON-RR'),TO_DATE('11-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(96,113,'77290',TO_DATE('04-MAR-21','DD-MON-RR'),1750,1750,0,2,TO_DATE('18-MAR-21','DD-MON-RR'),TO_DATE('08-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(97,119,'10843',TO_DATE('04-MAR-21','DD-MON-RR'),4901.26,4901.26,0,2,TO_DATE('18-MAR-21','DD-MON-RR'),TO_DATE('11-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(98,95,'111-92R-10092',TO_DATE('04-MAR-21','DD-MON-RR'),46.21,0,0,1,TO_DATE('29-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(99,95,'111-92R-10093',TO_DATE('05-MAR-21','DD-MON-RR'),39.77,0,0,2,TO_DATE('28-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(100,96,'I77271-O01',TO_DATE('05-MAR-21','DD-MON-RR'),662,0,0,2,TO_DATE('24-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(101,103,'75C-90227',TO_DATE('06-MAR-21','DD-MON-RR'),1367.5,1367.5,0,1,TO_DATE('13-MAR-21','DD-MON-RR'),TO_DATE('09-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(102,48,'P02-88D77S7',TO_DATE('06-MAR-21','DD-MON-RR'),856.92,856.92,0,1,TO_DATE('13-MAR-21','DD-MON-RR'),TO_DATE('09-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(103,95,'111-92R-10094',TO_DATE('06-MAR-21','DD-MON-RR'),19.67,0,0,1,TO_DATE('27-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(104,114,'CBM9920-M-T77109',TO_DATE('07-MAR-21','DD-MON-RR'),290,290,0,1,TO_DATE('12-MAR-21','DD-MON-RR'),TO_DATE('09-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(105,95,'111-92R-10095',TO_DATE('07-MAR-21','DD-MON-RR'),32.7,0,0,3,TO_DATE('26-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(106,95,'111-92R-10096',TO_DATE('08-MAR-21','DD-MON-RR'),16.33,0,0,2,TO_DATE('25-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(107,95,'111-92R-10097',TO_DATE('08-MAR-21','DD-MON-RR'),16.33,0,0,1,TO_DATE('24-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(108,117,'111897',TO_DATE('11-MAR-21','DD-MON-RR'),16.62,16.62,0,1,TO_DATE('14-MAR-21','DD-MON-RR'),TO_DATE('12-MAR-21','DD-MON-RR'));
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(109,102,'109596',TO_DATE('14-MAR-21','DD-MON-RR'),41.8,0,0,3,TO_DATE('11-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(110,72,'39104',TO_DATE('20-MAR-21','DD-MON-RR'),85.31,0,0,3,TO_DATE('20-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(111,37,'547480102',TO_DATE('19-FEB-21','DD-MON-RR'),224,0,0,3,TO_DATE('24-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(112,37,'547481328',TO_DATE('20-FEB-21','DD-MON-RR'),224,0,0,3,TO_DATE('25-MAR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(113,72,'40318',TO_DATE('18-APR-21','DD-MON-RR'),21842,0,0,3,TO_DATE('20-APR-21','DD-MON-RR'),null);
INSERT INTO invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(114,83,'31361833',TO_DATE('23-FEB-21','DD-MON-RR'),579.42,0,0,2,TO_DATE('09-MAR-21','DD-MON-RR'),null);








 
-- INSERTING into INVOICE_LINE_ITEMS
INSERT INTO invoice_line_items
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (1,1,572,116.54,'MVS Online Library');
INSERT INTO invoice_line_items
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (2,1,572,1083.58,'MSDN');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (3,1,120,20551.18,'CICS Part 2');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (4,1,120,26881.4,'MVS JCL');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (5,1,527,936.93,'Quarterly Maintenance');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (6,1,553,2312.2,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (7,1,541,600,'Trade advertising');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (8,1,553,1927.54,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (9,1,553,2184.11,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (10,1,553,2318.03,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (11,1,553,3813.33,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (12,1,553,3689.99,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (13,1,553,2765.36,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (14,1,553,2115.81,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (15,1,540,313.55,'Card revision');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (16,1,553,2051.59,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (17,1,523,356.48,'Network wiring');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (18,1,540,904.14,'DB2 Card decks');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (19,1,536,1197,'MC Bouncebacks');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (19,2,540,765.13,'SCMD Flyer');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (20,1,536,639.77,'Card deck');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (21,1,536,601.95,'Card deck revision');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (22,1,536,953.1,'Crash Course revision');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (23,1,541,565.15,'Crash Course Ad');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (24,1,540,1000.46,'Crash Course Cover');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (25,1,553,10,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (26,1,553,162.75,'International shipment');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (27,1,553,10,'Address correction');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (28,1,553,27,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (29,1,553,13.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (30,1,570,17.5,'Supplies');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (31,1,553,144.7,'Int''l shipment');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (32,1,523,95,'Telephone service');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (33,1,553,33,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (34,1,120,10976.06,'VSAM for the Cobol Programmer');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (35,1,553,63.4,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (36,1,120,23517.58,'DB2 Part 1');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (37,1,120,37966.19,'CICS Desk Reference');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (38,1,553,61.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (39,1,553,158,'Int''l shipment');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (40,1,553,26.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (41,1,553,23.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (42,1,572,9.95,'Monthly access fee');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (43,1,572,9.95,'Monthly access fee');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (44,1,553,52.25,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (45,1,553,109.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (46,1,553,42.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (47,1,553,36,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (48,1,553,111,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (49,1,553,53.25,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (50,1,553,53.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (51,1,553,108.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (52,1,553,38.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (53,1,553,15.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (54,1,553,127.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (55,1,553,241,'Int''l shipment');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (56,1,553,129,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (57,1,553,40.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (58,1,553,60,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (59,1,553,104,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (60,1,553,67,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (61,1,553,147.25,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (62,1,553,172.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (63,1,553,108.25,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (64,1,553,138.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (65,1,553,127.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (66,1,553,739.2,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (67,1,553,10,'Address correction');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (68,1,553,30.75,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (69,1,510,116,'Health Insurance');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (70,1,553,67.92,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (71,1,553,59.97,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (72,1,553,26.25,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (73,1,553,22.57,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (74,1,553,31.95,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (75,1,553,42.67,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (76,1,553,44.44,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (77,1,553,40.2,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (78,1,553,400,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (79,1,553,42.5,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (80,1,591,220,'Form 571-L');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (81,1,541,1575,'Catalog ad');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (82,1,553,6,'Freight out');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (83,1,553,25.67,'Freight out');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (84,1,552,6,'Freight out');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (85,1,553,6,'Freight');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (86,1,540,207.78,'Prospect list');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (87,1,536,2184.5,'PC card deck');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (88,1,536,2433,'Card deck');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (89,1,120,6940.25,'OS Utilities');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (90,1,523,450,'Back office additions');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (91,1,536,90.36,'Card deck advertising');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (92,1,536,175,'Card deck advertising');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (93,1,548,7125.34,'Web site design');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (94,1,569,503.2,'Bronco lease');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (95,1,235,1600,'Income Tax');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (96,1,520,1750,'Warehouse lease');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (97,1,520,4901.26,'Office lease');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (98,1,522,46.21,'Telephone (Line 1)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (99,1,522,39.77,'Telephone (Line 2)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (100,1,580,50,'DiCicco''s');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (100,2,540,75.6,'Kinko''s');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (100,3,570,58.4,'Office Max');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (100,4,546,478,'Publishers Marketing');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (101,1,221,1367.5,'401K Contributions');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (102,1,574,856.92,'Property Taxes');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (103,1,522,19.67,'Telephone (Line 3)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (104,1,552,290,'International pkg.');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (105,1,522,32.7,'Telephone (line 4)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (106,1,522,16.33,'Telephone (line 5)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (107,1,522,16.33,'Telephone (line 6)');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (108,1,589,16.62,'Propane-forklift');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (109,1,580,41.8,'Coffee');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (110,1,540,85.31,'Book copy');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (111,1,510,224,'Health Insurance');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (112,1,510,224,'Health Insurance');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (113,1,540,21842,'Book repro');
Insert into INVOICE_LINE_ITEMS
(invoice_id,invoice_sequence,account_number,line_item_amt,line_item_description)
VALUES (114,1,541,579.42,'Catalog ad');
 
COMMIT;
 








 


------------------------------------------------------------------------------------------
---- drop and create EX tables.  Drops will run without errors
------------------------------------------------------------------------------------------
SET DEFINE OFF;




BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE active_invoices';
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/


BEGIN  EXECUTE IMMEDIATE 'DROP TABLE CUSTOMERS_EX'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE date_sample'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE departments'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE employees'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE float_sample'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE null_sample'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE color_sample'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE paid_invoices'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE projects'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN  EXECUTE IMMEDIATE 'DROP TABLE string_sample'; EXCEPTION WHEN OTHERS THEN NULL; END;
/


 
Commit;
 
CREATE TABLE active_invoices
(
  invoice_id            NUMBER            NOT NULL,
  vendor_id             NUMBER            NOT NULL,
  invoice_number    VARCHAR2(50)  NOT NULL,
  invoice_date          DATE              NOT NULL,
  invoice_total         NUMBER(9,2)   NOT NULL,
  payment_total         NUMBER(9,2)   NOT NULL,
  credit_total          NUMBER(9,2)   NOT NULL,
  terms_id              NUMBER            NOT NULL,
  invoice_due_date  DATE              NOT NULL,
  payment_date          DATE
);
 
CREATE TABLE color_sample
(
  color_id          NUMBER                            NOT NULL,
  color_number  NUMBER                DEFAULT 0   NOT NULL,
  color_name        VARCHAR2(10)
);
 
 
CREATE TABLE CUSTOMERS_EX
(
  customer_id              NUMBER                NOT NULL,
  customer_last_name   VARCHAR2(30),
  customer_first_name  VARCHAR2(30),
  customer_address         VARCHAR2(60),
  customer_city            VARCHAR2(15),
  customer_state           VARCHAR2(15),
  customer_zip             VARCHAR2(10),
  customer_phone           VARCHAR2(24)
);
 
 
CREATE TABLE date_sample
(
  date_id           NUMBER   NOT NULL,
  start_date        DATE
);
 
CREATE TABLE departments
(
  department_number   NUMBER            NOT NULL,
  department_name     VARCHAR2(50)  NOT NULL UNIQUE,
  CONSTRAINT department_number_unq 
        UNIQUE (department_number)
);


Drop sequence department_id_Seq;


--Add for HW6 in Fall2019
CREATE SEQUENCE  Department_ID_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 
INCREMENT BY 1 
START WITH 5 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;


 
CREATE TABLE employees
(
  employee_id             NUMBER                NOT NULL,
  last_name               VARCHAR2 (35)         NOT NULL,
  first_name              VARCHAR2 (35)         NOT NULL,
  department_number   NUMBER                NOT NULL,
  manager_id              NUMBER
);
 
CREATE TABLE float_sample
(
  float_id           NUMBER,
  float_value        BINARY_DOUBLE
);
 
CREATE TABLE null_sample
(
  invoice_id          NUMBER                NOT NULL,
  invoice_total   NUMBER(9,2),
  CONSTRAINT invoice_id_unq
        UNIQUE (invoice_id)
);
 
CREATE TABLE paid_invoices
(
  invoice_id                NUMBER              NOT NULL,
  vendor_id                 NUMBER              NOT NULL,
  invoice_number        VARCHAR2(50)        NOT NULL,
  invoice_date              DATE                NOT NULL,
  invoice_total         NUMBER(9,2)         NOT NULL,
  payment_total         NUMBER(9,2)         NOT NULL,
  credit_total              NUMBER(9,2)         NOT NULL,
  terms_id                  NUMBER              NOT NULL,
  invoice_due_date          DATE                NOT NULL,
  payment_date              DATE
);
 
CREATE TABLE projects
(
  project_number        VARCHAR2(5)   NOT NULL,
  employee_id           NUMBER        NOT NULL
);
 
CREATE TABLE string_sample
(
  id            VARCHAR2(3),
  name          VARCHAR2(25)
);
 
-- INSERT INTO active_invoices
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(3,110,'P-0608',TO_DATE('11-APR-20','DD-MON-RR'),20551.18,0,1200,5,TO_DATE('30-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(6,122,'989319-497',TO_DATE('17-APR-20','DD-MON-RR'),2312.2,0,0,4,TO_DATE('26-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(8,122,'989319-487',TO_DATE('18-APR-20','DD-MON-RR'),1927.54,0,0,4,TO_DATE('19-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(15,121,'97/553B',TO_DATE('26-APR-20','DD-MON-RR'),313.55,0,0,4,TO_DATE('09-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(18,121,'97/553',TO_DATE('27-APR-20','DD-MON-RR'),904.14,0,0,4,TO_DATE('09-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(19,121,'97/522',TO_DATE('30-APR-20','DD-MON-RR'),1962.13,0,200,4,TO_DATE('10-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(30,94,'203339-19',TO_DATE('02-MAY-20','DD-MON-RR'),17.5,0,0,3,TO_DATE('13-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(34,110,'0-2436',TO_DATE('07-MAY-20','DD-MON-RR'),10976.06,0,0,4,TO_DATE('17-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(38,123,'963253272',TO_DATE('09-MAY-20','DD-MON-RR'),61.5,0,0,4,TO_DATE('29-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(39,123,'963253271',TO_DATE('09-MAY-20','DD-MON-RR'),158,0,0,4,TO_DATE('28-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(40,123,'963253269',TO_DATE('09-MAY-20','DD-MON-RR'),26.75,0,0,4,TO_DATE('25-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(41,123,'963253267',TO_DATE('09-MAY-20','DD-MON-RR'),23.5,0,0,4,TO_DATE('24-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(42,97,'21-4748363',TO_DATE('09-MAY-20','DD-MON-RR'),9.95,0,0,4,TO_DATE('25-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(44,123,'963253264',TO_DATE('10-MAY-20','DD-MON-RR'),52.25,0,0,4,TO_DATE('23-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(45,123,'963253263',TO_DATE('10-MAY-20','DD-MON-RR'),109.5,0,0,4,TO_DATE('22-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(67,123,'43966316',TO_DATE('17-MAY-20','DD-MON-RR'),10,0,0,3,TO_DATE('19-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(68,123,'263253273',TO_DATE('17-MAY-20','DD-MON-RR'),30.75,0,0,4,TO_DATE('29-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(69,37,'547479217',TO_DATE('17-MAY-20','DD-MON-RR'),116,0,0,3,TO_DATE('22-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(70,123,'263253270',TO_DATE('18-MAY-20','DD-MON-RR'),67.92,0,0,3,TO_DATE('25-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(71,123,'263253268',TO_DATE('18-MAY-20','DD-MON-RR'),59.97,0,0,3,TO_DATE('24-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(72,123,'263253265',TO_DATE('18-MAY-20','DD-MON-RR'),26.25,0,0,3,TO_DATE('23-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(79,123,'963253262',TO_DATE('22-MAY-20','DD-MON-RR'),42.5,0,0,3,TO_DATE('21-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(81,83,'31359783',TO_DATE('23-MAY-20','DD-MON-RR'),1575,0,0,2,TO_DATE('09-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(82,115,'25022117',TO_DATE('24-MAY-20','DD-MON-RR'),6,0,0,3,TO_DATE('21-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(88,86,'367447',TO_DATE('31-MAY-20','DD-MON-RR'),2433,0,0,3,TO_DATE('30-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(91,80,'134116',TO_DATE('01-JUN-20','DD-MON-RR'),90.36,0,0,3,TO_DATE('02-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(94,106,'9982771',TO_DATE('03-JUN-20','DD-MON-RR'),503.2,0,0,2,TO_DATE('18-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(98,95,'111-92R-10092',TO_DATE('04-JUN-20','DD-MON-RR'),46.21,0,0,1,TO_DATE('29-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(99,95,'111-92R-10093',TO_DATE('05-JUN-20','DD-MON-RR'),39.77,0,0,2,TO_DATE('28-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(100,96,'I77271-O01',TO_DATE('05-JUN-20','DD-MON-RR'),662,0,0,2,TO_DATE('24-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(103,95,'111-92R-10094',TO_DATE('06-JUN-20','DD-MON-RR'),19.67,0,0,1,TO_DATE('27-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(105,95,'111-92R-10095',TO_DATE('07-JUN-20','DD-MON-RR'),32.7,0,0,3,TO_DATE('26-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(106,95,'111-92R-10096',TO_DATE('08-JUN-20','DD-MON-RR'),16.33,0,0,2,TO_DATE('25-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(107,95,'111-92R-10097',TO_DATE('08-JUN-20','DD-MON-RR'),16.33,0,0,1,TO_DATE('24-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(109,102,'109596',TO_DATE('14-JUN-20','DD-MON-RR'),41.8,0,0,3,TO_DATE('11-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(110,72,'39104',TO_DATE('20-JUN-20','DD-MON-RR'),85.31,0,0,3,TO_DATE('20-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(111,37,'547480102',TO_DATE('19-MAY-20','DD-MON-RR'),224,0,0,3,TO_DATE('24-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(112,37,'547481328',TO_DATE('20-MAY-20','DD-MON-RR'),224,0,0,3,TO_DATE('25-JUN-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(113,72,'40318',TO_DATE('18-JUL-20','DD-MON-RR'),21842,0,0,3,TO_DATE('20-JUL-20','DD-MON-RR'),null);
INSERT INTO active_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(114,83,'31361833',TO_DATE('23-MAY-20','DD-MON-RR'),579.42,0,0,2,TO_DATE('09-JUN-20','DD-MON-RR'),null);
 
 
-- INSERT INTO CUSTOMERS_EX
INSERT INTO CUSTOMERS_EX VALUES (1, 'Anders', 'Maria', '345 Winchell Pl', 'Anderson', 'IN', '46014', '(765) 555-7878');
INSERT INTO CUSTOMERS_EX VALUES (2, 'Trujillo', 'Ana', '1298 E Smathers St', 'Benton', 'AR', '72018', '(501) 555-7733');
INSERT INTO CUSTOMERS_EX VALUES (3, 'Moreno', 'Antonio', '6925 N Parkland Ave', 'Puyallup', 'WA', '98373', '(253) 555-8332');
INSERT INTO CUSTOMERS_EX VALUES (4, 'Hardy', 'Thomas', '83 d''Urberville Ln', 'Casterbridge', 'GA', '31209', '(478) 555-1139');
INSERT INTO CUSTOMERS_EX VALUES (5, 'Berglund', 'Christina', '22717 E 73rd Ave', 'Dubuque', 'IA', '52004', '(319) 555-1139');
INSERT INTO CUSTOMERS_EX VALUES (6, 'Moos', 'Hanna', '1778 N Bovine Ave', 'Peoria', 'IL', '61638', '(309) 555-8755');
INSERT INTO CUSTOMERS_EX VALUES (7, 'Citeaux', 'Fred', '1234 Main St', 'Normal', 'IL', '61761', '(309) 555-1914');
INSERT INTO CUSTOMERS_EX VALUES (8, 'Summer', 'Martin', '1877 Ete Ct', 'Frogtown', 'LA', '70563', '(337) 555-9441');
INSERT INTO CUSTOMERS_EX VALUES (9, 'Lebihan', 'Laurence', '717 E Michigan Ave', 'Chicago', 'IL', '60611', '(312) 555-9441');
INSERT INTO CUSTOMERS_EX VALUES (10, 'Lincoln', 'Elizabeth', '4562 Rt 78 E', 'Vancouver', 'WA', '98684', '(360) 555-2680');
INSERT INTO CUSTOMERS_EX VALUES (11, 'Snyder', 'Howard', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', '(503) 555-7555');
INSERT INTO CUSTOMERS_EX VALUES (12, 'Latimer', 'Yoshi', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', '(503) 555-6874');
INSERT INTO CUSTOMERS_EX VALUES (13, 'Steel', 'John', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', '(509) 555-7969');
INSERT INTO CUSTOMERS_EX VALUES (14, 'Yorres', 'Jaime', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', '(415) 555-5938');
INSERT INTO CUSTOMERS_EX VALUES (15, 'Wilson', 'Fran', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', '(503) 555-9573');
INSERT INTO CUSTOMERS_EX VALUES (16, 'Phillips', 'Rene', '2743 Bering St.', 'Anchorage', 'AK', '99508', '(907) 555-7584');
INSERT INTO CUSTOMERS_EX VALUES (17, 'Wilson', 'Paula', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', '(505) 555-5939');
INSERT INTO CUSTOMERS_EX VALUES (18, 'Pavarotti', 'Jose', '187 Suffolk Ln.', 'Boise', 'ID', '83720', '(208) 555-8097');
INSERT INTO CUSTOMERS_EX VALUES (19, 'Braunschweiger', 'Art', 'P.O. Box 555', 'Lander', 'WY', '82520', '(307) 555-4680');
INSERT INTO CUSTOMERS_EX VALUES (20, 'Nixon', 'Liz', '89 Jefferson Way Suite 2', 'Providence', 'RI', '02909', '(401) 555-3612');
INSERT INTO CUSTOMERS_EX VALUES (21, 'Wong', 'Liu', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', '(406) 555-5834');
INSERT INTO CUSTOMERS_EX VALUES (22, 'Nagy', 'Helvetius', '722 DaVinci Blvd.', 'Concord', 'MA', '01742', '(351) 555-1219');
INSERT INTO CUSTOMERS_EX VALUES (23, 'Jablonski', 'Karl', '305 - 14th Ave. S. Suite 3B', 'Seattle', 'WA', '98128', '(206) 555-4112');
INSERT INTO CUSTOMERS_EX VALUES (24, 'Chelan', 'Donna', '2299 E Baylor Dr', 'Dallas', 'TX', '75224', '(469) 555-8828');
 
-- INSERT INTO date_sample
INSERT INTO date_sample VALUES (1, TO_DATE('1979-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO date_sample VALUES (2, TO_DATE('1999-02-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO date_sample VALUES (3, TO_DATE('2003-10-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO date_sample VALUES (4, TO_DATE('2005-02-28 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO date_sample VALUES (5, TO_DATE('2006-02-28 13:58:32', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO date_sample VALUES (6, TO_DATE('2006-03-01 09:02:25', 'YYYY-MM-DD HH24:MI:SS'));
 
-- INSERT INTO departments
INSERT INTO departments (department_number,department_name) VALUES
(1,'Accounting');
INSERT INTO departments (department_number,department_name) VALUES
(2,'Payroll');
INSERT INTO departments (department_number,department_name) VALUES
(3,'Operations');
INSERT INTO departments (department_number,department_name) VALUES
(4,'Personnel');
INSERT INTO departments (department_number,department_name) VALUES
(5,'Maintenance');
 
-- INSERT INTO employees
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(1,'Smith','Cindy',2,null);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(2,'Jones','Elmer',4,1);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(3,'Simonian','Ralph',2,2);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(4,'Hernandez','Olivia',1,9);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(5,'Aaronsen','Robert',2,4);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(6,'Watson','Denise',6,8);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(7,'Hardy','Thomas',5,2);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(8,'O''Leary','Rhea',4,9);
INSERT INTO employees
(employee_id,last_name,first_name,department_number,manager_id) VALUES
(9,'Locario','Paulo',6,1);
 
-- INSERT INTO float_sample
INSERT INTO float_sample VALUES (1, 0.999999999999999);
INSERT INTO float_sample VALUES (2, 1);
INSERT INTO float_sample VALUES (3, 1.000000000000001);
INSERT INTO float_sample VALUES (4, 1234.56789012345);
INSERT INTO float_sample VALUES (5, 999.04440209348);
INSERT INTO float_sample VALUES (6, 24.04849);
 
 
-- INSERT INTO null_sample
INSERT INTO null_sample (invoice_id,invoice_total) VALUES (1,125);
INSERT INTO null_sample (invoice_id,invoice_total) VALUES (2,0);
INSERT INTO null_sample (invoice_id,invoice_total) VALUES (3,null);
INSERT INTO null_sample (invoice_id,invoice_total) VALUES (4,2199.99);
INSERT INTO null_sample (invoice_id,invoice_total) VALUES (5,0);
 
-- INSERT INTO paid_invoices
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(2,34,'Q545443',TO_DATE('14-MAR-20','DD-MON-RR'),1083.58,1083.58,0,4,TO_DATE('23-MAY-20','DD-MON-RR'),TO_DATE('14-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(4,110,'P-0259',TO_DATE('16-APR-20','DD-MON-RR'),26881.4,26881.4,0,3,TO_DATE('16-MAY-20','DD-MON-RR'),TO_DATE('12-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(5,81,'MABO1489',TO_DATE('16-APR-20','DD-MON-RR'),936.93,936.93,0,3,TO_DATE('16-MAY-20','DD-MON-RR'),TO_DATE('13-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(7,82,'C73-24',TO_DATE('17-APR-20','DD-MON-RR'),600,600,0,2,TO_DATE('10-MAY-20','DD-MON-RR'),TO_DATE('05-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(9,122,'989319-477',TO_DATE('19-APR-20','DD-MON-RR'),2184.11,2184.11,0,4,TO_DATE('12-JUN-20','DD-MON-RR'),TO_DATE('07-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(10,122,'989319-467',TO_DATE('24-APR-20','DD-MON-RR'),2318.03,2318.03,0,4,TO_DATE('05-JUN-20','DD-MON-RR'),TO_DATE('29-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(11,122,'989319-457',TO_DATE('24-APR-20','DD-MON-RR'),3813.33,3813.33,0,3,TO_DATE('29-MAY-20','DD-MON-RR'),TO_DATE('20-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(12,122,'989319-447',TO_DATE('24-APR-20','DD-MON-RR'),3689.99,3689.99,0,3,TO_DATE('22-MAY-20','DD-MON-RR'),TO_DATE('12-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(13,122,'989319-437',TO_DATE('24-APR-20','DD-MON-RR'),2765.36,2765.36,0,2,TO_DATE('15-MAY-20','DD-MON-RR'),TO_DATE('03-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(14,122,'989319-427',TO_DATE('25-APR-20','DD-MON-RR'),2115.81,2115.81,0,1,TO_DATE('08-MAY-20','DD-MON-RR'),TO_DATE('01-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(16,122,'989319-417',TO_DATE('26-APR-20','DD-MON-RR'),2051.59,2051.59,0,1,TO_DATE('01-MAY-20','DD-MON-RR'),TO_DATE('28-APR-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(17,90,'97-1024A',TO_DATE('26-APR-20','DD-MON-RR'),356.48,356.48,0,3,TO_DATE('09-JUN-20','DD-MON-RR'),TO_DATE('09-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(20,121,'97/503',TO_DATE('30-APR-20','DD-MON-RR'),639.77,639.77,0,4,TO_DATE('11-JUN-20','DD-MON-RR'),TO_DATE('05-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(21,121,'97/488',TO_DATE('30-APR-20','DD-MON-RR'),601.95,601.95,0,3,TO_DATE('03-JUN-20','DD-MON-RR'),TO_DATE('27-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(22,121,'97/486',TO_DATE('30-APR-20','DD-MON-RR'),953.1,953.1,0,2,TO_DATE('21-MAY-20','DD-MON-RR'),TO_DATE('13-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(23,121,'97/465',TO_DATE('01-MAY-20','DD-MON-RR'),565.15,565.15,0,1,TO_DATE('14-MAY-20','DD-MON-RR'),TO_DATE('05-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(24,121,'97/222',TO_DATE('01-MAY-20','DD-MON-RR'),1000.46,1000.46,0,3,TO_DATE('03-JUN-20','DD-MON-RR'),TO_DATE('25-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(25,123,'4-342-8069',TO_DATE('01-MAY-20','DD-MON-RR'),10,10,0,4,TO_DATE('10-JUN-20','DD-MON-RR'),TO_DATE('27-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(26,123,'4-327-7357',TO_DATE('01-MAY-20','DD-MON-RR'),162.75,162.75,0,3,TO_DATE('27-MAY-20','DD-MON-RR'),TO_DATE('21-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(27,123,'4-321-2596',TO_DATE('01-MAY-20','DD-MON-RR'),10,10,0,2,TO_DATE('20-MAY-20','DD-MON-RR'),TO_DATE('11-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(28,123,'7548906-20',TO_DATE('01-MAY-20','DD-MON-RR'),27,27,0,3,TO_DATE('06-JUN-20','DD-MON-RR'),TO_DATE('26-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(29,123,'4-314-3057',TO_DATE('02-MAY-20','DD-MON-RR'),13.75,13.75,0,1,TO_DATE('13-MAY-20','DD-MON-RR'),TO_DATE('07-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(31,123,'2-000-2993',TO_DATE('03-MAY-20','DD-MON-RR'),144.7,144.7,0,1,TO_DATE('06-MAY-20','DD-MON-RR'),TO_DATE('04-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(32,89,'125520-1',TO_DATE('05-MAY-20','DD-MON-RR'),95,95,0,3,TO_DATE('08-JUN-20','DD-MON-RR'),TO_DATE('22-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(33,123,'1-202-2978',TO_DATE('06-MAY-20','DD-MON-RR'),33,33,0,1,TO_DATE('20-MAY-20','DD-MON-RR'),TO_DATE('13-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(35,123,'1-200-5164',TO_DATE('07-MAY-20','DD-MON-RR'),63.4,63.4,0,1,TO_DATE('13-MAY-20','DD-MON-RR'),TO_DATE('10-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(36,110,'0-2060',TO_DATE('08-MAY-20','DD-MON-RR'),23517.58,21221.63,2295.95,3,TO_DATE('09-JUN-20','DD-MON-RR'),TO_DATE('10-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(37,110,'0-2058',TO_DATE('08-MAY-20','DD-MON-RR'),37966.19,37966.19,0,3,TO_DATE('09-JUN-20','DD-MON-RR'),TO_DATE('31-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(43,97,'21-4923721',TO_DATE('09-MAY-20','DD-MON-RR'),9.95,9.95,0,1,TO_DATE('21-MAY-20','DD-MON-RR'),TO_DATE('13-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(46,123,'963253261',TO_DATE('10-MAY-20','DD-MON-RR'),42.75,42.75,0,3,TO_DATE('16-JUN-20','DD-MON-RR'),TO_DATE('10-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(47,123,'963253260',TO_DATE('10-MAY-20','DD-MON-RR'),36,36,0,3,TO_DATE('15-JUN-20','DD-MON-RR'),TO_DATE('06-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(48,123,'963253258',TO_DATE('10-MAY-20','DD-MON-RR'),111,111,0,3,TO_DATE('11-JUN-20','DD-MON-RR'),TO_DATE('31-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(49,123,'963253256',TO_DATE('10-MAY-20','DD-MON-RR'),53.25,53.25,0,3,TO_DATE('10-JUN-20','DD-MON-RR'),TO_DATE('27-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(50,123,'963253255',TO_DATE('11-MAY-20','DD-MON-RR'),53.75,53.75,0,3,TO_DATE('09-JUN-20','DD-MON-RR'),TO_DATE('03-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(51,123,'963253254',TO_DATE('11-MAY-20','DD-MON-RR'),108.5,108.5,0,3,TO_DATE('08-JUN-20','DD-MON-RR'),TO_DATE('30-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(52,123,'963253252',TO_DATE('11-MAY-20','DD-MON-RR'),38.75,38.75,0,3,TO_DATE('07-JUN-20','DD-MON-RR'),TO_DATE('27-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(53,123,'963253251',TO_DATE('11-MAY-20','DD-MON-RR'),15.5,15.5,0,3,TO_DATE('04-JUN-20','DD-MON-RR'),TO_DATE('21-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(54,123,'963253249',TO_DATE('12-MAY-20','DD-MON-RR'),127.75,127.75,0,2,TO_DATE('03-JUN-20','DD-MON-RR'),TO_DATE('28-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(55,123,'963253248',TO_DATE('13-MAY-20','DD-MON-RR'),241,241,0,2,TO_DATE('02-JUN-20','DD-MON-RR'),TO_DATE('24-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(56,123,'963253246',TO_DATE('13-MAY-20','DD-MON-RR'),129,129,0,2,TO_DATE('31-MAY-20','DD-MON-RR'),TO_DATE('20-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(57,123,'963253245',TO_DATE('13-MAY-20','DD-MON-RR'),40.75,40.75,0,2,TO_DATE('28-MAY-20','DD-MON-RR'),TO_DATE('14-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(58,123,'963253244',TO_DATE('13-MAY-20','DD-MON-RR'),60,60,0,2,TO_DATE('27-MAY-20','DD-MON-RR'),TO_DATE('21-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(59,123,'963253242',TO_DATE('13-MAY-20','DD-MON-RR'),104,104,0,2,TO_DATE('26-MAY-20','DD-MON-RR'),TO_DATE('17-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(60,123,'963253240',TO_DATE('23-MAY-20','DD-MON-RR'),67,67,0,1,TO_DATE('03-JUN-20','DD-MON-RR'),TO_DATE('28-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(61,123,'963253239',TO_DATE('23-MAY-20','DD-MON-RR'),147.25,147.25,0,1,TO_DATE('02-JUN-20','DD-MON-RR'),TO_DATE('28-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(62,123,'963253237',TO_DATE('23-MAY-20','DD-MON-RR'),172.5,172.5,0,1,TO_DATE('30-MAY-20','DD-MON-RR'),TO_DATE('24-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(63,123,'963253235',TO_DATE('14-MAY-20','DD-MON-RR'),108.25,108.25,0,1,TO_DATE('20-MAY-20','DD-MON-RR'),TO_DATE('17-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(64,123,'963253234',TO_DATE('14-MAY-20','DD-MON-RR'),138.75,138.75,0,1,TO_DATE('19-MAY-20','DD-MON-RR'),TO_DATE('16-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(65,123,'963253232',TO_DATE('14-MAY-20','DD-MON-RR'),127.75,127.75,0,1,TO_DATE('18-MAY-20','DD-MON-RR'),TO_DATE('16-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(66,123,'963253230',TO_DATE('15-MAY-20','DD-MON-RR'),739.2,739.2,0,1,TO_DATE('17-MAY-20','DD-MON-RR'),TO_DATE('16-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(73,123,'263253257',TO_DATE('18-MAY-20','DD-MON-RR'),22.57,22.57,0,2,TO_DATE('10-JUN-20','DD-MON-RR'),TO_DATE('27-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(74,123,'263253253',TO_DATE('18-MAY-20','DD-MON-RR'),31.95,31.95,0,2,TO_DATE('07-JUN-20','DD-MON-RR'),TO_DATE('01-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(75,123,'263253250',TO_DATE('19-MAY-20','DD-MON-RR'),42.67,42.67,0,2,TO_DATE('03-JUN-20','DD-MON-RR'),TO_DATE('25-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(76,123,'263253243',TO_DATE('20-MAY-20','DD-MON-RR'),44.44,44.44,0,1,TO_DATE('26-MAY-20','DD-MON-RR'),TO_DATE('23-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(77,123,'263253241',TO_DATE('20-MAY-20','DD-MON-RR'),40.2,40.2,0,1,TO_DATE('25-MAY-20','DD-MON-RR'),TO_DATE('22-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(78,123,'94007069',TO_DATE('22-MAY-20','DD-MON-RR'),400,400,0,3,TO_DATE('01-JUL-20','DD-MON-RR'),TO_DATE('25-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(80,105,'94007005',TO_DATE('23-MAY-20','DD-MON-RR'),220,220,0,1,TO_DATE('30-MAY-20','DD-MON-RR'),TO_DATE('26-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(83,115,'24946731',TO_DATE('25-MAY-20','DD-MON-RR'),25.67,25.67,0,2,TO_DATE('14-JUN-20','DD-MON-RR'),TO_DATE('28-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(84,115,'24863706',TO_DATE('27-MAY-20','DD-MON-RR'),6,6,0,1,TO_DATE('07-JUN-20','DD-MON-RR'),TO_DATE('01-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(85,115,'24780512',TO_DATE('29-MAY-20','DD-MON-RR'),6,6,0,1,TO_DATE('31-MAY-20','DD-MON-RR'),TO_DATE('30-MAY-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(86,88,'972110',TO_DATE('30-MAY-20','DD-MON-RR'),207.78,207.78,0,1,TO_DATE('06-JUN-20','DD-MON-RR'),TO_DATE('02-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(87,100,'587056',TO_DATE('31-MAY-20','DD-MON-RR'),2184.5,2184.5,0,3,TO_DATE('28-JUN-20','DD-MON-RR'),TO_DATE('22-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(89,99,'509786',TO_DATE('31-MAY-20','DD-MON-RR'),6940.25,6940.25,0,2,TO_DATE('16-JUN-20','DD-MON-RR'),TO_DATE('08-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(90,108,'121897',TO_DATE('01-JUN-20','DD-MON-RR'),450,450,0,2,TO_DATE('19-JUN-20','DD-MON-RR'),TO_DATE('14-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(92,80,'133560',TO_DATE('01-JUN-20','DD-MON-RR'),175,175,0,2,TO_DATE('20-JUN-20','DD-MON-RR'),TO_DATE('03-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(93,104,'P02-3772',TO_DATE('03-JUN-20','DD-MON-RR'),7125.34,7125.34,0,2,TO_DATE('18-JUN-20','DD-MON-RR'),TO_DATE('08-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(95,107,'RTR-72-3662-X',TO_DATE('04-JUN-20','DD-MON-RR'),1600,1600,0,2,TO_DATE('18-JUN-20','DD-MON-RR'),TO_DATE('11-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(96,113,'77290',TO_DATE('04-JUN-20','DD-MON-RR'),1750,1750,0,2,TO_DATE('18-JUN-20','DD-MON-RR'),TO_DATE('08-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(97,119,'10843',TO_DATE('04-JUN-20','DD-MON-RR'),4901.26,4901.26,0,2,TO_DATE('18-JUN-20','DD-MON-RR'),TO_DATE('11-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(101,103,'75C-90227',TO_DATE('06-JUN-20','DD-MON-RR'),1367.5,1367.5,0,1,TO_DATE('13-JUN-20','DD-MON-RR'),TO_DATE('09-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(102,48,'P02-88D77S7',TO_DATE('06-JUN-20','DD-MON-RR'),856.92,856.92,0,1,TO_DATE('13-JUN-20','DD-MON-RR'),TO_DATE('09-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(104,114,'CBM9920-M-T77109',TO_DATE('07-JUN-20','DD-MON-RR'),290,290,0,1,TO_DATE('12-JUN-20','DD-MON-RR'),TO_DATE('09-JUN-20','DD-MON-RR'));
INSERT INTO paid_invoices
(invoice_id,vendor_id,invoice_number,invoice_date,invoice_total,payment_total,credit_total,terms_id,invoice_due_date,payment_date)
VALUES
(108,117,'111897',TO_DATE('11-JUN-20','DD-MON-RR'),16.62,16.62,0,1,TO_DATE('14-JUN-20','DD-MON-RR'),TO_DATE('12-JUN-20','DD-MON-RR'));
 
-- INSERTING into PROJECTS
INSERT INTO projects (project_number,employee_id) VALUES ('P1011',8);
INSERT INTO projects (project_number,employee_id) VALUES ('P1011',4);
INSERT INTO projects (project_number,employee_id) VALUES ('P1012',3);
INSERT INTO projects (project_number,employee_id) VALUES ('P1012',1);
INSERT INTO projects (project_number,employee_id) VALUES ('P1012',5);
INSERT INTO projects (project_number,employee_id) VALUES ('P1013',6);
INSERT INTO projects (project_number,employee_id) VALUES ('P1013',9);
INSERT INTO projects (project_number,employee_id) VALUES ('P1014',10);
 
-- INSERTING into STRING_SAMPLE
INSERT INTO string_sample VALUES ('1', 'Lizbeth Darien');
INSERT INTO string_sample VALUES ('2', 'Darnell O''Sullivan');
INSERT INTO string_sample VALUES ('17', 'Lance Pinos-Potter');
INSERT INTO string_sample VALUES ('20', 'Jean Paul Renard');
INSERT INTO string_sample VALUES ('3', 'Alisha von Strump');
 
COMMIT;
 






-------------------------------------------------------
---- drop and create OM tables
-------------------------------------------------------


SET DEFINE OFF;
 
-- Begin an anonymous PL/SQL script that
-- drops all tables in the EX schema and
-- suppresses the error messages that are displayed if the tables don't exist
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE order_details';
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/


BEGIN EXECUTE IMMEDIATE 'DROP TABLE orders'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE items'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CUSTOMERS_OM'; EXCEPTION WHEN OTHERS THEN NULL; END; 
/
  




 
CREATE TABLE CUSTOMERS_OM
(
  customer_id               NUMBER              NOT NULL,
  customer_first_name   VARCHAR2(50),
  customer_last_name    VARCHAR2(50)        NOT NULL,
  customer_address      VARCHAR2(255)   NOT NULL,
  customer_city             VARCHAR2(50)        NOT NULL,
  customer_state            CHAR(2)             NOT NULL,
  customer_zip              VARCHAR2(20)        NOT NULL,
  customer_phone        VARCHAR2(30)        NOT NULL,
  customer_fax              VARCHAR2(30),
  CONSTRAINT CUSTOMERS_OM_pk
        PRIMARY KEY (customer_id)
);
 
CREATE TABLE items
(
  item_id           NUMBER                       NOT NULL,
  title             VARCHAR2(50)                 NOT NULL,
  artist            VARCHAR2(50)                NOT NULL,
  unit_price        NUMBER                                          NOT NULL,
  CONSTRAINT items_pk
        PRIMARY KEY (item_id),
  CONSTRAINT title_artist_unq
        UNIQUE (title, artist)
);
 
CREATE TABLE orders
(
  order_id              NUMBER          NOT NULL,
  customer_id           NUMBER          NOT NULL,
  order_date            DATE            NOT NULL,
  shipped_date          DATE,
  CONSTRAINT orders_pk
    PRIMARY KEY (order_id),
  CONSTRAINT orders_fk_CUSTOMERS_OM
        FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_OM (customer_id)
);
 
CREATE TABLE order_details
(
  order_id          NUMBER            NOT NULL,
  item_id           NUMBER            NOT NULL,
  order_qty         NUMBER            NOT NULL,
  CONSTRAINT order_details_pk
        PRIMARY KEY (order_id, item_id),
  CONSTRAINT order_details_fk_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
  CONSTRAINT order_details_fk_items
        FOREIGN KEY (item_id)
        REFERENCES items (item_id)
);
 
-- INSERT INTO CUSTOMERS_OM
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (1,'Korah','Blanca','1555 W Lane Ave','Columbus','OH','43221','6145554435','6145553928');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (2,'Yash','Randall','11 E Rancho Madera Rd','Madison','WI','53707','2095551205','2095552262');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (3,'Johnathon','Millerton','60 Madison Ave','New York','NY','10010','2125554800',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (4,'Mikayla','Damion','2021 K Street Nw','Washington','DC','20006','2025555561',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (5,'Kendall','Mayte','4775 E Miami River Rd','Cleves','OH','45002','5135553043',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (6,'Kaitlin','Hostlery','3250 Spring Grove Ave','Cincinnati','OH','45225','8005551957','8005552826');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (7,'Derek','Chaddick','9022 E Merchant Wy','Fairfield','IA','52556','5155556130',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (8,'Deborah','Damien','415 E Olive Ave','Fresno','CA','93728','5595558060',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (9,'Karina','Lacy','882 W Easton Wy','Los Angeles','CA','90084','8005557000',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (10,'Kurt','Nickalus','28210 N Avenue Stanford','Valencia','CA','91355','8055550584','8055556689');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (11,'Kelsey','Eulalia','7833 N Ridge Rd','Sacramento','CA','95887','2095557500','2095551302');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (12,'Anders','Rohansen','12345 E 67th Ave NW','Takoma Park','MD','24512','3385556772',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (13,'Thalia','Neftaly','2508 W Shaw Ave','Fresno','CA','93711','5595556245',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (14,'Gonzalo','Keeton','12 Daniel Road','Fairfield','NJ','07004','2015559742',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (15,'Ania','Irvin','1099 N Farcourt St','Orange','CA','92807','7145559000',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (16,'Dakota','Baylee','1033 N Sycamore Ave.','Los Angeles','CA','90038','2135554322',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (17,'Samuel','Jacobsen','3433 E Widget Ave','Palo Alto','CA','92711','4155553434',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (18,'Justin','Javen','828 S Broadway','Tarrytown','NY','10591','8005550037',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (19,'Kyle','Marissa','789 E Mercy Ave','Phoenix','AZ','85038','9475553900',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (20,'Erick','Kaleigh','Five Lakepointe Plaza, Ste 500','Charlotte','NC','28217','7045553500',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (21,'Marvin','Quintin','2677 Industrial Circle Dr','Columbus','OH','43260','6145558600','6145557580');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (22,'Rashad','Holbrooke','3467 W Shaw Ave #103','Fresno','CA','93711','5595558625','5595558495');
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (23,'Trisha','Anum','627 Aviation Way','Manhatttan Beach','CA','90266','3105552732',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (24,'Julian','Carson','372 San Quentin','San Francisco','CA','94161','6175550700',NULL);
INSERT INTO CUSTOMERS_OM
(customer_id,customer_first_name,customer_last_name,customer_address,customer_city,customer_state,customer_zip,customer_phone,customer_fax)
VALUES (25,'Kirsten','Story','2401 Wisconsin Ave NW','Washington','DC','20559','2065559115',NULL);
 
-- INSERT INTO items
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(1,'Umami In Concert','Umami',17.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(2,'Race Car Sounds','The Ubernerds',13);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(3,'No Rest For The Weary','No Rest For The Weary',16.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(4,'More Songs About Structures and Comestibles','No Rest For The Weary',17.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(5,'On The Road With Burt Ruggles','Burt Ruggles',17.5);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(6,'No Fixed Address','Sewed the Vest Pocket',16.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(7,'Rude Noises','Jess & Odie',13);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(8,'Burt Ruggles: An Intimate Portrait','Burt Ruggles',17.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(9,'Zone Out With Umami','Umami',16.95);
INSERT INTO items (item_id,title,artist,unit_price) VALUES
(10,'Etcetera','Onn & Onn',17);
 
-- INSERT INTO orders
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(19,1,TO_DATE('23-OCT-18','DD-MON-RR'),TO_DATE('28-OCT-18','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(29,8,TO_DATE('05-NOV-18','DD-MON-RR'),TO_DATE('11-NOV-18','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(32,11,TO_DATE('10-NOV-18','DD-MON-RR'),TO_DATE('13-NOV-18','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(45,2,TO_DATE('25-NOV-18','DD-MON-RR'),TO_DATE('30-NOV-18','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(70,10,TO_DATE('28-DEC-18','DD-MON-RR'),TO_DATE('07-JAN-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(89,22,TO_DATE('20-JAN-19','DD-MON-RR'),TO_DATE('22-JAN-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(97,20,TO_DATE('29-JAN-19','DD-MON-RR'),TO_DATE('02-FEB-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(118,3,TO_DATE('24-FEB-19','DD-MON-RR'),TO_DATE('28-FEB-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(144,17,TO_DATE('21-MAR-19','DD-MON-RR'),TO_DATE('29-MAR-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(158,9,TO_DATE('04-APR-19','DD-MON-RR'),TO_DATE('20-APR-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(165,14,TO_DATE('11-APR-19','DD-MON-RR'),TO_DATE('13-APR-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(180,24,TO_DATE('25-APR-19','DD-MON-RR'),TO_DATE('30-MAY-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(231,15,TO_DATE('14-JUN-19','DD-MON-RR'),TO_DATE('22-JUN-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(242,23,TO_DATE('24-JUN-19','DD-MON-RR'),TO_DATE('06-JUL-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(264,9,TO_DATE('15-JUL-19','DD-MON-RR'),TO_DATE('18-JUL-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(298,18,TO_DATE('18-AUG-19','DD-MON-RR'),TO_DATE('22-SEP-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(321,2,TO_DATE('09-SEP-19','DD-MON-RR'),TO_DATE('05-OCT-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(381,7,TO_DATE('08-NOV-19','DD-MON-RR'),TO_DATE('16-NOV-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(392,19,TO_DATE('16-NOV-19','DD-MON-RR'),TO_DATE('23-NOV-19','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(413,17,TO_DATE('05-DEC-19','DD-MON-RR'),TO_DATE('11-JAN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(442,5,TO_DATE('28-DEC-19','DD-MON-RR'),TO_DATE('03-JAN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(479,1,TO_DATE('30-JAN-20','DD-MON-RR'),TO_DATE('03-MAR-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(491,16,TO_DATE('08-FEB-20','DD-MON-RR'),TO_DATE('14-FEB-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(494,4,TO_DATE('10-FEB-20','DD-MON-RR'),TO_DATE('14-FEB-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(523,3,TO_DATE('07-MAR-20','DD-MON-RR'),TO_DATE('15-MAR-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(548,2,TO_DATE('22-MAR-20','DD-MON-RR'),TO_DATE('18-APR-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(550,17,TO_DATE('23-MAR-20','DD-MON-RR'),TO_DATE('03-APR-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(601,16,TO_DATE('21-APR-20','DD-MON-RR'),TO_DATE('27-APR-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(606,6,TO_DATE('25-APR-20','DD-MON-RR'),TO_DATE('02-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(607,20,TO_DATE('25-APR-20','DD-MON-RR'),TO_DATE('04-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(624,2,TO_DATE('04-MAY-20','DD-MON-RR'),TO_DATE('09-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(627,17,TO_DATE('05-MAY-20','DD-MON-RR'),TO_DATE('10-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(630,20,TO_DATE('08-MAY-20','DD-MON-RR'),TO_DATE('18-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(631,21,TO_DATE('09-MAY-20','DD-MON-RR'),TO_DATE('11-MAY-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(651,12,TO_DATE('19-MAY-20','DD-MON-RR'),TO_DATE('02-JUN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(658,12,TO_DATE('23-MAY-20','DD-MON-RR'),TO_DATE('02-JUN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(687,17,TO_DATE('05-JUN-20','DD-MON-RR'),TO_DATE('08-JUN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(693,9,TO_DATE('07-JUN-20','DD-MON-RR'),TO_DATE('19-JUN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(703,19,TO_DATE('12-JUN-20','DD-MON-RR'),TO_DATE('19-JUN-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(773,25,TO_DATE('11-JUL-20','DD-MON-RR'),TO_DATE('13-JUL-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(778,13,TO_DATE('12-JUL-20','DD-MON-RR'),TO_DATE('21-JUL-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(796,17,TO_DATE('19-JUL-20','DD-MON-RR'),TO_DATE('26-JUL-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(800,19,TO_DATE('21-JUL-20','DD-MON-RR'),TO_DATE('28-JUL-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(802,2,TO_DATE('21-JUL-20','DD-MON-RR'),TO_DATE('31-JUL-20','DD-MON-RR'));
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(824,1,TO_DATE('01-AUG-20','DD-MON-RR'),null);
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(827,18,TO_DATE('02-AUG-20','DD-MON-RR'),null);
INSERT INTO orders (order_id,customer_id,order_date,shipped_date) VALUES
(829,9,TO_DATE('02-AUG-20','DD-MON-RR'),null);
 
-- INSERTING into ORDER_DETAILS
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (381,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (601,9,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (442,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (523,9,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (630,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (778,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (693,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (118,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (264,7,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (607,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (624,7,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (658,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (800,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (158,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (321,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (687,6,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (827,6,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (144,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (264,8,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (479,1,2);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (630,6,2);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (796,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (97,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (601,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (773,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (800,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (29,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (70,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (97,8,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (165,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (180,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (231,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (392,8,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (413,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (491,6,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (494,2,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (606,8,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (607,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (651,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (703,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (796,2,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (802,2,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (802,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (824,7,2);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (829,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (550,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (796,7,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (829,2,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (693,6,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (29,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (32,7,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (242,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (298,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (479,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (548,9,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (627,9,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (778,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (687,8,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (19,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (89,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (242,6,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (264,4,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (550,1,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (631,10,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (693,7,3);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (824,3,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (829,5,1);
INSERT INTO order_details (order_id,item_id,order_qty) VALUES (829,9,1);
 
COMMIT;
 






 
------------------------------------------------------------
---- drop and create MGS tables 
------------------------------------------------------------


SET DEFINE OFF;
 
-- Use an anonymous PL/SQL script to
-- drop all tables and sequences in the current schema and
-- suppress any error messages that may displayed
-- if these objects don't exist
----drop MGS schema
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE category_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE order_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE customer_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE product_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE address_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE item_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE admin_id_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE administrators'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE order_items'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE orders_mgs'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE products'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE categories'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE addresses'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE customers_mgs'; EXCEPTION WHEN OTHERS THEN NULL; END;
/




 
-- Create the tables
CREATE TABLE categories (
  category_id            NUMBER             PRIMARY KEY,
  category_name      VARCHAR2(255)  NOT NULL          UNIQUE
);
 
CREATE TABLE products (
  product_id             NUMBER             PRIMARY KEY,
  category_id            NUMBER             REFERENCES categories (category_id),
  product_code           VARCHAR2(10)   NOT NULL      UNIQUE,
  product_name           VARCHAR2(255)  NOT NULL,
  description            VARCHAR2(1500) NOT NULL,
  list_price             NUMBER(10,2)   NOT NULL,
  discount_percent   NUMBER(10,2)                 DEFAULT 0.00,
  date_added             DATE                             DEFAULT NULL        
);
 
CREATE TABLE CUSTOMERS_mgs (
  customer_id               NUMBER              PRIMARY KEY,
  email_address             VARCHAR2(255)   NOT NULL      UNIQUE,
  password                  VARCHAR2(60)        NOT NULL,
  first_name                VARCHAR2(60)        NOT NULL,
  last_name                 VARCHAR2(60)        NOT NULL,
  shipping_address_id   NUMBER                            DEFAULT NULL,
  billing_address_id        NUMBER                            DEFAULT NULL
);
 
CREATE TABLE addresses (
  address_id             NUMBER              PRIMARY KEY,
  customer_id            NUMBER              REFERENCES CUSTOMERS_mgs (customer_id),
  line1                  VARCHAR2(60)    NOT NULL,
  line2                  VARCHAR2(60)                         DEFAULT NULL,
  city                   VARCHAR2(40)        NOT NULL,
  state                  VARCHAR2(2)         NOT NULL,
  zip_code               VARCHAR2(10)        NOT NULL,
  phone                  VARCHAR2(12)        NOT NULL,
  disabled               NUMBER(1)                            DEFAULT 0
);
 
CREATE TABLE orders_mgs (
  order_id               NUMBER             PRIMARY KEY,
  customer_id            NUMBER             REFERENCES CUSTOMERS_mgs (customer_id),
  order_date             DATE               NOT NULL,
  ship_amount            NUMBER(10,2)   NOT NULL,
  tax_amount             NUMBER(10,2)   NOT NULL,
  ship_date              DATE                            DEFAULT NULL,
  ship_address_id        NUMBER             NOT NULL,
  card_type              VARCHAR2(50)   NOT NULL,
  card_number            CHAR(16)           NOT NULL,
  card_expires           CHAR(7)            NOT NULL,
  billing_address_id NUMBER         NOT NULL
);
 
CREATE TABLE order_items (
  item_id                NUMBER             PRIMARY KEY,
  order_id               NUMBER             REFERENCES orders_mgs (order_id),
  product_id             NUMBER             REFERENCES products (product_id),
  item_price             NUMBER(10,2)   NOT NULL,
  discount_amount    NUMBER(10,2)   NOT NULL,
  quantity               NUMBER             NOT NULL
);
 
CREATE TABLE administrators (
  admin_id               NUMBER              PRIMARY KEY,
  email_address      VARCHAR2(255)   NOT NULL,
  password               VARCHAR2(255)   NOT NULL,
  first_name             VARCHAR2(255)   NOT NULL,
  last_name              VARCHAR2(255)   NOT NULL
);
 
-- Disable substitution variable prompting
SET DEFINE OFF;
 
 
-- Insert data into the tables
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Guitars');
INSERT INTO categories (category_id, category_name) VALUES
(2, 'Basses');
INSERT INTO categories (category_id, category_name) VALUES
(3, 'Drums');
INSERT INTO categories (category_id, category_name) VALUES
(4, 'Keyboards');
 
CREATE SEQUENCE category_id_seq
  START WITH 5;
 
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(1, 1, 'strat', 'Fender Stratocaster', 'The Fender Stratocaster is the electric guitar design that changed the world. New features include a tinted neck, parchment pickguard and control knobs, and a ''70s-style logo. Includes select alder body, 21-fret maple neck with your choice of a rosewood or maple fretboard, 3 single-coil pickups, vintage-style tremolo, and die-cast tuning keys. This guitar features a thicker bridge block for increased sustain and a more stable point of contact with the strings. At this low price, why play anything but the real thing?\r\n\r\nFeatures:\r\n\r\n* New features:\r\n* Thicker bridge block\r\n* 3-ply parchment pick guard\r\n* Tinted neck', '699.00', '30.00', TO_DATE('2011-10-30 09:32:40', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(2, 1, 'les_paul', 'Gibson Les Paul', 'This Les Paul guitar offers a carved top and humbucking pickups. It has a simple yet elegant design. Cutting-yet-rich tone?the hallmark of the Les Paul?pours out of the 490R and 498T Alnico II magnet humbucker pickups, which are mounted on a carved maple top with a mahogany back. The faded finish models are equipped with BurstBucker Pro pickups and a mahogany top. This guitar includes a Gibson hardshell case (Faded and satin finish models come with a gig bag) and a limited lifetime warranty.\r\n\r\nFeatures:\r\n\r\n* Carved maple top and mahogany back (Mahogany top on faded finish models)\r\n* Mahogany neck, ''59 Rounded Les Paul\r\n* Rosewood fingerboard (Ebony on Alpine white)\r\n* Tune-O-Matic bridge with stopbar\r\n* Chrome or gold hardware\r\n* 490R and 498T Alnico 2 magnet humbucker pickups (BurstBucker Pro on faded finish models)\r\n* 2 volume and 2 tone knobs, 3-way switch', '1199.00', '30.00', TO_DATE('2011-12-05 16:33:13', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(3, 1, 'sg', 'Gibson SG', 'This Gibson SG electric guitar takes the best of the ''62 original and adds the longer and sturdier neck joint of the late ''60s models. All the classic features you''d expect from a historic guitar. Hot humbuckers go from rich, sweet lightning to warm, tingling waves of sustain. A silky-fast rosewood fretboard plays like a dream. The original-style beveled mahogany body looks like a million bucks. Plus, Tune-O-Matic bridge and chrome hardware. Limited lifetime warranty. Includes hardshell case.\r\n\r\nFeatures:\r\n\r\n* Double-cutaway beveled mahogany body\r\n* Set mahogany neck with rounded ''50s profile\r\n* Bound rosewood fingerboard with trapezoid inlays\r\n* Tune-O-Matic bridge with stopbar tailpiece\r\n* Chrome hardware\r\n* 490R humbucker in the neck position\r\n* 498T humbucker in the bridge position\r\n* 2 volume knobs, 2 tone knobs, 3-way switch\r\n* 24-3/4" scale', '2517.00', '52.00', TO_DATE('2012-02-04 11:04:31', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(4, 1, 'fg700s', 'Yamaha FG700S', 'The Yamaha FG700S solid top acoustic guitar has the ultimate combo for projection and pure tone. The expertly braced spruce top speaks clearly atop the rosewood body. It has a rosewood fingerboard, rosewood bridge, die-cast tuners, body and neck binding, and a tortoise pickguard.\r\n\r\nFeatures:\r\n\r\n* Solid Sitka spruce top\r\n* Rosewood back and sides\r\n* Rosewood fingerboard\r\n* Rosewood bridge\r\n* White/black body and neck binding\r\n* Die-cast tuners\r\n* Tortoise pickguard\r\n* Limited lifetime warranty', '489.99', '38.00', TO_DATE('2012-06-01 11:12:59', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(5, 1, 'washburn', 'Washburn D10S', 'The Washburn D10S acoustic guitar is superbly crafted with a solid spruce top and mahogany back and sides for exceptional tone. A mahogany neck and rosewood fingerboard make fretwork a breeze, while chrome Grover-style machines keep you perfectly tuned. The Washburn D10S comes with a limited lifetime warranty.\r\n\r\nFeatures:\r\n\r\n        * Spruce top\r\n        * Mahogany back, sides\r\n        * Mahogany neck Rosewood fingerboard\r\n        * Chrome Grover-style machines', '299.00', '0.00', TO_DATE('2012-07-30 13:58:35', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(6, 1, 'rodriguez', 'Rodriguez Caballero 11', 'Featuring a carefully chosen, solid Canadian cedar top and laminated bubinga back and sides, the Caballero 11 classical guitar is a beauty to behold and play. The headstock and fretboard are of Indian rosewood. Nickel-plated tuners and Silver-plated frets are installed to last a lifetime. The body binding and wood rosette are exquisite.\r\n\r\nThe Rodriguez Guitar is hand crafted and glued to create precise balances. From the invisible careful sanding, even inside the body, that ensures the finished instrument''s purity of tone, to the beautifully unique rosette inlays around the soundhole and on the back of the neck, each guitar is a credit to its luthier and worthy of being handed down from one generation to another.\r\n\r\nThe tone, resonance and beauty of fine guitars are all dependent upon the wood from which they are made. The wood used in the construction of Rodriguez guitars is carefully chosen and aged to guarantee the highest quality. No wood is purchased before the tree has been cut down, and at least 2 years must elapse before the tree is turned into lumber. The wood has to be well cut from the log. The grain must be close and absolutely vertical. The shop is totally free from humidity.', '415.00', '39.00', TO_DATE('2012-07-30 14:12:41', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(7, 2, 'precision', 'Fender Precision', 'The Fender Precision bass guitar delivers the sound, look, and feel today''s bass players demand. This bass features that classic P-Bass old-school design. Each Precision bass boasts contemporary features and refinements that make it an excellent value. Featuring an alder body and a split single-coil pickup, this classic electric bass guitar lives up to its Fender legacy.\r\n\r\nFeatures:\r\n\r\n* Body: Alder\r\n* Neck: Maple, modern C shape, tinted satin urethane finish\r\n* Fingerboard: Rosewood or maple (depending on color)\r\n* 9-1/2" Radius (241 mm)\r\n* Frets: 20 Medium-jumbo frets\r\n* Pickups: 1 Standard Precision Bass split single-coil pickup (Mid)\r\n* Controls: Volume, Tone\r\n* Bridge: Standard vintage style with single groove saddles\r\n* Machine heads: Standard\r\n* Hardware: Chrome\r\n* Pickguard: 3-Ply Parchment\r\n* Scale Length: 34" (864 mm)\r\n* Width at Nut: 1-5/8" (41.3 mm)\r\n* Unique features: Knurled chrome P Bass knobs, Fender transition logo', '799.99', '30.00', TO_DATE('2012-06-01 11:29:35', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(8, 2, 'hofner', 'Hofner Icon', 'With authentic details inspired by the original, the Hofner Icon makes the legendary violin bass available to the rest of us. Don''t get the idea that this a just a "nowhere man" look-alike. This quality instrument features a real spruce top and beautiful flamed maple back and sides. The semi-hollow body and set neck will give you the warm, round tone you expect from the violin bass.\r\n\r\nFeatures:\r\n\r\n* Authentic details inspired by the original\r\n* Spruce top\r\n* Flamed maple back and sides\r\n* Set neck\r\n* Rosewood fretboard\r\n* 30" scale\r\n* 22 frets\r\n* Dot inlay', '499.99', '25.00', TO_DATE('2012-07-30 14:18:33', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(9, 3, 'ludwig', 'Ludwig 5-piece Drum Set with Cymbals', 'This product includes a Ludwig 5-piece drum set and a Zildjian starter cymbal pack.\r\n\r\nWith the Ludwig drum set, you get famous Ludwig quality. This set features a bass drum, two toms, a floor tom, and a snare?each with a wrapped finish. Drum hardware includes LA214FP bass pedal, snare stand, cymbal stand, hi-hat stand, and a throne.\r\n\r\nWith the Zildjian cymbal pack, you get a 14" crash, 18" crash/ride, and a pair of 13" hi-hats. Sound grooves and round hammer strikes in a simple circular pattern on the top surface of these cymbals magnify the basic sound of the distinctive alloy.\r\n\r\nFeatures:\r\n\r\n* Famous Ludwig quality\r\n* Wrapped finishes\r\n* 22" x 16" kick drum\r\n* 12" x 10" and 13" x 11" toms\r\n* 16" x 16" floor tom\r\n* 14" x 6-1/2" snare drum kick pedal\r\n* Snare stand\r\n* Straight cymbal stand hi-hat stand\r\n* FREE throne', '699.99', '30.00', TO_DATE('2012-07-30 12:46:40', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added) VALUES
(10, 3, 'tama', 'Tama 5-Piece Drum Set with Cymbals', 'The Tama 5-piece Drum Set is the most affordable Tama drum kit ever to incorporate so many high-end features.\r\n\r\nWith over 40 years of experience, Tama knows what drummers really want. Which is why, no matter how long you''ve been playing the drums, no matter what budget you have to work with, Tama has the set you need, want, and can afford. Every aspect of the modern drum kit was exhaustively examined and reexamined and then improved before it was accepted as part of the Tama design. Which is why, if you start playing Tama now as a beginner, you''ll still enjoy playing it when you''ve achieved pro-status. That''s how good these groundbreaking new drums are.\r\n\r\nOnly Tama comes with a complete set of genuine Meinl HCS cymbals. These high-quality brass cymbals are made in Germany and are sonically matched so they sound great together. They are even lathed for a more refined tonal character. The set includes 14" hi-hats, 16" crash cymbal, and a 20" ride cymbal.\r\n\r\nFeatures:\r\n\r\n* 100% poplar 6-ply/7.5mm shells\r\n* Precise bearing edges\r\n* 100% glued finishes\r\n* Original small lugs\r\n* Drum heads\r\n* Accu-tune bass drum hoops\r\n* Spur brackets\r\n* Tom holder\r\n* Tom brackets', '799.99', '15.00', TO_DATE('2012-07-30 13:14:15', 'YYYY-MM-DD HH24:MI:SS'));
 
CREATE SEQUENCE product_id_seq
  START WITH 11;
 
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(1, 'allan.sherwood@yahoo.com', '650215acec746f0e32bdfff387439eefc1358737', 'Allan', 'Sherwood', 1, 2);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(2, 'barryz@gmail.com', '3f563468d42a448cb1e56924529f6e7bbe529cc7', 'Barry', 'Zimmer', 3, 3);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(3, 'christineb@solarone.com', 'ed19f5c0833094026a2f1e9e6f08a35d26037066', 'Christine', 'Brown', 4, 4);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(4, 'david.goldstein@hotmail.com', 'b444ac06613fc8d63795be9ad0beaf55011936ac', 'David', 'Goldstein', 5, 6);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(5, 'erinv@gmail.com', '109f4b3c50d7b0df729d299bc6f8e9ef9066971f', 'Erin', 'Valentino', 7, 7);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(6, 'frankwilson@sbcglobal.net', '3ebfa301dc59196f18593c45e519287a23297589', 'Frank Lee', 'Wilson', 8, 8);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(7, 'gary_hernandez@yahoo.com', '1ff2b3704aede04eecb51e50ca698efd50a1379b', 'Gary', 'Hernandez', 9, 10);
INSERT INTO CUSTOMERS_mgs (customer_id, email_address, password, first_name, last_name, shipping_address_id, billing_address_id) VALUES
(8, 'heatheresway@mac.com', '911ddc3b8f9a13b5499b6bc4638a2b4f3f68bf23', 'Heather', 'Esway', 11, 12);
 
CREATE SEQUENCE customer_id_seq
  START WITH 9;
 
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(1, 1, '100 East Ridgewood Ave.', '', 'Paramus', 'NJ', '07652', '201-653-4472', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(2, 1, '21 Rosewood Rd.', '', 'Woodcliff Lake', 'NJ', '07677', '201-653-4472', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(3, 2, '16285 Wendell St.', '', 'Omaha', 'NE', '68135', '402-896-2576', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(4, 3, '19270 NW Cornell Rd.', '', 'Beaverton', 'OR', '97006', '503-654-1291', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(5, 4, '186 Vermont St.', 'Apt. 2', 'San Francisco', 'CA', '94110', '415-292-6651', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(6, 4, '1374 46th Ave.', '', 'San Francisco', 'CA', '94129', '415-292-6651', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(7, 5, '6982 Palm Ave.', '', 'Fresno', 'CA', '93711', '559-431-2398', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(8, 6, '23 Mountain View St.', '', 'Denver', 'CO', '80208', '303-912-3852', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(9, 7, '7361 N. 41st St.', 'Apt. B', 'New York', 'NY', '10012', '212-335-2093', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(10, 7, '3829 Broadway Ave.', 'Suite 2', 'New York', 'NY', '10012', '212-335-2093', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(11, 8, '2381 Buena Vista St.', '', 'Los Angeles', 'CA', '90023', '213-772-5033', 0);
INSERT INTO addresses (address_id, customer_id, line1, line2, city, state, zip_code, phone, disabled) VALUES
(12, 8, '291 W. Hollywood Blvd.', '', 'Los Angeles', 'CA', '90024', '213-772-5033', 0);
 
CREATE SEQUENCE address_id_seq
  START WITH 13;
 
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(1, 1, TO_DATE('2012-03-28 09:40:28', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '32.32', TO_DATE('2012-03-30 15:32:51', 'YYYY-MM-DD HH24:MI:SS'), 1, 'Visa', '4111111111111111', '04/2014', 2);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(2, 2, TO_DATE('2012-03-28 11:23:20', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', TO_DATE('2012-03-29 12:52:14', 'YYYY-MM-DD HH24:MI:SS'), 3, 'Visa', '4012888888881881', '08/2016', 3);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(3, 1, TO_DATE('2012-03-29 09:44:58', 'YYYY-MM-DD HH24:MI:SS'), '10.00', '89.92', TO_DATE('2012-03-31 9:11:41', 'YYYY-MM-DD HH24:MI:SS'), 1, 'Visa', '4111111111111111', '04/2014', 2);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(4, 3, TO_DATE('2012-03-30 15:22:31', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', TO_DATE('2012-04-03 16:32:21', 'YYYY-MM-DD HH24:MI:SS'), 4, 'American Express', '378282246310005', '04/2013', 4);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(5, 4, TO_DATE('2012-03-31 05:43:11', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', TO_DATE('2012-04-02 14:21:12', 'YYYY-MM-DD HH24:MI:SS'), 5, 'Visa', '4111111111111111', '04/2016', 6);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(6, 5, TO_DATE('2012-03-31 18:37:22', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', NULL, 7, 'Discover', '6011111111111117', '04/2016', 7);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(7, 6, TO_DATE('2012-04-01 23:11:12', 'YYYY-MM-DD HH24:MI:SS'), '15.00', '0.00', TO_DATE('2012-04-03 10:21:35', 'YYYY-MM-DD HH24:MI:SS'), 8, 'MasterCard', '5555555555554444', '04/2016', 8);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(8, 7, TO_DATE('2012-04-02 11:26:38', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', NULL, 9, 'Visa', '4012888888881881', '04/2016', 10);
INSERT INTO orders_mgs (order_id, customer_id, order_date, ship_amount, tax_amount, ship_date, ship_address_id, card_type, card_number, card_expires, billing_address_id) VALUES
(9, 4, TO_DATE('2012-04-03 12:22:31', 'YYYY-MM-DD HH24:MI:SS'), '5.00', '0.00', NULL, 5, 'Visa', '4111111111111111', '04/2016', 6);
 
CREATE SEQUENCE order_id_seq
  START WITH 10;
 
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(1, 1, 2, '1199.00', '359.70', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(2, 2, 4, '489.99', '186.20', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(3, 3, 3, '2517.00', '1308.84', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(4, 3, 6, '415.00', '161.85', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(5, 4, 2, '1199.00', '359.70', 2);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(6, 5, 5, '299.00', '0.00', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(7, 6, 5, '299.00', '0.00', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(8, 7, 1, '699.00', '209.70', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(9, 7, 7, '799.99', '240.00', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(10, 7, 9, '699.99', '210.00', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(11, 8, 10, '799.99', '120.00', 1);
INSERT INTO order_items (item_id, order_id, product_id, item_price, discount_amount, quantity) VALUES
(12, 9, 1, '699.00', '209.70', 1);
 
CREATE SEQUENCE item_id_seq
  START WITH 13;
 
INSERT INTO administrators (admin_id, email_address, password, first_name, last_name) VALUES
(1, 'admin@myguitarshop.com', '6a718fbd768c2378b511f8249b54897f940e9022', 'Admin', 'User');
INSERT INTO administrators (admin_id, email_address, password, first_name, last_name) VALUES
(2, 'joel@murach.com', '971e95957d3b74d70d79c20c94e9cd91b85f7aae', 'Joel', 'Murach');
INSERT INTO administrators (admin_id, email_address, password, first_name, last_name) VALUES
(3, 'mike@murach.com', '3f2975c819cefc686282456aeae3a137bf896ee8', 'Mike', 'Murach');
 
CREATE SEQUENCE admin_id_seq
  START WITH 13;
 
COMMIT;
 














---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----AS NEED PUT DROP STATEMENTS HERE TO REMOVE TABLES NOT NEEDED DEPENDING ON THE DAY’S PRACTICE
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----DROP HOMEWORK TABLES if not needed today


--drops for tables and sequences
drop table location_features_linking;
drop table reservation_details;
drop table features;
drop table reservation;
drop table room;
drop table customer_payment;
drop table customer;
drop table location;


drop sequence customer_id_seq;
drop sequence payment_id_seq;
drop sequence feature_id_seq;
drop sequence location_id_seq;
drop sequence reservation_id_seq;
drop sequence room_id_seq;






----Uncomment if not needed - Drops extra  MURACH TABLES not used for in class practice
DROP TABLE NULL_SAMPLE;
DROP TABLE FLOAT_SAMPLE;
--DROP TABLE DATE_SAMPLE;
DROP TABLE COLOR_SAMPLE;
DROP TABLE string_sample;


DROP TABLE departments;
DROP TABLE projects; 
DROP TABLE employees;




DROP TABLE INVOICE_ARCHIVE;
DROP TABLE PAID_INVOICES;
DROP TABLE ACTIVE_INVOICES;


DROP TABLE ORDER_ITEMS;
DROP TABLE ADDRESSES;
DROP TABLE CUSTOMERS_MGS CASCADE CONSTRAINTS;
DROP TABLE orders_mgs cascade constraints;
--DROP TABLE PRODUCTS;
--drop table categories;
drop table administrators;
DROP TABLE customers_ex CASCADE CONSTRAINTS;
DROP TABLE customers_om CASCADE CONSTRAINTS;
drop table order_details;
drop table orders;






 
----Allows you to use user-defined variables
--SET DEFINE ON;