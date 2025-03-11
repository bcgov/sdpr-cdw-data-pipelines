truncate table cdw.em_userid_to_emplid_xref_d_new;

insert into cdw.em_userid_to_emplid_xref_d_new
select ps.oprid,
	ps.emplid,
	ps.rowsecclass,
    ps.oprdefndesc,
    ss.override_deptid,
    ss.drill_through_yn
from chips_stg.ps_oprdefn_bc_tbl ps
left outer join chips_stg.stiip_security_requirement ss
    on ps.emplid = ss.emplid
where ps.emplid is not null
;

commit;