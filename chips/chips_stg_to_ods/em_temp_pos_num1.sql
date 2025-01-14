create table ods.em_temp_pos_num1 as (
    select position_nbr, descr, can_noc_cd 
    from ods.em_temp_pos_dat2 
    where position_nbr||effdt in (
        select position_nbr||effdt 
        from ods.em_temp_pos_dat1
    )
);