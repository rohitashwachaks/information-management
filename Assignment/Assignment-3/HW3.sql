--Question 1--
SELECT 
    cardholder_first_name,
    cardholder_last_name,
    card_type,
    expiration_date
FROM 
    customer_payment
ORDER BY
    expiration_date ASC;
    
--Question 2--
SELECT 
    CONCAT(CONCAT(first_name , ' ') ,last_name) AS customer_full_name
FROM 
    customer
WHERE
    SUBSTR(first_name,1,1) IN ('A','B','C')
ORDER BY last_name DESC;
    
--QUESTION 3--
SELECT
    customer_id,
    confirmation_nbr,
    date_created, 
    check_in_date, 
    number_of_guests
FROM 
    reservation
WHERE 
    status = 'U' AND
    check_in_date >= SYSDATE AND check_in_date <= '31-DEC-21';

--QUESTION 4--

--PART A--
SELECT
    customer_id,
    confirmation_nbr,
    date_created, 
    check_in_date,
    number_of_guests
FROM 
    reservation
WHERE 
    status = 'U' AND
    check_in_date BETWEEN SYSDATE and '31-DEC-21';
    
--PART B--
SELECT
    customer_id, 
    confirmation_nbr,
    date_created, 
    check_in_date,
    number_of_guests
FROM 
    reservation
WHERE 
    status = 'U' AND
    check_in_date >= SYSDATE AND check_in_date <= '31-DEC-21'
MINUS
SELECT
    customer_id, 
    confirmation_nbr, 
    date_created, 
    check_in_date,
    number_of_guests
FROM 
    reservation
WHERE 
    status = 'U' AND
    check_in_date BETWEEN SYSDATE AND '31-DEC-21';


--QUESTION 5--
SELECT 
    customer_id, 
    location_id, 
    (check_out_date-check_in_date) AS length_of_stay
FROM 
    reservation
WHERE 
    status = 'C' and rownum<=10
ORDER BY
    length_of_stay desc, customer_id ASC;

-- QUESTION 6 --
SELECT
    first_name,
    last_name, 
    email, 
    (stay_credits_earned - stay_credits_used) AS credits_available
FROM 
    customer
WHERE 
    (stay_credits_earned - stay_credits_used) >= 10
ORDER BY
    credits_available;



-- QUESTION 7 --
SELECT
    cardholder_first_name, 
    cardholder_mid_name,
    cardholder_last_name
FROM 
    customer_payment
WHERE 
    cardholder_mid_name IS NOT NULL
ORDER BY 
    2, 3 asc;

-- QUESTION 8 --
SELECT 
    SYSDATE AS today_unformatted,
    TO_CHAR ( SYSDATE, 'fmMM/DD/YYYY') AS today_formatted,
    25 AS Credits_Earned,
    25/10 AS Stays_Earned,
    FLOOR(25/10) AS Redeemable_stays,
    ROUND(25/10) AS Next_Stay_to_earn
FROM
    DUAL;

-- QUESTION 9 --
SELECT 
    customer_id, 
    location_id , 
    (check_out_date-check_in_date) as length_of_stay
FROM
    reservation
WHERE 
    status = 'C' 
    AND location_id = 2
ORDER BY 
    length_of_stay DESC, 
    customer_id ASC
FETCH FIRST 20 ROWS ONLY;

-- QUESTION 10 --
SELECT 
    first_name,
    last_name, 
    confirmation_nbr,
    date_created, 
    check_in_date, 
    check_out_date
FROM 
    customer
INNER JOIN reservation ON reservation.customer_id = customer.customer_id
ORDER BY 
    customer.customer_id ASC, 
    reservation.check_out_date DESC;

-- QUESTION 11 --
SELECT 
    customer.first_name || ' ' || customer.last_name AS name,
    reservation.location_id, 
    confirmation_nbr, 
    check_in_date, 
    room_number
FROM 
    customer
INNER JOIN reservation ON reservation.customer_id = customer.customer_id
INNER JOIN reservation_details ON reservation_details.reservation_id = reservation.reservation_id
INNER JOIN room ON room.room_id = reservation_details.room_id
WHERE
    reservation.status = 'U'
    AND customer.stay_credits_earned > 40;
    
-- QUESTION 12 --
SELECT 
    first_name, 
    last_name,
    confirmation_nbr,
    date_created,
    check_in_date,
    check_out_date
FROM 
    customer
LEFT OUTER JOIN reservation ON reservation.customer_id = customer.customer_id
WHERE reservation.reservation_id IS NULL;

-- QUESTION 13 --
SELECT 
    first_name, 
    last_name, 
    email, 
    stay_Credits_earned, 
    CASE WHEN stay_credits_earned < 10 THEN '1-Gold Member'
        WHEN stay_credits_earned >= 10 AND stay_credits_earned < 40 THEN '2-Platinum Member'
       ELSE '3-Diamond Club' 
    END AS status_level
FROM
    customer
ORDER BY 1,3;