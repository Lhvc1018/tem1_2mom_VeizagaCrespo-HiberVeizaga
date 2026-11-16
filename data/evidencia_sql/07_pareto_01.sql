SELECT metrica, COUNT(*) AS productos_elegibles,
       SUM(CASE WHEN (acumulado - aporte) / total_metrica < 0.8 THEN 1 ELSE 0 END) AS productos_para_80_pct,
       ROUND(100 * SUM(CASE WHEN (acumulado - aporte) / total_metrica < 0.8 THEN 1 ELSE 0 END) / COUNT(*), 2) AS porcentaje_productos
FROM superstore_veizaga.pareto_productos
GROUP BY metrica ORDER BY metrica;
