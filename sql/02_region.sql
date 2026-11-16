WITH anuales AS (
  SELECT region, year(order_date) AS anio,
         SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas
  GROUP BY region, year(order_date)
), comparacion AS (
  SELECT region, anio, ventas, ganancia,
         LAG(ventas) OVER (PARTITION BY region ORDER BY anio) AS ventas_anio_previo,
         LAG(ganancia) OVER (PARTITION BY region ORDER BY anio) AS ganancia_anio_previo
  FROM anuales
)
SELECT region, anio, ROUND(ventas, 2) AS ventas,
       ROUND(ganancia, 2) AS ganancia,
       ROUND(100 * ganancia / ventas, 2) AS margen_pct,
       ROUND(100 * (ventas - ventas_anio_previo) / ventas_anio_previo, 2) AS variacion_ventas_pct,
       ROUND(100 * (ganancia - ganancia_anio_previo) / ABS(ganancia_anio_previo), 2) AS variacion_ganancia_pct
FROM comparacion
ORDER BY region, anio;

WITH region_total AS (
  SELECT region, SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas GROUP BY region
)
SELECT region, ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       ROUND(100 * ganancia / ventas, 2) AS margen_pct,
       RANK() OVER (ORDER BY ganancia DESC) AS puesto_ganancia
FROM region_total ORDER BY puesto_ganancia;
