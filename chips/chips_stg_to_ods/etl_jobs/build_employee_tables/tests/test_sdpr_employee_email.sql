-- check: there is only one current record per emplid (pk)
-- expect: no results
select emplid, current_flg, count(*) 
from ods.sdpr_employee_email 
where current_flg = 'Y'
group by emplid, current_flg
having count(*) > 1;

-- check: there is only one current record per idir
-- expect: no results
select email, current_flg, count(*)
from ods.sdpr_employee_email
where current_flg = 'Y'
group by email, current_flg
having count(*) != 1
;