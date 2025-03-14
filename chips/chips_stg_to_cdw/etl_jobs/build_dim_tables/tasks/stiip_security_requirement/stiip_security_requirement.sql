truncate table chips_stg.stiip_security_requirement;

insert into chips_stg.stiip_security_requirement
    select lpad(emplid, 6, '0') emplid,
        name,
        override_deptid,
        drill_through_yn,
        current_date load_dt
    from chips_stg.stiip_security_requirement_stg
;

commit;