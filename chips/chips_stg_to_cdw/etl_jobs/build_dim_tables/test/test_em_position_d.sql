-- check: (position_nbr, eff_date) is unique (pk)
-- excpect: no records
select position_nbr, eff_date, count(*)
from cdw.em_position_d
group by position_nbr, eff_date
having count(*) != 1
;
