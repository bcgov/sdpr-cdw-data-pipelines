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

def run_sql_script(db: OracleDB, sql_script_endpoint: str):
    tasks_dir = fr'{this_dir}\tasks\\'
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

    run_sql_script(db, r'em_temp_jcode.sql')
    run_sql_script(db, r'em_temp_fte_burn1.sql')
    run_sql_script(db, r'em_temp_fte_burn2.sql')
    run_sql_script(db, r'em_temp_act_reas1.sql')
    run_sql_script(db, r'em_temp_act_reas2.sql')
    run_sql_script(db, r'em_temp_dept_tab1.sql')
    run_sql_script(db, r'em_temp_actn_reas.sql')
    run_sql_script(db, r'em_temp_dept_tab2.sql')
    run_sql_script(db, r'em_temp_pos_dat1.sql')
    run_sql_script(db, r'em_temp_pos_dat2.sql')
    run_sql_script(db, r'em_temp_pos_num1.sql')
    run_sql_script(db, r'em_temp_last_pay.sql')
    run_sql_script(db, r'em_temp_q1.sql')
    run_sql_script(db, r'em_temp_q2.sql')
    run_sql_script(db, r'em_temp_q3.sql')
    run_sql_script(db, r'em_temp_q4.sql')
    run_sql_script(db, r'em_temp_empl_movement.sql')
    run_sql_script(db, r'em_temp_bu1.sql')
    run_sql_script(db, r'em_temp_bu2.sql')
    run_sql_script(db, r'em_temp_bu3.sql')
    run_sql_script(db, r'em_temp_bu4.sql')
    run_sql_script(db, r'em_temp_bu5.sql')
    run_sql_script(db, r'em_temp_bu6.sql')
    run_sql_script(db, r'em_temp_bu7.sql')
    run_sql_script(db, r'em_temp_bu8.sql')
    run_sql_script(db, r'em_temp_bu9.sql')
    run_sql_script(db, r'em_temp_bu10.sql')
    run_sql_script(db, r'em_temp_bu11.sql')
    run_sql_script(db, r'em_empl_movement_temp2.sql')
    run_sql_script(db, r'em_can_noc_tbl.sql')
    run_sql_script(db, r'em_employee_movement_t3.sql')
    run_sql_script(db, r'em_emplid_2_idir.sql')
    run_sql_script(db, r'em_empl_movement.sql')

if __name__ == "__main__":
    try:
        main()
        logging.info('finished')
    except Exception:
        logging.exception('Got exception on main handler')
        sys.exit(1)
    sys.exit(0)
