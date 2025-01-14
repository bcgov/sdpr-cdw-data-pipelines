INSERT INTO EM_JOB_CLASS_D(
	"JOBCLASS_SID",
	"JOBCODE_BK",
	"JC_DESCR",
	"SETID",
	"JOBCODE",
	"EFFDT",
	"JC_EFF_STATUS",
	"JC_DESCRSHORT",
	"SAL_ADMIN_PLAN",
	"GRADE",
	"STEP",
	"UNION_CD",
	"STD_HOURS",
	"STD_HRS_FREQUENCY",
	"JOB_FUNCTION",
	"JOB_FUNC_DESCR",
	"EMP_GROUP",
	"EMP_GRP_DESCR",
	"INCL_EXCL",
	"INCL_EXCL_DESCR",
	"EFF_END_DT",
	"CURR_IND"
) VALUES (
	ORCHESTRATE."JOBCLASS_SID",
	ORCHESTRATE."JOBCODE_BK",
	ORCHESTRATE."JC_DESCR",
	ORCHESTRATE."SETID",
	ORCHESTRATE."JOBCODE",
	ORCHESTRATE."EFFDT",
	ORCHESTRATE."JC_EFF_STATUS",
	ORCHESTRATE."JC_DESCRSHORT",
	ORCHESTRATE."SAL_ADMIN_PLAN",
	ORCHESTRATE."GRADE",
	ORCHESTRATE."STEP",
	ORCHESTRATE."UNION_CD",
	ORCHESTRATE."STD_HOURS",
	ORCHESTRATE."STD_HRS_FREQUENCY",
	ORCHESTRATE."JOB_FUNCTION",
	ORCHESTRATE."JOB_FUNC_DESCR",
	ORCHESTRATE."EMP_GROUP",
	ORCHESTRATE."EMP_GRP_DESCR",
	ORCHESTRATE."INCL_EXCL",
	ORCHESTRATE."INCL_EXCL_DESCR",
	ORCHESTRATE."EFF_END_DT",
	ORCHESTRATE."CURR_IND"
)
;