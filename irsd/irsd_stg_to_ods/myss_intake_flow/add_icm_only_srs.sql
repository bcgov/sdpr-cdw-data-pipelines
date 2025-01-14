insert into IRSD_MYSS_INTAKE_FLOW (  
CLIENT_BCEID_GUID,  
CLIENT_BCEID_ID,  
IA_SR_NUM,  
RELATED_SR_NUM,  
IA_CREATED_ON_DT,  
IA_CLOSE_DT,  
IA_X_CREATED_BY,  
IA_X_OWNER,  
IA_STATUS,  
IA_X_SR_CAT_TYPE_CD,  
IA_SUBTYPE_CD,  
IA_X_SUB_SUB_TYPE,  
IA_X_SLA1_START_DT,  
IA_X_SLA2_START_DT,  
IA_X_DUE_DT,  
IA_PRIO_CD,  
IA_RESOLUTION_CD,  
IA_X_COMM_METHOD_CD,  
IA_CASE_NUM,  
IA_CASE_OPEN_REOPEN_DT,  
IA_X_CREATED_BY_OFFICE,  
IA_X_SVC_OFFICE,  
IA_X_LOCAL_OFFICE,  
IA_STATUS_GROUP,  
IA_X_TPC_STATUS_CD,  
IA_SR_WID,  
IA_CASE_WID,  
IA_CASE_X_LEGACY_FILE_NUM,  
IA_CONTACT_WID,  
IA_X_PUBLISH_CD,  
SEQ_NO   
,APPLICATION_SUBMISSION_DT  
,SELF_DECLARED_INA_FLG  
,OVERRIDE_CODE  
,FIRST_CONTACT_FLG  
,ELECTRONIC_SIGNATURE_FLG  
,AUTO_START_FLG  
,START_LOV_RETURNED_FLG  
,WORK_SEARCH_GRP   
,CURRENT_CLIENT_ID  
,ICM_LINKED_STATUS  
,IA_APPT_DT  
,PULLED_FLG  
)  
select /*+ PARALLEL 4 DYNAMIC_SAMPLING(4)*/  
Per.X_CON_GUID              CLIENT_BCEID_GUID,  
PER.X_CON_BCEID             CLIENT_BCEID_ID,  
  
/* income assistance */
SRA.SR_NUM       IA_SR_NUM,  
null                        RELATED_SR_NUM,  
SRA.CREATED_ON_DT    IA_CREATED_ON_DT,  
nvl(SRA.X_ACTUAL_CLOSE_DT,SRA.CLOSE_DT)      IA_CLOSE_DT,  
SRA.X_CREATED_BY     IA_X_CREATED_BY,  
SRA.X_OWNER      IA_X_OWNER,  
SRA.STATUS       IA_STATUS,  
SRA.X_SR_CAT_TYPE_CD   IA_X_SR_CAT_TYPE_CD,  
SRA.SUBTYPE_CD     IA_SUBTYPE_CD,  
SRA.X_SUB_SUB_TYPE     IA_X_SUB_SUB_TYPE,  
SRA.X_SLA1_START_DT    IA_X_SLA1_START_DT,  
SRA.X_SLA2_START_DT    IA_X_SLA2_START_DT,  
SRA.X_DUE_DT       IA_X_DUE_DT,  
SRA.PRIO_CD      IA_PRIO_CD,  
SRA.RESOLUTION_CD    IA_RESOLUTION_CD,  
SRA.X_COMM_METHOD_CD   IA_X_COMM_METHOD_CD,  
C.CASE_NUM     IA_CASE_NUM,  
NVL(C.X_REOPEN_DT,CASE_DT) IA_CASE_OPEN_REOPEN_DT,  
SRA.X_CREATED_BY_OFFICE  IA_X_CREATED_BY_OFFICE,  
SRA.X_SVC_OFFICE   IA_X_SVC_OFFICE,  
SRA.X_LOCAL_OFFICE   IA_X_LOCAL_OFFICE,  
case SRA.STATUS  
 when 'Cancelled'   Then 'Inactive'  
       When 'Closed'      Then 'Inactive'  
       when 'Pending'     Then 'Active'  
       When 'In Progress' Then 'Active'  
       When 'Ready'       Then 'Active'  
       When 'Open'        Then 'Active'  
       Else                    'Unspecified'  
 END          as IA_STATUS_GROUP,  
SRA.X_TPC_STATUS_CD    IA_X_TPC_STATUS_CD,  
SRA.ROW_WID      IA_SR_WID,  
C.ROW_WID      IA_CASE_WID,  
C.X_LEGACY_FILE_NUM    IA_CASE_X_LEGACY_FILE_NUM,  
SRF.CONTACT_WID    IA_CONTACT_WID,  
SRA.X_PUBLISH_CD           IA_X_PUBLISH_CD,  
1000000 + row_number() over (partition by (PER.X_CON_GUID) order by SRA.created_on_dt desc)  
       ICM_IA_SR_seq_no  
, NULL   as APPLICATION_SUBMISSION_DT  
,'FALSE' as SELF_DECLARED_INA_FLG  
/* set to manually created if the owner is not SIEBEL EIA else set to no override. */
, case when SRA.x_created_by = 'SIEBEL_EAI' then 'No Override' else 'Manually Created' end as OVERRIDE_CODE  
,'FALSE' as FIRST_CONTACT_FLG  
,'FALSE' as ELECTRONIC_SIGNATURE_FLG  
,'FALSE' as AUTO_START_FLG  
,'FALSE' as START_LOV_RETURNED_FLG  
,'Not Validated' as WORK_SEARCH_GRP   
,'FALSE' AS CURRENT_CLIENT_ID  
,'Not Found in ICM' as ICM_LINKED_STATUS  
,SRA.X_APPT_DT  
,'FALSE' as PULLED_FLG  
FROM   
           ICM_STG.W_SRVREQ_D SRA   
     JOIN  ICM_STG.W_SRVREQ_F SRF     ON SRF.SR_WID = SRA.ROW_WID  
                                     AND SRF.DELETE_FLG = 'N'  
/*When porting this over from DM to DS the date below was set to the variable ICM_4_2_5_DATE - which was hard coded to the date below*/
                                     AND SRF.CREATED_ON_DT >=  To_Date('2017-Feb-25 12:00:00 AM','YYYY-Mon-DD HH:MI:SS AM')   
    JOIN  ICM_STG.W_PARTY_PER_D PER   ON PER.ROW_WID = SRF.CONTACT_WID   
    left JOIN  ICM_STG.W_CASE_D   C        ON SRF.CASE_WID = C.ROW_WID   
WHERE SRA.X_SR_CAT_TYPE_CD = 'Application'  
  AND SRA.SUBTYPE_CD = 'Income Assistance'  
  AND SRA.DELETE_FLG = 'N'  
  AND SRA.SR_NUM NOT IN (SELECT ICM_SR_NUM FROM ODS.IRSD_MYSS_INTAKE_FLOW WHERE ICM_SR_NUM IS NOT NULL)