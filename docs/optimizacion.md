# Análisis de optimización

Este análisis cubre las ocho preguntas desarrolladas y los cuatro análisis complementarios.

## Almacenamiento

El CSV se cargó primero como texto con OpenCSVSerde para conservar campos entrecomillados y permitir la auditoría de conversiones. La tabla analítica usa ORC y tipos `DATE`, `INT` y `DOUBLE`. ORC permite lecturas de columnas concretas en consultas agregadas.

## Modelo

La tabla contiene 9.994 filas. Particionar por cuatro años o cuatro regiones produciría particiones pequeñas y aumentaría la administración sin una ventaja clara para este volumen. Se mantuvo una tabla ORC sin particiones.

## Consultas

Las agregaciones se realizan antes de las funciones de ventana para reducir las filas procesadas por `LAG()`, `RANK()` y sumas acumuladas. RFM calcula una fila por cliente; Pareto, una fila por producto. Las listas de inspección usan `LIMIT`, mientras que los resúmenes completos conservan todos los grupos.

La tabla ORC evita volver a analizar el CSV original en cada pregunta. Los datos originales permanecen en una tabla de carga para repetir la auditoría. En Hive 2.3.2, la ejecución MapReduce tiene un costo fijo apreciable; por ello se evita dividir innecesariamente una métrica en múltiples trabajos.

## Comprobaciones

La consulta de calidad confirmó 9.994 filas, ninguna conversión inválida y ningún identificador de fila duplicado. Las consultas RFM y Pareto usan vistas lógicas para reutilizar definiciones; las vistas no duplican físicamente los datos.
