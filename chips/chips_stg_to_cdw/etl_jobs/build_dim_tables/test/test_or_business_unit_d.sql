-- check: (setid, bu_deptid, effdt) is unique (pk)
-- excpect: no records
select setid, bu_deptid, eff_date, count(*)
from cdw.or_business_unit_d
group by setid, bu_deptid, eff_date
having count(*) != 1
;
