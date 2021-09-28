---------------------------------------------------------
-- How to create a table
---------------------------------------------------------

CREATE TABLE Vendors
(
  vendor_id     NUMBER,
  vendor_name   VARCHAR2(50)
);

 
DROP TABLE Vendors;  -- if necessary
 
 
CREATE TABLE Vendors
(
  vendor_id     NUMBER          NOT NULL    UNIQUE,
  vendor_name   VARCHAR2(50)    NOT NULL    UNIQUE
);

 
CREATE TABLE Invoices
(
  invoice_id       NUMBER          NOT NULL    UNIQUE,
  vendor_id        NUMBER          NOT NULL,
  invoice_number   VARCHAR2(50)    NOT NULL,
  invoice_date     DATE                        DEFAULT SYSDATE,
  invoice_total    NUMBER(9,2)     NOT NULL,
  payment_total    NUMBER(9,2)                 DEFAULT 0
);



---------------------------------------------------------
-- How to code a primary key
---------------------------------------------------------
DROP TABLE Vendors;  -- if necessary


CREATE TABLE Vendors
(
  vendor_id     NUMBER          PRIMARY KEY,
  vendor_name   VARCHAR2(50)    NOT NULL   UNIQUE
);


DROP TABLE Vendors;  -- if necessary

 
CREATE TABLE Vendors
(
  vendor_id     NUMBER          CONSTRAINT vendors_pk PRIMARY KEY,
  vendor_name   VARCHAR2(50)    CONSTRAINT vendor_name_nn NOT NULL
                                CONSTRAINT vendor_name_un UNIQUE
);
 
CREATE TABLE Vendors
(
  vendor_id     NUMBER          ,
  vendor_name   VARCHAR2(50)    NOT NULL,
  CONSTRAINT vendors_pk PRIMARY KEY (vendor_id),
  CONSTRAINT vendor_name_unq UNIQUE (vendor_name)
);

-- try composite primary key as two separate PKs below

CREATE TABLE Invoice_line_items
(
  invoice_id               NUMBER        NOT NULL,
  invoice_sequence         NUMBER        NOT NULL,
  line_item_description    VARCHAR2(100) NOT NULL,
  CONSTRAINT line_items_pk PRIMARY KEY (invoice_id, invoice_sequence)
);

DROP TABLE Invoice_line_items;

---------------------------------------------------------
-- How to code a foreign key constraint 
---------------------------------------------------------
 
DROP TABLE Invoices;
DROP TABLE Vendors;

CREATE TABLE Vendors
(
  vendor_id     NUMBER          PRIMARY KEY,
  vendor_name   VARCHAR2(50)    NOT NULL       UNIQUE
);

CREATE TABLE Invoices
(
  invoice_id       NUMBER          PRIMARY KEY,
  vendor_id        NUMBER          REFERENCES vendors (vendor_id),
  invoice_number   VARCHAR2(50)    NOT NULL    UNIQUE
);


CREATE TABLE Invoices
(
  invoice_id       NUMBER          NOT NULL,
  vendor_id        NUMBER          NOT NULL,
  invoice_number   VARCHAR2(50)    NOT NULL    UNIQUE,
  CONSTRAINT invoices_pk PRIMARY KEY (invoice_id),
  CONSTRAINT invoices_fk_vendors FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id)
    ON DELETE CASCADE
);

-- An INSERT statement that fails because a related row doesn't exist
INSERT INTO Invoices
VALUES (1, 1, '1');


---------------------------------------------------------
-- How to code a check constraint 
---------------------------------------------------------
 
 DROP TABLE Invoices;
 
 CREATE TABLE Invoices
 (
   invoice_id       NUMBER          PRIMARY KEY,
   invoice_total    NUMBER(9,2)     NOT NULL    CHECK (invoice_total >= 0),
   payment_total    NUMBER(9,2)     DEFAULT 0   CHECK (payment_total >= 0)
 );
 
  
 
 CREATE TABLE Invoices
 (
   invoice_id       NUMBER          PRIMARY KEY,
   invoice_total    NUMBER(9,2)     NOT NULL,
   payment_total    NUMBER(9,2)     DEFAULT 0, 
   CONSTRAINT invoices_ck CHECK (invoice_total >= 0 AND payment_total >= 0)
 );
 
 -- An INSERT statement that fails because of a check constraint
 INSERT INTO Invoices
VALUES (1, 99.99, -10);


---------------------------------------------------------
-- How to alter columns of a table
---------------------------------------------------------
DROP TABLE Invoices;
DROP TABLE Vendors;

