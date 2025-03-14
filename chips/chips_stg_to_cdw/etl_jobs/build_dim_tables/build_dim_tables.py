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
from tasks.stiip_security_requirement.stiip_security_requirement_stg import build_stiip_security_requirement_stg

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

tasks_dir = r'E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_cdw\etl_jobs\build_dim_tables\tasks\\'

def run_sql_script(db: OracleDB, sql_script_endpoint: str):
    file_path = tasks_dir + sql_script_endpoint
    logger.info(f'executing: {sql_script_endpoint}')
    db.run_sql_script(sql_file_path=file_path)
    logger.info(f'finished executing: {sql_script_endpoint}')

def main():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    # have no local dependencies
    run_sql_script(db, r'em_appointment_status_d.sql')
    run_sql_script(db, r'em_employee_d.sql')
    run_sql_script(db, r'em_employee_status_d.sql')
    run_sql_script(db, r'em_job_class_d.sql')
    run_sql_script(db, r'em_paycode_d.sql')
    run_sql_script(db, r'em_position_d.sql')
    run_sql_script(db, r'or_business_unit_d.sql')
    run_sql_script(db, r'or_location_d.sql')

    # have local dependencies
    build_stiip_security_requirement_stg() # dependencies: stiip_security_requirement.csv
    run_sql_script(db, r'stiip_security_requirement\stiip_security_requirement.sql') # dependencies: chips_stg.stiip_security_requirement_stg
    run_sql_script(db, r'em_userid_to_emplid_xref_d.sql') # dependencies: chips_stg.stiip_security_requirement
    run_sql_script(db, r'em_bu_security_d.sql') # dependencies: cdw.or_business_unit_d

if __name__ == "__main__":
    try:
        main()
        logging.info('finished')
        sys.exit(0)
    except Exception:
        logging.exception('Got exception on main handler')
        sys.exit(1)