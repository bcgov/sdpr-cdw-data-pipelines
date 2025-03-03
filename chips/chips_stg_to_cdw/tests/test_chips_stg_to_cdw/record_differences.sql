--------------------------------------------------------------------------
-- Dimension Tables
--------------------------------------------------------------------------

with
a as
(select * from cdw.em_appointment_status_d minus select * from cdw.em_appointment_status_d@cwp_link),
b as
(select * from cdw.em_appointment_status_d@cwp_link minus select * from cdw.em_appointment_status_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by appointment_status, env
;

with
a as
(select * from cdw.em_bu_security_d minus select * from cdw.em_bu_security_d@cwp_link),
b as
(select * from cdw.em_bu_security_d@cwp_link minus select * from cdw.em_bu_security_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by hier_level, env
;

with
a as
(select * from cdw.em_employee_d minus select * from cdw.em_employee_d@cwp_link),
b as
(select * from cdw.em_employee_d@cwp_link minus select * from cdw.em_employee_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by emplid, env
;

with
a as
(select * from cdw.em_employee_status_d minus select * from cdw.em_employee_status_d@cwp_link),
b as
(select * from cdw.em_employee_status_d@cwp_link minus select * from cdw.em_employee_status_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by empl_status, env
;

with
a as
(select * from cdw.em_job_class_d minus select * from cdw.em_job_class_d@cwp_link),
b as
(select * from cdw.em_job_class_d@cwp_link minus select * from cdw.em_job_class_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by jobcode, env
;

with
a as
(select * from cdw.em_paycode_d minus select * from cdw.em_paycode_d@cwp_link),
b as
(select * from cdw.em_paycode_d@cwp_link minus select * from cdw.em_paycode_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c
;

with
a as
(select * from cdw.em_position_d minus select * from cdw.em_position_d@cwp_link),
b as
(select * from cdw.em_position_d@cwp_link minus select * from cdw.em_position_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by position_descr, udt_date desc, env
;

with
a as
(select * from cdw.em_userid_to_emplid_xref_d minus select * from cdw.em_userid_to_emplid_xref_d@cwp_link),
b as
(select * from cdw.em_userid_to_emplid_xref_d@cwp_link minus select * from cdw.em_userid_to_emplid_xref_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by emplid, env
;

with
a as
(select * from cdw.or_business_unit_d minus select * from cdw.or_business_unit_d@cwp_link),
b as
(select * from cdw.or_business_unit_d@cwp_link minus select * from cdw.or_business_unit_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by bu_bk, eff_date, env
;

with
a as
(select * from cdw.or_location_d minus select * from cdw.or_location_d@cwp_link),
b as
(select * from cdw.or_location_d@cwp_link minus select * from cdw.or_location_d),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by setid_loc, eff_dt, env
;

--------------------------------------------------------------------------
-- Fact Tables
--------------------------------------------------------------------------

with
a as
(select * from cdw.em_efp_fte_f minus select * from cdw.em_efp_fte_f@cwp_link),
b as
(select * from cdw.em_efp_fte_f@cwp_link minus select * from cdw.em_efp_fte_f),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c
order by fscl_period_id desc, bu_deptid, env
;

with
a as
(select * from cdw.em_fte_burn_f minus select * from cdw.em_fte_burn_f@cwp_link),
b as
(select * from cdw.em_fte_burn_f@cwp_link minus select * from cdw.em_fte_burn_f),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by pay_end_dt_sk desc, emplid, env
;

with
a as
(select * from cdw.em_stiip_f minus select * from cdw.em_stiip_f@cwp_link),
b as
(select * from cdw.em_stiip_f@cwp_link minus select * from cdw.em_stiip_f),
c as 
(select 'this env' env, a.* from a union select 'prod' env, b.* from b)
select * from c order by pay_end_dt_sk desc, emplid, env
;