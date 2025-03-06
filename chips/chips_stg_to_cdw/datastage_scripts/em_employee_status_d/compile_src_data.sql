select
	x.fieldvalue empl_status,
	to_char(x.effdt, 'yyyy-mm-dd hh24:mi:ss') effdt,
	x.xlatlongname descr,
	decode(
        x.fieldvalue,
        'A','All Active',
        'L','All Active',
        'P','All Active',
        'S','All Active',
        'D','All Non-Active',
        'R','All Non-Active',
        'T','All Non-Active',
        'UNKNOWN'
    ) status_grp
from chips_stg.psxlatitem x
where x.fieldname = 'EMPL_STATUS'
    and x.eff_status = 'A'
	and x.effdt = (
        select max(x2.effdt) 
        from chips_stg.psxlatitem x2
        where x2.fieldname = x.fieldname
            and x2.fieldvalue = x.fieldvalue
            and x2.effdt <= sysdate
    )
;