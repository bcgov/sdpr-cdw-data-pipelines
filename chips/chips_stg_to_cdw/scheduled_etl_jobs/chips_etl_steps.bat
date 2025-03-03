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
rem STEO010 - Run CHIPS API to CHIPS_STG (Oracle) ETL Pipeline
rem ********************************************************************

:STEP010 

@REM @REM activate virtual environment
@REM call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\.venv\Scripts\activate.bat

@REM @REM run python job script
@REM python "E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.py"

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
