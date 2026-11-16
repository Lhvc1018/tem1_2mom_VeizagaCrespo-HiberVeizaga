# Resultados de las doce consultas

El examen desarrolla ocho preguntas. Las preguntas 9 a 12 de este repositorio son análisis complementarios, porque el apartado de GitHub solicita doce scripts sin incluir sus cuatro enunciados.

Los importes proceden del CSV Sample Superstore. La unidad monetaria no aparece especificada en el archivo; por eso se presentan sin símbolo de moneda. Las cifras mostradas se redondean a dos decimales.

## Pregunta 1. Modelo e ingesta

**Estrategia.** Se revisaron las 21 columnas originales. Se creó una tabla de carga con campos `STRING` y OpenCSVSerde, seguida de una tabla analítica ORC con fechas y números convertidos.

**HiveQL.** [Modelo y carga](../sql/00_modelo_carga.sql).

**Evidencia.** [Ubicación de la tabla](../evidencias/01_ubicacion.png), [conteo de filas](../evidencias/01_carga.png) y [muestra de diez registros](../evidencias/01_muestra.png).

**Resultado.** Se cargaron 9.994 registros. La tabla analítica contiene 21 campos. Los primeros diez registros muestran fechas convertidas y ventas numéricas.

**Interpretación.** La tabla de carga conserva el texto original para auditar conversiones. La tabla final facilita agregaciones y ventanas sobre datos tipados.

**Conclusión.** La carga es íntegra y apta para los análisis siguientes.

## Pregunta 2. Calidad e integridad

**Estrategia.** Se comparó el total con identificadores únicos y se revisaron valores nulos, conversiones, rangos y orden temporal.

**HiveQL.** [Auditoría de calidad](../sql/01_calidad.sql).

**Evidencia.** [Resumen](../evidencias/01_calidad_01.png) y [campos nulos](../evidencias/01_calidad_02.png).

**Resultado.** Hay 9.994 filas, 0 `Row ID` duplicados, 5.009 órdenes y 793 clientes. No hay fechas inválidas, ventas no positivas, descuentos fuera de 0 a 1 ni envíos anteriores al pedido. Ninguna fila tiene un campo `NULL` en la tabla final. La auditoría del CSV tampoco encontró conversiones inválidas.

**Interpretación.** Las reglas evaluadas no detectaron anomalías. Se debe conservar el CSV original y rechazar futuras filas que incumplan las restricciones antes de incorporarlas a la tabla analítica.

**Conclusión.** Este archivo no requiere corrección de registros para los criterios comprobados.

## Pregunta 3. Evolución comercial por región

**Estrategia.** Se agregaron ventas y ganancias por región y año. `LAG()` compara cada año con el anterior de la misma región. El margen es ganancia dividida entre ventas.

**HiveQL.** [Evolución y ranking regional](../sql/02_region.sql).

**Evidencia.** [Serie regional anual](../evidencias/02_region_01.png) y [ranking global](../evidencias/02_region_02.png).

**Resultado.** West lidera la ganancia acumulada con 108.418,45 y margen de 14,94 %. Central queda última en ganancia, con 39.706,36 y margen de 7,92 %. La consulta devuelve 16 combinaciones de cuatro regiones y cuatro años.

**Interpretación.** El primer año carece de comparación previa, por lo que su variación es `NULL`. La variación de ganancia usa el valor absoluto de la base previa para evitar invertir el signo de la comparación cuando hay pérdidas.

**Conclusión.** West presenta el mejor resultado económico agregado y Central el menor.

## Pregunta 4. Segmentación RFM

**Estrategia.** La referencia de recencia es la fecha máxima del dataset. La frecuencia cuenta órdenes distintas y el valor monetario suma ventas por cliente. `NTILE(5)` asigna quintiles a cada componente.

**Criterios.** Alto valor exige puntuaciones R, F y M de al menos 4. En riesgo exige R de hasta 2 y F o M de al menos 3. Recurrente exige F de al menos 4 sin cumplir antes las otras reglas.

**HiveQL.** [Vista y segmentación RFM](../sql/03_rfm.sql).

**Evidencia.** [Resumen de segmentos](../evidencias/03_rfm_01.png) y [clientes de mayor gasto](../evidencias/03_rfm_02.png).

