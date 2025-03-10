with 

min_pay_end_date_to_load as (
    select current_date - 28 from dual
)

select
    appointment_status,
    LEAVE_END_DT_SK,
    LEAVE_END_DT,
    LEAVE_BEGIN_DT_SK,
    location_bk,
    PAY_END_DT_SK,
    pay_end_dt,
    empl_status,
    position_nbr,
    bu_bk,
    emplid,
    jobcode_bk,
    hourly_rt,
    LEAVE_HOURS,
    LEAVECOST,
    PAIDCOST,
    empls,
    LEAVECODE
from ( -- B
    SELECT
        A.emplid,
        A.pay_end_dt,
        trim(TO_CHAR(A.pay_end_dt, 'YYYYMMDD')) || '0' as PAY_END_DT_SK,
        trim(TO_CHAR(A.earns_begin_dt, 'YYYYMMDD')) || '0' as LEAVE_BEGIN_DT_SK,
        A.earns_end_dt as LEAVE_END_DT,
        trim(TO_CHAR(A.earns_end_dt, 'YYYYMMDD')) || '0' as LEAVE_END_DT_SK,
        A.hourly_rt,
        A.erncd as LEAVECODE,
        C.empl_ctg as appointment_status,
        c.empl_status,
        c.setid_location||c.location as location_bk,
        NVL(TRIM(A.position_nbr),C.position_nbr) as position_nbr,
        -- c.setid_dept||a.deptid bu_bk
        SC.setid||a.deptid as bu_bk,
        -- SC2.setid||A.jobcode jobcode_bk
        -- c.setid_jobcode||A.jobcode jobcode_bk
        SC2.setid||NVL(TRIM(A.jobcode), C.jobcode) as jobcode_bk,
        CASE
            WHEN A.erncd IN ('SIS','SIX') THEN (A.oth_hrs * (-1.0))
            WHEN A.erncd = 'S57' THEN 0
            ELSE A.oth_hrs * (1.0)  -- SIH,SIP,SIZ, ESL
        END LEAVE_HOURS,
        CASE
            WHEN A.erncd IN ('SIS', 'SIX') THEN (A.oth_hrs * A.hourly_rt) * -1
            WHEN A.erncd ='S57' THEN 0
            ELSE (A.oth_hrs * A.hourly_rt) -- SIH,SIP,SIZ, ESL
        END LEAVECOST,
        CASE
            WHEN A.erncd = 'SIP' THEN (A.oth_hrs * A.hourly_rt) *.75
            WHEN A.erncd = 'SIX' THEN ((A.oth_hrs * A.hourly_rt) * -1) * .667
            WHEN A.erncd = 'SIS' THEN ((A.oth_hrs * A.hourly_rt) * -1) * .75
            WHEN A.erncd in ('SIH','S57') THEN (A.oth_hrs * A.hourly_rt)
            WHEN A.erncd = 'SIZ' THEN 0
            WHEN A.erncd IN ('ESL') THEN (A.oth_hrs * A.hourly_rt)
        END PAIDCOST,
        COUNT(DISTINCT a.emplid) empls
    FROM (   -- A
        select
            A.earns_begin_dt,
            A.earns_end_dt,
            A.pay_end_dt,
            A.deptid,
            A.position_nbr,
            A.business_unit,
            A.emplid,
            A.empl_rcd,
            A.jobcode,
            A.hourly_rt,
            B.erncd,
            sum(B.oth_hrs) oth_hrs
        from chips_stg.PS_PAY_EARNINGS A 
        JOIN chips_stg.PS_PAY_OTH_EARNS B 
            ON A.COMPANY = B.COMPANY
                AND A.PAY_END_DT = B.PAY_END_DT            
                AND A.PAYGROUP = B.PAYGROUP
                AND A.PAGE_NUM = B.PAGE_NUM
                AND A.OFF_CYCLE = B.OFF_CYCLE
                AND A.LINE_NUM = B.LINE_NUM
                AND A.ADDL_NBR = B.ADDL_NBR
                AND B.ERNCD IN ('SIZ','SIX','SIH','SIP','SIS','S57', 'ESL')   --  'SIL'
                AND A.COMPANY = 'GOV'
                AND A.PAYGROUP IN ('STD','OBL','LBM')
                and a.pay_end_dt >= (select * from min_pay_end_date_to_load)
        group by
            A.earns_begin_dt, 
            A.earns_end_dt, 
            A.pay_end_dt, 
            A.deptid, 
            A.position_nbr, 
            A.business_unit,
            A.emplid, 
            A.empl_rcd, 
            A.jobcode,
            A.hourly_rt, 
            B.erncd
    ) A,
    chips_stg.PS_JOB C,
    chips_stg.PS_SET_CNTRL_REC sc,
    chips_stg.PS_SET_CNTRL_REC sc2
    WHERE
        A.EMPLid = C.EMPLID
        AND A.EMPL_RCD = C.EMPL_RCD
        AND C.EFFDT = (
            SELECT MAX(C1.EFFDT)
            FROM chips_stg.PS_JOB C1
            WHERE C1.EMPLID = C.EMPLID
                AND C1.EMPL_RCD = C.EMPL_RCD
                AND C1.EFFDT <= A.EARNS_END_DT
        )
        AND C.EFFSEQ = (
            SELECT MAX(C2.EFFSEQ)
            FROM chips_stg.PS_JOB C2
            WHERE C2.EMPLID = C.EMPLID
                AND C2.EMPL_RCD = C.EMPL_RCD
                AND C2.EFFDT = C.EFFDT
        )
        AND sc.RECNAME = 'DEPT_TBL' AND sc.SETCNTRLVALUE = A.business_unit
        AND sc2.RECNAME = 'JOBCODE_TBL' AND sc2.SETCNTRLVALUE = A.business_unit
    GROUP BY
        A.emplid,
        A.pay_end_dt,
        trim(TO_CHAR(A.pay_end_dt, 'YYYYMMDD')) || '0',
        trim(TO_CHAR(A.earns_begin_dt,'YYYYMMDD')) || '0',
        A.earns_end_dt,
        trim(TO_CHAR(A.earns_end_dt, 'YYYYMMDD')) || '0',
        C.empl_ctg,
        c.empl_status,
        c.setid_location||c.location,
        NVL(TRIM(A.position_nbr),C.position_nbr),
        A.hourly_rt,
        A.erncd,
        SC.setid||a.deptid,
        SC2.setid||NVL(TRIM(A.jobcode), C.jobcode),
        CASE WHEN A.erncd IN ('SIS','SIX') THEN (A.oth_hrs * (-1.0))
            WHEN A.erncd = 'S57' THEN 0
            ELSE A.oth_hrs*(1.0)
        END,
        CASE WHEN A.erncd IN ('SIS','SIX') THEN (A.oth_hrs * A.hourly_rt) * -1
            WHEN A.erncd ='S57' THEN 0
            ELSE (A.oth_hrs * A.hourly_rt)
        END,
        CASE WHEN A.erncd = 'SIP' THEN (A.oth_hrs * A.hourly_rt) * .75
            WHEN A.erncd = 'SIX' THEN ((A.oth_hrs * A.hourly_rt) * -1) * .667
            WHEN A.erncd = 'SIS' THEN ((A.oth_hrs * A.hourly_rt) * -1) * .75
            WHEN A.erncd in ('SIH','S57') THEN (A.oth_hrs * A.hourly_rt)
            WHEN A.erncd = 'SIZ' THEN 0
            WHEN A.erncd IN ('ESL') THEN (A.oth_hrs * A.hourly_rt)
        END
) B
;