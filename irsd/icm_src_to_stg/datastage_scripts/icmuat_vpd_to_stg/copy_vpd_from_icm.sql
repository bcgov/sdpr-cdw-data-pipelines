create table vpd_recon_buid_v as 
select table_owner, table_name, buid_icmdw_1000_count, buid_icmdw_2000_count, 
    buid_icmdw_3000_count, buid_icmdw_4000_count, buid_0_count, buid_null_count, 
    buid_other_count 
from vpd.vpd_recon_buid_v@icmdwppr_link
;

commit;

create table vpd_recon_row_count_v as 
select table_owner, table_name, open_count, msd_count, mcfd_count, mecc_count, 
    diff_count, open_subq_join_count, diff_subq_join_count, vpd_msd_predicate,  
    vpd_mcfd_predicate, vpd_mecc_predicate 
from vpd.vpd_recon_row_count_v@icmdwppr_link
;

commit;
 