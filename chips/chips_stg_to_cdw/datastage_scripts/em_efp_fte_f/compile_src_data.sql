select
    fte_sum.clndr_mth_id,
    pay_periods_cnt.fscl_period_id,
    case substr(to_char(pay_periods_cnt.fscl_period_id), 5, 2)
        WHEN '01' THEN 'Apr'
        WHEN '02' THEN 'May'
        WHEN '03' THEN 'Jun'
        WHEN '04' THEN 'Jul'
        WHEN '05' THEN 'Aug'
        WHEN '06' THEN 'Sep'
        WHEN '07' THEN 'Oct'
        WHEN '08' THEN 'Nov'
        WHEN '09' THEN 'Dec'
        WHEN '10' THEN 'Jan'
        WHEN '11' THEN 'Feb'
        WHEN '12' THEN 'Mar'
        ELSE null
    end || ' '  ||
        substr (to_char(to_number(substr(to_char(pay_periods_cnt.fscl_period_id), 1, 4))-1), 3, 2) ||
        '-' || substr(to_char(pay_periods_cnt.fscl_period_id), 3, 2)
    as fscl_period_nam,
    fte_sum.deptid as bu_deptid,
    fte_sum.resp_num,
    fte_sum.fte_reg,
    fte_sum.fte_ovt,
    fte_sum.fire_ovt,
    fte_sum.fte_burn ,
    pay_periods_cnt.num_pay_periods,
    -- Calculate Average FTE burn per fiscal pay period
    --(month may have 2 or 3 pay periods, FTE_BURN is not additive)
    fte_sum.fte_burn / pay_periods_cnt.num_pay_periods as efp_avg_fte
from (
    select
        to_number(to_char(pay_end_dt,'YYYYMM')) as clndr_mth_id,
        deptid,
        tgb_gl_response as resp_num,
        sum(fte_reg) as fte_reg,
        sum(fte_ovt) as fte_ovt,
        sum(fire_ovt) as fire_ovt,
        sum(fte_reg + fte_ovt + fire_ovt) as fte_burn
    from chips_stg.ps_tgb_fteburn_tbl
    where business_unit = 'BC031'
    group by to_number(to_char(pay_end_dt, 'YYYYMM')), deptid, tgb_gl_response
) FTE_Sum
inner join (
    select
        clndr_pay_month,
        to_number(clndr_pay_month) as clndr_mth_id,
        case
            when substr(clndr_pay_month,5,2) <= '03' then to_number(clndr_pay_month) + 9   -- Jan, Feb, Mar
            else ((to_number(substr(clndr_pay_month,1,4))+1)*100) 
                + to_number(substr(clndr_pay_month, 5, 2)) - 3
        end as fscl_period_id,
        count(*) as num_pay_periods
    from (
        select distinct pay_end_dt, to_char(pay_end_dt, 'YYYYMM') as clndr_pay_month 
        from chips_stg.ps_pay_calendar
    )
    group by clndr_pay_month,
        case
            when substr(clndr_pay_month,5,2) <= '03' then to_number(clndr_pay_month) + 9
            else (to_number(substr(clndr_pay_month, 1, 4)) + 1) * 100 
                + to_number(substr(clndr_pay_month, 5, 2)) - 3
        end
) pay_periods_cnt
    on pay_periods_cnt.clndr_mth_id = fte_sum.clndr_mth_id
;