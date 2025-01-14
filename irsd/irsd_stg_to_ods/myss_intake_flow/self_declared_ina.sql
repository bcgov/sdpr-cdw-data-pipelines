MERGE INTO IRSD_MYSS_INTAKE_FLOW TARGET USING (
    SELECT /*+ PARALLEL 4 DYNAMIC_SAMPLING(4)*/ 
        IA_SR_WID,  
        ROW_NUMBER() over (partition BY B.SR_WID ORDER BY B.LAST_UPD_DT DESC) AS LATEST_ROW_NUM, 
        CASE 
            WHEN NVL(B.SHORT_TERM_FOOD,' ' ) IN ('Y', 'Yes') 
                OR NVL(B.SHORT_TERM_MEDICAL, ' ') IN ('Y', 'Yes') 
                OR NVL(B.SHORT_TERM_SHELTER, ' ') IN ('Y', 'Yes')  
                THEN 'TRUE' 
            ELSE 'FALSE' 
        END SELF_DECLARED_INA_FLG 
    FROM IRSD_MYSS_INTAKE_FLOW A 
    JOIN ICM_STG.WC_SR_FORMS_DM2 B 
        ON A.IA_SR_WID = B.SR_WID 
)  SRC ON (TARGET.IA_SR_WID = SRC.IA_SR_WID AND SRC.LATEST_ROW_NUM = 1) 
WHEN MATCHED THEN UPDATE 
SET TARGET.SELF_DECLARED_INA_FLG = SRC.SELF_DECLARED_INA_FLG
;

commit;