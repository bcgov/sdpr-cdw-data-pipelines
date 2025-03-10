truncate table ods.em_temp_q3;

insert into ods.em_temp_q3
    select * 
    from chips_stg.ps_job 
    where emplid in (select emplid from ods.em_temp_q2)
;

commit;