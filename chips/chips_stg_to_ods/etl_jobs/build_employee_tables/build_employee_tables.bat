@REM activate virtual environment
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\.venv\Scripts\activate.bat

@REM run python job script
python "E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_ods\etl_jobs\build_employee_tables\build_employee_tables.py"