-- check: there is only one current record per emplid (pk)
-- expect: no results
select emplid, current_flg, count(*) 
from ods.employee_name
where current_flg = 'Y'
group by emplid, current_flg
having count(*) > 1
;
