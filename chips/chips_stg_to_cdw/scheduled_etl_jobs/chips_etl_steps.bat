rem ---------------------------------------------------------------
rem CHIPS_ETL_STEPS
rem
rem Description: Runs Data Manager job stream 
rem 		 
rem Input: Argument 1 = JOB_NAME
rem        Argument 2 = STEP_NUM
rem ---------------------------------------------------------------
rem
rem ---------------------------------------------------------------
rem Modification Log
rem ----------------
rem
rem    Date      Change #   Name          Desc   
rem -----------  ---------  ------------- -------------------------
rem 2010.Sep.17             Milos         Rewrote the ETL wrapper to fix and simplify
rem 2016.Nov.09  WO160250   TSS           Add Dashboard logging on start and success/failure
rem 2017.09.28   WO160254   Milos         Add Step 60 - Preprocess data for EFP and EFP Salary cube
@REM 2018-07-06   SR627223   GN	          E-mail notification standardization. Removed the e-mail call and related lines
@REM 2019-10-17             TSS           modify calls to account for reject tables being loaded as part of fact build in data stage
rem 2024-08-13              kjd           temporary (goto EXIT) after downloading, do not post process
rem 2024-10-09              mpal          remove temporary (goto EXIT) after downloading; use DataStage job to download source to stage - Source_to_Stg_ALL
rem
rem
rem  STEP010 --- LOAD_STAGING
rem  STEP015 --- BU_Hierarchy_Flattening
rem  STEP020 --- Generate Load Control
rem  STEP030 --- Load Dimension Tables
rem  STEP040 --- Load Fact Tables
rem  STEP050 --- Finalize Load Control
rem  STEO060 --- PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube
rem
rem ----------------------------------------------------------------

rem ----------------------------------------------------------------
rem Set job variables.
rem ----------------------------------------------------------------
set JOB_NAME=%1
set STEP_NUM=%2

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
rem STEO010 - Load Staging
rem ********************************************************************

:STEP010 
@REM ------------------------------------------------------------
@REM RUN Job Stream 
@REM ------------------------------------------------------------
SET DS_PROJECT=HR

REM ##### set DS_PROCESS_NAME="JS_copy_PeopleSoft_tables"
set DS_PROCESS_NAME="Source_to_Stg_ALL"

CALL %ETL_BIN%\DataStageJob.bat
@SET RET=%ERRORLEVEL%
@ECHO %DS_PROCESS_NAME% return code is %RET%                                   >>%BATCH_LOG_FILE%



REM ####### @REM activate virtual environment
REM ####### call E:\ETL_V8\Python\people-soft-api\.venv\Scripts\activate.bat

REM ####### @REM run python job script
REM ####### python "E:\ETL_V8\Python\people-soft-api\HCDWLPWA.py"
REM ####### @SET RET=%ERRORLEVEL%
REM ####### @ECHO MHRGRP API to CHIPS_STG job return code is %RET%                            >>%BATCH_LOG_FILE%


REM -----------------------------------------------------------------------------------------------------
REM Check return code for data stage job run.  
REM Only return code of 1 (Finished OK) and 2 (Finished with Warning) are acceptable.
REM -----------------------------------------------------------------------------------------------------
IF %RET% NEQ 1 IF %RET% NEQ 2 (
    SET RET=16
    GOTO FAILED
)
SET RET=0


REM ####  goto FINISH


:STEP015
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
rem STEO020 - Set Load Control  for incremental load
rem ********************************************************************

:STEP020 
SET DS_PROJECT=HR
set DS_PROCESS_NAME="TURN_OFF_LOAD_IN_PROGRESS_IND_CH"
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



set DS_PROCESS_NAME="GEN_LOAD_CONTROL"
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


set DS_PROCESS_NAME="UPD_LOAD_CONTROL"
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
rem STEO050 - Load Control End
rem ********************************************************************

:STEP050 
SET DS_PROJECT=HR
set DS_PROCESS_NAME="SET_LOAD_SCHED_END_TIME"
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


set DS_PROCESS_NAME="TURN_OFF_CURR_LOAD_IND_CH"
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


set DS_PROCESS_NAME="SET_IN_PROGESS_TO_CURR_LOAD_CH"
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
rem STEO060 - PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube
rem ********************************************************************

:STEP060 



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
echo ------------------------------------------------      >> %SCRIPT_LOG%
echo [%TIME%] Update status on CDW Welcome Page            >> %SCRIPT_LOG%
echo ----------------------------------------------------  >> %SCRIPT_LOG%
call %ETL_BIN%\Update_CDW_Dashboard.bat Current %JOB_NAME% >> %SCRIPT_LOG%

goto FINISH



:FAILED
SET RET=16
echo.                                                  >> %SCRIPT_LOG%
echo.                                                  >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo %JOB_NAME% Failed. RETURN CODE=%RET%              >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo ------------------------------------------------     >> %SCRIPT_LOG%
echo [%TIME%] Update status on CDW Welcome Page           >> %SCRIPT_LOG%
echo ---------------------------------------------------- >> %SCRIPT_LOG%
call %ETL_BIN%\Update_CDW_Dashboard.bat Failed %JOB_NAME% >> %SCRIPT_LOG%


:FINISH
echo.>> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo *****  Finishing CHIPS_ETL_STEPS.bat              >> %SCRIPT_LOG%
echo RETURN CODE  RET=%RET%                            >> %SCRIPT_LOG%
echo End Date= %DATE%                                  >> %SCRIPT_LOG%
echo End Time= %TIME%                                  >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo.>> %SCRIPT_LOG%