**Resultado.** De 793 clientes, 105 son de alto valor, 199 están en riesgo, 129 son recurrentes y 360 quedan en otros perfiles. Los clientes en riesgo acumulan 692.584,35 en ventas y tienen 255,86 días de recencia media.

**Interpretación.** La segmentación usa reglas explícitas y reproducibles. Un cliente de gran gasto puede quedar en riesgo si su última compra fue antigua.

**Conclusión.** Los 199 clientes en riesgo son un grupo prioritario para retención.

## Pregunta 5. Rentabilidad de productos

**Estrategia.** Se agruparon líneas por `Product ID`, se calcularon ventas, ganancia, unidades y margen. `RANK()` y `DENSE_RANK()` ordenan la ganancia dentro de cada categoría. `SUM() OVER` acumula la ganancia.

**HiveQL.** [Rankings de productos](../sql/04_productos.sql).

**Evidencia.** [Cinco mejores por categoría](../evidencias/04_productos_01.png), [mayor cantidad de unidades](../evidencias/04_productos_02.png), [mayor venta monetaria](../evidencias/04_productos_03.png) y [menor ganancia](../evidencias/04_productos_04.png).

**Resultado.** El producto `TEC-CO-10004722` obtiene las mayores ventas monetarias, 61.599,82. El producto `TEC-AC-10003832` lidera unidades, con 75. La peor ganancia corresponde a `TEC-MA-10000418`, con -8.879,97 y margen de -80 %.

**Interpretación.** Un ranking por unidades difiere de uno por importe. Las pérdidas absolutas permiten priorizar revisión, mientras que el margen muestra intensidad relativa.

**Conclusión.** Los productos de mayor venta no son necesariamente los de mayor rentabilidad.

## Pregunta 6. Impacto de los descuentos

**Estrategia.** Se separaron cuatro rangos: 0, mayor que 0 hasta 0,20, mayor que 0,20 hasta 0,50 y mayor que 0,50. Se compararon ventas, ganancias, márgenes y filas con ganancia no positiva.

**HiveQL.** [Descuentos y subcategorías](../sql/05_descuentos.sql).

**Evidencia.** [Resumen por rango](../evidencias/05_descuentos_01.png) y [subcategorías afectadas](../evidencias/05_descuentos_02.png).

**Resultado.** Las 856 líneas con descuento alto tienen ganancia total de -76.559,05 y 100 % de operaciones no rentables. Sin descuento, la proporción no rentable es 0,63 %. Binders pierde 38.510,50 en el rango alto.

**Interpretación.** Los descuentos altos aparecen asociados a mayor proporción de pérdidas en este conjunto. La comparación es descriptiva y no demuestra causalidad.

**Conclusión.** Conviene revisar la política de descuentos altos, especialmente en Binders.

## Pregunta 7. Tendencias mensuales

**Estrategia.** Se agregaron ventas y ganancias por mes. `LAG(1)` compara el mes previo, `LAG(12)` el mismo mes del año previo y `AVG() OVER` calcula tres meses móviles.

**HiveQL.** [Tendencias y extremos](../sql/06_tendencias.sql).

**Evidencia.** [Serie mensual](../evidencias/06_tendencias_01.png) y [tres meses mayores y menores](../evidencias/06_tendencias_02.png).

**Resultado.** Noviembre de 2017 lidera con 118.447,83 en ventas. Febrero de 2014 es el menor, con 4.519,89. Hay 48 meses entre 2014 y 2017.

**Interpretación.** Los primeros meses no tienen suficiente historia para todas las comparaciones. `NULL` en esas variaciones indica falta de base previa.

**Conclusión.** Las ventas mensuales muestran grandes diferencias entre periodos y justifican comparar también con el mismo mes del año anterior.

## Pregunta 8. Pareto de ventas y ganancias

**Estrategia.** Se agregaron ventas y ganancias por producto. Cada métrica se ordenó por aporte, se calculó participación individual y suma acumulada. Para ganancias se analizaron solo productos con ganancia neta positiva; los productos con pérdida requieren revisión separada.

**HiveQL.** [Pareto independiente por métrica](../sql/07_pareto.sql).

