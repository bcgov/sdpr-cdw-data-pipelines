-- check: empl_status is unique (pk)
-- excpect: no records
select empl_status, count(*)
from cdw.em_employee_status_d
group by empl_status
having count(*) != 1
;
