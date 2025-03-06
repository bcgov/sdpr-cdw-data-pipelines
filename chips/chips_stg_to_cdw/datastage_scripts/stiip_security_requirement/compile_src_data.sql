select lpad(emplid, 6, '0') emplid,
	name,
	override_deptid,
	drill_through_yn
from chips_stg.stiip_security_requirement_stg
;