truncate table ods.em_temp_q2;

insert into ods.em_temp_q2
    select distinct emplid 
    from chips_stg.ps_job 
    where (business_unit='BC031' or emplid in (select emplid from ods.em_temp_q1))
;

commit;