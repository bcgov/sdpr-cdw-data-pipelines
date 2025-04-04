alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

truncate table cdw.em_employee_d; 

insert into cdw.em_employee_d (
    emplid,
    name,
    nid_country,
    national_id_type,
    national_id,
    name_prefix,
    preferred_name,    
    country,  
    address1,
    address2,   
    address3, 
    address4,
    city,     
    house_type, 
    county,   
    state,
    postal,   
    geo_code,
    home_phone,
    work_phone,
    orig_hire_dt,
    sex,
    birthdate,
    dt_of_death,
    mar_status,
    disabled,
    hire_dt,
    rehire_dt,
    cmpny_seniority_dt,
    service_dt,
    expected_return_dt,
    termination_dt,
    last_date_worked,
    business_title,
    reports_to,
    supervisor_id,
    business_unit,
    deptid,
    jobcode,
    position_nbr,
    empl_status,
    location,
    company,
    paygroup,
    empl_type,
    grade,
    jobtitle,
    physical_location,
    empl_sid
)
    with
    src_data as (
        select
            p.emplid,
            p.name,
            null as nid_country,
            null as national_id_type,
            null as national_id,
            p.name_prefix,
            p.pref_first_name preferred_name,    
            p.country,  
            p.address1,
            p.address2,   
            p.address3, 
            p.address4,
            p.city,     
            p.house_type, 
            p.county,   
            p.state,
            p.postal,   
            p.geo_code,
            p.phone as home_phone,
            e.position_phone as work_phone,
            null as orig_hire_dt,
            p.sex,
            p.birthdate,
            p.dt_of_death,
            p.mar_status,
            p.disabled,
            e.hire_dt,
            e.rehire_dt,
            e.cmpny_seniority_dt,
            e.service_dt,
            j.expected_return_dt,
            j.termination_dt,
            e.last_date_worked,
            e.business_title,
            e.reports_to,
            e.supervisor_id,
            j.business_unit,
            j.deptid,
            j.jobcode,
            j.position_nbr,
            j.empl_status,
            j.location,
            j.company,
            j.paygroup,
            j.empl_type,
            j.grade,
            jc.descr as jobtitle,
            null physical_location
        from chips_stg.ps_personal_data p
        join (
            select
                emplid,
                empl_rcd,
                business_unit,
                deptid,
                jobcode,
                setid_jobcode,
                position_nbr,
                empl_status,
                location,
                company,
                paygroup,
                empl_type,
                grade,
                expected_return_dt,
                termination_dt
            from chips_stg.ps_job
            where (emplid, empl_rcd, effdt, effseq) in ( 
                -- x3
                -- select only one employee profile  per employee(most recent record), giving preference to MHSD profile
                select emplid, empl_rcd, effdt, effseq -- MHSD_YN
                from ( -- x2
                    -- for each employee, identify last profile -- this profile will be used for load into CDW give preference to employee profile from MHSD
                    select emplid, MHSD_YN, effdt, effseq, empl_rcd,
                        last_value(effdt) over (
                            partition by emplid 
                            order by mhsd_yn, effdt 
                            rows between unbounded preceding and unbounded following
                        ) as last_effdt,
                        last_value(effseq) over (
                            partition by emplid  
                            order by mhsd_yn, effdt, effseq 
                            rows between unbounded preceding and unbounded following
                        ) as last_effseq,
                        last_value(empl_rcd) over (
                            partition by emplid 
                            order by mhsd_yn, effdt, effseq, empl_rcd 
                            rows between unbounded preceding and unbounded following
                        ) as last_empl_rcd
                    from ( -- x1
                        -- an  employeemay have multiple profiles (identified by empl_rcd  field)
                        -- for each employee profile (combination of emplid,empl_rcd),
                        -- show if the profile belongs to MHSD or not
                        -- identify the last ps_job  record (eff_dt, eddseq)
                        select emplid, empl_rcd, decode(business_unit, 'BC031', 'Y', 'N') as MHSD_YN,
                            effdt,
                            last_value(effdt) over (
                                partition by emplid, empl_rcd
                                order by effdt 
                                rows between unbounded preceding and unbounded following
                            ) as last_eff_dt,
                            effseq,
                            last_value(effseq) over (
                                partition by emplid, empl_rcd
                                order by effdt,effseq 
                                rows between unbounded preceding and unbounded following
                            ) as last_effseq
                            from chips_stg.ps_job  
                            where effdt <= sysdate
                    )   -- x1
                    -- only show the last record for each profile
                    where effdt = last_eff_dt 
                        and effseq = last_effseq
                )  -- x2
                -- select only one employee profile per employee
                where effdt = last_effdt 
                    and effseq=last_effseq 
                    and last_empl_rcd=empl_rcd
                ) -- x3
        ) J
            on p.emplid = j.emplid
        join chips_stg.ps_jobcode_tbl jc 
            on j.jobcode = jc.jobcode 
                and j.setid_jobcode = jc.setid
        left join chips_stg.ps_employment e 
            on j.emplid = e.emplid 
                and j.empl_rcd = e.empl_rcd
        where
            jc.effdt = (
                select max(x2.effdt) 
                from chips_stg.ps_jobcode_tbl x2 
                where jc.setid = x2.setid 
                    and jc.jobcode = x2.jobcode 
                    and x2.effdt <= sysdate
            )
    )
    select  
        s.*,
        row_number() over (order by emplid) empl_sid
    from src_data s
    order by empl_sid
;

drop index cdw.iemployee_d_a1;

create unique index cdw.iemployee_d_a1 on cdw.em_employee_d (emplid)
    tablespace cdw_indx
    pctfree 10
    initrans 2
    maxtrans 255
    storage (initial 10m minextents 1 maxextents unlimited)
    nologging compute statistics
;

drop index cdw.iemployee_d_a2;

create index cdw.iemployee_d_a2 on cdw.em_employee_d (name)
    tablespace cdw_indx
    pctfree 10
    initrans 2
    maxtrans 255
    storage  (initial 10m  minextents 1 maxextents unlimited)
    nologging compute statistics
; 

commit;