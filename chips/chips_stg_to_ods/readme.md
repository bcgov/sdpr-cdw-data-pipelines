# CHIPS_STG to CDW
Tables in the CHIPS_STG schema form the basis for the SDPR employee movement tables. 

## How to Run CHIPS_STG to ODS ETL Jobs (On Any Machine)
Set the required environment variables. You can either do this by adding system variable on your machine or you can use the dotenv python library by creating a .env file in the same directory as this readme: `...\chips\chips_stg_to_cdw\.env`. Here are the required environment variables and example values: 

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

You can find the tnsnames.ora file on the ETL servers for TNSNAMES_CONFIG_DIR and you can open Registry Editor on the servers, navigate to the keys containing Oracle connection strings at `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Datasources\SDSI\Databases\Oracle\`, export the ones you want, then import them into the Registry Editor on your local machine.

Once the environment variables are set, the batch and python scripts in the `etl_jobs` folder should be runnable. Of course, python and the required python libraries need to be installed on the machine, too.