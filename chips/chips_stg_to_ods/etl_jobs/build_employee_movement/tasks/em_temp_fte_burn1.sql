truncate table ods.em_temp_fte_burn1;

insert into ods.em_temp_fte_burn1
    select emplid, business_unit, to_char(max(pay_end_dt),'YYYYMMDD') as pay_end_dt 
    from CHIPS_STG.PS_TGB_FTEBURN_TBL 
    group by emplid, business_unit
;

commit;