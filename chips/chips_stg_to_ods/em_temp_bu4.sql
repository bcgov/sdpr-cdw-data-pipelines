create table ods.em_temp_bu4 as 
    select bu_deptid, min(eff_date) as eff_date 
    from cdw.OR_BUSINESS_UNIT_D 
    group by bu_deptid
;