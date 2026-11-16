WITH region_total AS (
  SELECT region, SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas GROUP BY region
)
SELECT region, ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       ROUND(100 * ganancia / ventas, 2) AS margen_pct,
       RANK() OVER (ORDER BY ganancia DESC) AS puesto_ganancia
FROM region_total ORDER BY puesto_ganancia;
