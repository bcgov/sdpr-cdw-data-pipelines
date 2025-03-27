-- check: there is only one current record per emplid (pk)
-- expect: no results
select emplid, current_flg, count(*) 
from ods.sdpr_employee_idir 
where current_flg = 'Y'
group by emplid, current_flg
having count(*) > 1;
