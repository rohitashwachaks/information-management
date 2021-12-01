---------------------------------------------------------
-- Authors : 
    -- SHREYA BHOOTDA ()
    -- KAUSHIK KUMARAN ()
---------------------------------------------------------
--SELECT * FROM reservation_details;
drop table reservation_details;
drop table customer_payments;
drop table reservations;
drop table rides;
drop table customer_personal_details ;
drop table pass_type;
drop sequence customer_id_seq;
drop sequence payment_id_seq;
drop sequence reservation_id_seq;
drop sequence ride_id_seq;
create sequence customer_id_seq start with 100031 increment by 1;
create sequence payment_id_seq start with 1 increment by 1;
create sequence reservation_id_seq start with 1 increment by 1;
create sequence ride_id_seq start with 1 increment by 1;

CREATE TABLE customer_personal_details 
(
  customer_id     NUMBER       default customer_id_seq.nextval   primary key,
  first_name    VARCHAR2(50)   NOT NULL, 
  last_name     VARCHAR2(50)   NOT NULL, 
  address       VARCHAR2(50)   NOT NULL, 
  city          VARCHAR2(25)   NOT NULL, 
  state         CHAR(2)        DEFAULT 'TX', 
  DATE_OF_BIRTH VARCHAR2(50) not null,
  phone         VARCHAR2(20) not null
);

create table customer_payments
(
    payment_id              number          default payment_id_seq.nextval      primary key,
    customer_id             number          not null        unique              references customer_personal_details(customer_id),
    cardholder_first_name   varchar(100)    not null,
    cardholder_mid_name     varchar(100)    null,
    cardholder_last_name    varchar(100)    not null,
    card_type               char(4)         not null,
    card_number             number          not null,
    expiration_date         date            not null,
    cc_id                   number          not null,
    billing_address         varchar(100)    not null,
    billing_city            varchar(100)    not null,
    billing_state           char(2)         not null,
    billing_zip             char(5)         not null
);

create table pass_type(
    ticket_type             varchar2(20)          primary key,
    description             varchar2(100),
    weekday_rate            number          not null,
    weekend_rate            number          not null
);

create table reservations
(
    reservation_id          number          default reservation_id_seq.nextval    primary key,
    customer_id             number          references customer_personal_details(customer_id),
    confirmation_nbr        char(8)         not null  unique,
    date_created            date            default sysdate,
    date_reserved           date            not null,
    status                  varchar2(20)    not null,
    ticket_type             varchar2(20)    references  pass_type(ticket_type), --Standard, Premium
    number_of_customers        number          not null,
    reservation_total       number          not null,
    discount_code           number,
    customer_rating         number,
    notes                   varchar(100)
);

create table rides(
    ride_id                 number          default ride_id_seq.nextval       primary key,
    ride_name               varchar2(200)          not null,
    ride_duration           number          not null
);

create table reservation_details
(
    reservation_id          number          not null        references reservations(reservation_id),
    ride_id                 number          not null        references rides(ride_id),
    constraint reservation_room_pk                          primary key(reservation_id, ride_id)
);

commit;

