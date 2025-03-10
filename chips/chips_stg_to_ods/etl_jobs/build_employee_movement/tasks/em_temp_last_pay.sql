truncate table ods.em_temp_last_pay;

insert into ods.em_temp_last_pay
    select max(pay_end_dt) as pay_end_dt 
    from chips_stg.d_date 
    where pay_end_dt<sysdate
;

commit;