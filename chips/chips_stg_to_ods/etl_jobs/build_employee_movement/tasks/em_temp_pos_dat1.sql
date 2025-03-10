truncate table ods.em_temp_pos_dat1;

insert into ods.em_temp_pos_dat1
    select position_nbr, to_char(max(effdt),'YYYYMMDD') as effdt 
    from CHIPS_STG.PS_POSITION_DATA 
    where eff_status='A' 
    group by position_nbr
;

commit;