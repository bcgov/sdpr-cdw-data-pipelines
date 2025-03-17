# CHIPS_STG to CDW
Tables in the CHIPS_STG schema form the basis for the 'EM', as in 'employee', series of fact and dimension tables in the CDW schema. 

## How to Run CHIPS_STG to CDW ETL Jobs
1. Set the required environment variables. You can either do this by adding system variable on your machine or you can use the dotenv python library by creating a .env file in the same directory as this readme: `...\chips\chips_stg_to_cdw\.env`.
2. Set the following variable values (example values are provided--will be different for your machine): 
    ```conf
    <!-- where the sdpr-cdw-data-pipelines repo is cloned on your machine -->
    MAIN_BASE_DIR = "C:\GitHub\sdpr-cdw-data-pipelines"

    <!-- the Windows Registry folder name containing the Oracle conn string -->
    ORACLE_CONN_STRING_KEY = "CW1D_ETL"

    <!-- the directory in Registry Editor that contains Oracle connection strings -->
    ORACLE_CONN_STR_DIR_IN_WINREG = 'SOFTWARE\Datasources\SDSI\Databases\Oracle\\'

    <!-- the directory containing tnsnames.ora -->
    TNSNAMES_CONFIG_DIR = "E:/tnsnames_dir"
    ```