import polars as pl 
import datetime as dt
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

def build_stiip_security_requirement_stg():
    csv_path = this_dir + r'\stiip_security_requirements.csv'
    df = pl.read_csv(source = csv_path)
    df = df.with_columns(load_dt = dt.datetime.now())
    cols = df.columns
    rows = df.rows()
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)
    db.default_load(
        table_owner = 'CHIPS_STG', 
        table_name = 'STIIP_SECURITY_REQUIREMENT_STG',
        cols_to_load_list = cols,
        writeRows = rows,
        truncate_first = True
    )
