SELECT product_id, MAX(product_name) AS product_name,
       ROUND(SUM(sales), 2) AS ventas, ROUND(SUM(profit), 2) AS ganancia,
       ROUND(100 * SUM(profit) / SUM(sales), 2) AS margen_pct
FROM superstore_veizaga.ventas GROUP BY product_id
ORDER BY ganancia ASC LIMIT 5;
