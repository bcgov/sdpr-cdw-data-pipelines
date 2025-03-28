@echo off
@SETLOCAL & PUSHD & SET RET=
@REM ---------------------------------------------------------------
@REM HCDWLPWI - Employee Movement and Employee Organization Cubes build
@REM
@REM Description: This job will invoke the Cube Build  process from ETL server.
@REM
@REM		Note:  environment variables: 
@REM                                        DATAMART and 
@REM                                        CUBE 
@REM
@REM          will get passed down to  Cube build batch file on Cognos BI server 
@REM          and hence need to match
@REM		       to the names defined in set_cube_params.bat in order for this to work.
@REM ---------------------------------------------------------------
@REM Modification Log
@REM ----------------
@REM
@REM    Date      Change #   Name          Desc   
@REM -----------  ---------  ------------ -------------------------
@REM 2016.Aug.30             JDM          Original (copied from HCDWC1EN.bat) Modified for Employee Movement Cubes
@REM 2017.Jul.25  Wo170179   TSS          Add EM Org to process. Also fix goto exit issue
@REM 2018-09-20   SR627223   GN	          E-mail notification standardization. Removed e-mailing lines (REMOTE_CALL.BAT sends e-mail now)
@REM                                      Added call to EnvironmentStart, EnvironmentEnd and the call to AGENT_EXE
@REM                                      Removed common code to EnvironmentStart/End.bat
@REM ----------------------------------------------------------------

@SET JOB_NAME=%~n0
@SET JOB_DESCRIPTION=Employee Movement and Employee Organization Cubes build
@SET OBJ_TYPE=CUBE
@SET APP_SYS=CHIPS
@SET BAT_FILE=_Employee_Movement_CUBE.bat
@SET DATAMART=CHIPS
@SET CUBE=SINGLE_CUBE

@CALL %ETL_BIN%\EnvironmentStart.bat
@IF %RET% NEQ 0 GOTO EXIT

:Job_Initiation 
@ECHO Calling  %ETL_BIN%\Remote_call.bat with variables-  %APP_SYS% %JOB_NAME% %BAT_FILE% %DATAMART% %CUBE% >> %BATCH_LOG_FILE%
@CALL %ETL_BIN%\remote_call.bat
@SET RET=%ERRORLEVEL%

:EXIT
@SET EXIT_CODE=%RET%
@CALL %ETL_BIN%\EnvironmentEnd.bat

@POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%

@REM ------------------------------------------------------------
@REM Send Return code back to ESP.
@REM ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%