CREATE TABLE Vendors
(
  vendor_id     NUMBER          PRIMARY KEY,
  vendor_name   VARCHAR2(50)    NOT NULL       UNIQUE
);

ALTER TABLE Vendors
ADD last_transaction_date DATE;

ALTER TABLE Vendors
DROP COLUMN last_transaction_date;

ALTER TABLE Vendors
MODIFY vendor_name VARCHAR2(100);

ALTER TABLE Vendors
MODIFY vendor_name CHAR(100);

ALTER TABLE Vendors
MODIFY vendor_name DEFAULT 'New Vendor';

INSERT INTO Vendors
VALUES (1, 'US Postal Service');

INSERT INTO Vendors (vendor_id)
VALUES (2);

-- ready for anohter error? Think why

ALTER TABLE Vendors
MODIFY vendor_name CHAR(10);

-- UPDATE Vendors SET vendor_name=substr(vendor_name,1,5) WHERE LENGTH(vendor_name) > 5;



---------------------------------------------------------
-- How to alter constraints of a table
---------------------------------------------------------
 
DROP TABLE invoices;
DROP TABLE vendors;

-- NOTE: these tables don't contain FOREIGN KEY or UNIQUE constraints
CREATE TABLE vendors
(
  vendor_id     NUMBER          CONSTRAINT vendors_pk PRIMARY KEY,
  vendor_name   VARCHAR2(50)
);

CREATE TABLE invoices
(
  invoice_id       NUMBER          CONSTRAINT invoices_pk PRIMARY KEY,
  vendor_id        NUMBER          NOT NULL,
  invoice_total    NUMBER(9,2)     NOT NULL    CONSTRAINT invoice_total_ck   CHECK (invoice_total >= 0),
  payment_total    NUMBER(9,2)     DEFAULT 0   CONSTRAINT payment_total_ck   CHECK (payment_total >= 0)
);

INSERT INTO vendors
VALUES(1, 'US Postal Service');

INSERT INTO invoices
VALUES(1, 1, 0, 0);

/***************************************
* CHECK constraints
**************************************/
ALTER TABLE invoices
DROP CONSTRAINT invoice_total_ck;

ALTER TABLE invoices
ADD CONSTRAINT invoice_total_ck CHECK (invoice_total >= 0);

ALTER TABLE invoices
DROP CONSTRAINT invoice_total_ck;

ALTER TABLE invoices
ADD CONSTRAINT invoice_total_ck CHECK (invoice_total >= 1) DISABLE;

ALTER TABLE invoices
ENABLE NOVALIDATE CONSTRAINT invoice_total_ck;

ALTER TABLE invoices
DISABLE CONSTRAINT invoice_total_ck;

/***************************************
* FOREIGN KEY constraints
**************************************/
ALTER TABLE invoices
ADD CONSTRAINT invoices_fk_vendors
FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id);

ALTER TABLE invoices
DROP CONSTRAINT invoices_fk_vendors;

/***************************************
* UNIQUE constraints
**************************************/
ALTER TABLE vendors
ADD CONSTRAINT vendors_vendor_name_uq
UNIQUE (vendor_name);

ALTER TABLE vendors
DROP CONSTRAINT vendors_vendor_name_uq;

/***************************************
* NOT NULL constraints
**************************************/
ALTER TABLE vendors
MODIFY vendor_name 
CONSTRAINT vendors_vendor_name_nn NOT NULL;

ALTER TABLE vendors
DROP CONSTRAINT vendors_vendor_name_nn;







---------------------------------------------------------
-- How to rename, truncate, and drop a table
---------------------------------------------------------

RENAME vendors TO vendor;
RENAME invoices TO invoice;

TRUNCATE TABLE invoice;
TRUNCATE TABLE vendor;

DROP TABLE invoice;
DROP TABLE vendor;

 
CREATE TABLE vendors
(
  vendor_id     NUMBER          CONSTRAINT vendors_pk PRIMARY KEY,
  vendor_name   VARCHAR2(50)    UNIQUE
);

CREATE TABLE invoices
(
  invoice_id       NUMBER          CONSTRAINT invoices_pk PRIMARY KEY,
  vendor_id        NUMBER          CONSTRAINT invoices_fk_vendors REFERENCES vendors (vendor_id),
  invoice_total    NUMBER(9,2)     NOT NULL    CONSTRAINT invoice_total_ck   CHECK (invoice_total >= 0),
  payment_total    NUMBER(9,2)     DEFAULT 0   CONSTRAINT payment_total_ck   CHECK (payment_total >= 0)
);

INSERT INTO vendors
VALUES(1, 'US Postal Service');

INSERT INTO invoices
VALUES(1, 1, 0, 0);
 