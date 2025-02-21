select to_char(max(end_pay_period), 'yyyymmdd') 
from ods.em_employee_idir_scd
;