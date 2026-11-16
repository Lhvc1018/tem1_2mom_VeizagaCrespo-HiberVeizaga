@echo off
cd /d "%~dp0.."
if not exist data\resultados mkdir data\resultados
for %%F in (sql\01_calidad.sql sql\02_region.sql sql\03_rfm.sql sql\04_productos.sql sql\05_descuentos.sql sql\06_tendencias.sql sql\07_pareto.sql sql\08_envios.sql sql\09_segmentos.sql sql\10_estados.sql sql\11_categorias.sql) do (
  echo Ejecutando %%F
  docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < %%F > data\resultados\%%~nF.log 2>&1
  if errorlevel 1 exit /b 1
  findstr /C:"Error:" data\resultados\%%~nF.log >nul
  if not errorlevel 1 exit /b 1
)
echo Consultas terminadas.
exit /b 0
