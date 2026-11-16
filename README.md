# Sample Superstore en Apache Hive

Hiber Veizaga Crespo.

## Objetivo

Cargar y analizar 9.994 registros de [Sample Superstore](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) con HiveQL.

## Requisitos

Docker Desktop, Apache Hive 2.3.2, CMD y Python 3.

## Ejecución

Desde CMD, en la carpeta del proyecto:

```cmd
python scripts\preparar_csv.py data\superstore_original.csv data\superstore_utf8.csv
cmd\cargar.cmd
cmd\consultas.cmd
```

## Entregables

- Datos CSV: `data/`.
- Diccionario: `docs/diccionario_datos.md`.
- DDL y DML: `sql/ddl/` y `sql/dml/`.
- Doce scripts HiveQL: `sql/00_modelo_carga.sql` a `sql/11_categorias.sql`.
- Resultados y conclusiones: `docs/resultados.md`.
- Evidencias de CMD: `evidencias/`.
- Optimización: `docs/optimizacion.md`.
- Informe Word: `EvidenciasExamen2mo.docx`.

## Conclusión

West lideró la ganancia regional. Los 856 registros con descuento superior al 50 % registraron pérdidas.
