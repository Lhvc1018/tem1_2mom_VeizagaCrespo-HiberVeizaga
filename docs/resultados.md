# Resultados de las doce consultas

El examen explica ocho preguntas. Las preguntas 9 a 12 son análisis adicionales para completar los doce scripts solicitados.

Los importes vienen del CSV Sample Superstore. El archivo no indica moneda; por eso muestro las cifras sin símbolo y con dos decimales.

## Pregunta 1. Modelo e ingesta

**Estrategia.** Revisé las 21 columnas. Primero cargué el CSV como texto con OpenCSVSerde. Después pasé fechas y números a una tabla ORC.

**HiveQL.** [Modelo y carga](../sql/00_modelo_carga.sql).

**Evidencia.** [Ubicación de la tabla](../evidencias/01_ubicacion.png), [conteo de filas](../evidencias/01_carga.png) y [muestra de diez registros](../evidencias/01_muestra.png).

**Resultado.** Cargué 9.994 registros en una tabla de 21 campos. Revisé diez filas y comprobé las fechas y los importes.

**Interpretación.** La primera tabla guarda el texto del CSV. En la tabla ORC ya puedo sumar ventas y trabajar con fechas.

**Conclusión.** Los 9.994 registros quedaron listos para las consultas.

## Pregunta 2. Calidad e integridad

**Estrategia.** Conté filas, órdenes y clientes. También busqué duplicados, nulos, fechas incorrectas y valores fuera de rango.

**HiveQL.** [Auditoría de calidad](../sql/01_calidad.sql).

**Evidencia.** [Resumen](../evidencias/01_calidad_01.png) y [campos nulos](../evidencias/01_calidad_02.png).

**Resultado.** Hay 9.994 filas, 0 `Row ID` duplicados, 5.009 órdenes y 793 clientes. No encontré fechas inválidas, ventas de 0 o menos, descuentos fuera de 0 a 1 ni envíos anteriores al pedido. Tampoco encontré campos `NULL` ni conversiones inválidas.

**Interpretación.** Los datos pasaron estas revisiones. Si entran más filas, repetiría los controles antes de cargarlas.

**Conclusión.** No tuve que corregir filas según las reglas que revisé.

## Pregunta 3. Evolución comercial por región

**Estrategia.** Sumé ventas y ganancias por región y año. Usé `LAG()` para compararlas con el año anterior.

**HiveQL.** [Evolución y ranking regional](../sql/02_region.sql).

**Evidencia.** [Serie regional anual](../evidencias/02_region_01.png) y [ranking global](../evidencias/02_region_02.png).

**Resultado.** West ganó 108.418,45 y tuvo un margen de 14,94 %. Central ganó 39.706,36 y tuvo 7,92 %. Hay 16 resultados: cuatro regiones por cuatro años.

**Interpretación.** En 2014 la variación sale `NULL` porque no hay año anterior. Para comparar ganancias con pérdidas, usé el valor absoluto del año previo.

**Conclusión.** West tuvo la mayor ganancia total; Central, la menor.

## Pregunta 4. Segmentación RFM

**Estrategia.** Tomé la última fecha del archivo como referencia. Conté órdenes distintas y sumé ventas por cliente. Después asigné puntuaciones de 1 a 5.

**Criterios.** Alto valor: R, F y M de 4 o 5. En riesgo: R de 1 o 2 y F o M de 3 a 5. Recurrente: F de 4 o 5, sin entrar antes en otro grupo.

**HiveQL.** [Vista y segmentación RFM](../sql/03_rfm.sql).

**Evidencia.** [Resumen de segmentos](../evidencias/03_rfm_01.png) y [clientes de mayor gasto](../evidencias/03_rfm_02.png).

**Resultado.** De 793 clientes, 105 son de alto valor, 199 están en riesgo, 129 son recurrentes y 360 quedan en otros grupos. Los clientes en riesgo suman 692.584,35 en ventas. Su última compra fue, en promedio, hace 255,86 días.

**Interpretación.** Gastar mucho no basta para quedar en alto valor. Si un cliente lleva tiempo sin comprar, puede aparecer en riesgo.

**Conclusión.** Revisaría primero a los 199 clientes en riesgo.

## Pregunta 5. Rentabilidad de productos

**Estrategia.** Agrupé las ventas por producto. Calculé unidades, importe, ganancia y margen. Luego ordené los productos dentro de cada categoría.

**HiveQL.** [Rankings de productos](../sql/04_productos.sql).

**Evidencia.** [Cinco mejores por categoría](../evidencias/04_productos_01.png), [mayor cantidad de unidades](../evidencias/04_productos_02.png), [mayor venta monetaria](../evidencias/04_productos_03.png) y [menor ganancia](../evidencias/04_productos_04.png).

**Resultado.** `TEC-CO-10004722` vendió 61.599,82, el importe mayor. `TEC-AC-10003832` lideró en unidades, con 75. `TEC-MA-10000418` tuvo la mayor pérdida: -8.879,97 y margen de -80 %.

**Interpretación.** El producto más vendido por importe no fue el de más unidades. También hay productos con ventas altas que pierden dinero.

**Conclusión.** Hay que mirar la ganancia y el margen, además de las ventas.

## Pregunta 6. Impacto de los descuentos

**Estrategia.** Separé las filas en cuatro descuentos: 0; más de 0 hasta 20 %; más de 20 % hasta 50 %; y más de 50 %. Comparé ventas y ganancias.

**HiveQL.** [Descuentos y subcategorías](../sql/05_descuentos.sql).

**Evidencia.** [Resumen por rango](../evidencias/05_descuentos_01.png) y [subcategorías afectadas](../evidencias/05_descuentos_02.png).

