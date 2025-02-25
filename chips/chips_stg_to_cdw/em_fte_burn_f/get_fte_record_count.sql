with

-- get the latest pay end date in em_fte_burn_f
last_pay_end_date_loaded as (
    select max(to_date(substr(pay_end_dt_sk, 1, length(pay_end_dt_sk) - 1), 'yyyy-mm-dd')) pay_end_dt 
    from cdw.em_fte_burn_f
)

select count(*) cnt
from chips_stg.ps_tgb_fteburn_tbl f,  chips_stg.ps_set_cntrl_rec sc2 
WHERE sc2.recname = 'JOBCODE_TBL' 
    AND sc2.setcntrlvalue = F.business_unit
    AND f.pay_end_dt >= (
        select * from last_pay_end_date_loaded
    )
;