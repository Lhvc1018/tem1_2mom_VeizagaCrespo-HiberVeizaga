@echo off
setlocal
cd /d "%~dp0.."
if not exist evidencias mkdir evidencias
if exist "..\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\ocultar_icono_barra.ps1" -Accion Ocultar >nul
title Apache Hive Beeline - Superstore - Hiber Veizaga Crespo
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\01_ubicacion.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\01_ubicacion.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\01_carga.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\01_carga.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\01_muestra.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\01_muestra.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\01_calidad_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\01_calidad_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\01_calidad_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\01_calidad_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\02_region_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\02_region_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\02_region_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\02_region_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\03_rfm_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\03_rfm_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\03_rfm_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\03_rfm_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\04_productos_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\04_productos_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\04_productos_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\04_productos_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\04_productos_03.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\04_productos_03.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\04_productos_04.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\04_productos_04.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\05_descuentos_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\05_descuentos_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\05_descuentos_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\05_descuentos_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\06_tendencias_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\06_tendencias_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\06_tendencias_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\06_tendencias_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\07_pareto_01.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\07_pareto_01.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\07_pareto_02.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\07_pareto_02.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\08_envios.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\08_envios.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\09_segmentos.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\09_segmentos.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\10_estados.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\10_estados.png" >nul
if errorlevel 1 goto error
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\11_categorias.sql"
if errorlevel 1 goto error
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\11_categorias.png" >nul
if errorlevel 1 goto error
goto cleanup
:error
echo Ocurrio un error durante las capturas.
:cleanup
if exist "..\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\ocultar_icono_barra.ps1" -Accion Restaurar >nul
echo Capturas terminadas.
pause
