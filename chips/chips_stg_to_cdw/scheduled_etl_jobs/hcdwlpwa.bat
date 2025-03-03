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
REM  ###### SET STARTING_STEP=STEP010
@SET STARTING_STEP=STEP010
@REM -------------------------------------------------------------------------------
@REM RUN CAT Data Manager Job Stream
@REM ------------------------------------------------------------
@CALL CHIPS_ETL_STEPS.bat %JOB_NAME% %STARTING_STEP%

:EXIT
@SET EXIT_CODE=%RET%
@CALL %ETL_BIN%\EnvironmentEnd.bat

@POPD & ENDLOCAL & SET EXIT_CODE=%EXIT_CODE%  & SET AGENT_EXE=%AGENT_EXE%

@REM ------------------------------------------------------------
@REM Send Return code back to ESP.
@REM ------------------------------------------------------------
%AGENT_EXE% %EXIT_CODE%