**Evidencia.** [Umbral del 80 %](../evidencias/07_pareto_01.png) y [productos principales](../evidencias/07_pareto_02.png).

**Resultado.** En ventas, 414 de 1.862 productos, el 22,23 %, alcanzan el 80 %. En ganancias positivas, 340 de 1.558 productos, el 21,82 %, alcanzan el 80 %. `TEC-CO-10004722` aporta 25.199,93 de ganancia positiva y lidera esa lista.

**Interpretación.** Ambas métricas muestran concentración próxima a 80/20, pero sus denominadores y rankings difieren. La ganancia positiva excluye productos con pérdida para que el porcentaje acumulado sea interpretable.

**Conclusión.** Una minoría de productos concentra la mayor parte de ventas y ganancias positivas.

## Pregunta 9. Tiempos de envío por modalidad (complementaria)

**Estrategia.** Se calculó la diferencia de días entre pedido y envío y se agrupó por modalidad.

**HiveQL.** [Tiempos de envío](../sql/08_envios.sql).

**Evidencia.** [Resultado en CMD](../evidencias/08_envios.png).

**Resultado.** Same Day registró 543 líneas y 0,04 días de espera media. Standard Class registró 5.968 líneas y 5,01 días.

**Interpretación.** Las modalidades ofrecen plazos de envío distintos en este conjunto. La cuenta se hace por línea de venta, no por orden única.

**Conclusión.** Standard Class es la modalidad más usada y la de mayor espera media.

## Pregunta 10. Segmentos comerciales

**Estrategia.** Se agruparon líneas por segmento y se calcularon clientes, ventas, ganancias y margen.

**HiveQL.** [Segmentos comerciales](../sql/09_segmentos.sql).

**Evidencia.** [Resultado en CMD](../evidencias/09_segmentos.png).

**Resultado.** Consumer tuvo 5.191 líneas, 409 clientes, 1.161.401,34 en ventas y 11,55 % de margen. Home Office tuvo el margen mayor, 14,03 %.

**Interpretación.** Consumer lidera en volumen y ganancia absoluta. Home Office convierte una proporción mayor de ventas en ganancia.

**Conclusión.** El volumen y el margen señalan segmentos líderes distintos.

## Pregunta 11. Estados con mayor y menor ganancia (complementaria)

**Estrategia.** Se agruparon ventas y ganancias por estado y se aplicaron rankings ascendente y descendente.

**HiveQL.** [Ranking de estados](../sql/10_estados.sql).

**Evidencia.** [Resultado en CMD](../evidencias/10_estados.png).

**Resultado.** California encabezó la ganancia con 76.381,39. Texas registró la peor ganancia, -25.729,36.

**Interpretación.** Las ventas elevadas no garantizan ganancia positiva; Texas vendió 170.188,05 y perdió 25.729,36.

**Conclusión.** Conviene revisar costos y descuentos en los estados con pérdida.

## Pregunta 12. Categorías

**Estrategia.** Se agregaron ventas y ganancias por categoría y año. `LAG()` comparó las ventas con el año previo de la misma categoría.

**HiveQL.** [Evolución por categoría](../sql/11_categorias.sql).

**Evidencia.** [Resultado en CMD](../evidencias/11_categorias.png).

**Resultado.** Technology pasó de 175.278,23 en ventas en 2014 a 271.730,81 en 2017. Furniture terminó 2017 con margen de 1,40 %.

**Interpretación.** El primer año de cada categoría tiene variación `NULL` porque no existe un año anterior en el dataset.

**Conclusión.** Technology creció en ventas durante el periodo; Furniture mantuvo un margen final bajo.

## Conclusiones generales

La carga de 9.994 líneas en una tabla ORC permitió ejecutar las ocho consultas sobre tipos apropiados. La auditoría no detectó anomalías en las reglas evaluadas.

West obtuvo la mayor ganancia regional y Central la menor. Los descuentos superiores al 50 % coincidieron con pérdidas en las 856 líneas de ese grupo. La asociación es descriptiva y no demuestra causalidad.

La segmentación identificó 199 clientes en riesgo. El análisis Pareto mostró que 414 productos concentran el 80 % de las ventas y 340 productos el 80 % de las ganancias positivas. Estos grupos ofrecen puntos concretos para revisar retención, descuentos y portafolio.
