-- check: emplid is unique (pk)
-- excpect: no records
select emplid, count(*)
from cdw.em_employee_d
group by emplid
having count(*) != 1
;