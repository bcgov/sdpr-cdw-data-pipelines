import logging

logger = logging.getLogger('__main__.' + __name__)

class PrimaryKeys:
    def __init__(self):
        # the primary_keys dictionary should have keys of the form [ORACLE_TABLE_NAME]_PK
        # and values should be lists of columns in [ORACLE_TABLE_NAME] that compose the PK.
        self.primary_keys = {
            "MR_TIMESHEET_VW_PK": ["EMPLID", "EMPL_RCD"],
            "MHR_TIMESHEET_VW_PK": ["EMPLID", "EMPL_RCD", "DUR", "SEQ_NBR"],
            "PS_ACTION_TBL_PK": ["ACTION", "EFFDT"],
            "PS_ACTN_REASON_TBL_PK": ["ACTION", "ACTION_REASON", "EFFDT"],
            "PS_BEN_DEFN_OPTN_PK": ["BENEFIT_PROGRAM", "EFFDT", "PLAN_TYPE", "OPTION_ID"],
            "PS_BEN_DEFN_PGM_PK": ["BENEFIT_PROGRAM", "EFFDT"],
            "PS_BENEF_PLAN_TBL_PK": ["PLAN_TYPE", "BENEFIT_PLAN", "EFFDT"],
            "PS_BUS_UNIT_OPT_HR_PK": ["SETID"],
            "PS_BUS_UNIT_TBL_FS_PK": ["BUSINESS_UNIT"],
            "PS_BUS_UNIT_TBL_HR_PK": ["BUSINESS_UNIT"],
            "PS_CAN_NOC_TBL_PK": ["CAN_NOC_CD", "EFFDT"],
            "PS_COMPANY_TBL_PK": ["COMPANY", "EFFDT"],
            "PS_DEDUCTION_CLASS_PK": ["PLAN_TYPE", "DEDCD", "EFFDT", "DED_CLASS", "DED_SLSTX_CLASS"],
            "PS_DEDUCTION_FREQ_PK": ["PLAN_TYPE", "DEDCD", "EFFDT", "PAY_FREQUENCY"],
            "PS_DEDUCTION_TBL_PK": ["PLAN_TYPE", "DEDCD", "EFFDT"],
            "PS_DEPT_TBL_PK": ["DEPTID", "SETID", "EFFDT"],
            "PS_DEPT_TREE_NODE_PK": ["SETID", "DEPTID", "TREE_NODE"],
            "PS_EARNINGS_TBL_PK": ["ERNCD", "EFFDT"],
            "PS_EMPL_CTG_L1_PK": ["SETID", "LABOR_AGREEMENT", "EMPL_CTG", "EFFDT"],
            "PS_EMPLOYEES_PK": ["EMPLID", "EMPL_RCD"],
            "PS_EMPLOYMENT_PK": ["EMPLID", "EMPL_RCD"],
            "PS_EMPLOYMENT_old_PK": ["EMPLID", "EMPL_RCD"],
            "PS_JOB_PK": ["EMPLID", "EMPL_RCD", "EFFDT", "EFFSEQ"],
            "PS_JOBCODE_TBL_PK": ["SETID", "JOBCODE", "DESCR"],
            "PS_JOBFUNCTION_TBL_PK": ["JOB_FUNCTION", "EFFDT"],
            "PS_LEAVE_ACCRUAL_PK": ["EMPLID", "EMPL_RCD", "COMPANY", "PLAN_TYPE", "ACCRUAL_PROC_DT"],
            "PS_LEAVE_PLAN_PK": ["EMPLID", "EMPL_RCD", "PLAN_TYPE", "BENEFIT_NBR", "EFFDT"],
            "PS_LEAVE_PLAN_TBL_PK": ["PLAN_TYPE", "BENEFIT_PLAN", "EFFDT"],
            "PS_LEAVE_RATE_TBL_PK": ["PLAN_TYPE", "BENEFIT_PLAN", "EFFDT", "SERVICE_INTERVALS"],
            "PS_LOCATION_TBL_PK": ["SETID", "LOCATION", "EFFDT"],
            "PS_PAY_CALENDAR_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT"],
            "PS_PAY_CHECK_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM", "SEPCHK"],
            "PS_PAY_DEDUCTION_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM", "SEPCHK", "BENEFIT_RCD_NBR", "PLAN_TYPE", "BENEFIT_PLAN", "DEDCD", "DED_CLASS", "DED_SLSTX_CLASS"],
            "PS_PAY_EARNINGS_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM", "ADDL_NBR"],
            "PS_PAY_EARNINGS_2_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM", "ADDL_NBR"],
            "PS_PAY_LINE_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM"],
            "PS_PAY_OTH_EARNS_PK": ["COMPANY", "PAYGROUP", "PAY_END_DT", "OFF_CYCLE", "PAGE_NUM", "LINE_NUM", "ADDL_NBR", "ERNCD"],
            "PS_PAYGROUP_TBL_PK": ["COMPANY", "PAYGROUP", "EFFDT"],
            "PS_PER_ORG_ASGN_PK": ["EMPLID", "EMPL_RCD"],
            "PS_PERSONAL_DATA_PK": ["EMPLID"],
            "PS_POSITION_DATA_PK": ["POSITION_NBR", "EFFDT"],
            "PS_SAL_GRADE_TBL_PK": ["SETID", "SAL_ADMIN_PLAN", "GRADE", "EFFDT"],
            "PS_SAL_PLAN_TBL_PK": ["SETID", "SAL_ADMIN_PLAN", "EFFDT"],
            "PS_SAL_STEP_TBL_PK": ["SETID", "SAL_ADMIN_PLAN", "GRADE", "EFFDT", "STEP"],
            "PS_SET_CNTRL_REC_PK": ["SETCNTRLVALUE", "REC_GROUP_ID", "RECNAME"],
            "PS_SET_CNTRL_TBL_PK": ["SETCNTRLVALUE"],
            "PS_SET_CNTRL_TREE_PK": ["SETCNTRLVALUE", "TREE_NAME"],
            "PS_SETID_TBL_PK": ["SETID"],
            "PS_TGB_CITY_TBL_PK": ["CITY"],
            "PS_TGB_CNOCSUB_TBL_PK": ["CAN_NOC_CD", "EFFDT", "TGB_CAN_NOC_SUB_CD"],
            "PS_TGB_FTEBURN_TBL_PK": ["PAY_END_DT", "BUSINESS_UNIT", "DEPTID", "EMPLID", "EMPL_RCD", "JOB_FUNCTION"],
            "PS_TRAINING_PK": ["EMPLID", "COURSE_START_DT", "COURSE", "SESSION_NBR", "COURSE_TITLE"],
            "PS_TREE_LEVEL_TBL_PK": ["SETID", "TREE_LEVEL", "EFFDT"],
            "PS_UNION_TBL_PK": ["UNION_CD", "EFFDT"],
            "PSOPRDEFN_BC_PK": ["OPRID"],
            "PSTREELEVEL_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_LEVEL"],
            "PSTREENODE_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_NODE_NUM", "TREE_NODE", "TREE_BRANCH"],
            "PSXLATITEM_PK": ["FIELDNAME", "FIELDVALUE", "EFFDT"],
            "TREEBRANCH_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_BRANCH"],
            "TREEDEFN_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT"],
            "TREELEAF_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_NODE_NUM", "RANGE_FROM", "RANGE_TO", "TREE_BRANCH"],
            "TREELEVEL_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_LEVEL"],
            "TREENODE_PK": ["SETID", "SETCNTRLVALUE", "TREE_NAME", "EFFDT", "TREE_NODE_NUM", "TREE_NODE", "TREE_BRANCH"],
        }

    def get_primary_key(self, pk_name: str) -> list[str]:
        """
        Gets the primary key for pk_name from a dict of the form:
            
            {'pk_name': ['col1', ..., 'coln'], ...}
        
        Args:
            pk_name (str): a key that can be looked up in the primary key dictionary to return
                a list of column names representing a primary key
        """
        try:
            pk = self.primary_keys[pk_name]
            logger.debug(f'Primary key called {pk_name} is {pk}')
            return pk
        except KeyError:
            logger.exception(f'Primary key is not defined for {pk_name}')
            return []
