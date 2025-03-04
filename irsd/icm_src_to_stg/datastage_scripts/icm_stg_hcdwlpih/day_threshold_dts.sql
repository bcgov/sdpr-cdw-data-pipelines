select to_char(day_threshold_expiry_dts, 'yyyy-mm-dd hh24:mi:ss')  
from icm_stg.is_icm_etl_schedule_config 
where trunc(sched_load_dt) = trunc(sysdate)
;