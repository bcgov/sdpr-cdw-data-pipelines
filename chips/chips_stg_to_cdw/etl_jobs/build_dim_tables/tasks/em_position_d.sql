truncate table cdw.em_position_d;

insert into cdw.em_position_d
    with
    src_data as (
        select /*+rule*/
            p.position_nbr,
            p.descr as position_descr,
            p.eff_status,
            p.descrshort,
            p.budgeted_posn,
            p.key_position,
            p.reports_to,
            p.report_dotted_line,
            trim(p.can_noc_cd || '-' || p.tgb_can_noc_sub_cd) as noc_sub_cd,
            subnoc_tbl.sub_descr subcode,
            p.can_noc_cd,
            noc_tbl.noc_descr noc,
            p.effdt eff_date,
            lag(p.effdt) over (partition by p.position_nbr order by p.effdt desc) end_date
        from chips_stg.ps_position_data p
        left join (
            select distinct
                cn.can_noc_cd,
                cn.descr as noc,
                n.tgb_can_noc_sub_cd,
                n.descr as sub_descr
            from chips_stg.ps_tgb_cnocsub_tbl n
            join chips_stg.ps_can_noc_tbl cn
                on n.can_noc_cd = cn.can_noc_cd
            where cn.effdt = (
                select max(cn2.effdt)
                from chips_stg.ps_can_noc_tbl cn2
                where cn2.can_noc_cd = cn.can_noc_cd
                    and cn2.effdt <= sysdate
            )
            and n.effdt = (
                select max(n2.effdt)
                from chips_stg.ps_tgb_cnocsub_tbl n2
                where n2.can_noc_cd = cn.can_noc_cd
                    and n.tgb_can_noc_sub_cd = n2.tgb_can_noc_sub_cd
                    and n2.effdt <= sysdate
            )
        ) subnoc_tbl
            on p.can_noc_cd = subnoc_tbl.can_noc_cd
            and p.tgb_can_noc_sub_cd = subnoc_tbl.tgb_can_noc_sub_cd
        left join (
            select distinct
                cn.can_noc_cd,
                cn.descr as noc_descr
            from chips_stg.ps_can_noc_tbl cn
            where cn.effdt = (
                select max(cn2.effdt)
                from chips_stg.ps_can_noc_tbl cn2
                where cn2.can_noc_cd = cn.can_noc_cd
                    and cn2.effdt <= sysdate
            )
        ) noc_tbl
            on p.can_noc_cd = noc_tbl.can_noc_cd
        order by eff_date
    )
    select 
        rownum position_sid, 
        s.*,
        current_date udt_date,
        case
          when end_date is not null then 'N'
          else 'Y'
        end curr_ind
    from src_data s
;

drop index cdw.iposition_d_a1;

create index cdw.iposition_d_a1 on cdw.em_position_d (position_nbr)
     tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
     storage  (initial 10m minextents 1 maxextents unlimited)
     nologging compute statistics
; 

drop index cdw.iposition_d_a2;

create bitmap index cdw.iposition_d_a2 on cdw.em_position_d (can_noc_cd)
     tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
     storage  (initial 10m minextents 1 maxextents unlimited)
     nologging compute statistics
; 

drop index cdw.iposition_d_a3;

create bitmap index cdw.iposition_d_a3 on cdw.em_position_d (noc_sub_cd)
     tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
     storage (initial 10m minextents 1 maxextents unlimited)
     nologging compute statistics
; 

commit;