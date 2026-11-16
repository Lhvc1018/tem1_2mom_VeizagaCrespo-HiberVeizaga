@echo off
setlocal
cd /d "%~dp0.."
if "%~1"=="" exit /b 1
if not exist "data\evidencia_sql\%~1.sql" exit /b 1
if exist "..\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\ocultar_icono_barra.ps1" -Accion Ocultar >nul
title Apache Hive Beeline - Superstore - Hiber Veizaga Crespo
cls
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\evidencia_sql\%~1.sql"
if errorlevel 1 goto cleanup
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\capturar_pantalla_con_hora.ps1" -Output "evidencias\%~1.png" >nul
:cleanup
if exist "..\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\ocultar_icono_barra.ps1" -Accion Restaurar >nul
echo Captura terminada.
pause
