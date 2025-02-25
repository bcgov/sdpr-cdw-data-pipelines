# Test Approach for CDW.EM_STIIP_F

1. Run `refresh\cdw\table_sets\em_stiip_f_plus_dim_tables.py` to import EM_STIIP_F and all of it's dimension tables from prod to dev/test. This will ensure the SID's are in alignment.
2. Run the data pipelines that builds EM_STIIP_F, HCDWLPWA.bat.
3. Analyze the results of the queries in the sql files in this folder to determine if differences are as expected.