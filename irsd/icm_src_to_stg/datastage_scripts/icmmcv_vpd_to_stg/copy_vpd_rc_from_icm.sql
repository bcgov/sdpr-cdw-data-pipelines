create table vpd_recon_row_count_v as 
select  table_owner, table_name, open_count, msd_count, mcfd_count, 
    mecc_count, diff_count, open_subq_join_count, diff_subq_join_count, 
    vpd_msd_predicate,  vpd_mcfd_predicate,  vpd_mecc_predicate 
from vpd.vpd_recon_mcv_row_count_v@icmdwuat_link
;

commit;
 