delete ODS.ICM_VPD_RECON_BUID where EXTRACT_DT = trunc(sysdate);

commit;

insert into ODS.ICM_VPD_RECON_BUID
select /*+ parallel append */ trunc(sysdate) EXTRACT_DT, table_owner, table_name, 
    buid_icmdw_1000_count, buid_icmdw_2000_count, buid_icmdw_3000_count, 
    buid_0_count, buid_null_count, buid_other_count, buid_icmdw_4000_count 
from ICM_STG.VPD_RECON_BUID_V t
;

commit;

create bitmap index ICM_VPD_RECON_BUID_DT_B on ICM_VPD_RECON_BUID (EXTRACT_DT);

commit;