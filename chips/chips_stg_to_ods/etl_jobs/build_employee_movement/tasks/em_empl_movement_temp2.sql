truncate table ods.em_empl_movement_temp2;

insert into ods.em_empl_movement_temp2 
    select * from ods.em_temp_bu9 
    union 
    select * from ods.em_temp_bu11
;

commit;