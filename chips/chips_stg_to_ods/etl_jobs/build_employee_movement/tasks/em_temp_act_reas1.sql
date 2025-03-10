truncate table ods.em_temp_act_reas1;

insert into ods.em_temp_act_reas1
    select action, action_reason, max(effdt) as effdt 
    from CHIPS_STG.PS_ACTN_REASON_TBL 
    where eff_status='A' 
    group by action, action_reason
;

commit;