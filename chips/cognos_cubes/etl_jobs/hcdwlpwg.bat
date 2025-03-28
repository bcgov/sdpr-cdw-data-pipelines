@ECHO OFF
@SETLOCAL & PUSHD & SET RET=
@REM ---------------------------------------------------------------
@REM HCDWLPWG - CHIPS FTE and STIIP Cubes Build
@REM
@REM Description: This job will invoke the CHIPS Cube Build process from ETL server.
@REM		environment variable: DATAMART and CUBE will get passed down to
@REM		Cube build batch file on Cognos BI server and hence need to match
@REM		to the names defined in set_cube_params.bat in order for this to work.
@REM		Note:  values of variables: 
@REM                                        DATAMART and
@REM                                        CUBE
@REM                   will be passed down to remote server
@REM ---------------------------------------------------------------
@REM Modification Log
@REM ----------------
@REM
@REM    Date      Change #   Name          Desc
@REM -----------  ---------  ------------ -------------------------
@REM 2009.Jul.17     	    CLI           Original
@REM 2016.Feb.05             TSSukkel     Strip to base info and leverage standard EnvrionmentStart
@REM 2018-09-14   SR627223   GN	          E-mail notification standardization. Added the e-mail related variables
@REM                                      Added call to EnvironmentStart, EnvironmentEnd and the call to AGENT_EXE
@REM                                      Removed common code to EnvironmentStart/End.bat
@REM ----------------------------------------------------------------

@SET JOB_NAME=%~n0
@SET JOB_DESCRIPTION=CHIPS FTE and STIIP Cubes Build
@SET OBJ_TYPE=CUBE
@SET APP_SYS=Chips
@SET BAT_FILE=CHIPS_CUBES.bat
@SET DATAMART=Chips
@SET CUBE=%~1

@CALL %ETL_BIN%\EnvironmentStart.bat
@IF %RET% NEQ 0 GOTO EXIT

:Job_Initiation
@ECHO Calling  %ETL_BIN%\Remote_call.bat with variables-  %APP_SYS% %JOB_NAME% %BAT_FILE% %DATAMART% %CUBE% >>%BATCH_LOG_FILE%
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
