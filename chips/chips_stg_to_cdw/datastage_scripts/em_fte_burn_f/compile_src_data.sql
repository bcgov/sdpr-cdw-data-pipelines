-- with

-- min_pay_end_date_to_load as (
--     select current_date - 70 from dual
-- )

SELECT
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
    -- and f.pay_end_dt >= (select * from min_pay_end_date_to_load)
    AND sc.RECNAME = 'DEPT_TBL'  
    AND sc.SETCNTRLVALUE = F.business_unit
    AND sc2.RECNAME = 'JOBCODE_TBL'  
    AND sc2.SETCNTRLVALUE = F.business_unit
;