**Resultado.** Las 856 filas con descuento superior al 50 % perdieron 76.559,05 en total. Todas fueron no rentables. Sin descuento, solo el 0,63 % fue no rentable. Binders perdió 38.510,50 con descuento alto.

**Interpretación.** En estos datos, los descuentos altos coinciden con más pérdidas. La consulta no prueba que el descuento sea la única causa.

**Conclusión.** Revisaría los descuentos superiores al 50 %, sobre todo en Binders.

## Pregunta 7. Tendencias mensuales

**Estrategia.** Sumé ventas y ganancias por mes. Comparé cada mes con el anterior y con el mismo mes del año previo. También calculé el promedio de tres meses.

**HiveQL.** [Tendencias y extremos](../sql/06_tendencias.sql).

**Evidencia.** [Serie mensual](../evidencias/06_tendencias_01.png) y [tres meses mayores y menores](../evidencias/06_tendencias_02.png).

**Resultado.** El mes con más ventas fue noviembre de 2017: 118.447,83. El menor fue febrero de 2014: 4.519,89. Analicé 48 meses, de 2014 a 2017.

**Interpretación.** Los primeros meses muestran `NULL` en algunas variaciones porque todavía no hay meses previos para comparar.

**Conclusión.** Las ventas cambian mucho entre meses. La comparación anual ayuda a entender esos cambios.

## Pregunta 8. Pareto de ventas y ganancias

**Estrategia.** Sumé ventas y ganancias por producto y calculé cuánto aporta cada uno al total. Para ganancias, tomé solo productos con resultado positivo.

**HiveQL.** [Pareto independiente por métrica](../sql/07_pareto.sql).

**Evidencia.** [Umbral del 80 %](../evidencias/07_pareto_01.png) y [productos principales](../evidencias/07_pareto_02.png).

**Resultado.** 414 de 1.862 productos, el 22,23 %, reúnen el 80 % de las ventas. En ganancias positivas, 340 de 1.558 productos, el 21,82 %, reúnen el 80 %. `TEC-CO-10004722` lidera la ganancia con 25.199,93.

**Interpretación.** Un grupo pequeño aporta la mayor parte de ventas y ganancias. El cálculo de ganancias deja fuera los productos con pérdida.

**Conclusión.** Vale la pena cuidar los productos que más aportan y revisar aparte los que pierden dinero.

## Pregunta 9. Tiempos de envío por modalidad (complementaria)

**Estrategia.** Calculé los días entre cada pedido y su envío. Después agrupé las filas por modalidad.

**HiveQL.** [Tiempos de envío](../sql/08_envios.sql).

**Evidencia.** [Resultado en CMD](../evidencias/08_envios.png).

**Resultado.** Same Day tuvo 543 líneas y tardó 0,04 días en promedio. Standard Class tuvo 5.968 líneas y tardó 5,01 días.

**Interpretación.** Standard Class tarda más y se usa más. Conté líneas de venta, no pedidos únicos.

**Conclusión.** Standard Class concentra más líneas y tiene el mayor tiempo medio de envío.

## Pregunta 10. Segmentos comerciales

**Estrategia.** Agrupé las líneas por segmento y calculé clientes, ventas, ganancias y margen.

**HiveQL.** [Segmentos comerciales](../sql/09_segmentos.sql).

**Evidencia.** [Resultado en CMD](../evidencias/09_segmentos.png).

**Resultado.** Consumer tuvo 5.191 líneas, 409 clientes, 1.161.401,34 en ventas y 11,55 % de margen. Home Office alcanzó el margen mayor: 14,03 %.

**Interpretación.** Consumer vende más en total. Home Office obtiene más ganancia por cada 100 de ventas.

**Conclusión.** Consumer lidera las ventas, pero Home Office tiene mejor margen.

## Pregunta 11. Estados con mayor y menor ganancia (complementaria)

**Estrategia.** Sumé ventas y ganancias por estado. Luego ordené los estados de mayor a menor ganancia y al revés.

**HiveQL.** [Ranking de estados](../sql/10_estados.sql).

**Evidencia.** [Resultado en CMD](../evidencias/10_estados.png).

**Resultado.** California tuvo la ganancia mayor: 76.381,39. Texas tuvo el resultado menor: -25.729,36.

**Interpretación.** Texas vendió 170.188,05, pero perdió 25.729,36. Vender mucho no siempre deja ganancia.

**Conclusión.** Revisaría los costos y descuentos de Texas y los demás estados con pérdida.

## Pregunta 12. Categorías

**Estrategia.** Sumé ventas y ganancias por categoría y año. Comparé cada año con el anterior de la misma categoría.

**HiveQL.** [Evolución por categoría](../sql/11_categorias.sql).

**Evidencia.** [Resultado en CMD](../evidencias/11_categorias.png).

**Resultado.** Technology vendió 175.278,23 en 2014 y 271.730,81 en 2017. Furniture cerró 2017 con margen de 1,40 %.

**Interpretación.** En 2014 aparece `NULL` en la variación porque no hay datos de 2013 para comparar.

**Conclusión.** Technology vendió más en 2017 que en 2014. Furniture terminó con un margen bajo.

## Conclusiones generales

La tabla ORC quedó con 9.994 líneas. Las doce consultas se ejecutaron sobre esos datos. La revisión de calidad no encontró problemas según las reglas aplicadas.

West tuvo la mayor ganancia regional y Central la menor. Las 856 líneas con descuento superior al 50 % dieron pérdida. Eso no prueba que el descuento fuera la única causa.

Encontré 199 clientes en riesgo. Además, 414 productos reúnen el 80 % de las ventas y 340 reúnen el 80 % de las ganancias positivas. Revisaría primero esos clientes, los descuentos altos y los productos con pérdida.
