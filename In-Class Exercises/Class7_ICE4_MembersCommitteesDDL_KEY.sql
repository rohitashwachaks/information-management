

--1. Create members table
CREATE TABLE members
(
    uteid       varchar(20)     primary key,
    first_name  varchar(30),
    last_name   varchar(40),
    email       varchar(40),
    phone       varchar(12),
    grade       number(1),
    birthdate   date
);




--2. Create committees table
CREATE TABLE committees
(
committee_id NUMBER(5) PRIMARY KEY,
committee_name VARCHAR(30),
semester_year VARCHAR(4)
);




--3. Create committees table with composite PK and FKs to parent tables
CREATE TABLE member_committees 
(
        uteid           VARCHAR(20),
        committee_id    NUMBER(5),
        CONSTRAINT   uteid_committtee_pkk        PRIMARY key  (uteid, committee_id),
        CONSTRAINT   uteid_fk                    FOREIGN KEY (UTEID)  REFERENCES  MEMBERS (UTEID),
        CONSTRAINT   COMMITTEEE_fk               FOREIGN KEY (COMMITTEE_id)  REFERENCES  COMMITTEES (COMMITTEE_id)

);


 


--4. Add check constraint to grade
ALTER TABLE members
ADD CONSTRAINT grade_ck CHECK (grade > 0);

--4 Option B.  Drop the table and recreate with check
Drop table members

CREATE TABLE members
(
    uteid       varchar(20)     primary key,
    first_name  varchar(30),
    last_name   varchar(40),
    email       varchar(40),
    phone       varchar(12),
    grade       number(1),
    birthdate   date,
    CONSTRAINT grade_ck CHECK (grade > 0)
);

        
        
    
    
      
 