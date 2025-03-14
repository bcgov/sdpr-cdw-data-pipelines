truncate table cdw.em_userid_to_emplid_xref_d;

insert into cdw.em_userid_to_emplid_xref_d
    with
    src_data as (
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
    )
    select 
        s.oprid,
        s.emplid,
        s.rowsecclass,
        s.oprdefndesc,
        emp.deptid home_dept_id,
        s.override_deptid,
        nvl(s.override_deptid, emp.deptid) deptid,
        s.drill_through_yn
    from src_data s
    left join cdw.em_employee_d emp on s.emplid = emp.emplid
; 

commit;