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
    for table in [
        'control_object',
        'control_stream',
        'control_function',
        'control_task',
        'control_field',
        'control_stage',
        'control_step',
        'control_fragment',
        'control_privilege',
        'control_transform',
    ]:
        full_table = f'etl.{table}'
        r = Refresh()
        r.full_refresh(full_table)

if __name__ == "__main__":
    try:
        main()
    except:
        logging.exception('Got exception on main handler')
        raise