INSERT INTO pass_type(ticket_type, description, weekday_rate, weekend_rate) values ('S','Standard',10,20);
INSERT INTO pass_type(ticket_type, description, weekday_rate, weekend_rate) values ('P','Premium',20,30);
commit;

Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100001,'Jamill','Kemm','9 Burrows Avenue','San Antonio','TX',to_date('08-DEC-94','DD-MON-RR'),'512-661-1720');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100002,'Jefferey','Kosiada','3 Iowa Street','LA','CA',to_date('25-OCT-97','DD-MON-RR'),'512-661-1719');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100003,'Joline','Gloyens','6795 Graedel Street','Syracuse','NY',to_date('19-APR-78','DD-MON-RR'),'512-661-1718');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100004,'Kary','Klimkowski','14 Bluejay Crossing','Spring','TX',to_date('06-MAR-78','DD-MON-RR'),'512-661-1717');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100005,'Lana','Eddison','64 Calypso Pass','Austin','TX',to_date('18-MAR-97','DD-MON-RR'),'512-661-1716');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100006,'Laure','Chatin','90 Logan Hill','Dallas','TX',to_date('13-NOV-82','DD-MON-RR'),'512-661-1715');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100007,'Leighton','Breawood','7 Welch Junction','Houston','TX',to_date('06-NOV-86','DD-MON-RR'),'512-661-1714');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100008,'Lila','Weightman','1494 Mcguire Street','Jamaica','NY',to_date('31-AUG-00','DD-MON-RR'),'512-661-1713');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100009,'Linnell','Cranmere','30 Crescent Oaks Terrace','Houston','TX',to_date('28-FEB-88','DD-MON-RR'),'512-661-1712');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100010,'Malory','Buttrum','34 Hudson Lane','El Paso','TX',to_date('13-DEC-74','DD-MON-RR'),'512-661-1711');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100011,'Megan','Rotlauf','09756 Bashford Point','Dallas','TX',to_date('05-OCT-89','DD-MON-RR'),'512-661-1710');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100012,'Meggie','Christoffels','38 Longview Point','Houston','TX',to_date('15-JUN-77','DD-MON-RR'),'512-661-1709');
Insert into customer_personal_details (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,DATE_OF_BIRTH,PHONE) values (100013,'Omero','Goomes','11 Fairfield Terrace','Waco','TX',to_date('20-NOV-82','DD-MON-RR'),'512-661-1708');
commit;

Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (1,100001,'Jamill','Kemm','Wilson','VISA',4389827342838761,to_date('01-JUN-21','DD-MON-RR'),561,'9 Burrows Avenue','San Antonio','TX','75897');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (2,100002,'Jeff',NULL,'Kosiada','MSTR',4660193595413514,to_date('01-OCT-21','DD-MON-RR'),395,'3 Iowa Street','Shreveport','LA','79024');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (3,100003,'Joline',NULL,'Gloyens','VISA',4156943723409445,to_date('01-JAN-21','DD-MON-RR'),578,'6795 Graedel Street','Syracuse','NY','10005');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (4,100004,'Kary',NULL,'Klimkowski','MSTR',4568606041245606,to_date('01-DEC-23','DD-MON-RR'),216,'14 Bluejay Crossing','Spring','TX','78267');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (5,100005,'Lana',NULL,'Eddison','AMEX',437567592508337,to_date('01-JUN-22','DD-MON-RR'),356,'64 Calypso Pass','Austin','TX','76738');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (6,100006,'Laure',NULL,'Chatin','VISA',4558723083811426,to_date('01-OCT-21','DD-MON-RR'),828,'90 Logan Hill','Dallas','TX','77148');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (7,100007,'Leighton',NULL,'Breawood','MSTR',4798567143866077,to_date('01-SEP-23','DD-MON-RR'),236,'7 Welch Junction','Houston','TX','76233');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (8,100008,'Lila',NULL,'Weightman','MSTR',4651707639003764,to_date('01-AUG-23','DD-MON-RR'),745,'1494 Mcguire Street','Jamaica','NY','10020');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (9,100009,'Linny',NULL,'Cranmere','MSTR',4843934754783083,to_date('01-SEP-22','DD-MON-RR'),935,'30 Crescent Oaks Terrace','Houston','TX','77296');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (10,100010,'Malory','Buttrum','Cake','AMEX',462042241996570,to_date('01-APR-22','DD-MON-RR'),158,'34 Hudson Lane','El Paso','TX','77855');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (11,100011,'Megan',NULL,'Rotlauf','VISA',4397329439003271,to_date('01-NOV-24','DD-MON-RR'),732,'09756 Bashford Point','Dallas','TX','78249');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (12,100012,'Meggie',NULL,'Christoffels','AMEX',486975103511579,to_date('01-JUN-24','DD-MON-RR'),348,'38 Longview Point','Houston','TX','76131');
Insert into CUSTOMER_PAYMENTS (PAYMENT_ID,CUSTOMER_ID,CARDHOLDER_FIRST_NAME,CARDHOLDER_MID_NAME,CARDHOLDER_LAST_NAME,CARD_TYPE,CARD_NUMBER,EXPIRATION_DATE,CC_ID,BILLING_ADDRESS,BILLING_CITY,BILLING_STATE,BILLING_ZIP) values (13,100013,'O','K','Goomes','VISA',4315108111054339,to_date('01-MAY-22','DD-MON-RR'),834,'11 Fairfield Terrace','Waco','TX','78488');
commit;

Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (393,100001,'N46GAM14',to_date('25-JUL-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (394,100002,'G52HVX94',to_date('28-JUL-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (395,100003,'S29ART25',to_date('31-JUL-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'P','U',2,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (396,100006,'Z59QQJ29',to_date('02-AUG-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'P','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (397,100004,'W22TSB99',to_date('02-AUG-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'P','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (398,100005,'W24IOP60',to_date('02-AUG-21','DD-MON-RR'),to_date('28-JUL-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (399,100007,'T97KTW11',to_date('09-AUG-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (400,100008,'Y96FXT57',to_date('10-AUG-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (401,100009,'Z97IYC19',to_date('11-AUG-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (402,100010,'V95TPO85',to_date('04-APR-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (403,100011,'Z61PFH84',to_date('04-APR-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (404,100012,'G86EEZ11',to_date('14-AUG-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'S','U',1,1,null,null,null);
Insert into RESERVATIONS (RESERVATION_ID,CUSTOMER_ID,CONFIRMATION_NBR,DATE_CREATED,date_reserved,ticket_type,STATUS,number_of_customers,RESERVATION_TOTAL,DISCOUNT_CODE,CUSTOMER_RATING,NOTES) values (405,100013,'D21VON80',to_date('15-AUG-21','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'P','U',1,1,null,null,null);
commit;

Insert into RIDES (RIDE_ID,RIDE_NAME,RIDE_DURATION) values (1,'Flight of the Hippogriff',117);
Insert into RIDES (RIDE_ID,RIDE_NAME,RIDE_DURATION) values (2,'Harry Potter and the Escape from Gringotts',118);
commit;

Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (393,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (394,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (395,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (396,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (397,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (398,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (399,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (399,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (400,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (400,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (401,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (402,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (403,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (404,1);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (405,2);
Insert into RESERVATION_DETAILS (RESERVATION_ID,RIDE_ID) values (405,1);
commit;

-- Query for Distinct customers for rides
select b.ride_id, count(distinct a.customer_id) as count_of_customers
from reservations a 
join reservation_details b
on a.reservation_id = b.reservation_id
group by b.ride_id
order by count_of_customers desc;



---------------------------------------------------------
-- Authors : 
    -- Ayush Malani (am95655)
    -- Dipali Pandey (dp33957)
---------------------------------------------------------


--- Dropping Tables : Employee/Staff Database

DROP TABLE Attraction_Staff;
DROP TABLE Maintenance_Staff;
DROP TABLE Maintenance_Schedule;
DROP TABLE Staff_Bank_Account;
DROP TABLE Staff;


--- Dropping Sequences
DROP SEQUENCE staff_id_sequence;
DROP SEQUENCE schedule_activity_sequence;


-- Creating Sequences

CREATE SEQUENCE staff_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE schedule_activity_sequence START WITH 1 INCREMENT BY 1;




-- Creating Tables

CREATE TABLE Staff
(
  StaffID       NUMBER     DEFAULT staff_id_sequence.nextval     CONSTRAINT StaffID PRIMARY KEY,
  FirstName        VARCHAR(20)     NOT NULL, 
  LastName    VARCHAR(20)      NOT NULL,
  Designation   VARCHAR(40)     NOT NULL,
  Department    VARCHAR(20)     NOT NULL,
  Email    VARCHAR(50)    NOT NULL      UNIQUE    CONSTRAINT email_length  CHECK (LENGTH(Email) >= 7),
  PhoneNumber     CHAR(12)    NOT NULL,
  StreetAddress    VARCHAR(50)     NOT NULL,
  City      VARCHAR(20)     NOT NULL,
  State     CHAR(2)     NOT NULL,
  Country   VARCHAR(20)     NOT NULL,
  Zipcode       CHAR(5)     NOT NULL,
  JoiningDate     DATE      NOT NULL,
  LastDate      DATE,
  DOB     DATE,
  
  CONSTRAINT last_date_check CHECK (LastDate >= JoiningDate)
);




CREATE TABLE Staff_Bank_Account
(
  StaffID        NUMBER      CONSTRAINT staff_id_fk REFERENCES Staff (StaffID),
  Salary       NUMBER      NOT NULL,
  BankAccountNumber     NUMBER     NOT NULL, 
  RoutingNumber       NUMBER     NOT NULL,
  BankStreetAddress   VARCHAR(50)     NOT NULL,   
  BankCity  VARCHAR(20)     NOT NULL,
  BankState     VARCHAR(20)     NOT NULL,   -- Assumption that state might not be the state code, but the entire state name
  BankZIP       VARCHAR(20)     NOT NULL,    -- Assumption that Zipcode might not necessarily be a number, or from the US, hence considering VARCHAR
  CONSTRAINT staff_id_pk  PRIMARY KEY (StaffID)
);


CREATE TABLE Attraction_Staff
(
  StaffID        NUMBER      CONSTRAINT staff_id_fk_att REFERENCES Staff (StaffID),
  ride_id      NUMBER      CONSTRAINT attraction_id_fk REFERENCES Ride_Details (ride_id),
  DateFrom     DATE,
  DateTo     DATE,
  CONSTRAINT att_staff_pk PRIMARY KEY (StaffID, ride_id),
  CONSTRAINT attraction_staff_date_check CHECK (DateTo >= DateFrom)
);





CREATE TABLE Maintenance_Schedule
(
  ScheduleActivityID    NUMBER     DEFAULT schedule_activity_sequence.nextval     CONSTRAINT ScheduleActivityID PRIMARY KEY,
  ride_id      NUMBER      CONSTRAINT attraction_id_fk_mtnsch REFERENCES Ride_Details (ride_id),
  StartDate     DATE,
  EndDate     DATE,
  Details   VARCHAR(100),
  
  CONSTRAINT maintenance_date_check CHECK (EndDate >= StartDate)
);




CREATE TABLE Maintenance_Staff
(
  StaffID        NUMBER      CONSTRAINT staff_id_fk_mtn REFERENCES Staff (StaffID),
  ScheduleActivityID    NUMBER      CONSTRAINT sch_act_fk REFERENCES Maintenance_Schedule (ScheduleActivityID),
  CONSTRAINT mtn_staff_pk PRIMARY KEY (StaffID, ScheduleActivityID)
);




-- Inserting Data

INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Dwight','Schrute','Operator','Ride','dks@univstud.com',99999,'101 Random St','Orlando','FL','USA','10001',TO_DATE('01-JAN-2018','DD-MON-YYYY'),TO_DATE('15-OCT-1967','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Michael','Scott','Manager','Admin','mgs@univstud.com',88888,'102 Random St','Orlando','FL','USA','10001',TO_DATE('01-JAN-2016','DD-MON-YYYY'),TO_DATE('28-FEB-1965','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Jim','Halpert','Cleaner','Maintenance','jh@univstud.com',77777,'103 Random St','Orlando','FL','USA','10001',TO_DATE('01-JAN-2019','DD-MON-YYYY'),TO_DATE('15-NOV-1988','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Andy','Bernard','Technician','Maintenance','nardog@univstud.com',66666,'104 Random St','Orlando','FL','USA','10001',TO_DATE('01-OCT-2018','DD-MON-YYYY'),TO_DATE('10-OCT-1987','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Pam','Beesly','Desk Staff','Ride','pbj@univstud.com',55555,'105 Random St','Orlando','FL','USA','10001',TO_DATE('01-OCT-2016','DD-MON-YYYY'),TO_DATE('22-OCT-1989','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Oscar','Nunez','Operator','Ride','on@univstud.com',44444,'106 Random St','Orlando','FL','USA','10001',TO_DATE('01-DEC-2016','DD-MON-YYYY'),TO_DATE('22-MAR-1989','DD-MON-YYYY'));
INSERT INTO Staff 
(FirstName, LastName, Designation, Department, Email, PhoneNumber, StreetAddress, City, State, Country, Zipcode, JoiningDate, DOB)
VALUES
('Kevin','Malone','Souvenier Shop','Attraction','km@univstud.com',33333,'107 Random St','Orlando','FL','USA','10001',TO_DATE('01-JUN-2016','DD-MON-YYYY'),TO_DATE('20-FEB-1989','DD-MON-YYYY'));

COMMIT;


INSERT INTO Staff_Bank_Account VALUES (1,60000,12345,67891,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (2,80000,56789,13579,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (3,40000,13579,24680,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (4,40000,24680,12346,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (5,50000,12367,34567,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (6,50000,13457,97623,'Muggle Bank 241','Orlando','FL','10005');
INSERT INTO Staff_Bank_Account VALUES (7,50000,13254,90008,'Muggle Bank 241','Orlando','FL','10005');

COMMIT;

INSERT INTO Attraction_Staff VALUES (1,1,TO_DATE('01-JAN-2020','DD-MON-YYYY'),NULL);
INSERT INTO Attraction_Staff VALUES (5,1,TO_DATE('01-JAN-2019','DD-MON-YYYY'),NULL);
INSERT INTO Attraction_Staff VALUES (6,1,TO_DATE('01-JAN-2019','DD-MON-YYYY'),NULL);
INSERT INTO Attraction_Staff VALUES (7,2,TO_DATE('01-JAN-2019','DD-MON-YYYY'),NULL);

COMMIT;


INSERT INTO Maintenance_Schedule 
(ride_id, StartDate, EndDate, Details)
VALUES 
(1,TO_DATE('01-OCT-2021','DD-MON-YYYY'),TO_DATE('20-NOV-2021','DD-MON-YYYY'),'Daily Cleaning');
INSERT INTO Maintenance_Schedule 
(ride_id, StartDate, EndDate, Details)
VALUES 
(2,TO_DATE('01-SEP-2021','DD-MON-YYYY'),TO_DATE('20-OCT-2021','DD-MON-YYYY'),'Electrical Wiring Check');

COMMIT;


INSERT INTO Maintenance_Staff VALUES (3,1);
INSERT INTO Maintenance_Staff VALUES (4,2);


COMMIT;




SELECT * FROM Staff;
SELECT * FROM Staff_Bank_Account;
SELECT * FROM Attraction_Staff;
SELECT * FROM Maintenance_Schedule;
SELECT * FROM Maintenance_Staff;


---------------------------------------------------------
-- Authors : 
    -- Sahitya Sundar Raj Vijayanagar (sv25849)
    -- Rohitashwa Chakraborty (rc47878)
---------------------------------------------------------


--- Dropping Tables
DROP TABLE Ride_Details;
DROP TABLE Vendor_Details;
DROP TABLE Attraction_Type;
DROP TABLE Sectors;
DROP TABLE Establishment_Status;

--- Dropping Sequences
DROP SEQUENCE ride_id_sequence;
DROP SEQUENCE vendor_id_sequence;

COMMIT;

-- Creating Sequences

CREATE SEQUENCE ride_id_sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE vendor_id_sequence START WITH 1 INCREMENT BY 1;

-- Creating Tables

CREATE TABLE Attraction_Type
(
    type_code       CHAR(2) PRIMARY KEY,
    description       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Sectors
(
    sector_code       CHAR(2) PRIMARY KEY,
    description       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Establishment_Status
(
    status_code       CHAR(1) PRIMARY KEY,
    description       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Ride_Details
(
    ride_id               NUMBER DEFAULT ride_id_sequence.nextval CONSTRAINT ride_id PRIMARY KEY,
    ride_name             VARCHAR(100) NOT NULL UNIQUE,
    ride_type             CHAR(2) NOT NULL CONSTRAINT ride_type_fk REFERENCES  Attraction_Type (type_code),
    sector_code           CHAR(2) NOT NULL CONSTRAINT rd_sector_code_fk REFERENCES Sectors (sector_code) ,
    start_date            DATE NOT NULL,
    end_date              DATE,
    status_code           CHAR(1) NOT NULL CONSTRAINT rd_status_code_fk REFERENCES Establishment_Status (status_code),
    last_maintainence     DATE,
    next_maintainence     DATE,
    operating_capacity    NUMERIC(2,0) CONSTRAINT capacity_check CHECK (operating_capacity > 0),
    opex_per_unit         NUMERIC(8,2) CONSTRAINT opex_check CHECK (opex_per_unit > 0),

    CONSTRAINT last_maintainence_check CHECK (last_maintainence >= start_date),--AND (next_maintainence < end_date),
    CONSTRAINT next_maintainence_check CHECK (next_maintainence >= last_maintainence)--AND (next_maintainence < end_date),
);

CREATE TABLE Vendor_Details
(
    vendor_id             NUMBER    DEFAULT vendor_id_sequence.nextval      CONSTRAINT vendor_id PRIMARY KEY,
    vendor_name           VARCHAR(100)      NOT NULL        UNIQUE,
    vendor_type           CHAR(2)       NOT NULL        CONSTRAINT vendor_type_fk REFERENCES Attraction_Type (type_code),
    sector_code           CHAR(2)  NOT NULL    CONSTRAINT vd_sector_code_fk REFERENCES Sectors (sector_code),
    start_date            DATE      NOT NULL,
    end_date              DATE,
    status_code           CHAR(1)   NOT NULL    CONSTRAINT vd_status_code_fk REFERENCES Establishment_Status (status_code),
    contract_renewed      DATE,
    contract_expiring     DATE,
    operating_capacity    NUMERIC(3,0)
                            CONSTRAINT op_capacity_check CHECK (operating_capacity > 0),
    rent                  NUMERIC(8,2)
                            CONSTRAINT rent_check CHECK (rent > 0),
    commission            NUMERIC(8,2)
                            CONSTRAINT commission CHECK (commission > 0),
    
    CONSTRAINT contract_expiring_check CHECK (contract_expiring > contract_renewed),--AND (next_maintainence < end_date),
    CONSTRAINT contract_renewed_check CHECK (contract_renewed >= start_date)--AND (next_maintainence < end_date),
);
COMMIT;


INSERT INTO Attraction_Type (type_code, description) VALUES ('T','Thrill Ride'); --Used in Ride table
INSERT INTO Attraction_Type (type_code, description) VALUES ('W','Water Ride'); --Used in Ride table
INSERT INTO Attraction_Type (type_code, description) VALUES ('X','Immersive Experience'); --Used in Ride table
INSERT INTO Attraction_Type (type_code, description) VALUES ('C','Casual Dining'); --Used in Vendor table
INSERT INTO Attraction_Type (type_code, description) VALUES ('S','Souvenir Shop'); --Used in Vendor table
INSERT INTO Attraction_Type (type_code, description) VALUES ('E','Entertainment'); --Used in Vendor table
COMMIT;


INSERT INTO Sectors (sector_code, description) VALUES ('UL', 'Upper Lot'); 
INSERT INTO Sectors (sector_code, description) VALUES ('LL', 'Lower Lot'); 
COMMIT;


INSERT INTO Establishment_Status (status_code, description) VALUES ('O', 'Operational'); 
INSERT INTO Establishment_Status (status_code, description) VALUES ('C', 'Permanently Closed'); 
INSERT INTO Establishment_Status (status_code, description) VALUES ('M', 'Under Maintenance'); 
COMMIT;


INSERT INTO Ride_Details 
(ride_name, ride_type, sector_code, start_date, status_code, last_maintainence, next_maintainence, operating_capacity, opex_per_unit) 
VALUES
('Flight of the Hippogriff', 'T', 'LL', TO_DATE('04-JUN-18','DD-MON-RR'), 'O', TO_DATE('04-JUN-21','DD-MON-RR'), TO_DATE('04-JUN-22','DD-MON-RR'), 25, 8);
INSERT INTO Ride_Details 
(ride_name, ride_type, sector_code, start_date, status_code, last_maintainence, next_maintainence, operating_capacity, opex_per_unit) 
VALUES
('Harry Potter and the Escape from Gringotts', 'X', 'UL', TO_DATE('21-AUG-18','DD-MON-RR'), 'O', TO_DATE('21-JUN-21','DD-MON-RR'), TO_DATE('21-JUN-22','DD-MON-RR'), 15, 10);
COMMIT;
    

INSERT INTO Vendor_Details 
(vendor_name , vendor_type, sector_code, start_date, status_code, contract_renewed, contract_expiring, operating_capacity, rent, commission)          
VALUES
('Three Broomsticks', 'C', 'LL', TO_DATE('18-AUG-18','DD-MON-RR'), 'O', TO_DATE('18-JUN-21','DD-MON-RR'), TO_DATE('21-JUN-22','DD-MON-RR'), 15, 4500, 8000);
INSERT INTO Vendor_Details 
(vendor_name , vendor_type, sector_code, start_date, status_code, contract_renewed, contract_expiring, operating_capacity, rent, commission)          
VALUES
('The Nighttime Lights At Hogwarts Castle', 'E', 'LL', TO_DATE('7-MAR-19','DD-MON-RR'), 'O', TO_DATE('7-MAR-21','DD-MON-RR'), TO_DATE('7-MAR-22','DD-MON-RR'), 250, 6000, 12000);
INSERT INTO Vendor_Details 
(vendor_name , vendor_type, sector_code, start_date, status_code, contract_renewed, contract_expiring, operating_capacity, rent, commission)          
VALUES
('Borgin and Burkes', 'S', 'UL', TO_DATE('15-JUN-18','DD-MON-RR'), 'O', TO_DATE('15-JUN-21','DD-MON-RR'), TO_DATE('15-JUN-22','DD-MON-RR'), 40, 2700, 6000);
COMMIT;


-------------
---- ETL-----
-------------

-- Customer to Staff Ratio --

SELECT r.ride_id, operating_capacity, staff_count, operating_capacity/staff_count as cust_staff_ratio
FROM

(SELECT ride_id, operating_capacity
FROM Ride_Details) r
--group by ride_id; 

join 

(SELECT ride_id, count(a.StaffID) as staff_count
FROM Attraction_Staff a
JOIN Staff b
ON a.StaffID = b.StaffID
WHERE Designation <> 'Desk Staff'
group by ride_id) s

on r.ride_id=s.ride_id;

-- ETL 2 -- Park-level profit for each ticket_type)

DROP TABLE Daily_Porfits;

CREATE TABLE Daily_Profits
AS
(
    SELECT Revenue_Table.Date_Reserved, Revenue_Table.Ticket_Type, Revenue, Operating_Expense, Revenue-Operating_Expense AS Profit
    FROM
    (
        SELECT date_reserved, Count_Tickets.FREQUENCY, pass_type.weekday_rate, Count_Tickets.ticket_type, FREQUENCY*pass_type.weekday_rate AS REVENUE
        FROM
        (SELECT date_reserved, ticket_type, COUNT(*) AS FREQUENCY
        FROM reservations
        GROUP BY date_reserved, ticket_type) Count_Tickets
        JOIN 
        pass_type
        ON pass_type.ticket_type = Count_Tickets.ticket_type
    ) Revenue_Table
    JOIN
    (
        SELECT Date_Tkt_CP.date_reserved, Date_Tkt_CP.ticket_type, SUM(Date_Tkt_CP.Total_Opex) AS Operating_Expense
        FROM
        (
            SELECT Ride_Cust_Count.date_reserved,Ride_Cust_Count.ticket_type,Ride_Cust_Count.customer_freq,Ride_Details.Ride_ID, Ride_Details.opex_per_unit, Ride_Cust_Count.customer_freq*Ride_Details.opex_per_unit AS Total_Opex
            FROM
            (
                SELECT Reservations.date_reserved, Reservations.ticket_type, Reservation_Details.ride_id, count(*) AS customer_freq
                FROM Reservation_Details
                JOIN Reservations ON Reservations.reservation_id = Reservation_Details.reservation_id
                GROUP BY Reservations.date_reserved,  Reservations.ticket_type, Reservation_Details.ride_id
            ) Ride_Cust_Count
            JOIN Ride_Details
            ON Ride_Cust_Count.Ride_ID = Ride_Details.Ride_ID
        ) Date_Tkt_CP
        GROUP BY Date_Tkt_CP.date_reserved, Date_Tkt_CP.ticket_type
    ) Expense_Table ON (Revenue_Table.date_reserved = Expense_Table.date_reserved) AND (Revenue_Table.ticket_type=Expense_Table.ticket_type)
);

COMMIT;
SELECT * FROM Daily_Profits;