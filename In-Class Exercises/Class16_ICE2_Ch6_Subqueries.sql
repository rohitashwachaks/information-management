-----------------------------------------------------------------
-------------------  INTRO TO SUBQUERIES ------------------------
-----------------------------------------------------------------

--1 Select statement that uses a subquery in the WHERE clause
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total > 
    (SELECT AVG(invoice_total)
     FROM invoices)
ORDER BY invoice_total;




-----------------------------------------------------------------
----------------  Subqueries compared to Joins ------------------
-----------------------------------------------------------------

--2a Query that uses an inner join
SELECT invoice_number, invoice_date, invoice_total
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = 'CA'
ORDER BY invoice_date;

--2b same query restated with a subquery
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN
    (SELECT vendor_id
    FROM vendors
    WHERE vendor_state = 'CA')
ORDER BY invoice_date;



-----------------------------------------------------------------
-------------- Code Subqueries in search conditions  ------------
-----------------------------------------------------------------

--3a query that returns vendors without invoices
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id NOT IN
    (SELECT DISTINCT vendor_id
    FROM invoices)
ORDER BY vendor_id;

--3b query restated without a subquery
SELECT v.vendor_id, vendor_name, vendor_state
FROM vendors v LEFT JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE i.vendor_id IS NULL
ORDER BY v.vendor_id;



--4 comparing results of subquery with an expression
SELECT invoice_number, invoice_date, 
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices
WHERE invoice_total - payment_total - credit_total  > 0 
    AND invoice_total - payment_total - credit_total <
    (
    SELECT AVG(invoice_total - payment_total - credit_total)
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0
    )
ORDER BY invoice_total DESC;


 







-- Using the ALL keyword
-- 5 query that returns invoices larger than largest invoice for vendor 34 using ALL
SELECT vendor_name, invoice_number, invoice_total
FROM invoices i JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE invoice_total > ALL
    (SELECT invoice_total
    FROM invoices
    WHERE vendor_id = 34)
ORDER BY vendor_name;
 


-- Using the ANY and SOME keywords
--6 query that returns invoice amounts smaller than the largest invoice amount for vendor 115
SELECT vendor_name, invoice_number, invoice_total
FROM vendors JOIN invoices ON vendors.vendor_id = invoices.invoice_id
WHERE invoice_total < ANY   --TIP: try using SOME instead of ANY
    (SELECT invoice_total
    FROM invoices
    WHERE vendor_id = 115);

 




-----------------------------------------------------------------
------------------ Other ways to use subqueries  ----------------
-----------------------------------------------------------------

--9 How to code a subquery in the FROM
SELECT  i.vendor_id, MAX(invoice_date) AS last_invoice_date,
    AVG(invoice_total) AS average_invoice_total
FROM invoices i JOIN
    (
    SELECT vendor_id, AVG(invoice_total) AS average_invoice_total
    FROM invoices
    HAVING AVG(invoice_total) > 4900
    GROUP BY vendor_id
    ) v
    ON i.vendor_id = v.vendor_id
GROUP BY i.vendor_id
ORDER BY MAX(invoice_date) DESC;


 

--10 How to code subqueries in the SELECT clause
--************************************
SELECT  vendor_name,
        (SELECT MAX(invoice_date) 
        FROM invoices
        WHERE invoices.vendor_id = v.vendor_id) AS latest_inv
FROM vendors v
ORDER BY latest_inv;

--same query restated using a join
SELECT vendor_name, MAX(invoice_date) AS latest_inv
FROM vendors v LEFT JOIN invoices i 
       ON v.vendor_id = i.vendor_id
GROUP BY vendor_name
ORDER BY latest_inv;




--11  Complex query that uses subqueries
SELECT summary1.vendor_state, summary1.vendor_name, top_in_state.sum_of_invoices
FROM
    (
    SELECT v_sub.vendor_state, v_sub.vendor_name,
        SUM(i_sub.invoice_total) AS sum_of_invoices
    FROM invoices i_sub JOIN vendors v_sub
        ON i_sub.vendor_id = v_sub.vendor_id
    GROUP BY v_sub.vendor_state, v_sub.vendor_name
    ) summary1
    JOIN
        (
        SELECT summary2.vendor_state,
            MAX(summary2.sum_of_invoices) AS sum_of_invoices
        FROM
            (
            SELECT v_sub.vendor_state, v_sub.vendor_name,
                SUM(i_sub.invoice_total) AS sum_of_invoices
            FROM invoices i_sub JOIN vendors v_sub
                ON i_sub.vendor_id = v_sub.vendor_id
            GROUP BY v_sub.vendor_state, v_sub.vendor_name
            ) summary2
        GROUP BY summary2.vendor_state
        ) top_in_state
    ON summary1.vendor_state = top_in_state.vendor_state AND
       summary1.sum_of_invoices = top_in_state.sum_of_invoices
ORDER BY summary1.vendor_state;


 




















 
-----------------------------------
------OUT OF SCOPE FOR CLASS-------
------ Practice is optional -------
-----------------------------------
--7 Correlated Queries   
SELECT vendor_id, invoice_number, invoice_total
FROM invoices inv_main
WHERE invoice_total >
    (SELECT AVG(invoice_total)
    FROM invoices inv_sub
    WHERE inv_sub.vendor_id = inv_main.vendor_id)
ORDER BY vendor_id, invoice_total;


SELECT vendor_id, invoice_number, invoice_total
FROM invoices inv_main
WHERE invoice_total >
    (SELECT AVG(invoice_total)
    FROM invoices)  
ORDER BY vendor_id, invoice_total;

SELECT AVG(invoice_total)
FROM invoices inv_sub
WHERE inv_sub.vendor_id = 95;

 
--8 EXISTS keyword
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE NOT EXISTS
    (SELECT *
    FROM invoices
    WHERE invoices.vendor_id = vendors.vendor_id)
ORDER BY vendor_id;


--13 subquery factoring clause
WITH summary AS
(
    SELECT vendor_state, vendor_name, SUM(invoice_total) AS sum_of_invoices
    FROM invoices 
        JOIN vendors ON invoices.vendor_id = vendors.vendor_id
    GROUP BY vendor_state, vendor_name
),
top_in_state AS
(
    SELECT vendor_state, MAX(sum_of_invoices) AS sum_of_invoices
    FROM summary
    GROUP BY vendor_state
)
SELECT summary.vendor_state, summary.vendor_name, 
    top_in_state.sum_of_invoices
FROM summary JOIN top_in_state
    ON summary.vendor_state = top_in_state.vendor_state AND
       summary.sum_of_invoices = top_in_state.sum_of_invoices
ORDER BY summary.vendor_state;


-- 14 code a hierarchical query
SELECT employee_id,
   first_name || ' ' || last_name AS employee_name,
   LEVEL
FROM employees
START WITH employee_id = 1
CONNECT BY PRIOR employee_id = manager_id
ORDER BY LEVEL, employee_id;