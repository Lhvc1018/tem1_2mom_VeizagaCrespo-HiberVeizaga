WITH clasificados AS (
  SELECT category, sub_category, sales, profit, discount,
         CASE WHEN discount = 0 THEN 'Sin descuento'
              WHEN discount <= 0.2 THEN 'Bajo'
              WHEN discount <= 0.5 THEN 'Medio'
              ELSE 'Alto' END AS rango_descuento
  FROM superstore_veizaga.ventas
)
SELECT rango_descuento, COUNT(*) AS registros,
       ROUND(SUM(sales), 2) AS ventas, ROUND(SUM(profit), 2) AS ganancia,
       ROUND(100 * SUM(profit) / SUM(sales), 2) AS margen_pct,
       SUM(CASE WHEN profit <= 0 THEN 1 ELSE 0 END) AS no_rentables,
       ROUND(100 * SUM(CASE WHEN profit <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_rentables_pct,
       ROUND(AVG(discount), 3) AS descuento_promedio
FROM clasificados GROUP BY rango_descuento
ORDER BY CASE rango_descuento WHEN 'Sin descuento' THEN 1 WHEN 'Bajo' THEN 2 WHEN 'Medio' THEN 3 ELSE 4 END;
