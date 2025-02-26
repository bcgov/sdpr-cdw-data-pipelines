-- dimension tables
truncate table cdw.em_appointment_status_d;
truncate table cdw.em_bu_security_d;
truncate table cdw.em_employee_d;
truncate table cdw.em_employee_status_d;
truncate table cdw.em_job_class_d;
truncate table cdw.em_paycode_d;
truncate table cdw.em_position_d;
truncate table cdw.em_userid_to_emplid_xref_d;
truncate table cdw.or_business_unit_d;
truncate table cdw.or_location_d;

-- fact tables
truncate table cdw.em_efp_fte_f;
truncate table cdw.em_fte_burn_f;
truncate table cdw.em_stiip_f;

commit;