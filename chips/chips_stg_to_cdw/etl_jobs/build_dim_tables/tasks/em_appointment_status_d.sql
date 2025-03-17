truncate table cdw.em_appointment_status_d; commit;

insert into cdw.em_appointment_status_d
    with
    src_data as (
        select
            distinct j.empl_ctg appointment_status,
            x.descr appt_status_descr,
            x.descrshort appt_descr_short,
            decode(
                j.empl_ctg,
                'K','A',
                'L','A',
                'M','A',
                'U','A',
                j.empl_ctg
            ) appointment_group,
            decode(
                j.empl_ctg,
                'K','Auxiliary',
                'L','Auxiliary',
                'M','Auxiliary',
                'U','Auxiliary',
                x.descr 
            ) appt_group_descr,
            decode(
                j.empl_ctg,
                'K','Aux',
                'L','Aux',
                'M','Aux',
                'U','Aux',
                x.descrshort 
            ) appt_group_descr_short
        from chips_stg.ps_job j
        left join (
            select
                x.labor_agreement,
                x.empl_ctg ,
                x.effdt,
                x.descr,
                x.descrshort
            from chips_stg.ps_empl_ctg_l1 x
            where
                x.effdt = (
                    select max(x2.effdt) 
                    from chips_stg.ps_empl_ctg_l1 x2 
                    where x.empl_ctg = x2.empl_ctg
                        and x.effdt < sysdate
                )
        ) x
            ON j.empl_ctg = x.empl_ctg
        order by appointment_status
    )
    select s.*, rownum appt_status_sid
    from src_data s
; commit;