SELECT /*+RULE*/
    p.position_nbr,
    p.eff_status,
    p.descr AS position_descr,
    p.descrshort,
    TRIM(p.can_noc_cd || '-' || p.tgb_can_noc_sub_cd) AS sub_noc_cd,
    subnoc_tbl.SUB_descr,
    p.can_noc_cd,
    noc_tbl.NOC_DESCR,
    p.budgeted_posn,
    p.key_position,
    p.reports_to,
    p.report_dotted_line
FROM chips_stg.ps_position_data p
LEFT JOIN (
    SELECT DISTINCT
        cn.can_noc_cd,
        cn.descr AS noc,
        n.tgb_can_noc_sub_cd,
        n.descr AS sub_descr
    FROM chips_stg.ps_tgb_cnocsub_tbl n
    JOIN chips_stg.ps_can_noc_tbl cn
        ON n.can_noc_cd = cn.can_noc_cd
    WHERE cn.effdt = (
        SELECT MAX(cn2.effdt)
        FROM chips_stg.ps_can_noc_tbl cn2
        WHERE cn2.can_noc_cd = cn.can_noc_cd
            AND cn2.effdt <= SYSDATE
    )
    AND n.effdt = (
        SELECT MAX(n2.effdt)
        FROM chips_stg.ps_tgb_cnocsub_tbl n2
        WHERE n2.can_noc_cd = cn.can_noc_cd
            AND n.tgb_can_noc_sub_cd = n2.tgb_can_noc_sub_cd
            AND n2.effdt <= SYSDATE
    )
) subnoc_tbl
    ON p.can_noc_cd = subnoc_tbl.can_noc_cd
    AND p.tgb_can_noc_sub_cd = subnoc_tbl.tgb_can_noc_sub_cd
LEFT JOIN (
    SELECT DISTINCT
        cn.can_noc_cd,
        cn.descr AS noc_descr
    FROM chips_stg.ps_can_noc_tbl cn
    WHERE cn.effdt = (
        SELECT MAX(cn2.effdt)
        FROM chips_stg.ps_can_noc_tbl cn2
        WHERE cn2.can_noc_cd = cn.can_noc_cd
            AND cn2.effdt <= SYSDATE
    )
) noc_tbl
    ON p.can_noc_cd = noc_tbl.can_noc_cd
WHERE p.effdt = (
    SELECT MAX(p2.effdt)
    FROM chips_stg.ps_position_data p2
    WHERE p2.position_nbr = p.position_nbr
        AND p2.effdt <= SYSDATE
)
;