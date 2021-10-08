---------------------------------------------------------
-- Section I : Drop all tables/sequences
-- Authors : 
    -- Ayush Malani (am95655)
    -- Sahitya Sundar Raj Vijayanagar (sv25849)
    -- Kaushik Kumaran ()
---------------------------------------------------------


--- Dropping Tables
DROP TABLE Reservation_Details;
DROP TABLE Room;
DROP TABLE Location_Features_Linking;
DROP TABLE Features;
DROP TABLE Location;
DROP TABLE Reservation;
DROP TABLE Customer_Payment;
DROP TABLE Customer;

--- Dropping Sequences
DROP SEQUENCE payment_id_sequence;
DROP SEQUENCE reservation_id_sequence;
DROP SEQUENCE room_id_sequence;
DROP SEQUENCE location_id_sequence;
DROP SEQUENCE feature_id_sequence;
DROP SEQUENCE customer_id_sequence;




---------------------------------------------------------
-- Section II : Create tables/sequences
-- Authors : 
    -- Ayush Malani (am95655)
    -- Sahitya Sundar Raj Vijayanagar (sv25849)
    -- Shreya Bhootda ()
---------------------------------------------------------

-- Creating Sequences

CREATE SEQUENCE payment_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE reservation_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE room_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE location_id_sequence START WITH 1 INCREMENT BY 1; --- Shouldnt be!
CREATE SEQUENCE feature_id_sequence START WITH 1 INCREMENT BY 1; --- ?
CREATE SEQUENCE customer_id_sequence START WITH 100001 INCREMENT BY 1;

-- Creating Tables

CREATE TABLE Customer
(
  Customer_ID       NUMBER     DEFAULT customer_id_sequence.nextval     CONSTRAINT Customer_ID PRIMARY KEY,
  First_Name        VARCHAR(20)     NOT NULL, 
  Last_Name    VARCHAR(20)      NOT NULL,
  Email    VARCHAR(50)    NOT NULL      UNIQUE    CONSTRAINT email_length_check   CHECK (LENGTH(Email) >= 7),
  Phone     CHAR(12)    NOT NULL,
  Address_Line_1    VARCHAR(50)     NOT NULL,
  Address_Line_2    VARCHAR(50),
  City      VARCHAR(20)     NOT NULL,
  State     CHAR(2)     NOT NULL,
  Zip       CHAR(5)     NOT NULL,
  Birthdate     DATE,
  Stay_Credits_Earned   NUMBER      DEFAULT 0      NOT NULL,
  Stay_Credits_Used     NUMBER      DEFAULT 0       NOT NULL,
  CONSTRAINT credits_used_check CHECK (Stay_Credits_Used <= Stay_Credits_Earned)
);

CREATE INDEX customer_city_state_ix
ON Customer (City, State);

CREATE TABLE Customer_Payment
(
  Payment_ID        NUMBER      DEFAULT payment_id_sequence.nextval     CONSTRAINT Payment_ID PRIMARY KEY,
  Customer_ID       NUMBER      CONSTRAINT payment_fk_customer REFERENCES Customer (Customer_ID),
  Cardholder_First_Name     VARCHAR(20)     NOT NULL, 
  Cardholder_Mid_Name       VARCHAR(20),    -- Assumption that middle name can be null 
  Cardholder_Last_Name      VARCHAR(20)     NOT NULL, 
  CardType      CHAR(4)     NOT NULL,
  CardNumber    NUMBER      NOT NULL,
  Expiration_Date       DATE    NOT NULL,
  CC_ID     NUMBER,
  Billing_Address   VARCHAR(50)     NOT NULL,   
  Billing_City  VARCHAR(20)     NOT NULL,
  Billing_State     VARCHAR(20)     NOT NULL,   -- Assumption that state might not be the state code, but the entire state name
  Billing_Zip       VARCHAR(20)     NOT NULL    -- Assumption that Zipcode might not necessarily be a number, or from the US, hence considering VARCHAR
);


CREATE TABLE Reservation
(
  Reservation_ID         NUMBER     DEFAULT reservation_id_sequence.nextval        CONSTRAINT Reservation_ID PRIMARY KEY,
  Customer_ID        NUMBER      CONSTRAINT reservation_fk_customer REFERENCES Customer (Customer_ID),
  Confirmation_Nbr      CHAR(8)     UNIQUE      NOT NULL,
  Date_Created      DATE       DEFAULT SYSDATE      NOT NULL,
  Check_In_Date     DATE    NOT NULL,
  Check_Out_Date    DATE,-- null
  Status        CHAR(1)     NOT NULL    CONSTRAINT status_check    CHECK   (Status IN ('U','I','C','N','R')),
  Discount_Code     VARCHAR(20),-- null
  Reservation_Total     NUMBER(7,2)     NOT NULL,
  Customer_Rating   VARCHAR(10),-- null
  Notes VARCHAR(100)-- null
);


