-- check: the range of pay end dates
-- excpect: the range specified in the table build task
select min(pay_end_dt_sk), max(pay_end_dt_sk) from cdw.em_stiip_f;

-- check: every records has a value for appointment_status_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where appointment_status_sid is null
;

-- check: every records has a value for location_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where location_sid is null
;

-- check: every records has a value for empl_status_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where empl_status_sid is null
;

-- check: every records has a value for position_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where position_sid is null
;

-- check: every records has a value for bu_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where bu_sid is null
;

-- check: every records has a value for jobclass_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where jobclass_sid is null
;

-- check: every records has a value for paycode_sid
-- expect: 0
select count(*)
from cdw.em_stiip_f 
where paycode_sid is null
;
