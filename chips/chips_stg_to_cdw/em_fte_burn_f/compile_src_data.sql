-- not used by datastage because of variables

-- SELECT
--     f.emplid,
--     f.pay_end_dt,
--     trim(TO_CHAR(f.pay_end_dt,'YYYYMMDD')) || '0' as PAY_END_DT_SK,
--     sc.SETID||F.deptid bu_bk,
--     sc2.setid||F.jobcode jobcode_bk,
--     f.position_nbr,
--     f.appointment_status,
--     j.empl_status,
--     j.setid_location||j.location location_bk,
--     f.fte_reg,
--     f.fte_ovt,
--     f.fire_ovt,
--     '[DIM_SID (Unmatched)]' REASON
-- FROM
--     ps_job j,
--     ps_tgb_fteburn_tbl f,
--     PS_SET_CNTRL_REC sc,
--     PS_SET_CNTRL_REC sc2
-- WHERE f.emplid = j.emplid
--     AND f.empl_rcd = j.empl_rcd
--     AND j.effdt = (
--         SELECT MAX(j2.effdt)
--         FROM ps_job j2
--         WHERE j2.emplid = j.emplid
--             AND j2.empl_rcd = j.empl_rcd
--             AND j2.effdt <= f.pay_end_dt
--     )
--     AND j.effseq = (
--         SELECT MAX(j3.effseq)
--         FROM ps_job j3
--         WHERE j3.emplid = j.emplid
--             AND j3.empl_rcd = j.empl_rcd
--             AND j3.effdt = j.effdt
--     )
--     AND f.pay_end_dt BETWEEN TO_DATE('#V_BEG_DATE_RANGE#','DD-MON-YYYY') AND TO_DATE('#V_END_DATE_RANGE#','DD-MON-YYYY')
--     AND sc.RECNAME = 'DEPT_TBL'  
--     AND sc.SETCNTRLVALUE = F.business_unit
--     AND sc2.RECNAME = 'JOBCODE_TBL'  
--     AND sc2.SETCNTRLVALUE = F.business_unit
-- ;