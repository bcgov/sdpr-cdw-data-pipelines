alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

truncate table cdw.em_job_class_d;

insert into cdw.em_job_class_d
    with
    src_data as (
        select
            jc.setid||jc.jobcode jobcode_bk,
            jc.descr jc_descr,
            jc.setid,
            jc.jobcode,
            jc.effdt,
            jc.eff_status jc_eff_status,
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
            ) incl_excl_descr,
            lag(jc.effdt) over (partition by jc.jobcode order by jc.effdt desc) eff_end_dt
        from chips_stg.ps_jobcode_tbl jc
        order by jc.setid, jc.jobcode, jc.effdt
    )
    select 
        row_number() over (order by effdt) jobclass_sid, 
        s.*,
        case
            when eff_end_dt is not null then 'N'
            else 'Y'
        end curr_ind
    from src_data s
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