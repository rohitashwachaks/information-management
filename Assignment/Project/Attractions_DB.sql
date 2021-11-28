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
DROP TABLE Attraction_Status;

--- Dropping Sequences
DROP SEQUENCE ride_id_sequence;
DROP SEQUENCE vendor_id_sequence;

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
    sector_code       NUMERIC(3,0) PRIMARY KEY,
    description       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Attraction_Status
(
    status_code       CHAR(1) PRIMARY KEY,
    description       VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Ride_Details
(
    ride_id               NUMBER DEFAULT ride_id_sequence.nextval CONSTRAINT ride_id PRIMARY KEY,
    ride_name             VARCHAR(100) NOT NULL UNIQUE,
    ride_type             CHAR(2) NOT NULL CONSTRAINT ride_type_fk REFERENCES type_code (Attraction_Type),
    sector_code           NUMERIC(3,0) NOT NULL CONSTRAINT sector_code_fk REFERENCES sector_code (Sectors),
    start_date            DATE NOT NULL,
    end_date              DATE,
    status_code           CHAR(1) NOT NULL CONSTRAINT status_code_fk REFERENCES status_code (Attraction_Status),
    last_maintainence     DATE,
    next_maintainence     DATE,
    operating_capacity    NUMERIC(2,0) CONSTRAINT capacity_check CHECK (operating_capacity > 0),
    opex_per_unit         NUMERIC(5,2) CONSTRAINT opex_check CHECK (opex_per_unit > 0),

    CONSTRAINT last_maintainence_check CHECK (last_maintainence >= start_date),--AND (next_maintainence < end_date),
    CONSTRAINT next_maintainence_check CHECK (next_maintainence >= last_maintainence)--AND (next_maintainence < end_date),
);

CREATE TABLE Vendor_Details
(
    vendor_id             NUMBER
                            DEFAULT vendor_id_sequence.nextval 
                            CONSTRAINT vendor_id PRIMARY KEY,
    vendor_name           VARCHAR(100) 
                            NOT NULL
                            UNIQUE,
    vendor_type           CHAR(2)
                            NOT NULL
                            CONSTRAINT vendor_type_fk REFERENCES type_code (Attraction_Type),
    sector_code           NUMERIC(3,0)
                            NOT NULL
                            CONSTRAINT sector_code_fk REFERENCES sector_code (Sectors),
    start_date            DATE
                            NOT NULL,
    end_date              DATE,
    status_code           CHAR(1)
                            NOT NULL
                            CONSTRAINT status_code_fk REFERENCES status_code (Attraction_Status),
    contract_renewed      DATE,
    contract_expiring     DATE,
    operating_capacity    NUMERIC(2,0)
                            CONSTRAINT capacity_check CHECK (operating_capacity > 0),
    rent                  NUMERIC(5,2)
                            CONSTRAINT rent_check CHECK (rent > 0),
    commission            NUMERIC(5,2)
                            CONSTRAINT commission CHECK (commission > 0),
    
    CONSTRAINT contract_expiring_check CHECK (contract_expiring > contract_renewed),--AND (next_maintainence < end_date),
    CONSTRAINT contract_renewed_check CHECK (contract_renewed >= start_date)--AND (next_maintainence < end_date),
);

