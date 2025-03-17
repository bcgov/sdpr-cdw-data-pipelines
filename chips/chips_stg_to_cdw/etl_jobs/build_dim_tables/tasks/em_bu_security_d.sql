alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

truncate table cdw.em_bu_security_d; commit;

insert into cdw.em_bu_security_d (deptid, bu_bk, bu_deptid, hier_level, bu_sid)
    with
    l1 as (
        SELECT
            LEVEL1_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            1 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
    ),
    l2 as (
        SELECT
            LEVEL2_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            2 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL2_DEPTID IS NOT NULL
    ),
    l3 as (
        SELECT
            LEVEL3_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            3 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL3_DEPTID IS NOT NULL
    ),
    l4 as (
        SELECT
            LEVEL4_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            4 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL4_DEPTID IS NOT NULL
    ),
    l5 as (
        SELECT
            LEVEL5_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            5 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL5_DEPTID IS NOT NULL
    ),
    l6 as (
        SELECT
            LEVEL6_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            6 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL6_DEPTID IS NOT NULL
    ),
    l7 as (
        SELECT
            LEVEL7_DEPTID as DEPTID,
            BU_BK,
            BU_DEPTID,
            7 AS HIER_LEVEL
        FROM "CDW"."OR_BUSINESS_UNIT_D"
        WHERE SETID = 'ST031'
            AND LEVEL7_DEPTID IS NOT NULL
    ),
    src_data as (
        select * from l1
        union
        select * from l2
        union
        select * from l3
        union
        select * from l4
        union
        select * from l5
        union
        select * from l6
        union
        select * from l7
    )
    select  
        s.*,
        row_number() over (order by bu_bk, hier_level) bu_sid
    from src_data s
    order by bu_sid desc
; 

commit;
