# CHIPS
CHIPS is the Corporate Human Resource Information and Payroll System. The CHIPS web application is found at https://timepayhome.gov.bc.ca/. It is an Oracle PeopleSoft application.

## The MHRGRP API
The MHRGRP API exposes data in the CHIPS PeopleSoft application's OCI database to consumers. It is owned by the Public Service Agency (PSA).

## The CHIPS_STG Oracle CDW Schema
Data is copied one-to-one from endpoints at the MHRGRP API to the CHIPS_STG schema in the Oracle  CDW. From there, analytical tables are built in other schemas (CDW and ODS) and applications (IBM Cognos, Power BI) used by Analysts across SDPR.