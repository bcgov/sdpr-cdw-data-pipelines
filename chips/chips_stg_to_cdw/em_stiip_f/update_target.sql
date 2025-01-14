UPDATE EM_STIIP_F 
    SET "EMPL_SID" = ORCHESTRATE."EMPL_SID", 
        "HOURLY_RATE" = ORCHESTRATE."HOURLY_RATE", 
        "LEAVE_HOURS" = ORCHESTRATE."LEAVE_HOURS", 
        "LEAVE_COST" = ORCHESTRATE."LEAVE_COST", 
        "PAID_COST" = ORCHESTRATE."PAID_COST", 
        "EMPL_TAKING_LEAVE" = ORCHESTRATE."Empl_taking_leave" 
WHERE "APPOINTMENT_STATUS_SID" = ORCHESTRATE."APPOINTMENT_STATUS_SID" 
    and "LEAVE_END_DT_SK"= ORCHESTRATE."LEAVE_END_DT_SK" 
    and "LEAVE_BEGIN_DT_SK" = ORCHESTRATE."LEAVE_BEGIN_DT_SK" 
    and "LOCATION_SID" = ORCHESTRATE."LOCATION_SID" 
    and "PAY_END_DT_SK" = ORCHESTRATE."PAY_END_DT_SK" 
    and "EMPL_STATUS_SID" = ORCHESTRATE."EMPL_STATUS_SID" 
    and "POSITION_SID" = ORCHESTRATE."POSITION_SID" 
    and "BU_SID" = ORCHESTRATE."BU_SID" 
    and "EMPLID" = ORCHESTRATE."EMPLID" 
    and "JOBCLASS_SID" = ORCHESTRATE."JOBCLASS_SID" 
    and "PAYCODE_SID" = ORCHESTRATE."PAYCODE_SID"
;