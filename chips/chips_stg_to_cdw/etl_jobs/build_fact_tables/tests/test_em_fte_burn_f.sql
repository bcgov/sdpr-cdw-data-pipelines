-- check: the range of pay end dates
-- excpect: the range specified in the table build task
select min(pay_end_dt_sk), max(pay_end_dt_sk) from cdw.em_fte_burn_f;

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

select * 
from cdw.em_employee_d
where name like '&employee_name_to_lookup%'
;

select * 
from cdw.em_fte_burn_f f
left join cdw.em_appointment_status_d a on a.appt_status_sid = f.appointment_status_sid
left join cdw.or_location_d using(location_sid)
left join cdw.em_position_d using(position_sid)
left join cdw.em_employee_d using(emplid)
left join cdw.em_job_class_d j on j.jobclass_sid = f.job_class_sid
left join cdw.or_business_unit_d using(bu_sid)
where emplid = &enter_an_emplid
order by pay_end_dt_sk desc
;

select * 
from cdw.em_stiip_f f
left join cdw.em_appointment_status_d a on a.appt_status_sid = f.appointment_status_sid
left join cdw.or_location_d using(location_sid)
left join cdw.em_employee_status_d using(empl_status_sid)
left join cdw.em_position_d using(position_sid)
left join cdw.or_business_unit_d using(bu_sid)
left join cdw.em_employee_d using(emplid)
left join cdw.em_job_class_d j using (jobclass_sid)
left join cdw.em_paycode_d using(paycode_sid)
where emplid = &enter_an_emplid
order by pay_end_dt_sk desc
;