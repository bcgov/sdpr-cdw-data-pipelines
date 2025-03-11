truncate table cdw.em_paycode_d_new;

insert into cdw.em_paycode_d_new
select 
  pay_cd,
  pay_descr,
  class,
  class_descr,
  code_type,
  reduces_hours_worked
from chips_stg.paycodes
;

commit;