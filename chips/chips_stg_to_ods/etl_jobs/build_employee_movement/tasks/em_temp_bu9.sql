truncate table ods.em_temp_bu9;

insert into ods.em_temp_bu9 
    select * 
    from ods.em_temp_bu8 
    where p_level1_descr is not null
;

commit;