-- create indexes for the base tables to increase performance

drop index chips_stg.ps_tgb_fteburn_tbl1;

create bitmap index chips_stg.ps_tgb_fteburn_tbl1  on chips_stg.ps_tgb_fteburn_tbl (emplid, empl_rcd, pay_end_dt, business_unit)
tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index chips_stg.ps_job1;

create bitmap index chips_stg.ps_job1  on chips_stg.ps_job (emplid, empl_rcd, effdt DESC, effseq DESC)
tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index chips_stg.ps_set_cntrl_rec1;

create bitmap index chips_stg.ps_set_cntrl_rec1  on chips_stg.ps_set_cntrl_rec (setcntrlvalue, recname)
tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

commit;


truncate table cdw.em_fte_burn_f;

insert into cdw.em_fte_burn_f
    with
    src_data as (
        SELECT
            f.emplid,
            f.pay_end_dt,
            TRIM(TO_CHAR(f.pay_end_dt, 'YYYYMMDD')) || '0' AS PAY_END_DT_SK,
            sc.SETID || f.deptid AS bu_bk,
            sc2.setid || f.jobcode AS jobcode_bk,
            f.position_nbr,
            f.appointment_status,
            j.empl_status,
            j.setid_location || j.location AS location_bk,
            f.fte_reg,
            f.fte_ovt,
            f.fire_ovt,
            '[DIM_SID (Unmatched)]' AS REASON
        FROM
            chips_stg.ps_tgb_fteburn_tbl f
            INNER JOIN chips_stg.ps_job j
                ON f.emplid = j.emplid
                AND f.empl_rcd = j.empl_rcd
            INNER JOIN chips_stg.ps_set_cntrl_rec sc
                ON sc.recname = 'DEPT_TBL'
                AND sc.setcntrlvalue = f.business_unit
            INNER JOIN chips_stg.ps_set_cntrl_rec sc2
                ON sc2.recname = 'JOBCODE_TBL'
                AND sc2.setcntrlvalue = f.business_unit
                AND j.effdt = (
                    SELECT MAX(j2.effdt)
                    FROM chips_stg.ps_job j2
                    WHERE j2.emplid = j.emplid
                        AND j2.empl_rcd = j.empl_rcd
                        AND j2.effdt <= f.pay_end_dt
                )
                AND j.effseq = (
                    SELECT MAX(j3.effseq)
                    FROM chips_stg.ps_job j3
                    WHERE j3.emplid = j.emplid
                        AND j3.empl_rcd = j.empl_rcd
                        AND j3.effdt = j.effdt
                )
        WHERE
            f.pay_end_dt >= ADD_MONTHS(TRUNC(CURRENT_DATE), -12*7)
    )
    select
        apt.appt_status_sid appointment_status_sid,
        loc.location_sid,
        s.pay_end_dt_sk,
        es.empl_status_sid,
        pos.position_sid,
        jc.jobclass_sid job_class_sid,
        bu.bu_sid,
        s.fte_reg,
        s.fte_ovt,
        s.fire_ovt,
        s.emplid,
        emp.empl_sid
    from src_data s
    left join cdw.em_employee_d emp on emp.emplid = s.emplid
    left join cdw.or_business_unit_d bu on s.bu_bk = bu.bu_bk
    left join cdw.em_job_class_d jc on s.jobcode_bk = jc.jobcode_bk
    left join cdw.em_position_d pos on s.position_nbr = pos.position_nbr
    left join cdw.em_appointment_status_d apt on s.appointment_status = apt.appointment_status
    left join cdw.em_employee_status_d es on s.empl_status = es.empl_status
    left join cdw.or_location_d loc on s.location_bk = loc.setid_loc
    where s.emplid is not null
        and s.pay_end_dt_sk is not null
;

drop index cdw.ifte_burn_f_a1;

create bitmap index cdw.ifte_burn_f_a1  on cdw.em_fte_burn_f (appointment_status_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a2;

create bitmap index cdw.ifte_burn_f_a2  on cdw.em_fte_burn_f (bu_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a3;

create bitmap index cdw.ifte_burn_f_a3  on cdw.em_fte_burn_f (empl_status_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a4;

create bitmap index cdw.ifte_burn_f_a4  on cdw.em_fte_burn_f (job_class_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a5;

create bitmap index cdw.ifte_burn_f_a5  on cdw.em_fte_burn_f (location_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a6;

create bitmap index cdw.ifte_burn_f_a6  on cdw.em_fte_burn_f (pay_end_dt_sk)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a7;

create bitmap index cdw.ifte_burn_f_a7  on cdw.em_fte_burn_f (position_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a8;

create bitmap index cdw.ifte_burn_f_a8  on cdw.em_fte_burn_f (bu_sid,pay_end_dt_sk)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a9;

create  index cdw.ifte_burn_f_a9  on cdw.em_fte_burn_f (emplid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ifte_burn_f_a10;

create  index cdw.ifte_burn_f_a10  on cdw.em_fte_burn_f (empl_sid)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

commit;