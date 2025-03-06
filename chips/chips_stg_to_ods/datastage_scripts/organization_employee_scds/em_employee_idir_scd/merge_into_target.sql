Merge into ods.em_employee_idir_scd target using (
    with 
    latest_load as (
        select pay_begin_dt pay_period_start_date, pay_end_dt pay_period_end_date
        from chips_stg.ps_pay_calendar
        where pay_end_dt = (
            select max(pay_end_dt)
            from chips_stg.ps_pay_calendar
            where pay_begin_dt <= current_date
                and pay_off_cycle_cal = 'N'
                and paygroup = 'STD'
                and trim(run_id) is not null
        )
    ),
    scd as (
        select emplid, min(start_pay_period) start_pay_period, 
            max(end_pay_period) end_pay_period, 
            count(*)
        from ods.em_employee_idir_scd
        group by emplid 
        having count(*) = 1 
    )
    select emplid, pay_period_start_date -14 prior_Start_date
    from scd 
    join latest_load ll 
        on ll.pay_period_start_date = scd.start_pay_period 
            and ll.pay_period_end_date = scd.end_pay_period
) src on (target.emplid = src.emplid)
when matched then update
set start_pay_period = src.prior_start_date
;