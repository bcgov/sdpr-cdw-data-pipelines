select nvl2(max(handshake_bypass_dt),'Y','N') handshake_bypass_today_yn 
from icm_stg.is_etl_handshake_bypass_config 
where trunc(sysdate) = trunc(handshake_bypass_dt)
;