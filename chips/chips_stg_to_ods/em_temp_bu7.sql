create table ods.em_temp_bu7 as 
    select * from ods.em_temp_bu6 
    union 
    select * from ods.em_temp_bu2
;