--Questions 1 to 3
select  count(*)
        ,sum(invoice_total)
        ,round(avg(invoice_total),2)
        ,min(invoice_total)
        ,round(max(invoice_total),0)
        ,count(distinct vendor_id)
from invoices;




-- Question 4.  Sum of an expression
SELECT	COUNT(*) AS number_of_invoices,
    	SUM(invoice_total) AS sum_of_invoice_totals,
        SUM(invoice_total - payment_total - credit_total) as amount_due
FROM 	invoices;





-- Question 5.  Sum of an expression
SELECT	COUNT(*) AS number_of_invoices,
  	    SUM(invoice_total) AS sum_of_invoice_totals,
        SUM(invoice_total - payment_total - credit_total) as amount_due
FROM 	invoices
WHERE   invoice_date >= '15-FEB-2021';





-- 6
select vendor_state, count(vendor_state)
from vendors
group by vendor_state   
order by vendor_state;


-- 7 to 10
select  vendor_state, vendor_city,
        count(vendor_state)
from vendors
where vendor_state <> 'CA'
group by vendor_state, vendor_city
having count(vendor_state) > 1
order by count(vendor_state) desc;



--11 and 12
select vendor_state, vendor_city, count(vendor_id)
from vendors
group by ROLLUP(vendor_state, vendor_city) 
order by vendor_state;

--13 CUBE
select vendor_state, vendor_city, count(vendor_id)
from vendors
group by CUBE(vendor_state, vendor_city) 
order by vendor_state;



-- 14 Starter code to use to compare HAVING vs WHERE
SELECT vendor_name, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total),2) AS invoice_avg
FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
GROUP BY vendor_name
HAVING AVG(invoice_total) > 500 --aggregate filter
ORDER BY invoice_qty DESC;
 
SELECT vendor_name, COUNT(*) AS invoice_qty,
    ROUND(AVG(invoice_total),2) AS invoice_avg
FROM vendors JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total > 500   --row level filter
GROUP BY vendor_name
ORDER BY invoice_qty DESC;
 

--15---  Do this on your own


--16 & 17 Extra practice
SELECT  MIN(vendor_name) AS first_vendor,
        MAX(vendor_name) AS last_vendor,
        COUNT(vendor_name) AS number_of_vendors
        --,AVG(vendor_name)
FROM vendors;



---18.  Window Function
SELECT  DISTINCT vendor_state, 
        vendor_city, 
        COUNT(*) OVER (PARTITION BY vendor_state, vendor_city) AS invoice_qty, 
        SUM(invoice_total) OVER (PARTITION BY vendor_state, vendor_city) AS invoice_sum
FROM invoices JOIN vendors ON invoices.vendor_id = vendors.vendor_id
ORDER BY vendor_state, vendor_city;
 

