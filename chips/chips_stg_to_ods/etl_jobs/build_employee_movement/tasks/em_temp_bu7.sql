truncate table ods.em_temp_bu7;

insert into ods.em_temp_bu7 
    select * from ods.em_temp_bu6 
    union 
    select * from ods.em_temp_bu2
;

commit;