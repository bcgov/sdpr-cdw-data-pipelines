@ECHO OFF
@SETLOCAL & PUSHD & SET RET=
@REM  ---------------------------------------------------------------------------
@REM HCDWLPWH -- populates Employee Movement datat from MCHIPS_STG.
@REM          -- populated Organization Chart data from MCHIPS_STG.
@REM
@REM Description: 
@REM   This job controls the loading of Employee Movement data into the ODS.
@REM   This job controls the loading of Organization Chart data into the ODS.
@REM		
@REM		Data Transfering between CHIPS source and ODS performed via DM 
@REM
@REM  ---------------------------------------------------------------------------
@REM Modification Log
@REM ----------------
@REM
@REM    Date      Change #   Name          Desc   
@REM -----------  ---------  ------------ -------------------------
@REM 2016.Aug.26             JDM          Original (copied from HCDWLPWA)
@REM 2016.Oct.28  WO160219   KL           Added EM_ORGANIZATION (Org Chart) 
@REM 2018-09-14   SR627223   GN	          E-mail notification standardization. 
@REM                                      Added call to EnvironmentStart, EnvironmentEnd and the call to AGENT_EXE
@REM                                      Removed common code to EnvironmentStart/End.bat
@REM 2018-12-12   SR655039   KJD          Merged EM_ORG, EM_ORG_SD DM calls with a single
@REM                                      call that does both, plus CHIPS Organization stream
@REM 2024-07-29   EPIC0010289   CDodd          Implement data handshake indication
@REM  ---------------------------------------------------------------------------

@SET JOB_NAME=%~n0
@SET JOB_DESCRIPTION=Populate Employee Movement and Org Chart from CHIPS to ODS
@SET OBJ_TYPE=ETL
@SET APP_SYS=CHIPS
@set DS_PROJECT=HR

@CALL %ETL_BIN%\EnvironmentStart.bat
@IF %RET% NEQ 0 GOTO EXIT

:Job_Initiation 
SET DS_PROCESS_NAME=Build_EMPLOYEE_ORGANIZATION
@REM ------------------------------------------------------------
@REM RUN Job Stream 
@REM ------------------------------------------------------------
CALL %ETL_BIN%\DataStageJob.bat
@SET RET=%ERRORLEVEL%
@ECHO %DS_PROCESS_NAME% return code is %RET%                                   >>%BATCH_LOG_FILE%
REM -----------------------------------------------------------------------------------------------------
REM Check return code for data stage job run.  
REM Only return code of 1 (Finished OK) and 2 (Finished with Warning) are acceptable.
REM -----------------------------------------------------------------------------------------------------
IF %RET% NEQ 1 IF %RET% NEQ 2 (
    SET RET=16
    GOTO EXIT
)
SET RET=0
@CALL %ETL_BIN%\data_handshake.bat COMPLETE "CHIPS Data"

:EXIT
@SET EXIT_CODE=%RET%

@CALL %ETL_BIN%\EnvironmentEnd.bat

@POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%

@REM ------------------------------------------------------------
@REM Send Return code back to ESP.
@REM ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%
