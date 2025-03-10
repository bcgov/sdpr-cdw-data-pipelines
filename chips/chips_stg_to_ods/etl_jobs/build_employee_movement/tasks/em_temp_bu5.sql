truncate table ods.em_temp_bu5;

insert into ods.em_temp_bu5 
    select * 
    from cdw.OR_BUSINESS_UNIT_D 
    where bu_deptid||to_char(eff_date,'YYYYMMDD') in (
        select bu_deptid||to_char(eff_date,'YYYYMMDD') 
        from ods.em_temp_bu4
    )
;

commit;