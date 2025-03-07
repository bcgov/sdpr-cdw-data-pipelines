ECHO OFF
setlocal & PUSHD & SET RET=
rem  ---------------------------------------------------------------------------
rem HCDWLPWH -- populates Employee Movement datat from MCHIPS_STG.
rem          -- populated Organization Chart data from MCHIPS_STG.
rem
rem Description: 
rem   This job controls the loading of Employee Movement data into the ODS.
rem   This job controls the loading of Organization Chart data into the ODS.
rem		
rem		Data Transfering between CHIPS source and ODS performed via DM 
rem  ---------------------------------------------------------------------------

set JOB_NAME=%~n0
set JOB_DESCRIPTION=Populate Employee Movement and Org Chart from CHIPS to ODS
set OBJ_TYPE=ETL
set APP_SYS=CHIPS
set DS_PROJECT=HR

CALL %ETL_BIN%\EnvironmentStart.bat
IF %RET% NEQ 0 GOTO EXIT

:Job_Initiation 
SET DS_PROCESS_NAME=Build_EMPLOYEE_ORGANIZATION
rem ------------------------------------------------------------
rem RUN Job Stream 
rem ------------------------------------------------------------
CALL %ETL_BIN%\DataStageJob.bat
set RET=%ERRORLEVEL%
ECHO %DS_PROCESS_NAME% return code is %RET% >>%BATCH_LOG_FILE%
REM -----------------------------------------------------------------------------------------------------
REM Check return code for data stage job run.  
REM Only return code of 1 (Finished OK) and 2 (Finished with Warning) are acceptable.
REM -----------------------------------------------------------------------------------------------------
IF %RET% NEQ 1 IF %RET% NEQ 2 (
    SET RET=16
    GOTO EXIT
)
SET RET=0
CALL %ETL_BIN%\data_handshake.bat COMPLETE "CHIPS Data"

:EXIT
set EXIT_CODE=%RET%

CALL %ETL_BIN%\EnvironmentEnd.bat

POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%

rem ------------------------------------------------------------
rem Send Return code back to ESP.
rem ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%