CREATE TABLE Location
(
  Location_ID       NUMBER     DEFAULT location_id_sequence.nextval     CONSTRAINT Location_ID PRIMARY KEY,
  Location_Name     VARCHAR(50)       UNIQUE      NOT NULL,
  Address       VARCHAR(50)     NOT NULL,   
  City      VARCHAR(20)     NOT NULL,
  State     CHAR(2)     NOT NULL,   
  Zip       CHAR(5)     NOT NULL,
  Phone     CHAR(12)    NOT NULL,
  URL       VARCHAR(100)     NOT NULL
);


CREATE TABLE Features
(
  Feature_ID        NUMBER       DEFAULT feature_id_sequence.nextval    CONSTRAINT Feature_ID PRIMARY KEY,
  Feature_Name      VARCHAR(20)     UNIQUE      NOT NULL
);


CREATE TABLE Location_Features_Linking
(
  Location_ID       NUMBER      CONSTRAINT loc_linking_fk_location REFERENCES Location (Location_ID)        NOT NULL,
  Feature_ID        NUMBER      CONSTRAINT loc_linking_fk_features REFERENCES Features (Feature_ID)     NOT NULL,
  CONSTRAINT location_features_pk  PRIMARY KEY (Location_ID, Feature_ID)
);

CREATE TABLE Room
(
  Room_ID       NUMBER     DEFAULT room_id_sequence.nextval     CONSTRAINT Room_ID PRIMARY KEY,
  Location_ID       NUMBER      CONSTRAINT room_fk_location REFERENCES Location (Location_ID)        NOT NULL,
  Floor     NUMBER      NOT NULL,
  Room_Number      VARCHAR(10)      NOT NULL,
  Room_Type     CHAR(1)     NOT NULL    CONSTRAINT room_type_check    CHECK   (Room_Type IN ('D','Q','K','S','C')),
  Square_Footage       NUMBER       NOT NULL, -- Assuming that square footage is a whole number
  Max_People        NUMBER      NOT NULL,
  Weekday_Rate      NUMBER(7,2) NOT NULL,
  Weekend_Rate      NUMBER(7,2) NOT NULL
);

CREATE TABLE Reservation_Details
(
  Reservation_ID        NUMBER      CONSTRAINT res_details_fk_reservation REFERENCES Reservation (Reservation_ID)        NOT NULL,
  Room_ID       NUMBER      CONSTRAINT res_details_fk_room REFERENCES Room (Room_ID)        NOT NULL,
  Number_of_Guests      NUMBER      NOT NULL,
  CONSTRAINT reservation_details_pk  PRIMARY KEY (Reservation_ID, Room_ID)
);

-----------------------------------------------------------
---- Section III :  Create Indexes
-- Authors : 
    -- Dipali Pandey (dp33957)
    -- Rohitashwa Chakraborty (rc47878)
    -- Kaushik Kumaran ()
-----------------------------------------------------------
  
CREATE INDEX customer_city_state_ix
  ON Customer (City, State);

CREATE INDEX customer_payment_customer_id_ix
  ON Customer_Payment (customer_id);

CREATE INDEX reservation_customer_id_ix
  ON Reservation (customer_id);

CREATE INDEX reservation_check_in_date_ix
  ON Reservation (Check_In_Date);

CREATE INDEX room_location_id_ix
  ON Room (location_id);
Commit;

---------------------------------------------------------
-- Section IV : Insert Data
-- Authors : 
    -- Dipali Pandey (dp33957)
    -- Rohitashwa Chakraborty (rc47878)
    -- Shreya Bhootda ()
---------------------------------------------------------

--- while inserting data, don't insert the primary keys as their default values have already been given as a sequence

INSERT INTO Customer VALUES (DEFAULT, 'Dipali',     'Pandey',      'dipali.pandey@utexas.edu',          '777-999-0000', 'Tanglewood 250', NULL,          'Austin', 'TX', '78701', TO_DATE('08-02-2021', 'MM-DD-YYYY'), 5, 0);
INSERT INTO Customer VALUES (DEFAULT, 'Rohitashwa', 'Chakraborty', 'rohitashwa.chakraborty@utexas.edu', '888-777-9999', '1802 WEST AVE',  'Lantana 250', 'Austin', 'TX', '78751', TO_DATE('12-25-2021', 'MM-DD-YYYY'), 6, 3);
Commit;

SELECT * FROM Customer;

