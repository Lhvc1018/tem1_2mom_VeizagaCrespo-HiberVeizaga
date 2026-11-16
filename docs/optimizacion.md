# Análisis de optimización

Revisé las ocho preguntas del examen y las cuatro consultas adicionales.

## Almacenamiento

Primero cargué el CSV como texto con OpenCSVSerde. Así conservé los campos entrecomillados y pude revisar las conversiones. La tabla final usa ORC y tipos `DATE`, `INT` y `DOUBLE`. ORC permite leer solo las columnas que necesita cada consulta.

## Modelo

La tabla tiene 9.994 filas. Si la dividía por los cuatro años o las cuatro regiones, cada partición quedaba pequeña. Por eso dejé la tabla ORC sin particiones.

## Consultas

Primero sumé los datos por grupo y después usé `LAG()`, `RANK()` y las sumas acumuladas. Así esas funciones trabajan con menos filas. RFM usa una fila por cliente y Pareto una por producto. Usé `LIMIT` para mostrar ejemplos, pero los resúmenes incluyen todos los grupos.

Las consultas leen la tabla ORC sin volver a procesar el CSV. Dejé la tabla de carga para repetir la revisión del archivo original. En Hive 2.3.2, cada trabajo MapReduce tarda un tiempo en arrancar. Por eso evité dividir una consulta en trabajos innecesarios.

## Comprobaciones

La consulta de calidad contó 9.994 filas sin conversiones inválidas ni identificadores de fila duplicados. RFM y Pareto usan vistas para repetir consultas sin copiar los datos.
