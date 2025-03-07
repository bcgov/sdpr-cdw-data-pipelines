# Test Approach for the CHIPS_STG to CDW Data Pipeline

1. Run `refresh\cdw\table_sets\chips_stg_to_cdw_tables.py` to import all tables in CDW that are built upon CHIPS_STG tables from prod to dev/test. This will ensure the SID's are in alignment.
2. Run the CHIPS_STG to CDW data pipeline, HCDWLPWA.bat.
3. Analyze the results of the queries in the sql files in this folder to determine if differences are as expected.