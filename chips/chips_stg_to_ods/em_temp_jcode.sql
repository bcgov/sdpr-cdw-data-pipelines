create table ods.em_temp_jcode as 
    select jobcode, 
        effdt, 
        descr, 
        can_noc_cd, 
        lead(effdt,1,sysdate+1) over (
            partition by jobcode order by jobcode, effdt
        )-1 as effenddt 
    from CHIPS_STG.PS_JOBCODE_TBL
;