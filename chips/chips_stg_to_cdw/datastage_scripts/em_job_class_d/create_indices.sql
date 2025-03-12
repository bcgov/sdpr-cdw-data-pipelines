-- CREATE UNIQUE INDEX cdw.IJOB_CLASS_D_A1 ON cdw.EM_JOB_CLASS_D (JOBCLASS_SID)
--     tablespace CDW_INDX pctfree 10 initrans 2 maxtrans 255
--     storage (initial 10M  minextents 1  maxextents unlimited)
--     nologging compute statistics
-- ;
-- commit;

CREATE INDEX IJOB_CLASS_D_A2 ON cdw.EM_JOB_CLASS_D (JOBCODE_BK)
    tablespace CDW_INDX pctfree 10 initrans 2 maxtrans 255
    storage (initial 10M minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

CREATE BITMAP INDEX IJOB_CLASS_D_A3 ON cdw.EM_JOB_CLASS_D (EMP_GROUP)
    tablespace CDW_INDX pctfree 10 initrans 2 maxtrans 255
    storage (initial 10M minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

CREATE BITMAP INDEX IJOB_CLASS_D_A4 ON cdw.EM_JOB_CLASS_D (INCL_EXCL)
    tablespace CDW_INDX pctfree 10 initrans 2 maxtrans 255
    storage (initial 10M  minextents 1 maxextents unlimited)
    nologging compute statistics
;
commit;

CREATE BITMAP INDEX IJOB_CLASS_D_A5 ON cdw.EM_JOB_CLASS_D (JOB_FUNCTION)
  tablespace CDW_INDX pctfree 10 initrans 2 maxtrans 255
  storage (initial 10M  minextents 1 maxextents unlimited)
  nologging compute statistics
;
commit;