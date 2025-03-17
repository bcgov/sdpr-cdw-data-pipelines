alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

truncate table cdw.em_job_class_d;

insert into cdw.em_job_class_d
    with
    src_data as (
        select
            jc.setid||jc.jobcode jobcode_bk,
            jc.setid,
            jc.jobcode,
            jc.effdt,
            jc.eff_status jc_eff_status,
            jc.descr jc_descr,
            jc.descrshort jc_descrshort,
            jc.sal_admin_plan,
            jc.grade,
            jc.step,
            jc.union_cd,
            jc.std_hours,
            jc.std_hrs_frequency,
            jc.job_function,
            case
                when (
                    select x.xlatlongname
                    from chips_stg.psxlatitem x
                    where jc.job_function = x.fieldvalue
                        and x.fieldname = 'TGB_JOB_FUNCTION'
                        and x.effdt = (
                            select max(xx.effdt)
                            from chips_stg.psxlatitem xx
                            where xx.fieldname = x.fieldname
                                and xx.fieldvalue = x.fieldvalue
                                and xx.effdt <= jc.effdt
                        )
                ) is not null
                    then (
                        select x.xlatlongname 
                        from chips_stg.psxlatitem x
                        where jc.job_function = x.fieldvalue
                            and x.fieldname = 'TGB_JOB_FUNCTION'
                            and x.effdt = (
                                select max(xx.effdt)
                                from chips_stg.psxlatitem xx
                                where xx.fieldname = x.fieldname
                                    and xx.fieldvalue = x.fieldvalue
                                    and xx.effdt <= jc.effdt
                            )
                    )
                else jc.job_function
            end job_func_descr,
            substr(jc.job_function, 1, 2) emp_group,
            DECODE (
                SUBSTR (jc.job_function, 1, 2),
                '11', 'BCGEU',
                '12', 'PEA',
                '13', 'NURSES',
                '14', 'GCIU',
                '04', 'MGMT',
                '05', 'OIC PSA',
                '06', 'SAL PHY',
                '07', 'OTHER',
                '08', 'NON PSA OIC ABC',
                '09', 'NON PSA',
                null
            ) emp_grp_descr,
            substr(jc.job_function,1,1) incl_excl,
            DECODE (
                SUBSTR(jc.job_function,1,1),
                '1','Included',
                '0','Excluded',
                null
            ) incl_excl_descr
        from chips_stg.ps_jobcode_tbl jc
        order by jc.setid, jc.jobcode, jc.effdt
    ),
    -- add a column for the max(effdt) for each jobcode_bk
    src_with_max_effdt as (
        select s.*, max(effdt) over (partition by jobcode_bk) max_effdt
        from src_data s
    ),
    -- select only most recent records for each job code
    load_data as (
        select 
            jobcode_bk,
            jc_descr,
            setid,
            jobcode,
            effdt,
            jc_eff_status,
            jc_descrshort,
            sal_admin_plan,
            grade,
            step,
            union_cd,
            std_hours,
            std_hrs_frequency,
            job_function,
            job_func_descr,
            emp_group,
            emp_grp_descr,
            incl_excl,
            incl_excl_descr
        from src_with_max_effdt
        where effdt = max_effdt
    )
    select 
        row_number() over (order by effdt) jobclass_sid, 
        l.*,
        null eff_end_dt,
        'Y' curr_ind
    from load_data l
;


drop index cdw.ijob_class_d_a1;

create unique index cdw.ijob_class_d_a1 on cdw.em_job_class_d (jobclass_sid)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m  minextents 1  maxextents unlimited)
    nologging compute statistics
;

drop index cdw.ijob_class_d_a2;

create index cdw.ijob_class_d_a2 on cdw.em_job_class_d (jobcode_bk)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m minextents 1 maxextents unlimited)
    nologging compute statistics
;

drop index cdw.ijob_class_d_a3;

create bitmap index cdw.ijob_class_d_a3 on cdw.em_job_class_d (emp_group)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m minextents 1 maxextents unlimited)
    nologging compute statistics
;

drop index cdw.ijob_class_d_a4;

create bitmap index cdw.ijob_class_d_a4 on cdw.em_job_class_d (incl_excl)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m  minextents 1 maxextents unlimited)
    nologging compute statistics
;

drop index cdw.ijob_class_d_a5;

create bitmap index cdw.ijob_class_d_a5 on cdw.em_job_class_d (job_function)
  tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
  storage (initial 10m  minextents 1 maxextents unlimited)
  nologging compute statistics
; 

commit;