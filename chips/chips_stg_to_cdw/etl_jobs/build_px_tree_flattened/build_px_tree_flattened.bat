@REM activate virtual environment
call E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips-src-to-stg\.venv\Scripts\activate.bat

@REM run python job script
python "E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_px_tree_flattened\build_px_tree_flattened.py"