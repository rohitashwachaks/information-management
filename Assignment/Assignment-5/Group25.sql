SET SERVEROUTPUT ON;
SET DEFINE ON;

--------Question1--------------

DECLARE
  count_reservations NUMBER;
BEGIN
  SELECT COUNT(customer_id)
  INTO count_reservations
  FROM RESERVATION 
  WHERE customer_id = 100002;

  IF count_reservations > 15 THEN
    DBMS_OUTPUT.PUT_LINE('The customer has placed more than 15 reservations.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The customer has placed 15 or fewer reservations.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured in the script');
END;
/

DELETE
from reservation_details
where reservation_id = 318;


DELETE
from reservation
where reservation_id = 318;

ROLLBACK;

--------Question2--------------

DECLARE
    customer_id_value NUMBER;
    count_reservations NUMBER;
BEGIN
    customer_id_value := &customer_id;
    -- Use a bind variable in a SELECT statement
    SELECT
        COUNT(reservation_id)
    INTO
        count_reservations
    FROM
        reservation
    WHERE
        customer_id = customer_id_value;
    
    IF count_reservations > 15 THEN
        DBMS_OUTPUT.PUT_LINE('The customer ' || customer_id_value || ' has placed more than 15 reservations.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The customer ' || customer_id_value || ' has placed 15 or fewer reservations.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END;
/

--------Question3-------------

BEGIN  
  Insert into CUSTOMER (CUSTOMER_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,ADDRESS_LINE_1,ADDRESS_LINE_2,CITY,STATE,ZIP,BIRTHDATE,STAY_CREDITS_EARNED,STAY_CREDITS_USED) 
  values (customer_id_seq.nextval,'Sanya','Mirza','Sanyamirza@gmail.com','555-334-2211','3 West Avenue','Apt 2C','San Marcos','TX','78748',to_date('08-NOV-99','DD-MON-RR'),1,0);

  DBMS_OUTPUT.PUT_LINE('1 row inserted into the table.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
    DBMS_OUTPUT.PUT_LINE(SQLERRM); ----
    
Commit; 

END;
/

----Question4----

DECLARE
  TYPE feature_table      IS TABLE OF VARCHAR(40);
  f_names          feature_table;
BEGIN
  SELECT feature_name
  BULK COLLECT INTO f_names
  FROM features
  WHERE feature_name like  'P%'
  ORDER BY feature_name;

  FOR i IN 1..f_names.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Hotel feature ' || i || ': ' || f_names(i));
  END LOOP;
END;
/

----Question5----

DECLARE
    city_value VARCHAR2(100);
    CURSOR features_cursor IS --declare a variable for cursor
        SELECT 
            l.location_name, l.city, f.feature_name
        FROM
            LOCATION l
            JOIN LOCATION_FEATURES_LINKING lf ON l.location_id = lf.location_id
            JOIN FEATURES f ON lf.feature_id = f.feature_id
        ORDER BY 
            l.location_name, l.city, f.feature_name;
    features_row features_cursor%ROWTYPE; --declare a variable for each row
BEGIN
    city_value := '&city';
    FOR features_row IN features_cursor LOOP --for each row in the dataset
        IF features_row.city = city_value THEN
            DBMS_OUTPUT.PUT_LINE(features_row.location_name || ' in ' || features_row.city || ' has feature: ' || features_row.feature_name);
        END IF;
    END LOOP;
END;
/

----Question6----

CREATE OR REPLACE PROCEDURE insert_customer
(
    first_name  customer.first_name%TYPE,
    last_name   customer.last_name%TYPE,
    email_id    customer.email%TYPE,
    phone       customer.phone%TYPE,
    add_line1   customer.address_line_1%TYPE,
    city        customer.city%TYPE,
    state_code  customer.state%TYPE,
    zip_code    customer.zip%TYPE
)
AS
BEGIN
    Insert into CUSTOMER(
        CUSTOMER_ID
        ,FIRST_NAME
        ,LAST_NAME
        ,EMAIL
        ,PHONE
        ,ADDRESS_LINE_1
        ,CITY
        ,STATE
        ,ZIP
    ) 
    values (
        customer_id_seq.nextval
        ,first_name
        ,last_name
        ,email_id
        ,phone
        ,add_line1
        ,city
        ,state_code
        ,zip_code
    );
    DBMS_OUTPUT.PUT_LINE('1 row inserted into the table.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK; 
END;
/

CALL insert_customer ('Joseph', 'Lee', 'jo12@yahoo.com', '773-222-3344', 'Happy street', 'Chicago', 'Il', '60602');
BEGIN
Insert_customer ('Mary', 'Lee', 'jo34@yahoo.com', '773-222-3344', 'Happy street', 'Chicago', 'Il', '60602');
END;
/  

SELECT * 
FROM customer
WHERE customer.first_name IN ('Mary','Joseph');

----Question7----

CREATE OR REPLACE FUNCTION hold_count
    (
        customer_id_val NUMBER
    )
    RETURN NUMBER
AS
    total_rooms NUMBER;
BEGIN
    SELECT
        COUNT(ROOM_ID)
    INTO 
        total_rooms
    FROM
        RESERVATION_DETAILS rd
    JOIN RESERVATION r ON rd.reservation_id = r.reservation_id
    WHERE
        r.customer_id = customer_id_val;
    
    RETURN total_rooms;
END;
/

SELECT
    customer_id, hold_count(customer_id)
FROM
    reservation
GROUP BY customer_id
ORDER BY customer_id;
