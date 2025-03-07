select to_char(pay_end_dt, 'yyyymmdd') 
from chips_stg.ps_pay_calendar
where pay_end_dt = (
  select max(pay_end_dt)
  from chips_stg.ps_pay_calendar
  where pay_begin_dt <= current_date
    and pay_off_cycle_cal = 'N'
    and paygroup = 'STD'
    and trim(run_id) is not null
)
;