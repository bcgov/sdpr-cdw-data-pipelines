UPDATE EM_APPOINTMENT_STATUS_D SET
	"APPOINTMENT_STATUS" = ORCHESTRATE."APPOINTMENT_STATUS",
	"APPT_STATUS_DESCR" = ORCHESTRATE."APPT_STATUS_DESCR",
	"APPT_DESCR_SHORT" = ORCHESTRATE."APPT_DESCR_SHORT",
	"APPOINTMENT_GROUP" = ORCHESTRATE."APPOINTMENT_GROUP",
	"APPT_GROUP_DESCR" = ORCHESTRATE."APPT_GROUP_DESCR",
	"APPT_GROUP_DESCR_SHORT" = ORCHESTRATE."APPT_GROUP_DESCR_SHORT"
WHERE "APPT_STATUS_SID" = ORCHESTRATE."APPT_STATUS_SID"
;