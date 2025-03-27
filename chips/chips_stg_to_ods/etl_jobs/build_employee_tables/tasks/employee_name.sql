drop table ods.employee_name purge;

commit;

create table ods.employee_name as
    with 
    filter_pay_check as (
        select * 
        from chips_stg.ps_pay_check 
        where off_cycle = 'N'
    ),
    names as (
        select distinct emplid, name
        from filter_pay_check 
    ),
    name_periods as (
        select *
        from names n
        left join (
            select p.emplid, p.name, min(p.pay_end_dt) first_pay_end_date, max(p.pay_end_dt) last_pay_end_date
            from filter_pay_check p
            group by emplid, name
        ) using (emplid, name)
    ),
    rank_last_pay_end_date as (
        select n.*, 
            rank() over (partition by emplid order by last_pay_end_date desc) last_pay_end_date_rank
        from name_periods n
    )
    select emplid, name, first_pay_end_date, last_pay_end_date,
        case when last_pay_end_date_rank = 1 then 'Y' else 'N' end current_flg
    from rank_last_pay_end_date a
;

commit;