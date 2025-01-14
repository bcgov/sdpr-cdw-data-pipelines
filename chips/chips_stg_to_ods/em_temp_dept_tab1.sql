create table ods.em_temp_dept_tab1 as (
    select deptid, max(effdt) as effdt 
    from CHIPS_STG.PS_DEPT_TBL 
    where eff_status='A' 
    group by deptid
);