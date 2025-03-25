import logging
import sys
from dotenv import load_dotenv
import os 
from pathlib import Path
load_dotenv()
base_dir = os.getenv('MAIN_BASE_DIR')
odb_conn_str_key_endpoint = os.getenv('ORACLE_CONN_STRING_KEY')
sys.path.append(base_dir)
from utils.oracle_db import OracleDB
from tasks.stiip_security_requirement.sdpr_employee_email import build_sdpr_employee_email

this_dir = os.path.dirname(os.path.realpath(__file__))
this_file = Path(__file__).stem

logger = logging.getLogger(__name__)
logging.basicConfig(
    filename=fr'{this_dir}\{this_file}.log',
    filemode='w',
    level=logging.DEBUG, 
    format="{levelname} ({asctime}): {message}", 
    datefmt='%d/%m/%Y %H:%M:%S',
    style='{'
)

tasks_dir = fr'{this_dir}\tasks\\'

def run_sql_script(db: OracleDB, sql_script_endpoint: str):
    file_path = tasks_dir + sql_script_endpoint
    logger.info(f'executing: {sql_script_endpoint}')
    db.run_sql_script(
        sql_file_path=file_path, 
        ignore_all_db_errors=True,
        # ora_codes_to_ignore=['ORA-02289'],
    )
    logger.info(f'finished executing: {sql_script_endpoint}')

def main():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)
    
    build_sdpr_employee_email() 

if __name__ == "__main__":
    try:
        main()
        logging.info('finished')
    except Exception:
        logging.exception('Got exception on main handler')
        sys.exit(1)
    sys.exit(0)