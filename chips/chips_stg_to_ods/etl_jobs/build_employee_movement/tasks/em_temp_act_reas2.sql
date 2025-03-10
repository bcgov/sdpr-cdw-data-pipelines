truncate table ods.em_temp_act_reas2;

insert into ods.em_temp_act_reas2
    select action, action_reason, descr 
    from CHIPS_STG.PS_ACTN_REASON_TBL 
    where action||action_reason||to_char(effdt,'YYYYMMDD') in (
        select action||action_reason||to_char(effdt,'YYYYMMDD') 
        from ods.em_temp_act_reas1
    )
;

commit;