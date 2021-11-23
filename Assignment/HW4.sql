--Question 1--
SELECT COUNT(*) AS count_of_customers, MIN(stay_credits_earned) AS min_credits, MAX(stay_credits_earned) AS max_credits
FROM customer;

--Question 2--
--SELECT c.customer_id, count(r.reservation_id) AS Number_of_Reservations, MIN(r.check_in_date) AS earliest_check_in
--FROM customer c, reservation r
--WHERE c.customer_id = r.customer_id
--GROUP BY c.customer_id
--ORDER BY Number_of_Reservations DESC;

SELECT c.customer_id, count(r.reservation_id) AS Number_of_Reservations, MIN(r.check_in_date) AS earliest_check_in
FROM customer c
INNER JOIN reservation r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY Number_of_Reservations DESC;

--Question 3--
SELECT city, state, ROUND(AVG(stay_credits_earned)) AS avg_credits_earned
FROM customer
GROUP BY city, state
ORDER BY state ASC, avg_credits_earned DESC;

--Question 4--
SELECT c.customer_id, c.last_name, room.room_number, COUNT(r.reservation_id) AS stay_count
FROM customer c
JOIN reservation r ON c.customer_id = r.customer_id
JOIN reservation_details rd ON r.reservation_id = rd.reservation_id
JOIN room ON rd.room_id = room.room_id
WHERE r.location_id = 1
GROUP BY c.customer_id,c.last_name, room.room_number
ORDER BY c.customer_id ASC, stay_count DESC;

--Question 5--
SELECT c.customer_id, c.last_name, room.room_number, COUNT(r.reservation_id) AS stay_count
FROM customer c
JOIN reservation r ON c.customer_id = r.customer_id
JOIN reservation_details rd ON r.reservation_id = rd.reservation_id
JOIN room ON rd.room_id = room.room_id
WHERE r.status = 'C' AND r.location_id = 1
GROUP BY c.customer_id,c.last_name, room.room_number
HAVING COUNT(r.reservation_id)>2
ORDER BY c.customer_id ASC, stay_count DESC;

--Question 6a--
SELECT l.location_name, r.check_in_date, SUM(r.number_of_guests)
FROM location l
INNER JOIN reservation r ON l.location_id = r.location_id
WHERE r.status = 'U' AND r.check_in_date > SYSDATE
GROUP BY ROLLUP (l.location_name, r.check_in_date)
ORDER BY l.location_name;

-- Question 6b--
-- The ROLLUP operator is an extension on the GROUP BY which allows to group by on multiple levels of hierarchies and aggregate the values of columns based on this hierarchy
-- However, the CUBE operator, similar to ROLLUP, does the same aggregation based on all columns in the hierarchy.
-- In part 6a, if CUBE was used, subtotal grouped by check_in_date would also be calculated (ROLLUP calculates subtotal only based on location_name). 
-- Thus, CUBE allows us to calculate aggregations based on all fields involved in the GROUP BY clause

-- Sample query (not required for assignment)
SELECT l.location_name, r.check_in_date, SUM(r.number_of_guests)
FROM location l
INNER JOIN reservation r ON l.location_id = r.location_id
WHERE r.status = 'U' AND r.check_in_date > SYSDATE
GROUP BY CUBE (l.location_name, r.check_in_date)
ORDER BY l.location_name;

--Question 7--
SELECT f.feature_name, COUNT(lf.location_id) AS count_of_locations
FROM features f
INNER JOIN location_features_linking lf ON f.feature_id = lf.feature_id
GROUP BY f.feature_name
HAVING COUNT(lf.location_id) > 2;

--Question 8--
SELECT DISTINCT 
    customer_id, first_name, last_name, email
FROM    
    customer 
WHERE 
    customer_id NOT IN (SELECT DISTINCT customer_id FROM reservation); 

--Question 9--
SELECT 
    first_name, last_name, email, phone,stay_credits_earned
FROM 
    customer
WHERE 
    stay_credits_earned > (SELECT AVG(stay_credits_earned) FROM customer)
ORDER BY 
    stay_credits_earned desc;


--Question 10a-- assumption: displaying state before city to enhance hierarchial readibility 
SELECT 
    state, city, sum(stay_credits_earned) as total_earned, sum(stay_credits_used) as total_used
FROM 
    customer
GROUP BY
    state, city
ORDER BY
    state, city;
    
--Question 10b--
SELECT 
    state, city, (total_earned - total_used) as credits_remaining
FROM (
    SELECT 
        state, city, sum(stay_credits_earned) as total_earned, sum(stay_credits_used) as total_used
    FROM 
        customer
    GROUP BY
        state, city
    ORDER BY
        state, city
    )
ORDER BY
    credits_remaining desc;
    
--Question 11--
SELECT
    r.confirmation_nbr, r.date_created, r.check_in_date, r.status, rd.room_id
FROM
    reservation r JOIN reservation_details rd
        ON r.reservation_id = rd.reservation_id
WHERE
    rd.room_id IN
    (
    SELECT DISTINCT
        room_id 
    FROM
        reservation_details
    GROUP BY
        room_id
    HAVING
        count(reservation_id) < 5    
    )
    AND r.status <> 'C';
    
--Question 12--
SELECT 
    cp.cardholder_first_name, cp.cardholder_last_name, cp.card_number, cp.expiration_date, cp.cc_id
FROM
    ( 
    SELECT 
        distinct c.customer_id
    FROM
        customer c JOIN reservation r
            ON c.customer_id = r.customer_id
    WHERE
        r.status = 'C' 
    GROUP BY
        c.customer_id
    HAVING 
        count(r.reservation_id) = 1
    ) a
    
JOIN customer_payment cp
    ON a.customer_id = cp.customer_id
WHERE 
    cp.card_type = 'MSTR';
    
    
        


