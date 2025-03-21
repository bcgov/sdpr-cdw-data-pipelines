-- check: the range of pay end dates
-- excpect: the range specified in the table build task
select min(pay_end_dt_sk), max(pay_end_dt_sk) from cdw.em_fte_burn_f;

-- check: each employee has only one record per pay end dt
-- excpect: no results
select emplid, pay_end_dt_sk, count(*)
from cdw.em_fte_burn_f 
group by emplid, pay_end_dt_sk
having count(*) != 1
order by count(*) desc
;

-- check: every records has a value for appointment_status_sid
-- expect: 0
select count(*)
from cdw.em_fte_burn_f 
where appointment_status_sid is null
;

-- check: every records has a value for location_sid
-- expect: 0
select count(*)
from cdw.em_fte_burn_f 
where location_sid is null
;

-- check: every records has a value for empl_status_sid
-- expect: 0
select count(*)
from cdw.em_fte_burn_f 
where empl_status_sid is null
;

-- check: every records has a value for position_sid
-- expect: 0
select count(*)
from cdw.em_fte_burn_f 
where position_sid is null
;

-- check: every records has a value for job_class_sid
-- expect: 0
select *--count(*)
from cdw.em_fte_burn_f 
where job_class_sid is null
;

-- check: every records has a value for bu_sid
-- expect: 0
select count(*)
from cdw.em_fte_burn_f 
where bu_sid is null
;
