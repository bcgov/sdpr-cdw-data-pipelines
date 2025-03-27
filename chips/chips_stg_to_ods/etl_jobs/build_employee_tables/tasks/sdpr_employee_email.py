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

def build_sdpr_employee_email():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    db.execute("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'")

    # Insert records for new combinations of employee ID and email
    db.execute_with_exception_handling(
        """
        merge into ods.sdpr_employee_email d
        using (
            select emplid, emailid email
            from chips_stg.ps_oprdefn_bc_tbl 
            where trim(emplid) is not null 
                and upper(oprdefndesc) like '%SDPR%'
                and upper(emailid) like '%@GOV.BC.CA%'
            order by emplid
        ) s
        on (d.emplid = s.emplid and d.email = s.email)
        when not matched then insert (d.emplid, d.email, d.created_at, d.current_flg)
            values (s.emplid, s.email, current_date, 'Y')
        """,
        ignore_all_db_errors=False
    )

    db.execute("commit")

    # For all emails, update current_flg from 'Y' to 'N' on all but the most recent record 
    db.execute_with_exception_handling(
        """
        begin
            for sdpr_employee_email_tab in (
                with update_emails as (
                    select email, count(*)
                    from ods.sdpr_employee_email
                    where current_flg = 'Y'
                    group by email
                    having count(*) > 1
                )
                select email from update_emails
            ) loop
                dbms_output.put_line(sdpr_employee_email_tab.email);
                update ods.sdpr_employee_email
                    set current_flg = 'N'
                    where email = sdpr_employee_email_tab.email
                        and created_at < (
                            select max(created_at)
                            from ods.sdpr_employee_email
                            where email = sdpr_employee_email_tab.email
                        )
                        and current_flg = 'Y'
                ;
            end loop;
            commit;
        end;
        """,
        ignore_all_db_errors=False
    )

    # For all employee IDs, update current_flg from 'Y' to 'N' on all but the most recent record
    db.execute_with_exception_handling(
        """
        begin
            for sdpr_employee_email_tab in (
                with update_emplids as (
                    select emplid, count(*)
                    from ods.sdpr_employee_email
                    where current_flg = 'Y'
                    group by emplid
                    having count(*) > 1
                )
                select emplid from update_emplids
            ) loop
                dbms_output.put_line(sdpr_employee_email_tab.emplid);
                update ods.sdpr_employee_email
                    set current_flg = 'N'
                    where emplid = sdpr_employee_email_tab.emplid
                        and created_at < (
                            select max(created_at)
                            from ods.sdpr_employee_email
                            where emplid = sdpr_employee_email_tab.emplid
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
