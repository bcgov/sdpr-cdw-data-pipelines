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

def main():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    tasks_dir = r'E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_ods\etl_jobs\build_employee_movement\tasks\\'
    # tasks_dir = r'E:\ETL_V8\sdpr-cdw-data-pipelines\chips\chips_stg_to_ods\datastage_scripts\build_employee_movement\\'
    sql_file_enpoints = [
        r'em_temp_jcode.sql',
        r'em_temp_fte_burn1.sql',
        r'em_temp_fte_burn2.sql',
        r'em_temp_act_reas1.sql',
        r'em_temp_act_reas2.sql',
        r'em_temp_dept_tab1.sql',
        r'em_temp_actn_reas.sql',
        r'em_temp_dept_tab2.sql',
        r'em_temp_pos_dat1.sql',
        r'em_temp_pos_dat2.sql',
        r'em_temp_pos_num1.sql',
        r'em_temp_last_pay.sql',
        r'em_temp_q1.sql',
        r'em_temp_q2.sql',
        r'em_temp_q3.sql',
        r'em_temp_q4.sql',
        r'em_temp_empl_movement.sql',
        r'em_temp_bu1.sql',
        r'em_temp_bu2.sql',
        r'em_temp_bu3.sql',
        r'em_temp_bu4.sql',
        r'em_temp_bu5.sql',
        r'em_temp_bu6.sql',
        r'em_temp_bu7.sql',
        r'em_temp_bu8.sql',
        r'em_temp_bu9.sql',
        r'em_temp_bu10.sql',
        r'em_temp_bu11.sql',
        r'em_empl_movement_temp2.sql',
        r'em_can_noc_tbl.sql',
        r'em_employee_movement_t3.sql',
        r'em_emplid_2_idir.sql',
        r'em_empl_movement.sql',
    ]
    for endpoint in sql_file_enpoints:
        file_path = tasks_dir + endpoint
        logger.info(f'executing: {endpoint}')
        db.run_sql_script(sql_file_path=file_path)


if __name__ == "__main__":
    try:
        main()
        logging.info('finished')
        sys.exit(0)
    except Exception:
        logging.exception('Got exception on main handler')
        sys.exit(1)
