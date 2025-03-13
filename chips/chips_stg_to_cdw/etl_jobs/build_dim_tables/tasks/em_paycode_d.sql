truncate table cdw.em_paycode_d; commit;

drop sequence cdw.em_paycode_d_seq; commit;

create sequence cdw.em_paycode_d_seq; commit;

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
    select cdw.em_paycode_d_seq.nextval paycode_sid, s.*
    from src_data s
; commit;