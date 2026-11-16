-- Análisis complementario 9: tiempos de envío por modalidad.
SELECT ship_mode AS modalidad,
       COUNT(*) AS lineas,
       ROUND(AVG(DATEDIFF(ship_date, order_date)), 2) AS dias_promedio,
       MIN(DATEDIFF(ship_date, order_date)) AS dias_minimos,
       MAX(DATEDIFF(ship_date, order_date)) AS dias_maximos,
       ROUND(SUM(sales), 2) AS ventas
FROM superstore_veizaga.ventas
GROUP BY ship_mode
ORDER BY dias_promedio;
