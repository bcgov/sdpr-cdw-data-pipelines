with 

thedata as (
    select 
        emplid, 
        EMAILID,
    (
        select pay_end_dt pay_period_end_date
        from chips_stg.ps_pay_calendar
        where pay_end_dt = (
            select max(pay_end_dt)
            from chips_stg.ps_pay_calendar
            where pay_begin_dt <= current_date
                and pay_off_cycle_cal = 'N'
                and paygroup = 'STD'
                and trim(run_id) is not null
        )
    ) pay_end_dt,
    (
        select pay_begin_dt pay_period_start_date
        from chips_stg.ps_pay_calendar
        where pay_begin_dt = (
            select max(pay_begin_dt)
            from chips_stg.ps_pay_calendar
            where pay_begin_dt <= current_date
                and pay_off_cycle_cal = 'N'
                and paygroup = 'STD'
                and trim(run_id) is not null
        )
    ) pay_start_dt,
    row_number() over (partition by emplid 
        order by 
            case when upper (OPRDEFNDESC) LIKE '%SDPR%' THEN 1 ELSE 2 END,
            case when upper (EMAILID) LIKE '%.GOV.BC.CA%' THEN 1 ELSE 2 END,
            VERSION DESC, 
            OPRID 
    ) RNK
        from CHIPS_STG.PS_OPRDEFN_BC_TBL WHERE trim(EMPLID) is not null and EMAILID > ' '
)

select emplid, emailid, pay_end_dt, pay_start_dt 
from thedata
where rnk = 1
order by EMPLID
;