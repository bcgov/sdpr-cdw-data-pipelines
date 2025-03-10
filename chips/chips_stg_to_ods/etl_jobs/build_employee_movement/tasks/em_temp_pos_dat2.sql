truncate table ods.em_temp_pos_dat2;

insert into ods.em_temp_pos_dat2
    select position_nbr, to_char(effdt,'YYYYMMDD') as effdt, descr, can_noc_cd 
    from CHIPS_STG.PS_POSITION_DATA
;

commit;