INSERT INTO Customer_Payment VALUES (DEFAULT, 100001, 'Dipali',     NULL,      'Pandey',      'VISA', 23456789123456, TO_DATE('06-22','MM-DD'),'112','Tanglewood 250', 'Delhi', 'Delhi',     '110017');
INSERT INTO Customer_Payment VALUES (DEFAULT, 100002, 'Rohitashwa', 'Narayan', 'Chakraborty', 'MSTR', 45678901234567, TO_DATE('08-23','MM-DD'),'313','Lantana 251','Bangalore', 'Karnataka', '130011');
Commit;  

SELECT * FROM Customer_Payment;

INSERT INTO Reservation VALUES (DEFAULT, 100001, 'G2JD8J3', TO_DATE('08-01-2020','MM-DD-YYYY'), TO_DATE('09-21-2020','MM-DD-YYYY'), TO_DATE('09-23-2020','MM-DD-YYYY'), 'C', NULL,           80.31, 'Great',  'Customer does not like onion'); --- what if it covers both weekdays and weekend?
INSERT INTO Reservation VALUES (DEFAULT, 100002, 'G2JD8K9', TO_DATE('02-02-2021','MM-DD-YYYY'), TO_DATE('06-07-2021','MM-DD-YYYY'), TO_DATE('06-09-2021','MM-DD-YYYY'), 'C', '123457ABCDEZ', 73.12, 'Average','Customer has a sweet tooth'); --- Rating is given after the stay is over?
INSERT INTO Reservation VALUES (DEFAULT, 100001, 'G2JD8L4', TO_DATE('03-03-2021','MM-DD-YYYY'), TO_DATE('10-05-2021','MM-DD-YYYY'), TO_DATE('10-10-2021','MM-DD-YYYY'), 'I', '123kJ7A5F6EZ', 112.43,'Great',  'Customer wants bottled water'); ---- How to tie them to customers?
Commit;

SELECT * FROM Reservation;

------ Confirmation number should be incremental?
------ There could be multiple locations booked under the same confirmation number? 

INSERT INTO Location VALUES (DEFAULT,'South Congress', 'South Austin', 'Austin', 'TX', '78727', '737-999-1111', 'https://sourapple.com/southcongress');
INSERT INTO Location VALUES (DEFAULT,'East 7th Lofts', 'East Austin',  'Austin', 'TX', '78711', '737-888-1111', 'https://sourapple.com/east');
INSERT INTO Location VALUES (DEFAULT,'Balcones Canyonlands', 'West Austin', 'Marble Falls','TX', '78622','992-552-5522', 'https://sourapple.com/balconescanyonlands');
Commit;

SELECT * FROM Location;

INSERT INTO Features VALUES (DEFAULT, 'Free Wifi');
INSERT INTO Features VALUES (DEFAULT, 'Free Spa');
INSERT INTO Features VALUES (DEFAULT, 'Breakfast');
Commit;

SELECT * FROM Features;

INSERT INTO Room VALUES (DEFAULT, 1, 1,'101', 'D', 250, 2, 9.5, 10.9);
INSERT INTO Room VALUES (DEFAULT, 1, 2,'201', 'Q', 400, 2, 12.5, 15.9);
INSERT INTO Room VALUES (DEFAULT, 2, 1,'101', 'K', 500, 3, 15.5, 19.9);
INSERT INTO Room VALUES (DEFAULT, 2, 2,'201', 'C', 160, 1,  5.2, 7.9);
INSERT INTO Room VALUES (DEFAULT, 3, 1,'101', 'C', 160, 1,  6.3, 7.9);
INSERT INTO Room VALUES (DEFAULT, 3, 2,'201', 'S', 360, 2, 12.2, 15.9);
Commit;

-- Duplicate Room Numbers on same floor, location

SELECT * FROM Room;

INSERT INTO Reservation_Details VALUES (1, 1, 2);
INSERT INTO Reservation_Details VALUES (2, 2, 3);
INSERT INTO Reservation_Details VALUES (3, 1, 1);
Commit;

SELECT * FROM Reservation_Details;

INSERT INTO Location_Features_Linking VALUES (1,1);
INSERT INTO Location_Features_Linking VALUES (1,2);
INSERT INTO Location_Features_Linking VALUES (1,3);
INSERT INTO Location_Features_Linking VALUES (2,2);
INSERT INTO Location_Features_Linking VALUES (3,1);
Commit;

SELECT * FROM Location_Features_Linking;

--
-- 
-- 
-- 
----- Default is known as B-tree, the composite index can be created on multiple columns
----- Primary keys/unique constraints implicitly create indexes
----- Oracle faster than mysql cos of indexes
----- card number should be either 15 or 16 digits
--
--
--




