WITH anuales AS (
  SELECT category AS categoria,
         YEAR(order_date) AS anio,
         SUM(sales) AS ventas,
         SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas
  GROUP BY category, YEAR(order_date)
), comparacion AS (
  SELECT categoria, anio, ventas, ganancia,
         LAG(ventas) OVER (PARTITION BY categoria ORDER BY anio) AS ventas_previas
  FROM anuales
)
SELECT categoria, anio,
       ROUND(ventas, 2) AS ventas,
       ROUND(ganancia, 2) AS ganancia,
       ROUND(100 * ganancia / ventas, 2) AS margen_pct,
       ROUND(100 * (ventas - ventas_previas) / ventas_previas, 2) AS variacion_ventas_pct
FROM comparacion
ORDER BY categoria, anio;