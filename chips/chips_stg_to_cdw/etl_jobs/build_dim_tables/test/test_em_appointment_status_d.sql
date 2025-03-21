-- check: appointment_status is unique (pk)
-- excpect: no records
select appointment_status, count(*)
from cdw.em_appointment_status_d
group by appointment_status
having count(*) != 1
;