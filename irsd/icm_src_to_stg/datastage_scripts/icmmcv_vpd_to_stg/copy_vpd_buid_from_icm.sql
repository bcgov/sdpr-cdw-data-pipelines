create table icm_stg.vpd_recon_buid_v as 
select table_owner, table_name, buid_icmdw_1000_count, buid_icmdw_2000_count, 
    buid_icmdw_3000_count, buid_icmdw_4000_count, buid_0_count, 
    buid_null_count, buid_other_count 
from vpd.vpd_recon_mcv_buid_v@icmdwuat_link
;

commit;
