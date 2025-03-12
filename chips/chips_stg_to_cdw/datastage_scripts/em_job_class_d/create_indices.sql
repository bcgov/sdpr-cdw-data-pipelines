create unique index cdw.ijob_class_d_a1 on cdw.em_job_class_d (jobclass_sid)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m  minextents 1  maxextents unlimited)
    nologging compute statistics
;
commit;

create index cdw.ijob_class_d_a2 on cdw.em_job_class_d (jobcode_bk)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

create bitmap index cdw.ijob_class_d_a3 on cdw.em_job_class_d (emp_group)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

create bitmap index cdw.ijob_class_d_a4 on cdw.em_job_class_d (incl_excl)
    tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
    storage (initial 10m  minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

create bitmap index cdw.ijob_class_d_a5 on cdw.em_job_class_d (job_function)
  tablespace cdw_indx pctfree 10 initrans 2 maxtrans 255
  storage (initial 10m  minextents 1 maxextents unlimited)
  nologging compute statistics
;
commit;