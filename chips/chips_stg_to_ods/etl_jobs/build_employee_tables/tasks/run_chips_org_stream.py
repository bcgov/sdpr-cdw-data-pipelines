import logging
import sys
from dotenv import load_dotenv
import os 
load_dotenv()
base_dir = os.getenv('MAIN_BASE_DIR')
odb_conn_str_key_endpoint = os.getenv('ORACLE_CONN_STRING_KEY')
sys.path.append(base_dir)
from utils.oracle_db import OracleDB

this_dir = os.path.dirname(os.path.realpath(__file__))

logger = logging.getLogger('__main__.' + __name__)

def run_chips_org_stream():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    db.execute("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'")

    db.execute("begin ETL.ETL_CORE.RUN_STREAM_EASY_SAFE('CHIPS Organization'); end;")