truncate table ods.em_empl_movement;

insert into ods.em_empl_movement 
    select a.*, b.oprid as idir_id 
    from ods.em_employee_movement_t3 a 
    left join ods.em_emplid_2_idir b 
        on a.emplid=b.emplid
;

commit;