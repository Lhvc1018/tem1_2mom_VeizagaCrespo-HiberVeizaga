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

SELECT product_id, MAX(product_name) AS product_name,
       SUM(quantity) AS unidades, ROUND(SUM(sales), 2) AS ventas
FROM superstore_veizaga.ventas GROUP BY product_id
ORDER BY unidades DESC LIMIT 5;

SELECT product_id, MAX(product_name) AS product_name,
       SUM(quantity) AS unidades, ROUND(SUM(sales), 2) AS ventas
FROM superstore_veizaga.ventas GROUP BY product_id
ORDER BY ventas DESC LIMIT 5;

SELECT product_id, MAX(product_name) AS product_name,
       ROUND(SUM(sales), 2) AS ventas, ROUND(SUM(profit), 2) AS ganancia,
       ROUND(100 * SUM(profit) / SUM(sales), 2) AS margen_pct
FROM superstore_veizaga.ventas GROUP BY product_id
ORDER BY ganancia ASC LIMIT 5;
