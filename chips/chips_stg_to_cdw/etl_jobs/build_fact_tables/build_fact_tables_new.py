import logging
import sys
from dotenv import load_dotenv
import os 
load_dotenv()
base_dir = os.getenv('MAIN_BASE_DIR')
odb_conn_str_key_endpoint = os.getenv('ORACLE_CONN_STRING_KEY')
sys.path.append(base_dir)
from utils.oracle_db import OracleDB

logger = logging.getLogger(__name__)
logging.basicConfig(
    # filename=fr'{this_dir}\data_extract.log',
    filemode='w',
    level=logging.DEBUG, 
    format="{levelname} ({asctime}): {message}", 
    datefmt='%d/%m/%Y %H:%M:%S',
    style='{'
)

db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

tasks_dir = r'E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_fact_tables\tasks\\'
sql_file_enpoints = [
    r'em_fte_burn_f_new.sql',
    r'em_efp_fte_f_new.sql',
    r'em_stiip_f_new.sql',
]
for endpoint in sql_file_enpoints:
    file_path = tasks_dir + endpoint
    logger.info(f'executing: {endpoint}')
    db.run_sql_script(sql_file_path=file_path)
