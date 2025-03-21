-- check: (setid, jobcode, effdt) is unique (pk)
-- excpect: no records
select setid, jobcode, effdt, count(*)
from cdw.em_job_class_d
group by setid, jobcode, effdt
having count(*) != 1
;