Insert into EM_EMPLOYEE_NAME_SCD (
    EMPL_SK,
    EMPLID,
    EMPL_NAME,
    START_PAY_PERIOD,
    END_PAY_PERIOD,
    CURRENT_FLG     
) values (
    ORCHESTRATE.EMPL_SK,
    ORCHESTRATE.EMPLID,
    ORCHESTRATE.EMPL_NAME,
    ORCHESTRATE.START_PAY_PERIOD,
    ORCHESTRATE.END_PAY_PERIOD,
    ORCHESTRATE.CURRENT_FLG     
);