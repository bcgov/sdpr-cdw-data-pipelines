# HCDWLPEN Operations Doc
This job: 
1. extracts data from the Oracle SDPR CDW via an SQL query,
2. packages the data as an xlsx file, and 
3. delivers it to business users via a shared folder.

## Order of Key Events
Relative to the base directory, `E:\ETL_V8\sdpr-cdw-data-pipelines\data-quality\msp_enrollement_extract`:
1. Windows Task Scheduler runs `hcdwlpen.bat` at 7am on weekdays, which
2. runs `extract_msp_enrollment.py`, which
    1. runs `dq_msp_enrollment.sql` against the Oracle SDPR CDW
    2. packages the returned data as an xlsx file
    3. delivers the xlsx file to `//sfp.idir.bcgov/s134/s34404/GetDoc/CDW-SDPR/DQ TL/MSP Enrollment ID by Case Number Report.xlsx`

## Manual Execution
This job can be manually executed by running `E:\ETL_V8\sdpr-cdw-data-pipelines\data-quality\msp_enrollement_extract\hcdwlpen.bat`.

## File Distribution
creates/overwrites: `//sfp.idir.bcgov/s134/s34404/GetDoc/CDW-SDPR/DQ TL/MSP Enrollment ID by Case Number Report.xlsx`

## Reference

Batch Job Dir
* `E:\ETL_V8\sdpr-cdw-data-pipelines\data-quality\msp_enrollement_extract\hcdwlpen.bat`

Documentation Dir
* `E:\ETL_V8\sdpr-cdw-data-pipelines\data-quality\msp_enrollement_extract\readme.md`

Log File Dir
* `E:\ETL_V8\Test\DQ\log\hcdwlpen`

Source Code Dir
* `E:\ETL_V8\sdpr-cdw-data-pipelines\data-quality\msp_enrollement_extract`

