-- indexes for table PS_ACTN_REASON_TBL --

create index chips_stg.PS0ACTN_REASON_TBL ON
PS_ACTN_REASON_TBL (                         
DESCR,                                                                          
ACTION,                                                                         
ACTION_REASON,                                                                  
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_ACTN_REASON_TBL ON
PS_ACTN_REASON_TBL (                         
ACTION,                                                                         
ACTION_REASON,                                                                  
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

-- indexes for table PS_BUS_UNIT_TBL_HR --

create index chips_stg.PS0BUS_UNIT_TBL_HR ON
PS_BUS_UNIT_TBL_HR (                         
DESCR,                                                                          
BUSINESS_UNIT                                                                   
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
                                                                             
create index chips_stg.PS_BUS_UNIT_TBL_HR ON
PS_BUS_UNIT_TBL_HR (                         
BUSINESS_UNIT                                                                   
)tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging; 

-- indexes for table PS_CAN_NOC_TBL

create index chips_stg.PS0CAN_NOC_TBL ON
PS_CAN_NOC_TBL (                                 
DESCR,                                                                          
CAN_NOC_CD,                                                                     
EFFDT                                                                           
)tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_CAN_NOC_TBL ON
PS_CAN_NOC_TBL (                                 
CAN_NOC_CD,                                                                     
EFFDT                                                                           
)tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

-- indexes for PS_COMPANY_TBL
 
create index chips_stg.PS0COMPANY_TBL ON
PS_COMPANY_TBL (                                 
DESCR,                                                                          
COMPANY,                                                                        
EFFDT                                                                           
)tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_COMPANY_TBL ON
PS_COMPANY_TBL (                                 
COMPANY,                                                                        
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_DEDUCTION_CLASS ON
PS_DEDUCTION_CLASS (                         
PLAN_TYPE,                                                                      
DEDCD,                                                                          
EFFDT,                                                                          
DED_CLASS,                                                                      
DED_SLSTX_CLASS                                                                 
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS0DEDUCTION_TBL ON
PS_DEDUCTION_TBL (                             
DESCR,                                                                          
PLAN_TYPE,                                                                      
DEDCD,                                                                          
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS_DEDUCTION_TBL ON
PS_DEDUCTION_TBL (                             
PLAN_TYPE,                                                                      
DEDCD,                                                                          
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS_DEPT_TBL ON
PS_DEPT_TBL (                                       
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS0DEPT_TBL ON
PS_DEPT_TBL (                                       
DESCR,                                                                          
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS1DEPT_TBL ON
PS_DEPT_TBL (                                       
COMPANY,                                                                        
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS2DEPT_TBL ON
PS_DEPT_TBL (                                       
SETID_LOCATION,                                                                 
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS3DEPT_TBL ON
PS_DEPT_TBL (                                       
LOCATION,                                                                       
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS4DEPT_TBL ON
PS_DEPT_TBL (                                       
MANAGER_ID,                                                                     
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS5DEPT_TBL ON
PS_DEPT_TBL (                                       
BUDGET_DEPTID,                                                                  
SETID,                                                                          
DEPTID,                                                                         
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
  
create index chips_stg.PS_EMPL_CTG_L1 ON
PS_EMPL_CTG_L1 (                                 
SETID,                                                                          
LABOR_AGREEMENT,                                                                
EMPL_CTG,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS0JOBCODE_TBL ON
PS_JOBCODE_TBL (                                 
DESCR,                                                                          
SETID,                                                                          
JOBCODE,                                                                        
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS1JOBCODE_TBL ON
PS_JOBCODE_TBL (                                 
GVT_OCC_SERIES,                                                                 
SETID,                                                                          
JOBCODE,                                                                        
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS2JOBCODE_TBL ON
PS_JOBCODE_TBL (                                 
GVT_OFFICIAL_DESCR,                                                             
SETID,                                                                          
JOBCODE,                                                                        
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PSAJOBCODE_TBL ON
PS_JOBCODE_TBL (                                 
JOB_FAMILY                                                                      
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 

create index chips_stg.PS_JOBCODE_TBL ON
PS_JOBCODE_TBL (                                 
SETID,                                                                          
JOBCODE,                                                                        
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS0LOCATION_TBL ON
PS_LOCATION_TBL (                               
DESCR,                                                                          
SETID,                                                                          
LOCATION,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS1LOCATION_TBL ON
PS_LOCATION_TBL (                               
SAL_ADMIN_PLAN,                                                                 
SETID,                                                                          
LOCATION,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS2LOCATION_TBL ON
PS_LOCATION_TBL (                               
GVT_GEOLOC_CD,                                                                  
SETID,                                                                          
LOCATION,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_LOCATION_TBL ON
PS_LOCATION_TBL (                               
SETID,                                                                          
LOCATION,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS0POSITION_DATA ON
PS_POSITION_DATA (                             
DESCR,                                                                          
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS1POSITION_DATA ON
PS_POSITION_DATA (                             
BUSINESS_UNIT,                                                                  
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS2POSITION_DATA ON
PS_POSITION_DATA (                             
DEPTID,                                                                         
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS3POSITION_DATA ON
PS_POSITION_DATA (                             
JOBCODE,                                                                        
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS4POSITION_DATA ON
PS_POSITION_DATA (                             
POSN_STATUS,                                                                    
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS5POSITION_DATA ON
PS_POSITION_DATA (                             
JOB_SHARE,                                                                      
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS6POSITION_DATA ON
PS_POSITION_DATA (                             
REPORTS_TO,                                                                     
POSITION_NBR,                                                                   
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
   
create index chips_stg.PS_SAL_GRADE_TBL ON
PS_SAL_GRADE_TBL (                             
SETID,                                                                          
SAL_ADMIN_PLAN,                                                                 
GRADE,                                                                          
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS_SAL_PLAN_TBL ON
PS_SAL_PLAN_TBL (                               
SETID,                                                                          
SAL_ADMIN_PLAN,                                                                 
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS_SAL_STEP_TBL ON
PS_SAL_STEP_TBL (                               
SETID,                                                                          
SAL_ADMIN_PLAN,                                                                 
GRADE,                                                                          
EFFDT,                                                                          
STEP                                                                            
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
                                                                              
create index chips_stg.PS_SETID_TBL ON
PS_SETID_TBL (                                     
SETID                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_TGB_CITY_TBL ON
PS_TGB_CITY_TBL (                               
CITY                                                                            
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
                                                                              
create index chips_stg.PS_TGB_CNOCSUB_TBL ON
PS_TGB_CNOCSUB_TBL (                         
CAN_NOC_CD,                                                                     
EFFDT,                                                                          
TGB_CAN_NOC_SUB_CD                                                              
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_UNION_TBL ON
PS_UNION_TBL (                                     
UNION_CD,                                                                       
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PSAPSTREELEVEL ON
PSTREELEVEL (                                    
TREE_LEVEL,                                                                     
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_PSTREELEVEL ON
PSTREELEVEL (                                    
SETID,                                                                          
SETCNTRLVALUE,                                                                  
TREE_NAME,                                                                      
EFFDT,                                                                          
TREE_LEVEL)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PSAPSTREENODE ON
PSTREENODE (                                      
SETID,                                                                          
TREE_NAME,                                                                      
EFFDT,                                                                          
TREE_BRANCH,                                                                    
TREE_NODE,                                                                      
TREE_NODE_NUM,                                                                  
TREE_NODE_NUM_END,                                                              
TREE_NODE_TYPE                                                                  
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
  
create index chips_stg.PSBPSTREENODE ON
PSTREENODE (                                      
SETID,                                                                          
TREE_NAME,                                                                      
TREE_BRANCH,                                                                    
TREE_NODE_NUM,                                                                  
TREE_NODE,                                                                      
TREE_NODE_NUM_END,                                                              
TREE_LEVEL_NUM,                                                                 
TREE_NODE_TYPE                                                                  
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PSCPSTREENODE ON
PSTREENODE (                                      
TREE_NODE                                                                       
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PSDPSTREENODE ON
PSTREENODE (                                      
SETID,                                                                          
TREE_NAME,                                                                      
EFFDT,                                                                          
PARENT_NODE_NUM                                                                 
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PSFPSTREENODE ON
PSTREENODE (                                      
TREE_NAME,                                                                      
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS_PSTREENODE ON
PSTREENODE (                                      
SETID,                                                                          
SETCNTRLVALUE,                                                                  
TREE_NAME,                                                                      
EFFDT,                                                                          
TREE_NODE_NUM,                                                                  
TREE_NODE,                                                                      
TREE_BRANCH                                                                     
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PSAPSXLATITEM ON
PSXLATITEM (                                      
FIELDNAME                                                                       
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PSBPSXLATITEM ON
PSXLATITEM (                                      
FIELDVALUE                                                                      
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PSCPSXLATITEM ON
PSXLATITEM (                                      
SYNCID                                                                          
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;
 
create index chips_stg.PS_PSXLATITEM ON
PSXLATITEM (                                      
FIELDNAME,                                                                      
FIELDVALUE,                                                                     
EFFDT                                                                           
)
tablespace CHIPS_STG_INDX pctfree 0 initrans 2 maxtrans 255 
storage (initial 64K minextents 1 maxextents unlimited)
nologging;

create index chips_stg.PS0ACTION_TBL ON
PS_ACTION_TBL (                                   
ACTION_DESCR,                                                                   
ACTION,                                                                         
EFFDT                                                                           
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;

create index chips_stg.PS0EARNINGS_TBL ON
PS_EARNINGS_TBL (                               
DESCR,                                                                          
ERNCD,                                                                          
EFFDT                                                                           
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;
                                                                              
create index chips_stg.PS_ACTION_TBL ON
PS_ACTION_TBL (                                   
ACTION,                                                                         
EFFDT                                                                           
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;
                                                                              
create index chips_stg.PS_EARNINGS_TBL ON
PS_EARNINGS_TBL (                               
ERNCD,                                                                          
EFFDT                                                                           
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;                                                                              

CREATE INDEX chips_stg.i_ps_tgb_fteburn_tbl_a3  ON
chips_stg.ps_tgb_fteburn_tbl  (                                   
emplid,                                                                   
empl_rcd,                                                                         
pay_end_dt,
position_nbr,
appointment_status,
fte_reg,
fte_ovt,
fire_ovt,
deptid,
jobcode                                                                          
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;

CREATE INDEX chips_stg.i_ps_job_a3  ON
chips_stg.ps_job  (                                   
emplid,                                                                   
empl_rcd,
effdt,
effseq,                                                                         
setid_dept,
setid_jobcode,
empl_status,
setid_location,
location                                                                     
)
tablespace chips_stg_INDX pctfree 10 initrans 2 maxtrans 255
storage (initial 10M minextents 1 maxextents unlimited)
nologging compute statistics;
   
CREATE BITMAP INDEX chips_stg.IDX_PS_DEPT_TBL_A1 ON
PS_DEPT_TBL ( setid )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PS_DEPT_TBL_A2 ON
PS_DEPT_TBL ( effdt )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.IDX_PS_DEPT_TBL_A3 ON
PS_DEPT_TBL ( deptid )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PS_POSITION_A1 ON
PS_POSITION_DATA ( CAN_NOC_CD )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PS_POSITION_A2 ON
PS_POSITION_DATA ( TGB_CAN_NOC_SUB_CD )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.IDX_PS_POSITION_A3 ON
PS_POSITION_DATA ( EFFDT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.IDX_PS_POSITION_A4 ON
PS_POSITION_DATA ( POSITION_NBR )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.IDX_PS_TGB_FTEBURN_TBL_A1 ON
PS_TGB_FTEBURN_TBL ( EMPLID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PS_TGB_FTEBURN_TBL_A2 ON
PS_TGB_FTEBURN_TBL ( PAY_END_DT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PS_EMPLOYEES_A1 ON
PS_EMPLOYEES ( DEPTID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;
CREATE INDEX chips_stg.IDX_PS_EMPLOYEES_A2 ON
PS_EMPLOYEES ( EMPLID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.I_PS_JOB_A1 ON
PS_JOB( EMPLID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE INDEX chips_stg.PS_PAY_CHECK_IX1 ON
PS_PAY_CHECK ( EMPLID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.PS_PAY_CHECK_IX2 ON
PS_PAY_CHECK ( PAY_END_DT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.PS_PAY_CHECK_IX3 ON
PS_PAY_CHECK ( BUSINESS_UNIT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE        INDEX chips_stg.PS_PAY_CHECK_IX4    on PS_PAY_CHECK(PAY_END_DT, EMPLID) tablespace CHIPS_STG_INDX  nologging;

CREATE INDEX chips_stg.PS_PAY_EARNINGS_IX1  ON
PS_PAY_EARNINGS ( EMPLID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.PS_PAY_EARNINGS_IX2  ON
PS_PAY_EARNINGS( PAY_END_DT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.PS_PAY_EARNINGS_IX3  ON
PS_PAY_EARNINGS ( BUSINESS_UNIT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE        INDEX chips_stg.PS_PAY_EARNINGS_IX4 on PS_PAY_EARNINGS(PAY_END_DT, EMPLID) tablespace CHIPS_STG_INDX  nologging;

CREATE BITMAP INDEX chips_stg.PS_PAY_OTH_EARNS_IX1  ON
PS_PAY_OTH_EARNS( PAY_END_DT )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE BITMAP INDEX chips_stg.IDX_PX_TREE_FLATTENED_A1 ON
PX_TREE_FLATTENED( SETID )
  tablespace chips_stg_INDX   pctfree 10  initrans 2   maxtrans 255   storage  
  ( initial 10M  minextents 1  maxextents unlimited  )
nologging compute statistics;

CREATE UNIQUE INDEX chips_stg.PX_TREE_FLATTENED_PK ON
PX_TREE_FLATTENED( SETID , TREE_NODE, EFFDT )
nologging compute statistics;