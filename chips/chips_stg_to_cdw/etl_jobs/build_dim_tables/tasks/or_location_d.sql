truncate table cdw.or_location_d;

insert into cdw.or_location_d
    with
    src_data as (
        select 
            l.setid || l.location as setid_loc,
            l.setid,
            l.location,
            l.descr,
            null descrshort,
            l.address1,
            l.address2,
            l.address3,
            l.address4,
            l.postal,
            c.city,
            x.xlatlongname as regional_district,
            decode(
                trim(l.state), 
                null, 'BC',
                'C', 'BC',
                trim(l.state)
            ) as state,
            l.country,
            l.country_code
        from 
            chips_stg.ps_location_tbl l
        join 
            chips_stg.ps_tgb_city_tbl c
            on upper(l.city) = upper(c.city)
        join 
            chips_stg.psxlatitem x
            on c.tgb_reg_district = x.fieldvalue
            and x.fieldname = 'TGB_REG_DISTRICT'
            and x.eff_status = 'A'
            and x.effdt = (
                select max(x2.effdt)
                from chips_stg.psxlatitem x2
                where x.fieldname = x2.fieldname
                    and x.fieldvalue = x2.fieldvalue
                    and x2.eff_status = x.eff_status
                    and x2.effdt <= sysdate
            )
        where 
            l.setid = 'BCSET'
            and l.eff_status = 'A'
            and l.effdt = (
                select max(l2.effdt)
                from chips_stg.ps_location_tbl l2
                where l.setid = l2.setid
                    and l.location = l2.location
                    and l.eff_status = l2.eff_status
                    and l2.effdt <= sysdate
            )
    )
    select 
        row_number() over (order by setid_loc) location_sid, 
        s.*,
        'Y' curr_ind,
        current_date upt_dt,
        null eff_dt,
        null end_dt
    from src_data s
;

drop index cdw.ilocation_d_a1;

create index cdw.ilocation_d_a1 on cdw.or_location_d (city)
tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
storage  ( initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

drop index cdw.ilocation_d_a2;

create bitmap index cdw.ilocation_d_a2 on cdw.or_location_d (city)
tablespace cdw_indx pctfree 10 initrans 2   maxtrans 255
storage  ( initial 10m  minextents 1 maxextents unlimited)
nologging compute statistics;

drop index cdw.ilocation_d_a3;

create bitmap index cdw.ilocation_d_a3 on cdw.or_location_d (regional_district)
tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
storage (initial 10m  minextents 1  maxextents unlimited)
nologging compute statistics;

commit;