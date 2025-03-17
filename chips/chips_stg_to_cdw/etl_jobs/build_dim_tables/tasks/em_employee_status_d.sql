truncate table cdw.em_employee_status_d;

insert into cdw.em_employee_status_d
    with
    src_data as (
        select
            x.fieldvalue empl_status,
            x.xlatlongname descr,
            to_char(x.effdt, 'yyyy-mm-dd hh24:mi:ss') effdt,
            decode(
                x.fieldvalue,
                'A','All Active',
                'L','All Active',
                'P','All Active',
                'S','All Active',
                'D','All Non-Active',
                'R','All Non-Active',
                'T','All Non-Active',
                'UNKNOWN'
            ) status_grp
        from chips_stg.psxlatitem x
        where x.fieldname = 'EMPL_STATUS'
            and x.eff_status = 'A'
            and x.effdt = (
                select max(x2.effdt) 
                from chips_stg.psxlatitem x2
                where x2.fieldname = x.fieldname
                    and x2.fieldvalue = x.fieldvalue
                    and x2.effdt <= sysdate
            )
    )
    select s.*, 
        row_number() over (order by effdt) empl_status_sid
    from src_data s
    order by empl_status_sid
; 

commit;