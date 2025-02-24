select to_char(min(pay_period_end_date),'dd-mon-yyyy')
from cdw.chips_load_control
where load_in_progress_ind = 1
;