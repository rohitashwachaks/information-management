--Q1
DROP TABLE members;
CREATE TABLE members
(
    uteid       VARCHAR(20),
    first_name  VARCHAR(30) NOT NULL,
    last_name   VARCHAR(40) NOT NULL,
    email       VARCHAR(40) NOT NULL,
    phone       VARCHAR(12) NOT NULL,
    grade       NUMBER(1)   NOT NULL,
    birthdate   DATE        NOT NULL,
    CONSTRAINT members_pk PRIMARY KEY (uteid)
);
INSERT INTO members
VALUES ('jst333', 'Jason', 'Smith', '@gmail.com', '817', 2, '12-FEB-2000');

--Q2
DROP TABLE committees;
CREATE TABLE committees
(
    committee_id    NUMBER(5)   PRIMARY KEY,
    committee_name  VARCHAR(30) NOT NULL,
    semester_year   VARCHAR(4)  NOT NULL
);
INSERT INTO committees
VALUES (12345, 'Data Club', '2000');

--Q3
CREATE TABLE members_committees
(
    uteid           VARCHAR(20),
    committee_id    NUMBER(5),
    CONSTRAINT members_committees_pk PRIMARY KEY (uteid, committee_id),
    CONSTRAINT members_committees_fk1 FOREIGN KEY (uteid) REFERENCES members (uteid),
    CONSTRAINT members_committees_fk2 FOREIGN KEY (committee_id) REFERENCES committees (committee_id)
);

--Q4 - Cannot insert two members with same uteid or two committees with same id
INSERT INTO members
VALUES ('jst333', 'Joe', 'Bob', '@gmail.com', '817', 2, '03-MAR-2001');
INSERT INTO committees
VALUES (12345, 'Data 2', '2000');

--Q5
ALTER TABLE members
ADD CONSTRAINT grade_ck CHECK (grade > 0);

--Violates check constraint, with negative grade
INSERT INTO members
VALUES ('jtl111', 'Joe', 'Bob', '@gmail.com', '817', -1, '05-JAN-2002');

--- Q6
ALTER TABLE members
ADD CONSTRAINT grade_ck2 CHECK (grade = 1 OR grade = 2 OR grade = 3 OR grade = 4);

--Violates check constraint with grade = 5
INSERT INTO members
VALUES ('qq', 'Joe', 'Bob', '@gmail.com', '817', 5, '10-APR-2005');

--Q7
ALTER TABLE members
RENAME COLUMN phone TO phone_num;

--Q8
ALTER TABLE members
ADD CONSTRAINT email_un UNIQUE (email);

--Q9
ALTER TABLE members
MODIFY uteid VARCHAR(10);

--Q10
ALTER TABLE members
MODIFY phone_num CHAR(12);

--Q11
ALTER TABLE committees
ADD status VARCHAR(10);

ALTER TABLE committees
MODIFY status DEFAULT 'active';

INSERT INTO committees
VALUES (56789, 'hello club', '2001', DEFAULT);

--Q12
ALTER TABLE committees
MODIFY status VARCHAR(1);

ALTER TABLE committees
MODIFY status DEFAULT 'A';

ALTER TABLE committees
ADD CONSTRAINT status_chk CHECK (status = 'A' OR status = 'I');

--Q13
RENAME members TO allmembers;

--Q14
TRUNCATE TABLE invoices;

--Q15
DROP TABLE invoices;

--Q16
ALTER TABLE allmembers
DROP CONSTRAINT email_un;

--Q17
ALTER TABLE allmembers
DROP COLUMN birthdate;

--Q18 Done through SQL Developer GUI



