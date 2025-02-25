import logging
import sys
from dotenv import load_dotenv
import os 
load_dotenv(dotenv_path="E:\\ETL_V8\\sdpr-cdw-data-pipelines\\refresh\\.env")
base_dir = os.getenv('MAIN_BASE_DIR')
sys.path.append(base_dir)
from refresh.refresh import Refresh

this_dir = os.path.dirname(os.path.realpath(__file__))

logger = logging.getLogger(__name__)
logging.basicConfig(
    # filename=f'{this_dir}\\refresh.log',
    # filemode='w',
    level=logging.DEBUG, 
    format="{levelname} ({asctime}): {message}", 
    datefmt='%d/%m/%Y %H:%M:%S',
    style='{'
)

def main():
    tables = '''
        cdw.em_stiip_f,
        cdw.em_appointment_status_d,
        cdw.or_location_d,
        cdw.em_employee_status_d,
        cdw.em_position_d,
        cdw.em_bu_security_d,
        cdw.em_job_class_d,
        cdw.em_paycode_d
    '''
    r = Refresh()
    r.import_table_w_datapump(tables=tables)

if __name__ == "__main__":
    try:
        main()
    except:
        logging.exception('Got exception on main handler')
        raise
