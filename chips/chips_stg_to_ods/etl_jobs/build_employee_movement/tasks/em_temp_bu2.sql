truncate table ods.em_temp_bu2;

insert into ods.em_temp_bu2 
    select * 
    from ods.em_temp_bu1 
    where n_level1_descr is not null
;

commit;