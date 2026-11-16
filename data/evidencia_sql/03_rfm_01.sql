SET hive.strict.checks.cartesian.product=false;
SELECT segmento_rfm, COUNT(*) AS clientes,
       ROUND(SUM(monetary), 2) AS ventas_acumuladas,
       ROUND(AVG(recency), 2) AS recency_promedio
FROM superstore_veizaga.rfm_clientes
GROUP BY segmento_rfm ORDER BY ventas_acumuladas DESC;
