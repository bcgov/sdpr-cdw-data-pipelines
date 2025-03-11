truncate table cdw.or_business_unit_d_new;

insert into cdw.or_business_unit_d_new 
with

ranked_depts as (
    select dept.*,
        row_number() over (partition by setid, deptid order by effdt desc) as rn
    from chips_stg.ps_dept_tbl dept
),

latest_eff_dt_by_dept as (
    select *
    from ranked_depts
    where rn = 1
),

load_latest_eff_dt_by_dept as (
    select * 
    from latest_eff_dt_by_dept
),

ranked_companies AS (
    select co.*,
        row_number() over (partition by company order by effdt desc) as rn
    from chips_stg.ps_company_tbl co
),

latest_eff_dt_by_company as (
    select *
    from ranked_companies
    where rn = 1
),

load_latest_eff_dt_by_company as (
    select * 
    from latest_eff_dt_by_company
),

level_query as (
    select setid, deptid, descr, descrshort, effdt 
    from load_latest_eff_dt_by_dept
)

select 
    px.setid || px.tree_node as bu_bk,
    leaf.descr as bu_bk_descr,
    leaf.deptid as bu_deptid,
    px.tree_name,
    px.setid,
    leaf.company as company,
    cmp.descr as company_descr,
    cmp.descrshort as company_descr_short,
    nvl2(px.l1_tree_node,px.setid || px.l1_tree_node, null) as level1_bk,
    'BUS_UNIT' as level1_name,
    l1_tree_node as level1_deptid,
    l1.descr as level1_descr,
    l1.descrshort as level1_descr_short,
    l1.effdt as level1_effdt,
    nvl2(px.l2_tree_node, px.setid || px.l2_tree_node, null) as level2_bk,
    'PROGRAM' as level2_name,
    l2_tree_node as level2_deptid,
    l2.descr as level2_descr,
    l2.descrshort as level2_descr_short,
    l2.effdt as level2_effdt,
    nvl2(px.l3_tree_node, px.setid || px.l3_tree_node, null) as level3_bk,
    'DIVISION' as level3_name,
    l3_tree_node as level3_deptid,
    l3.descr as level3_descr,
    l3.descrshort as level3_descr_short,
    l3.effdt as level3_effdt,
    nvl2(px.l4_tree_node, px.setid || px.l4_tree_node, null) as level4_bk,
    'BRANCH' as level4_name,
    l4_tree_node as level4_deptid,
    l4.descr as level4_descr,
    l4.descrshort as level4_descr_short,
    l4.effdt as level4_effdt,
    nvl2(px.l5_tree_node, px.setid || px.l5_tree_node, null) as level5_bk,
    'SECTION' as level5_name,
    l5_tree_node as level5_deptid,
    l5.descr as level5_descr,
    l5.descrshort as level5_descr_short,
    l5.effdt as level5_effdt,
    nvl2(px.l6_tree_node, px.setid || px.l6_tree_node, null) as level6_bk,
    'UNIT' as level6_name,
    l6_tree_node as level6_deptid,
    l6.descr as level6_descr,
    l6.descrshort as level6_descr_short,
    l6.effdt as level6_effdt,
    nvl2(px.l7_tree_node, px.setid || px.l7_tree_node, null) as level7_bk,
    'DEPARTMENT' as level7_name,
    l7_tree_node as level7_deptid,
    l7.descr as level7_descr,
    l7.descrshort as level7_descr_short,
    l7.effdt as level7_effdt,
    leaf.tgb_gl_client as gl_client,
    leaf.tgb_gl_response as gl_response,
    leaf.tgb_gl_service_ln as gl_service_ln,
    leaf.tgb_gl_project as gl_project,
    leaf.tgb_gl_stob as gl_stob,
    greatest(px.effdt, leaf.effdt) as eff_date
from chips_stg.px_tree_flattened px

left join (
    select setid, deptid, descr, descrshort, company, effdt,
        tgb_gl_client, tgb_gl_response, tgb_gl_service_ln, tgb_gl_project, tgb_gl_stob
    from load_latest_eff_dt_by_dept
) leaf
    on px.setid=leaf.setid 
        and px.tree_node=leaf.deptid

left join (
    select * from level_query
) l1 
    on px.setid=l1.setid 
        and px.l1_tree_node=l1.deptid

left join (
    select * from level_query
) l2 
    on px.setid = l2.setid 
        and px.l2_tree_node = l2.deptid

left join (
    select * from level_query
) l3 
    on px.setid = l3.setid 
        and px.l3_tree_node = l3.deptid

left join (
    select * from level_query
) l4 
    on px.setid = l4.setid 
        and px.l4_tree_node = l4.deptid

left join (
    select * from level_query
) l5 
    on px.setid = l5.setid 
        and px.l5_tree_node = l5.deptid

left join (
    select * from level_query
) l6 
    on px.setid = l6.setid 
        and px.l6_tree_node = l6.deptid

left join (
    select * from level_query
) l7 
    on px.setid = l7.setid 
        and px.l7_tree_node = l7.deptid

left join (
    select company, descr, descrshort 
    from load_latest_eff_dt_by_company
) cmp 
    on leaf.company=cmp.company

left join (
    select max(eff_date) eff_date,d.bu_bk
    from cdw.or_business_unit_d d 
    group by d.bu_bk 
) bu
    on px.setid || px.tree_node = bu.bu_bk

where px.tree_name = 'DEPT_SECURITY'
    and px.setid not in ('QEGID', 'COMMN','ST000')
    and px.setid like 'ST%'
    -- only select the latest row from the PX file to be added to the SCD
    and px.effdt = (
        select max(px2.effdt) 
        from chips_stg.px_tree_flattened px2 
        where px2.setid = px.setid 
            and px2.tree_node = px.tree_node
    )
    and greatest(px.effdt, leaf.effdt) >= nvl(bu.eff_date, to_date('19000101', 'yyyymmdd'))
order by px.setid || px.tree_node, greatest(px.effdt, leaf.effdt)
;

commit;