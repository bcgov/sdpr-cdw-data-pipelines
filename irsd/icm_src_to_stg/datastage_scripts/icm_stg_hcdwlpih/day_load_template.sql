select day_standard_template_override  
from icm_stg.is_icm_etl_schedule_config 
where trunc(sched_load_dt) = trunc(sysdate)
;