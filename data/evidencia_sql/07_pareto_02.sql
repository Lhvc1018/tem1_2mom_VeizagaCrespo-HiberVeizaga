SELECT metrica, posicion, product_id, product_name,
       ROUND(aporte, 2) AS aporte, ROUND(participacion_pct, 2) AS participacion_pct,
       ROUND(acumulado_pct, 2) AS acumulado_pct
FROM superstore_veizaga.pareto_productos
WHERE posicion <= 10 ORDER BY metrica, posicion;
