truncate table ods.em_temp_dept_tab2;

insert into ods.em_temp_dept_tab2
    select deptid, descr 
    from CHIPS_STG.PS_DEPT_TBL 
    where deptid||to_char(effdt,'YYYYMMDD') in (
        select deptid||to_char(effdt,'YYYYMMDD') 
        from ods.em_temp_dept_tab1
    )
;

commit;