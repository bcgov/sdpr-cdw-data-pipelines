create table ods.em_temp_q1 as (
    select distinct emplid 
    from chips_stg.ps_job 
    where business_unit='BC031' 
        and effdt < (select pay_end_dt from ods.em_temp_last_pay)
);

commit;