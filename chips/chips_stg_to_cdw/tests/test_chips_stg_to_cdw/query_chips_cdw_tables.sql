--------------------------------------------------------------------------
-- Dimension Tables
--------------------------------------------------------------------------

select * from cdw.em_appointment_status_d;
select * from cdw.em_bu_security_d;
select * from cdw.em_employee_d;
select * from cdw.em_employee_status_d;
select * from cdw.em_job_class_d;
select * from cdw.em_paycode_d;
select * from cdw.em_position_d;
select * from cdw.em_userid_to_emplid_xref_d;
select * from cdw.or_business_unit_d;
select * from cdw.or_location_d;

--------------------------------------------------------------------------
-- Fact Tables
--------------------------------------------------------------------------

select * from cdw.em_efp_fte_f;
select * from cdw.em_fte_burn_f;
select * from cdw.em_stiip_f;