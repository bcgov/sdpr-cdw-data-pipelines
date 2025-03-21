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

def build_em_stiip_f():
    db = OracleDB(conn_str_key_endpoint = odb_conn_str_key_endpoint)

    db.execute("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'")
    db.execute("truncate table cdw.em_stiip_f")
    db.execute(r"""
        declare
            type em_stiip_f_tab is table of cdw.em_stiip_f%rowtype index by binary_integer; 
            em_stiip_f_recs em_stiip_f_tab;
        begin
            for pay_end_dts in (
                select distinct a.pay_end_dt
                from chips_stg.ps_pay_earnings a 
                join chips_stg.ps_pay_oth_earns b 
                    on a.pay_end_dt = b.pay_end_dt            
                    and b.erncd in ('SIZ','SIX','SIH','SIP','SIS','S57', 'ESL')
                    and a.company = 'GOV'
                    and a.paygroup in ('STD','OBL','LBM')
                where a.pay_end_dt >= add_months(trunc(current_date), -12*10)
                order by a.pay_end_dt desc
            ) loop
                select *
                bulk collect into em_stiip_f_recs
                from (
                    select
                        apt.appt_status_sid appointment_status_sid,
                        s.leave_end_dt_sk,
                        s.leave_begin_dt_sk,
                        loc.location_sid,
                        s.pay_end_dt_sk,
                        es.empl_status_sid,
                        pos.position_sid,
                        bu.bu_sid,
                        emp.empl_sid,
                        s.emplid,
                        jc.jobclass_sid,
                        s.hourly_rt hourly_rate,
                        s.leave_hours,
                        s.leavecost leave_cost,
                        s.paidcost paid_cost,
                        s.empls empl_taking_leave,
                        pc.paycode_sid
                    from (
                        SELECT
                            a.emplid,
                            a.pay_end_dt,
                            trim(to_char(a.pay_end_dt, 'yyyymmdd')) || '0' as pay_end_dt_sk,
                            trim(to_char(a.earns_begin_dt, 'yyyymmdd')) || '0' as leave_begin_dt_sk,
                            a.earns_end_dt as leave_end_dt,
                            trim(to_char(a.earns_end_dt, 'yyyymmdd')) || '0' as leave_end_dt_sk,
                            a.hourly_rt,
                            a.erncd as leavecode,
                            c.empl_ctg as appointment_status,
                            c.empl_status,
                            c.setid_location||c.location as location_bk,
                            nvl(trim(a.position_nbr),c.position_nbr) as position_nbr,
                            sc.setid||a.deptid as bu_bk,
                            sc2.setid||nvl(trim(a.jobcode), c.jobcode) as jobcode_bk,
                            case
                                when a.erncd in ('SIS','SIX') then (a.oth_hrs * (-1.0))
                                when a.erncd = 'S57' THEN 0
                                else a.oth_hrs * (1.0)  -- SIH,SIP,SIZ, ESL
                            end leave_hours,
                            case
                                when a.erncd in ('SIS', 'SIX') then (a.oth_hrs * a.hourly_rt) * -1
                                when a.erncd = 'S57' then 0
                                else (a.oth_hrs * a.hourly_rt) -- SIH,SIP,SIZ, ESL
                            end leavecost,
                            case
                                when a.erncd = 'SIP' then (a.oth_hrs * a.hourly_rt) *.75
                                when a.erncd = 'SIX' then ((a.oth_hrs * a.hourly_rt) * -1) * .667
                                when a.erncd = 'SIS' then ((a.oth_hrs * a.hourly_rt) * -1) * .75
                                when a.erncd in ('SIH','S57') then (a.oth_hrs * a.hourly_rt)
                                when a.erncd = 'SIZ' then 0
                                when a.erncd IN ('ESL') then (a.oth_hrs * a.hourly_rt)
                            end paidcost,
                        count(distinct a.emplid) empls
                        from (
                            select
                                a.earns_begin_dt,
                                a.earns_end_dt,
                                a.pay_end_dt,
                                a.deptid,
                                a.position_nbr,
                                a.business_unit,
                                a.emplid,
                                a.empl_rcd,
                                a.jobcode,
                                a.hourly_rt,
                                b.erncd,
                                sum(b.oth_hrs) oth_hrs
                            from chips_stg.ps_pay_earnings a 
                            join chips_stg.ps_pay_oth_earns b 
                                on a.company = b.company
                                and a.pay_end_dt = b.pay_end_dt            
                                and a.paygroup = b.paygroup
                                and a.page_num = b.page_num
                                and a.off_cycle = b.off_cycle
                                and a.line_num = b.line_num
                                and a.addl_nbr = b.addl_nbr
                                and b.erncd in ('SIZ','SIX','SIH','SIP','SIS','S57', 'ESL')   --  'SIL'
                                and a.company = 'GOV'
                                and a.paygroup in ('STD','OBL','LBM')
                            where a.pay_end_dt = pay_end_dts.pay_end_dt
                            group by
                                a.earns_begin_dt, 
                                a.earns_end_dt, 
                                a.pay_end_dt, 
                                a.deptid, 
                                a.position_nbr, 
                                a.business_unit,
                                a.emplid, 
                                a.empl_rcd, 
                                a.jobcode,
                                a.hourly_rt, 
                                b.erncd
                        ) a,
                        chips_stg.ps_job c,
                        chips_stg.ps_set_cntrl_rec sc,
                        chips_stg.ps_set_cntrl_rec sc2
                        where
                            a.emplid = c.emplid
                            and a.empl_rcd = c.empl_rcd
                            and c.effdt = (
                                select max(c1.effdt)
                                from chips_stg.ps_job c1
                                where c1.emplid = c.emplid
                                    and c1.empl_rcd = c.empl_rcd
                                    and c1.effdt <= a.earns_end_dt
                            )
                            and c.effseq = (
                                select max(c2.effseq)
                                from chips_stg.ps_job c2
                                where c2.emplid = c.emplid
                                    and c2.empl_rcd = c.empl_rcd
                                    and c2.effdt = c.effdt
                            )
                            and sc.recname = 'DEPT_TBL' 
                            and sc.setcntrlvalue = a.business_unit
                            and sc2.recname = 'JOBCODE_TBL' 
                            and sc2.setcntrlvalue = a.business_unit
                        group by
                            A.emplid,
                            A.pay_end_dt,
                            trim(to_char(a.pay_end_dt, 'yyyymmdd')) || '0',
                            trim(to_char(a.earns_begin_dt,'yyyymmdd')) || '0',
                            a.earns_end_dt,
                            trim(to_char(a.earns_end_dt, 'yyyymmdd')) || '0',
                            c.empl_ctg,
                            c.empl_status,
                            c.setid_location||c.location,
                            nvl(trim(a.position_nbr),c.position_nbr),
                            a.hourly_rt,
                            a.erncd,
                            sc.setid||a.deptid,
                            sc2.setid||nvl(trim(a.jobcode), c.jobcode),
                            case when a.erncd in ('SIS','SIX') then (a.oth_hrs * (-1.0))
                                when a.erncd = 'S57' then 0
                                else a.oth_hrs*(1.0)
                            end,
                            case when a.erncd IN ('SIS','SIX') then (a.oth_hrs * a.hourly_rt) * -1
                                when a.erncd ='S57' then 0
                                else (a.oth_hrs * a.hourly_rt)
                            end,
                            case when a.erncd = 'SIP' then (a.oth_hrs * a.hourly_rt) * .75
                                when a.erncd = 'SIX' then ((a.oth_hrs * a.hourly_rt) * -1) * .667
                                when a.erncd = 'SIS' then ((a.oth_hrs * a.hourly_rt) * -1) * .75
                                when a.erncd in ('SIH','S57') then (a.oth_hrs * a.hourly_rt)
                                when a.erncd = 'SIZ' then 0
                                when a.erncd IN ('ESL') then (a.oth_hrs * a.hourly_rt)
                            end
                    ) s
                    left join cdw.em_appointment_status_d apt 
                        on s.appointment_status = apt.appointment_status
                    left join cdw.or_location_d loc 
                        on s.location_bk = loc.setid_loc
                        and loc.eff_dt = (
                            select max(sub_loc.eff_dt)
                            from cdw.or_location_d sub_loc
                            where sub_loc.eff_dt <= s.pay_end_dt
                                and sub_loc.setid_loc = s.location_bk
                        )
                    left join cdw.em_employee_status_d es 
                        on s.empl_status = es.empl_status
                    left join cdw.em_position_d pos 
                        on s.position_nbr = pos.position_nbr
                        and pos.eff_date = (
                            select max(sub_pos.eff_date)
                            from cdw.em_position_d sub_pos
                            where sub_pos.eff_date <= s.pay_end_dt
                                and sub_pos.position_nbr = s.position_nbr
                        )
                    left join cdw.or_business_unit_d bu 
                        on s.bu_bk = bu.bu_bk
                        and bu.eff_date = (
                            select max(sub_bu.eff_date)
                            from cdw.or_business_unit_d sub_bu
                            where sub_bu.eff_date <= s.pay_end_dt
                                and sub_bu.bu_bk = s.bu_bk
                        )
                    left join cdw.em_employee_d emp 
                        on s.emplid = emp.emplid
                    left join cdw.em_job_class_d jc 
                        on s.jobcode_bk = jc.jobcode_bk
                        and to_date(jc.effdt) = (
                            select max(sub_jc.effdt)
                            from cdw.em_job_class_d sub_jc
                            where to_date(sub_jc.effdt) <= to_date(s.pay_end_dt)
                                and sub_jc.jobcode_bk = s.jobcode_bk
                        )
                    left join cdw.em_paycode_d pc 
                        on s.leavecode = pc.pay_cd
                );

                forall i in 1 .. em_stiip_f_recs.count
                    insert into cdw.em_stiip_f values em_stiip_f_recs(i);
                
                commit;
            end loop;
        end;
    """)
    db.execute("commit")

    
    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a01",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a01  on cdw.em_stiip_f (appointment_status_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a02",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a02  on cdw.em_stiip_f (leave_begin_dt_sk) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a03",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a03  on cdw.em_stiip_f (leave_end_dt_sk) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a04",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a04  on cdw.em_stiip_f (bu_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a05",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a05  on cdw.em_stiip_f (empl_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a06",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a06  on cdw.em_stiip_f (empl_status_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a07",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create index cdw.istiip_f_a07  on cdw.em_stiip_f (jobclass_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a08",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create index cdw.istiip_f_a08  on cdw.em_stiip_f (location_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a09",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a09  on cdw.em_stiip_f (pay_end_dt_sk) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a10",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create bitmap index cdw.istiip_f_a10  on cdw.em_stiip_f (paycode_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a11",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create  index cdw.istiip_f_a11  on cdw.em_stiip_f (position_sid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a12",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create index cdw.istiip_f_a12  on cdw.em_stiip_f (bu_sid,leave_end_dt_sk) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a13",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create index cdw.istiip_f_a13  on cdw.em_stiip_f (bu_sid,pay_end_dt_sk) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        "drop index cdw.istiip_f_a14",
        ignore_all_db_errors=True
    )

    db.execute_with_exception_handling(
        """
        create index cdw.istiip_f_a14  on cdw.em_stiip_f (emplid) 
        tablespace cdw_indx   pctfree 10   initrans 2   maxtrans 255 
        storage  (initial 10m  minextents 1  maxextents unlimited) 
        nologging compute statistics
        """,
        ignore_all_db_errors=True
    )

    db.execute("commit")