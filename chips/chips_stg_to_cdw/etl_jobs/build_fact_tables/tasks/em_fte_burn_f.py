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

def build_em_fte_burn_f():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    # create indexes for the base tables to increase performance

    db.execute_with_exception_handling(
        "drop index chips_stg.ps_tgb_fteburn_tbl1",
        ignore_all_db_errors=True
    )
    db.execute_with_exception_handling(
        """
        create bitmap index chips_stg.ps_tgb_fteburn_tbl1  on chips_stg.ps_tgb_fteburn_tbl (emplid, empl_rcd, pay_end_dt, business_unit)
        tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )
    db.execute_with_exception_handling(
        "drop index chips_stg.ps_job1", 
        ignore_all_db_errors=True
    )
    db.execute_with_exception_handling("""
        create bitmap index chips_stg.ps_job1  on chips_stg.ps_job (emplid, empl_rcd, effdt DESC, effseq DESC)
        tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )
    db.execute_with_exception_handling(
        "drop index chips_stg.ps_set_cntrl_rec1", 
        ignore_all_db_errors=True
    )
    db.execute_with_exception_handling("""
        create bitmap index chips_stg.ps_set_cntrl_rec1  on chips_stg.ps_set_cntrl_rec (setcntrlvalue, recname)
        tablespace chips_stg_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )
    db.execute("commit")


    # Build em_fte_burn
    db.execute("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'")
    db.execute("truncate table cdw.em_fte_burn_f")
    db.execute(r"""
        declare
            type em_fte_burn_f_tab is table of cdw.em_fte_burn_f%rowtype index by binary_integer; 
            em_fte_burn_f_recs em_fte_burn_f_tab;
        begin
            for pay_end_dts in (
                select distinct pay_end_dt 
                from chips_stg.ps_tgb_fteburn_tbl 
                where pay_end_dt >= add_months(trunc(current_date), -12*10)
                order by pay_end_dt desc
            ) loop
                select *
                bulk collect into em_fte_burn_f_recs
                from (
                    select
                        apt.appt_status_sid appointment_status_sid,
                        loc.location_sid,
                        s.pay_end_dt_sk,
                        es.empl_status_sid,
                        pos.position_sid,
                        jc.jobclass_sid job_class_sid,
                        bu.bu_sid,
                        s.fte_reg,
                        s.fte_ovt,
                        s.fire_ovt,
                        s.emplid,
                        emp.empl_sid
                    from (
                        -- the query of the chips_stg source data
                        SELECT
                            f.emplid,
                            f.pay_end_dt,
                            TRIM(TO_CHAR(f.pay_end_dt, 'YYYYMMDD')) || '0' AS PAY_END_DT_SK,
                            sc.SETID || f.deptid AS bu_bk,
                            sc2.setid || f.jobcode AS jobcode_bk,
                            f.position_nbr,
                            f.appointment_status,
                            j.empl_status,
                            j.setid_location || j.location AS location_bk,
                            f.fte_reg,
                            f.fte_ovt,
                            f.fire_ovt,
                            '[DIM_SID (Unmatched)]' AS REASON
                        FROM
                            chips_stg.ps_tgb_fteburn_tbl f
                            JOIN chips_stg.ps_job j
                                ON f.emplid = j.emplid
                                AND f.empl_rcd = j.empl_rcd
                            JOIN chips_stg.ps_set_cntrl_rec sc
                                ON sc.recname = 'DEPT_TBL'
                                AND sc.setcntrlvalue = f.business_unit
                            JOIN chips_stg.ps_set_cntrl_rec sc2
                                ON sc2.recname = 'JOBCODE_TBL'
                                AND sc2.setcntrlvalue = f.business_unit
                                AND j.effdt = (
                                    SELECT MAX(j2.effdt)
                                    FROM chips_stg.ps_job j2
                                    WHERE j2.emplid = j.emplid
                                        AND j2.empl_rcd = j.empl_rcd
                                        AND j2.effdt <= f.pay_end_dt
                                )
                                AND j.effseq = (
                                    SELECT MAX(j3.effseq)
                                    FROM chips_stg.ps_job j3
                                    WHERE j3.emplid = j.emplid
                                        AND j3.empl_rcd = j.empl_rcd
                                        AND j3.effdt = j.effdt
                                )
                        where f.pay_end_dt = pay_end_dts.pay_end_dt
                    ) s
                    -- joins on dim tables
                    left join cdw.em_employee_d emp 
                        on emp.emplid = s.emplid
                    left join cdw.or_business_unit_d bu 
                        on s.bu_bk = bu.bu_bk
                        and bu.eff_date = (
                            select max(sub_bu.eff_date)
                            from cdw.or_business_unit_d sub_bu
                            where sub_bu.eff_date <= s.pay_end_dt
                                and sub_bu.bu_bk = s.bu_bk
                        )
                    left join cdw.em_job_class_d jc 
                        on s.jobcode_bk = jc.jobcode_bk
                        and to_date(jc.effdt) = (
                            select max(sub_jc.effdt)
                            from cdw.em_job_class_d sub_jc
                            where to_date(sub_jc.effdt) <= to_date(s.pay_end_dt)
                                and sub_jc.jobcode_bk = s.jobcode_bk
                        )
                    left join cdw.em_position_d pos 
                        on s.position_nbr = pos.position_nbr
                        and pos.eff_date = (
                            select max(sub_pos.eff_date)
                            from cdw.em_position_d sub_pos
                            where sub_pos.eff_date <= s.pay_end_dt
                                and sub_pos.position_nbr = s.position_nbr
                        )
                    left join cdw.em_appointment_status_d apt 
                        on s.appointment_status = apt.appointment_status
                    left join cdw.em_employee_status_d es 
                        on s.empl_status = es.empl_status
                    left join cdw.or_location_d loc 
                        on s.location_bk = loc.setid_loc
                        and loc.eff_dt = (
                            select max(sub_loc.eff_dt)
                            from cdw.or_location_d sub_loc
                            where sub_loc.eff_dt <= s.pay_end_dt
                                and sub_loc.setid_loc = s.location_bk
                        )
                    where s.emplid is not null
                        and s.pay_end_dt_sk is not null
                );

                forall i in 1 .. em_fte_burn_f_recs.count
                    insert into cdw.em_fte_burn_f values em_fte_burn_f_recs(i);
                
                commit;
            end loop;
        end;
    """)
    db.execute("commit")


    # Build indexes for em_fte_burn_f

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a1",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a1  on cdw.em_fte_burn_f (appointment_status_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a2",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a2  on cdw.em_fte_burn_f (bu_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a3",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a3  on cdw.em_fte_burn_f (empl_status_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a4",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a4  on cdw.em_fte_burn_f (job_class_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a5",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a5  on cdw.em_fte_burn_f (location_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a6",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a6  on cdw.em_fte_burn_f (pay_end_dt_sk)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a7",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a7  on cdw.em_fte_burn_f (position_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a8",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.ifte_burn_f_a8  on cdw.em_fte_burn_f (bu_sid,pay_end_dt_sk)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a9",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create  index cdw.ifte_burn_f_a9  on cdw.em_fte_burn_f (emplid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.ifte_burn_f_a10",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create  index cdw.ifte_burn_f_a10  on cdw.em_fte_burn_f (empl_sid)
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255
        storage  (initial 10m  minextents 1  maxextents unlimited)
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute("commit")