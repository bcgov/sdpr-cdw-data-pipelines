with
a as
(select * from cdw.em_appointment_status_d minus select * from cdw.em_appointment_status_d@cwp_link),
b as
(select * from cdw.em_appointment_status_d@cwp_link minus select * from cdw.em_appointment_status_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.or_location_d minus select * from cdw.or_location_d@cwp_link),
b as
(select * from cdw.or_location_d@cwp_link minus select * from cdw.or_location_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_employee_status_d minus select * from cdw.em_employee_status_d@cwp_link),
b as
(select * from cdw.em_employee_status_d@cwp_link minus select * from cdw.em_employee_status_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_position_d minus select * from cdw.em_position_d@cwp_link),
b as
(select * from cdw.em_position_d@cwp_link minus select * from cdw.em_position_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_bu_security_d minus select * from cdw.em_bu_security_d@cwp_link),
b as
(select * from cdw.em_bu_security_d@cwp_link minus select * from cdw.em_bu_security_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_job_class_d minus select * from cdw.em_job_class_d@cwp_link),
b as
(select * from cdw.em_job_class_d@cwp_link minus select * from cdw.em_job_class_d)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_efp_fte_f minus select * from cdw.em_efp_fte_f@cwp_link),
b as
(select * from cdw.em_efp_fte_f@cwp_link minus select * from cdw.em_efp_fte_f)
select 'this env' env, a.* from a union select 'prod' env, b.* from b
;

with
a as
(select * from cdw.em_fte_burn_f minus select * from cdw.em_fte_burn_f@cwp_link),
b as
(select * from cdw.em_fte_burn_f@cwp_link minus select * from cdw.em_fte_burn_f),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select *
from c
order by pay_end_dt_sk desc, emplid, env
;
