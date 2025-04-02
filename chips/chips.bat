@echo on

for %%i in ("%~dp0") do set "chips_root_dir=%%~fi" 
echo chips_root_dir: %chips_root_dir%

echo running hcdwlpwa
call %chips_root_dir%chips_stg_to_cdw\etl_jobs\hcdwlpwa.bat

echo running hcdwlpwg
call %chips_root_dir%cognos_cubes\etl_jobs\hcdwlpwg.bat

echo running hcdwlpwh
call %chips_root_dir%chips_stg_to_ods\etl_jobs\hcdwlpwh.bat

echo running hcdwlpwi
call %chips_root_dir%cognos_cubes\etl_jobs\hcdwlpwi.bat

echo finished
