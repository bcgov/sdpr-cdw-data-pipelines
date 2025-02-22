SELECT 
    l.country,
    l.country_code,
    DECODE(
        TRIM(l.state), 
        NULL, 'BC',
        'C', 'BC',
        TRIM(l.state)
    ) AS state,
    c.city,
    l.setid || l.location AS setid_loc,
    l.setid,
    l.location,
    l.descr,
    l.address1,
    l.address2,
    l.address3,
    l.address4,
    l.postal,
    x.xlatlongname AS regional_district
FROM 
    chips_stg.ps_location_tbl l
JOIN 
    chips_stg.ps_tgb_city_tbl c
    ON UPPER(l.city) = UPPER(c.city)
JOIN 
    chips_stg.psxlatitem x
    ON c.tgb_reg_district = x.fieldvalue
    AND x.fieldname = 'TGB_REG_DISTRICT'
    AND x.eff_status = 'A'
    AND x.effdt = (
        SELECT MAX(x2.effdt)
        FROM chips_stg.psxlatitem x2
        WHERE x.fieldname = x2.fieldname
            AND x.fieldvalue = x2.fieldvalue
            AND x2.eff_status = x.eff_status
            AND x2.effdt <= SYSDATE
    )
WHERE 
    l.setid = 'BCSET'
    AND l.eff_status = 'A'
    AND l.effdt = (
        SELECT MAX(l2.effdt)
        FROM chips_stg.ps_location_tbl l2
        WHERE l.setid = l2.setid
            AND l.location = l2.location
            AND l.eff_status = l2.eff_status
            AND l2.effdt <= SYSDATE
    )
;