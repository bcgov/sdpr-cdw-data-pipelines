truncate table ods.em_temp_actn_reas;

insert into ods.em_temp_actn_reas 
    select distinct action, actiondescr 
    from chips_stg.d_action_reason
;

commit;