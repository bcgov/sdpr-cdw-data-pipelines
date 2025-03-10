truncate table ods.em_temp_dept_tab1;

insert into ods.em_temp_dept_tab1
    select deptid, max(effdt) as effdt 
    from CHIPS_STG.PS_DEPT_TBL 
    where eff_status='A' 
    group by deptid
;

commit;