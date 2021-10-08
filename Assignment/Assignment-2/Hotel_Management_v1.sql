---------------------------------------------------------
-- Section I : Drop all tables/sequences
-- Authors : Ayush Malani (am95655) and Sahitya Sundar Raj Vijayanagar (sv25849)
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
-- Authors : Ayush Malani (am95655) and Sahitya Sundar Raj Vijayanagar (sv25849)
---------------------------------------------------------

--------------------------------------------------------
-- Creating Sequences
--------------------------------------------------------

CREATE SEQUENCE payment_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE reservation_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE room_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE location_id_sequence START WITH 1 INCREMENT BY 1; --- Shouldnt be!
CREATE SEQUENCE feature_id_sequence START WITH 1 INCREMENT BY 1; --- ?
CREATE SEQUENCE customer_id_sequence START WITH 100001 INCREMENT BY 1;






--------------------------------------------------------
-- Creating Tables
--------------------------------------------------------



CREATE TABLE Customer
(
  Customer_ID       NUMBER     DEFAULT customer_id_sequence.nextval     CONSTRAINT Customer_ID PRIMARY KEY,
  First_Name        VARCHAR(20)     NOT NULL, 
  Last_Name    VARCHAR(20)      NOT NULL,
  Email    VARCHAR(30)    NOT NULL      UNIQUE    CONSTRAINT email_length_check   CHECK (LENGTH(Email) >= 7),
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
  Feature_ID        NUMBER      CONSTRAINT loc_linking_fk_features REFERENCES Location (Feature_ID)     NOT NULL,
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





---------------------------------------------------------
-- Section III : Insert Data
---------------------------------------------------------

--- while inserting data, don't insert the primary keys as their default values have already been given as a sequence

INSERT INTO Customer 
(
First_Name, 
Last_Name, 
Email, 
Phone, 
Address_Line_1, 
Address_Line_2, 
City, 
State, 
Zip, 
Birthdate, 
Stay_Credits_Earned, 
Stay_Credits_Used
)
VALUES 
('Dipali', 'Pandey', 'dipali.pandey@utexas.edu', '777-999-0000', 'Tanglewood 250', '', 'Delhi', 'Delhi','110017', '02-Oct','5','2'),
('Rohitashwa','Chakraborty', 'rohitashwa.chakraborty@utexas.edu', '888-777-9999','Tanglewood 250', 'Bangalore','Karnataka','130011','25-Dec','6','3')
Commit;


INSERT INTO Customer_Payment 
(
Cardholder_First_Name, 
Cardholder_Mid_Name, 
Cardholder_Last_Name, 
CardType, CardNumber, 
Expiration_Date, 
CC_ID, 
Billing_Address, 
Billing_City,
Billing_State,
Billing_Zip
)
  VALUES 
  ('Dipali', '', 'Pandey', 'VISA','23456789123456', '06-22','112','Tanglewood 250', 'Delhi', 'Delhi', '110017'),
  ('Rohitashwa', '', 'Chakraborty', 'MSTR','4567890123456789', '08-23','313','Tanglewood 251', 'Bangalore', 'Karnataka', '130011')
Commit;  


INSERT INTO Reservation
(
 Confirmation_Nbr, --- It’s a random collection of numbers and letters and looks something like “G2JD8J3”
  Date_Created,
  Check_In_Date,
  Check_Out_Date, 
  Status, --- (U for upcoming, I for in progress, C for completed, and N for no show, R for refunded)
  Discount_Code, --- Max 12 characters 
  Reservation_Total, --- A reservation total is saved on the reservation which is the number of nights times the rate of each room added up
  Customer_Rating, --- 1-5
  Notes
)
VALUES
('G2JD8J3','08-01-2020', '09-21-2020', '09-23-2020', 'C','123456ABCDEF','2*40','5', 'Customer doesn't like onion'), --- what if it covers both weekdays and weekend?
('G2JD8K9','02-02-2021', '06-07-2021', '06-09-2021', 'C','123457ABCDEZ','3*45','4','Customer has a sweet tooth'), --- Rating is given after the stay is over?
('G2JD8L4','03-03-2021', '10-05-2021', '10-09-2021', 'I','123457ABCDEZ','4*50','','Customer wants bottled water') ---- How to tie them to customers?
Commit;

---- Confirmation number should be incremental?
---- There could be multiple locations booked under the same confirmation number? 


 INSERT INTO Location
(
  Location_Name, ---- South Congress; East 7th Lofts; Balcones Canyonlands, west of Austin in the city, Marble Falls
  Address,   
  City,
  State,   
  Zip,
  Phone,
  URL  
)
VALUES 
('South Congress', 'South Austin', 'Austin','Texas', '78727','737-999-1111', 'https://sourapple.com/southcongress'),
('East 7th Lofts', 'East Austin', 'Austin','Texas', '78711','737-888-1111', 'https://sourapple.com/east'),
('Balcones Canyonlands', 'West  of Austin', 'Marble Falls','Texas', '78622','992-552-5522', 'https://sourapple.com/balconescanyonlands')
Commit;


INSERT INTO Features
(
  Feature_Name ---- Free Breakfast, Free WIFI, Free Spa
)
VALUES 
('Free Wifi')
('Fee Spa')
('Free Breakfast')
Commit;


INSERT INTO Room        
(                             
  Room_ID,
  Location_ID,
  Floor, 
  Room_Number,
  Room_Type, --- D for double beds, Q for single queen, K for single king, S for suite, C for cabin
  Square_Footage,
  Max_People,
  Weekday_Rate,
  Weekend_Rate      
)
VALUES 
('S101','1','1','101', 'D', '250','2', '35', '38'), 
('S201','1','2','201', 'Q', '400','2', '40', '43'),
('E101','2','1','101', 'K', '500','2', '45', '48'),
('E101','2','2','201', 'Q', '400','2', '40', '43'),
('W101','3','1','101', 'C', '160','1', '32', '35'),
('W101','3','2','201', 'S', '360','2', '55', '60')
Commit;


INSERT INTO Reservation_Details
(
 Number_of_Guests
)
VALUES 
('2'),
('2'),
('2')
Commit;
  
---------------------------------------------------------
-- Section IV :  Create Indexes
---------------------------------------------------------
 
CREATE INDEX room_location_id_ix
  ON Room (location_id);
  
CREATE INDEX reservation_customer_id_ix
  ON Reservation (customer_id);

CREATE INDEX customer_payment_customer_id_ix
  ON Customer_Payment (customer_id);

 
 
 
--- Default is known as B-tree, the composite index can be created on multiple columns
--- Primary keys/unique constraints implicitly create indexes
--- Oracle faster than mysql cos of indexes
--- card number should be either 15 or 16 digits







