SELECT EMPL_SK ,EMPLID, EMPL_IDIR, START_PAY_PERIOD, END_PAY_PERIOD, CURRENT_FLG
FROM EM_EMPLOYEE_IDIR_SCD
WHERE CURRENT_FLG = 'Y' 
order by EMPLID
;