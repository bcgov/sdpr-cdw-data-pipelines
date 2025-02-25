with
a as (
(select * from cdw.em_appointment_status_d minus select * from cdw.em_appointment_status_d@cwp_link)
union
(select * from cdw.em_appointment_status_d@cwp_link minus select * from cdw.em_appointment_status_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.or_location_d minus select * from cdw.or_location_d@cwp_link)
union
(select * from cdw.or_location_d@cwp_link minus select * from cdw.or_location_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_employee_status_d minus select * from cdw.em_employee_status_d@cwp_link)
union
(select * from cdw.em_employee_status_d@cwp_link minus select * from cdw.em_employee_status_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_position_d minus select * from cdw.em_position_d@cwp_link)
union
(select * from cdw.em_position_d@cwp_link minus select * from cdw.em_position_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_bu_security_d minus select * from cdw.em_bu_security_d@cwp_link)
union
(select * from cdw.em_bu_security_d@cwp_link minus select * from cdw.em_bu_security_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_job_class_d minus select * from cdw.em_job_class_d@cwp_link)
union
(select * from cdw.em_job_class_d@cwp_link minus select * from cdw.em_job_class_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_paycode_d minus select * from cdw.em_paycode_d@cwp_link)
union
(select * from cdw.em_paycode_d@cwp_link minus select * from cdw.em_paycode_d)
)
select count(*) from a
;

with
a as (
(select * from cdw.em_stiip_f minus select * from cdw.em_stiip_f@cwp_link)
union
(select * from cdw.em_stiip_f@cwp_link minus select * from cdw.em_stiip_f)
)
select count(*) from a
;
