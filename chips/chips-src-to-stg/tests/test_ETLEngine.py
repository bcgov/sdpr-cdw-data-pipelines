import unittest
import yaml
import sys
from dotenv import load_dotenv
import os
import aiohttp
import asyncio
import logging
import datetime as dt
load_dotenv()
base_dir = os.getenv('PEOPLESOFT_ETL_BASE_DIR')
sys.path.append(base_dir)
from src.etl_engine import ETLEngine
from src.peoplesoft_api import PeopleSoftAPI
from src.async_peoplesoft_api import AsyncPeopleSoftAPI
main_base_dir = os.getenv('MAIN_BASE_DIR')
sys.path.append(main_base_dir)
from utils.oracle_db import OracleDB

logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO, 
    format="{levelname} ({asctime}): {message}", 
    datefmt='%d/%m/%Y %H:%M:%S',
    style='{'
)

with open(base_dir + '\\' + 'config.yml', 'r') as file:
    conf = yaml.safe_load(file)

endpoint = 'ps_pay_check_by_date'
table = 'PS_PAY_CHECK'
params = {'payenddate': '2024-06-29T00:00:00Z'}

non_async_api = PeopleSoftAPI()
etl_db = OracleDB(conn_str_key_endpoint=conf['etl_conn_str_subkey'])
api = AsyncPeopleSoftAPI(oracledb=etl_db)

build_start = dt.datetime.now()
records_at_endpoint = non_async_api.get_record_count(endpoint)

etl_engine = ETLEngine(
    api=api,
    api_endpoint=endpoint,
    oracledb=etl_db,
    oracle_table_owner="CHIPS_STG",
    oracle_table_name=table,
    cache={
        'build_start': build_start,
        'records_at_endpoint': records_at_endpoint,
    }
)

async def run_an_etl_task(endpoint, params):
    async with aiohttp.ClientSession(base_url=api.base_url) as session:
        await etl_engine.etl_task(
            session=session, 
            endpoint=endpoint, 
            params=params
        )

asyncio.run(run_an_etl_task(endpoint=endpoint, params=params))

# class TestETLEngine(unittest.TestCase):

#     def setUp(self):
#         self.etl_engine = etl_engine()

# if __name__ == '__main__':
#     unittest.main()