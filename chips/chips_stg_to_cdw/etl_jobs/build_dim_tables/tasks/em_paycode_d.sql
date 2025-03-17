truncate table cdw.em_paycode_d; 

insert into cdw.em_paycode_d
    with
    src_data as (
        select 
            pay_cd,
            pay_descr,
            class,
            class_descr,
            code_type,
            reduces_hours_worked
        from chips_stg.paycodes
    )
    select row_number() over (order by pay_cd) paycode_sid, s.*
    from src_data s
; 

commit;