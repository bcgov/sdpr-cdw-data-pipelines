with 
thedata as (
    select emplid, "NAME", pay_end_dt, pay_end_dt - 13 PAY_START_DT,
        row_number() over (partition by emplid 
            order by off_cycle, update_dt desc, pay_sheet_src desc, paycheck_nbr desc
        ) rnk
    from chips_stg.ps_pay_check  
    WHERE PAY_END_DT = (
        select pay_end_dt pay_period_end_date
        from chips_stg.ps_pay_calendar
        where pay_end_dt = (
            select max(pay_end_dt)
            from chips_stg.ps_pay_calendar
            where pay_end_dt <= current_date
                and pay_off_cycle_cal = 'N'
                and paygroup = 'STD'
                and trim(run_id) is not null
        )
    )
)
select emplid, "NAME", pay_end_dt, PAY_START_DT
from thedata 
where rnk = 1
ORDER BY 1
;