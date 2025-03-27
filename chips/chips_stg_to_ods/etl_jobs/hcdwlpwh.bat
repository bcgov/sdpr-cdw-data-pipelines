ECHO OFF
setlocal & PUSHD & SET RET=
rem  ---------------------------------------------------------------------------
rem Description: 
rem   This job controls the loading of Employee Movement and Organization Chart 
rem   data into the ODS from CHIPS_STG.
rem  ---------------------------------------------------------------------------

set JOB_NAME=%~n0
set JOB_DESCRIPTION=Populate Employee Movement and Org Chart from CHIPS_STG to ODS
set OBJ_TYPE=ETL
set APP_SYS=CHIPS

CALL %ETL_BIN%\EnvironmentStart.bat
IF %RET% NEQ 0 GOTO EXIT
echo. >> %BATCH_LOG_FILE%

echo building employee movement >>%BATCH_LOG_FILE%  
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_ods\etl_jobs\build_employee_movement\build_employee_movement.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
for %%i in ("%~dp0..\..\") do set "chips_root_dir=%%~fi" 
echo python log dir is set to: %chips_root_dir%chips_stg_to_ods\etl_jobs\build_employee_movement\build_employee_movement.log >>%BATCH_LOG_FILE% 
if %RET% NEQ 0 (
    echo failed to build employee movement in python >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %chips_root_dir%chips_stg_to_ods\etl_jobs\build_employee_movement\build_employee_movement.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built employee movement >>%BATCH_LOG_FILE%
set RET=0
echo. >> %BATCH_LOG_FILE%

echo building employee email, idir, and name tables >>%BATCH_LOG_FILE%  
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_ods\etl_jobs\build_employee_tables\build_employee_tables.bat
set RET=%ERRORLEVEL%
echo python returned code %RET% >>%BATCH_LOG_FILE%
rem Only return code of 0 is acceptable.
for %%i in ("%~dp0..\..\") do set "chips_root_dir=%%~fi" 
echo python log dir is set to: %chips_root_dir%chips_stg_to_ods\etl_jobs\build_employee_tables\build_employee_tables.log >>%BATCH_LOG_FILE% 
if %RET% NEQ 0 (
    echo failed to build employee email, idir, and name tables in python >>%BATCH_LOG_FILE%
    echo ----- start python log ----- >>%BATCH_LOG_FILE% 
	type %chips_root_dir%chips_stg_to_ods\etl_jobs\build_employee_tables\build_employee_tables.log >>%BATCH_LOG_FILE% 
	echo ------ end python log ------ >>%BATCH_LOG_FILE% 
    set RET=16
    GOTO FAILED
)
echo successfully built employee email, idir, and name tables >>%BATCH_LOG_FILE%
set RET=0
echo. >> %BATCH_LOG_FILE%

CALL %ETL_BIN%\data_handshake.bat COMPLETE "CHIPS Data"
:EXIT
set EXIT_CODE=%RET%

CALL %ETL_BIN%\EnvironmentEnd.bat
POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%
rem Send Return code back to ESP.
\%AGENT_EXE% %EXIT_CODE%
