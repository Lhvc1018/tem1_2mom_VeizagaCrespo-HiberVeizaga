@echo off
cd /d "%~dp0.."
docker cp data\superstore_utf8.csv docker-hive-hive-server-1:/tmp/superstore_utf8.csv
if errorlevel 1 exit /b 1
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < sql\ddl\crear_tablas.sql
if errorlevel 1 exit /b 1
docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < sql\dml\cargar_ventas.sql
exit /b %errorlevel%
