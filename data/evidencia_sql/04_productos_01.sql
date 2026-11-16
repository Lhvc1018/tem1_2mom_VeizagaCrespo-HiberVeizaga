WITH productos AS (
  SELECT category, product_id, MAX(product_name) AS product_name,
         SUM(sales) AS ventas, SUM(profit) AS ganancia,
         SUM(quantity) AS unidades
  FROM superstore_veizaga.ventas GROUP BY category, product_id
), ranking AS (
  SELECT productos.*,
         RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS puesto_rank,
         DENSE_RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS puesto_dense_rank,
         SUM(ganancia) OVER (PARTITION BY category ORDER BY ganancia DESC, product_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ganancia_acumulada
  FROM productos
)
SELECT category, product_id, product_name, ROUND(ventas, 2) AS ventas,
       ROUND(ganancia, 2) AS ganancia, ROUND(100 * ganancia / ventas, 2) AS margen_pct,
       puesto_rank, puesto_dense_rank, ROUND(ganancia_acumulada, 2) AS ganancia_acumulada
FROM ranking WHERE puesto_rank <= 5 ORDER BY category, puesto_rank;
