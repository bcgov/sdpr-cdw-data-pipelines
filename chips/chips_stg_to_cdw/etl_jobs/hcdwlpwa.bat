echo OFF
setlocal & pushd & set RET=
rem  ------------------------------------------------------------
rem HCDWLPWA - CHIPS API to CHIPS_STG to CDW ETL Job
rem  -------------------------------------------------------------
rem  STEP010 --- CHIPS API to CHIPS_STG
rem  STEP020 --- Build px_tree_flattened
rem  STEP030 --- Build Dimension Tables
rem  STEP040 --- Build Fact Tables
rem  STEP050 --- PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube

set JOB_NAME=%~n0
set JOB_DESCRIPTION=CHIPS SRC to CDW ETL Job
set OBJ_TYPE=ETL
set APP_SYS=CHIPS

call %ETL_BIN%\EnvironmentStart.bat
@if %RET% NEQ 0 GOTO EXIT
call %ETL_BIN%\data_handshake.bat START "CHIPS Data"

:Job_Initiation 
set STARTING_STEP=STEP010

rem  -------------------------------------------------------------
rem Set job variables.
rem  -------------------------------------------------------------
set STEP_NUM=%STARTING_STEP%

set LOG_FOLDER=E:\ETL_V8\%APP_ENV%\%APP_SYS%\log
set SCRIPT_LOG=%LOG_FOLDER%\%JOB_NAME%\%JOB_NAME%_log.txt

echo.>> %SCRIPT_LOG%
echo ***** Starting CHIPS ETL >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo.>> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%
echo JOB_NAME=%JOB_NAME%                               >> %SCRIPT_LOG%
echo DS_PROCESS_NAME=%DS_PROCESS_NAME%                 >> %SCRIPT_LOG%
echo Start Date= %DATE%                                >> %SCRIPT_LOG%
echo Start Time= %TIME%                                >> %SCRIPT_LOG%
echo ************************************************* >> %SCRIPT_LOG%

for %%i in ("%~dp0..\..\") do set "chips_root_dir=%%~fi" 

echo starting at step: %step_num% >> %SCRIPT_LOG%  
echo. >> %SCRIPT_LOG%

goto %STEP_NUM% 

rem *************************************************************
rem STEP010 - Run CHIPS API to CHIPS_STG (Oracle) ETL Pipeline
rem *************************************************************
:STEP010 
echo building chips_stg tables >>%SCRIPT_LOG%  
echo python log dir is set to: %chips_root_dir%chips_stg_to_cdw\etl_jobs\chips_src_to_stg\chips_src_to_stg.log >>%BATCH_LOG_FILE% 
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
if %RET% NEQ 0 (
    echo failed to build chips_stg tables in python >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %chips_root_dir%chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built chips_stg tables >>%BATCH_LOG_FILE%
set RET=0
echo. >> %SCRIPT_LOG%

rem *************************************************************
rem STEP020 - build chips_stg.px_tree_flattened
rem *************************************************************
:STEP020 
echo building px_tree_flattened >>%SCRIPT_LOG%  
echo python log dir is set to: %chips_root_dir%chips_stg_to_cdw\etl_jobs\build_px_tree_flattened\build_px_tree_flattened.log >>%BATCH_LOG_FILE% 
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_px_tree_flattened\build_px_tree_flattened.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
if %RET% NEQ 0 (
    echo failed to build px_tree_flattened >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %~dp0build_px_tree_flattened\build_px_tree_flattened.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built px_tree_flattened >>%BATCH_LOG_FILE%
set RET=0
echo. >> %SCRIPT_LOG%

rem *************************************************************
rem STEP030 - Load Dimension Tables
rem *************************************************************
:STEP030 
echo building dimension tables >>%BATCH_LOG_FILE%
echo python log dir is set to: %chips_root_dir%chips_stg_to_cdw\etl_jobs\build_dim_tables\build_dim_tables.log >>%BATCH_LOG_FILE% 
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_dim_tables\build_dim_tables.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
if %RET% NEQ 0 (
    echo failed to build dimension tables in python >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %~dp0build_dim_tables\build_dim_tables.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built dimension tables >>%BATCH_LOG_FILE%
set RET=0
echo. >> %SCRIPT_LOG%

rem *************************************************************
rem STEP040 - Load Fact Tables
rem *************************************************************
:STEP040  
echo building fact tables >>%BATCH_LOG_FILE%
echo python log dir is set to: %chips_root_dir%chips_stg_to_cdw\etl_jobs\build_fact_tables\build_fact_tables.log >>%BATCH_LOG_FILE% 
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_fact_tables\build_fact_tables.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
if %RET% NEQ 0 (
    echo failed to build fact tables in python >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %~dp0build_fact_tables\build_fact_tables.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built fact tables >>%BATCH_LOG_FILE%
set RET=0
echo. >> %SCRIPT_LOG%


rem *************************************************************
rem STEP050 - PROCESS_CHIPS_SALARY_DATA - Preporcess data for EFP and EFP Salary Cube
rem *************************************************************
:STEP050 
set DS_PROJECT=FASB
set DS_PROCESS_NAME="PROCESS_CHIPS_SALARY_DATA"
rem ------------------------------------------------------------
rem RUN Job Stream 
rem ------------------------------------------------------------
call %ETL_BIN%\DataStageJob.bat
set RET=%ERRORLEVEL%
echo %DS_PROCESS_NAME% return code is %RET% >>%BATCH_LOG_FILE% 
rem ------------------------------------------------------------
rem Check return code for data stage job run.  
rem Only return code of 1 (Finished OK) and 2 (Finished with Warning) are acceptable.
rem ------------------------------------------------------------
if %RET% NEQ 1 if %RET% NEQ 2 (
    set RET=16
    GOTO FAILED
)
set RET=0

:EXIT 
echo. >> %SCRIPT_LOG%
echo Last errorlevel before exiting the job=%errorlevel% >> %SCRIPT_LOG%
echo. >> %SCRIPT_LOG%
echo %JOB_NAME% completed successfully >> %SCRIPT_LOG%

goto FINISH

:FAILED
set RET=16
echo. >> %SCRIPT_LOG%
echo %JOB_NAME% Failed. RETURN CODE=%RET%  >> %SCRIPT_LOG%

:FINISH
echo. >> %SCRIPT_LOG%
echo ************************************************************* >> %SCRIPT_LOG%
echo *****  Finishing CHIPS ETL                        >> %SCRIPT_LOG%
echo RETURN CODE  RET=%RET%                            >> %SCRIPT_LOG%
echo End Date= %DATE%                                  >> %SCRIPT_LOG%
echo End Time= %TIME%                                  >> %SCRIPT_LOG%
echo ************************************************************* >> %SCRIPT_LOG%
echo. >> %SCRIPT_LOG%

:EXIT
set EXIT_CODE=%RET%
call %ETL_BIN%\EnvironmentEnd.bat

@POPD & ENDLOCAL & set EXIT_CODE=%EXIT_CODE%  & set AGENT_EXE=%AGENT_EXE%

rem ------------------------------------------------------------
rem Send Return code back to ESP.
rem ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%
