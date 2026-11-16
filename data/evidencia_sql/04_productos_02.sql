SELECT product_id, MAX(product_name) AS product_name,
       SUM(quantity) AS unidades, ROUND(SUM(sales), 2) AS ventas
FROM superstore_veizaga.ventas GROUP BY product_id
ORDER BY unidades DESC LIMIT 5;
