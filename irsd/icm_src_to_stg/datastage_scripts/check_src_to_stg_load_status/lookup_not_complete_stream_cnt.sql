select count(*) cnt 
from icm_stg.is_etl_tables_to_copy t 
where current_etl_job_yn = 'Y' 
    and etl_job_type = 'DAY' 
    and stg_env_load_yn = 'Y' 
    and stg_processing_status <> 'COMPLETED'
;