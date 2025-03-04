delete ods.icm_vpd_recon_count where extract_dt = trunc(sysdate);

commit;

insert into ods.icm_vpd_recon_count 
select /*+ parallel append */ trunc(sysdate) extract_dt, table_owner, table_name, 
    open_count, msd_count, mcfd_count, diff_count, open_subq_join_count, 
    diff_subq_join_count, vpd_msd_predicate,  vpd_mcfd_predicate, mecc_count, 
    vpd_mecc_predicate 
from icm_stg.vpd_recon_row_count_v t
;

commit;

create bitmap index ods.icm_vpd_recon_count_dt_b on icm_vpd_recon_count (extract_dt);

commit;