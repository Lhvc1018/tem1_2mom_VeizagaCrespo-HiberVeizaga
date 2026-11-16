DROP VIEW IF EXISTS superstore_veizaga.pareto_productos;
CREATE VIEW superstore_veizaga.pareto_productos AS
WITH productos AS (
  SELECT product_id, MAX(product_name) AS product_name,
         SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas GROUP BY product_id
), medidas AS (
  SELECT 'Ventas' AS metrica, product_id, product_name, ventas AS aporte
  FROM productos WHERE ventas > 0
  UNION ALL
  SELECT 'Ganancias positivas' AS metrica, product_id, product_name, ganancia AS aporte
  FROM productos WHERE ganancia > 0
), acumuladas AS (
  SELECT medidas.*,
         ROW_NUMBER() OVER (PARTITION BY metrica ORDER BY aporte DESC, product_id) AS posicion,
         SUM(aporte) OVER (PARTITION BY metrica) AS total_metrica,
         SUM(aporte) OVER (PARTITION BY metrica ORDER BY aporte DESC, product_id
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado
  FROM medidas
)
SELECT metrica, product_id, product_name, aporte, posicion, total_metrica, acumulado,
       100 * aporte / total_metrica AS participacion_pct,
       100 * acumulado / total_metrica AS acumulado_pct
FROM acumuladas;

SELECT metrica, COUNT(*) AS productos_elegibles,
       SUM(CASE WHEN (acumulado - aporte) / total_metrica < 0.8 THEN 1 ELSE 0 END) AS productos_para_80_pct,
       ROUND(100 * SUM(CASE WHEN (acumulado - aporte) / total_metrica < 0.8 THEN 1 ELSE 0 END) / COUNT(*), 2) AS porcentaje_productos
FROM superstore_veizaga.pareto_productos
GROUP BY metrica ORDER BY metrica;

SELECT metrica, posicion, product_id, product_name,
       ROUND(aporte, 2) AS aporte, ROUND(participacion_pct, 2) AS participacion_pct,
       ROUND(acumulado_pct, 2) AS acumulado_pct
FROM superstore_veizaga.pareto_productos
WHERE posicion <= 10 ORDER BY metrica, posicion;
