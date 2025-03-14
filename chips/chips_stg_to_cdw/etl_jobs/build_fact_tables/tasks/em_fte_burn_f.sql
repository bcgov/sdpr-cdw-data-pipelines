truncate table cdw.em_fte_burn_f;

insert into cdw.em_fte_burn_f
    with
    src_data as (
        select
            f.emplid,
            f.pay_end_dt,
            trim(TO_CHAR(f.pay_end_dt,'YYYYMMDD')) || '0' as PAY_END_DT_SK,
            sc.SETID||F.deptid bu_bk,
            sc2.setid||F.jobcode jobcode_bk,
            f.position_nbr,
            f.appointment_status,
            j.empl_status,
            j.setid_location||j.location location_bk,
            f.fte_reg,
            f.fte_ovt,
            f.fire_ovt,
            '[DIM_SID (Unmatched)]' REASON
        from
            chips_stg.ps_job j,
            chips_stg.ps_tgb_fteburn_tbl f,
            chips_stg.ps_set_cntrl_rec sc,
            chips_stg.ps_set_cntrl_rec sc2
        where f.emplid = j.emplid
            and f.empl_rcd = j.empl_rcd
            and j.effdt = (
                select max(j2.effdt)
                from chips_stg.ps_job j2
                where j2.emplid = j.emplid
                    and j2.empl_rcd = j.empl_rcd
                    and j2.effdt <= f.pay_end_dt
            )
            and j.effseq = (
                select max(j3.effseq)
                from chips_stg.ps_job j3
                where j3.emplid = j.emplid
                    and j3.empl_rcd = j.empl_rcd
                    and j3.effdt = j.effdt
            )
            and sc.recname = 'DEPT_TBL'  
            and sc.setcntrlvalue = f.business_unit
            and sc2.recname = 'JOBCODE_TBL'  
            and sc2.setcntrlvalue = f.business_unit
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