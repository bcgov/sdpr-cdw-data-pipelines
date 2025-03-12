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
)

-- select only most recent records for each job code
select 
    jobcode_bk,
    setid,
    jobcode,
    effdt,
    jc_eff_status,
    jc_descr,
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
;