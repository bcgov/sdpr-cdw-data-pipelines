# Test Approach for CDW.EM_FTE_BURN_F

1. Run `C:\GitHub\sdpr-cdw-etl-pipelines\refresh\cdw\table_sets\em_fte_burn_f_plus_dim_tables.py` to import EM_FTE_BURN_F and all of it's dimension tables from prod to dev/test. This will ensure the SID's are in alignment.
2. Run the data pipelines that builds EM_FTE_BURN_F, HCDWLPWA.bat.
3. Analyze the results of the queries in the sql files in this folder to determine if differences are as expected.