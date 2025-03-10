truncate table ods.em_temp_fte_burn2;

insert into ods.em_temp_fte_burn2
    select distinct emplid, business_unit, pay_end_dt, empl_name, job_function 
    from CHIPS_STG.PS_TGB_FTEBURN_TBL 
    where emplid||business_unit||to_char(pay_end_dt,'YYYYMMDD') in (
        select emplid||business_unit||pay_end_dt 
        from ods.em_temp_fte_burn1
    )
;

commit;