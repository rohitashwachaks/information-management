--Create test table for practice
create table vendor_only_ca as
select vendor_name, vendor_address1, vendor_address2, vendor_city, vendor_phone
from vendors
where vendor_state 
= 'CA'
order by vendor_city;




--Use this to SELECT data from table
select * from vendor_only_ca;



--Update records
update vendor_only_ca
set vendor_name = 'Who Cares!?!';

--Rollback changes before commit is done
rollback;
 
--Saves changes and prevents rollback from undoing changes
commit;

--drops table
drop table vendor_only_ca;

-----------------------------------------------------------------------------------

--Insert a new member in the ubc_members table and don’t specify their years_oc
insert into ubc_members (uteid, first_name, last_name, email, phone, birthdate)
values ('tuttlejc', 'Clint', 'Tuttle', 'clinttuttle@email.com', '214-123-4567', '06-AUG-80');

commit;

select * from ubc_members;
select * from ubc_committees;

--Add this member to the “VIP Committee” for SP20
insert into ubc_members_committees
values ('tuttlejc',1);

--Update the first name of the member whose uteid is ieo328.  Update first from Igor to Iggy.    
update ubc_members
set first_name = 'Iggy'
where uteid = 'ieo328';

--Update members phone column to be NULL if their years on council is > 1
update ubc_members
set phone = NULL
where year_oc > 1;

--Update all members - add 1 to their year_oc
update ubc_members
set year_oc = year_oc + 1;

--Delete the new member you added and only that member
delete 
from ubc_members_committees
where uteid = 'tuttlejc';

delete 
from ubc_members
where uteid = 'tuttlejc';

-- delete all members' assigned committes if their years on council are 4
delete 
from ubc_members_committees where uteid in (
select uteid from ubc_members where year_oc = 4);

 
 
--Use this to check if your ubc_members insert worked
select * from ubc_members;

--Use this to check if your ubc_committees insert worked
select * from ubc_committees;

--Use this to check if your ubc_member_committees insert worked
select * from ubc_member_committees;

--Use this to join all tables and confirm inserts work across all tables
Select  m.first_name, c.committee_name, c.semester_year
from    ubc_members m inner join ubc_member_committees mc on m.uteid = mc.uteid 
        inner join ubc_committees c on mc.committee_id = c.committee_id;


-----------------------------------
--BONUS
-----------------------------------
--1 
select vendor_id
from vendors
where vendor_state = 'CA';

--2
update invoices
set invoice_date = '20-FEB-2020'
where vendor_id in (select vendor_id
                    from vendors
                    where vendor_state = 'CA');

--3
delete invoices
where vendor_id in (select vendor_id
                    from vendors
                    where vendor_state = 'CA');
                

 