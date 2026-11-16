# Análisis de Sample Superstore con Apache Hive

Proyecto individual de Hiber Veizaga Crespo.

## Objetivos

Modelar y cargar el CSV de Sample Superstore en Hive, verificar calidad y resolver las ocho preguntas desarrolladas del examen. Se añaden cuatro análisis complementarios para completar doce scripts numerados.

## Alcance de las preguntas

El enunciado desarrolla las preguntas 1 a 8. Su sección de GitHub menciona scripts para doce preguntas sin enunciar las preguntas 9 a 12. Por ello, los scripts 9 a 12 son ampliaciones identificadas como complementarias: tiempos de envío, segmentos comerciales, estados y evolución por categoría.

## Fuente de datos

[Sample Superstore en Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final). El archivo tiene 9.994 registros y 21 columnas. `data/superstore_original.csv` conserva la codificación Windows-1252; `data/superstore_utf8.csv` es la versión usada en la carga.

## Requisitos

- Docker Desktop con la pila Apache Hive 2.3.2 utilizada en la práctica.
- CMD de Windows y Python 3.
- Contenedor HiveServer2 llamado `docker-hive-hive-server-1`.

## Procedimiento en CMD

1. Abra CMD en la raíz del repositorio.
2. Inicie la pila Docker y compruebe `docker ps`.
3. Si necesita reconstruir el CSV UTF-8, ejecute `python scripts\preparar_csv.py data\superstore_original.csv data\superstore_utf8.csv`.
4. Ejecute `cmd\cargar.cmd` para crear las tablas y cargar los 9.994 registros.
5. Ejecute `cmd\consultas.cmd` para resolver las preguntas 2 a 12. Los registros de salida se guardan en `data\resultados\`.
6. Ejecute `python scripts\preparar_evidencias.py` y `cmd\capturas.cmd` desde CMD maximizado para repetir las capturas.

## Entregables

- `docs/diccionario_datos.md`: nombre, tipo, descripción y restricción de los 21 campos.
- `sql/ddl/crear_tablas.sql`: base y tablas Hive.
- `sql/dml/cargar_ventas.sql`: carga y transformación.
- `sql/00_modelo_carga.sql` a `sql/11_categorias.sql`: doce soluciones numeradas.
- `docs/resultados.md`: estrategia, resultados, interpretación y conclusiones.
- `evidencias/`: capturas completas de CMD y Beeline.
- `docs/optimizacion.md`: decisiones de almacenamiento y consulta.
- `Informe_Superstore_Hiber_Veizaga_Crespo.docx`: informe con código y evidencia.

## Conclusiones generales

La tabla contiene 9.994 registros y la auditoría no detectó anomalías en las reglas comprobadas. West obtuvo la mayor ganancia regional. Los descuentos superiores al 50 % coincidieron con pérdidas en 856 líneas. Los análisis complementarios muestran diferencias en plazos de envío, margen por segmento, rentabilidad estatal y evolución por categoría.
