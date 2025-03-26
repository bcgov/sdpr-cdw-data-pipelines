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

def build_sdpr_employee_idir():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    db.execute("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'")

    db.execute_with_exception_handling(
        """
        merge into ods.sdpr_employee_idir d
        using (
            select emplid, oprid idir
            from chips_stg.ps_oprdefn_bc_tbl 
            where trim(emplid) is not null 
                and upper(oprdefndesc) like '%SDPR%'
                and upper(emailid) like '%@GOV.BC.CA%'
            order by emplid
        ) s
        on (d.emplid = s.emplid and d.idir = s.idir)
        when not matched then insert (d.emplid, d.idir, d.created_at, d.current_flg)
            values (s.emplid, s.idir, current_date, 'Y')
        """,
        ignore_all_db_errors=False
    )

    db.execute("commit")

    db.execute_with_exception_handling(
        """
        begin
            for sdpr_employee_idir_tab in (
                with update_emplids as (
                    select emplid, count(*)
                    from ods.sdpr_employee_idir
                    where current_flg = 'Y'
                    group by emplid
                    having count(*) > 1
                )
                select emplid from update_emplids
            ) loop
                dbms_output.put_line(sdpr_employee_idir_tab.emplid);
                update ods.sdpr_employee_idir
                    set current_flg = 'N'
                    where emplid = sdpr_employee_idir_tab.emplid
                        and created_at < (
                            select max(created_at)
                            from ods.sdpr_employee_idir
                            where emplid = sdpr_employee_idir_tab.emplid
                        )
                        and current_flg = 'Y'
                ;
            end loop;
            commit;
        end;
        """,
        ignore_all_db_errors=False
    )

    db.execute("commit")
