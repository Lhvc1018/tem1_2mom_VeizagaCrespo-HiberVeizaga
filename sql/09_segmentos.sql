-- Análisis complementario 10: rentabilidad por segmento comercial.
SELECT segment AS segmento,
       COUNT(*) AS lineas,
       COUNT(DISTINCT customer_id) AS clientes,
       ROUND(SUM(sales), 2) AS ventas,
       ROUND(SUM(profit), 2) AS ganancia,
       ROUND(100 * SUM(profit) / SUM(sales), 2) AS margen_pct
FROM superstore_veizaga.ventas
GROUP BY segment
ORDER BY ganancia DESC;
