@ECHO OFF
@SETLOCAL & PUSHD & SET RET=
@REM ---------------------------------------------------------------
@REM HCDWLPWA - CHIPS SRC to CDW ETL Job
@REM
@REM ----------------------------------------------------------------
@REM Description: Wrapper for CHIPS ETL
@REM  STEP010 --- LOAD_STAGING      - JS: JS_copy_PeopleSoft_tables
@REM  STEP015 --- BU_Hierarchy_Flattening
@REM  STEP020 --- Generate Load Control
@REM  STEP030 --- Load Dimension Tables
@REM  STEP040 --- Load Fact Tables
@REM  STEP050 --- Finalize Load Control
@REM  STEO060 --- PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube
@REM ----------------------------------------------------------------
@REM Modification Log
@REM ----------------------------------------------------------------
@REM
@REM    Date      Change #   Name          Desc   
@REM -----------  ---------  ----------- --------------------------
@REM 2010.Set.16  SR106592    Mpal        The structure of the CHIPS ETL has been 
@REM                                      completly rewritten to simplify the process
@REM 2018-09-20   SR627223   GN	          E-mail notification standardization. Added the e-mail related variables and the e-mailing lines
@REM                                      Added call to EnvironmentStart, EnvironmentEnd and the call to AGENT_EXE
@REM                                      Removed common code to EnvironmentStart/End.bat
@REM 2024-July    NA         JS           STEP010 has been changed to get data from the MHRGRP API
@REM 2024-07-29   EPIC0010289   CDodd          Implement data handshake indication
@REM ----------------------------------------------------------------

@SET JOB_NAME=%~n0
@SET JOB_DESCRIPTION=CHIPS SRC to CDW ETL Job
@SET OBJ_TYPE=ETL
@SET APP_SYS=CHIPS
@set DS_PROJECT=HR

@CALL %ETL_BIN%\EnvironmentStart.bat
@IF %RET% NEQ 0 GOTO EXIT
@CALL %ETL_BIN%\data_handshake.bat START "CHIPS Data"

:Job_Initiation 
@SET STARTING_STEP=STEP010



rem ---------------------------------------------------------------
rem CHIPS_ETL_STEPS
rem
rem Description: Runs Data Manager job stream 
rem 		 
rem Input: Argument 1 = JOB_NAME
rem        Argument 2 = STEP_NUM
rem ----------------------------------------------------------------

rem ----------------------------------------------------------------
rem Set job variables.
rem ----------------------------------------------------------------
@REM set JOB_NAME=JOB_NAME
set STEP_NUM=%STARTING_STEP%

set LOG_FOLDER=E:\ETL_V8\%APP_ENV%\%APP_SYS%\log
set SCRIPT_LOG=%LOG_FOLDER%\%JOB_NAME%\%JOB_NAME%_log.txt

echo.>> %SCRIPT_LOG%
echo *****  Entering  CHIPS_ETL_STEPS.bat              >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo.>> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo JOB_NAME=%JOB_NAME%                               >> %SCRIPT_LOG%
echo DS_PROCESS_NAME=%DS_PROCESS_NAME%                 >> %SCRIPT_LOG%
echo Start Date= %DATE%                                >> %SCRIPT_LOG%
echo Start Time= %TIME%                                >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%

echo  step  %step_num%        >> %SCRIPT_LOG%  

goto %STEP_NUM% 

rem ********************************************************************
rem STEO010 - Run CHIPS API to CHIPS_STG (Oracle) ETL Pipeline
rem ********************************************************************

:STEP010 

@REM @REM activate virtual environment
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\.venv\Scripts\activate.bat

@REM @REM run python job script
python "E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.py"

@SET RET=%ERRORLEVEL%
REM -----------------------------------------------------------------------------------------------------
REM Check return code for data stage job run.  
REM Only return code of 1 (Finished OK) and 2 (Finished with Warning) are acceptable.
REM -----------------------------------------------------------------------------------------------------
IF %RET% NEQ 1 IF %RET% NEQ 2 (
    SET RET=16
    GOTO FAILED
)
SET RET=0


rem ********************************************************************
rem STEO020 - build chips_stg.px_tree_flattened
rem ********************************************************************

:STEP020 

SET DS_PROJECT=HR
set DS_PROCESS_NAME="BU_Hierarchy_Flattening" 
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
    GOTO FAILED
)
SET RET=0


rem ********************************************************************
rem STEO030 - Load Dimension Tables
rem ********************************************************************

:STEP030 
SET DS_PROJECT=HR
set DS_PROCESS_NAME="CHIPS_DIM_MASTER"
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
    GOTO FAILED
)
SET RET=0


rem ********************************************************************
rem STEO040 - Load Fact Tables
rem ********************************************************************

:STEP040 
SET DS_PROJECT=HR
set DS_PROCESS_NAME="F_STIIP"
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
    GOTO FAILED
)
SET RET=0

:LOAD_FTE

REM #########################################################################################
REM #########################################################################################
SET DS_PROJECT=HR
set DS_PROCESS_NAME="F_FTE_BURN"
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
    GOTO FAILED
)
SET RET=0


:FTE_DONE


rem ********************************************************************
rem STEP050 - PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube
rem ********************************************************************

:STEP050 

SET DS_PROJECT=FASB
set DS_PROCESS_NAME="PROCESS_CHIPS_SALARY_DATA"
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
    GOTO FAILED
)
SET RET=0


:EXIT 
echo. >> %SCRIPT_LOG%
echo ---------------------------------------------------------------------- >> %SCRIPT_LOG%
echo Check for final error code and print job complete message to the log.  >> %SCRIPT_LOG%
echo ---------------------------------------------------------------------- >> %SCRIPT_LOG%
echo Last errorlevel before exiting the job=%errorlevel% >> %SCRIPT_LOG%
echo.                                                  >> %SCRIPT_LOG%
echo.                                                  >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo %JOB_NAME% Completed Successfully.                >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%

goto FINISH


:FAILED
SET RET=16
echo.                                                  >> %SCRIPT_LOG%
echo.                                                  >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo %JOB_NAME% Failed. RETURN CODE=%RET%              >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%


:FINISH
echo.>> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo *****  Finishing CHIPS_ETL_STEPS.bat              >> %SCRIPT_LOG%
echo RETURN CODE  RET=%RET%                            >> %SCRIPT_LOG%
echo End Date= %DATE%                                  >> %SCRIPT_LOG%
echo End Time= %TIME%                                  >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo.>> %SCRIPT_LOG%





:EXIT
@SET EXIT_CODE=%RET%
@CALL %ETL_BIN%\EnvironmentEnd.bat

@POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%

@REM ------------------------------------------------------------
@REM Send Return code back to ESP.
@REM ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%
