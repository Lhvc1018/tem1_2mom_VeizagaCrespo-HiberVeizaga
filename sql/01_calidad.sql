-- Resumen de calidad de la tabla final.
SELECT
  COUNT(*) AS filas,
  COUNT(*) - COUNT(DISTINCT row_id) AS row_id_duplicados,
  COUNT(DISTINCT order_id) AS ordenes_unicas,
  COUNT(DISTINCT customer_id) AS clientes_unicos,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS fechas_pedido_invalidas,
  SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS fechas_envio_invalidas,
  SUM(CASE WHEN sales <= 0 THEN 1 ELSE 0 END) AS ventas_no_positivas,
  SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS descuentos_fuera_rango,
  SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS envios_antes_pedido,
  SUM(CASE WHEN sales IS NULL OR profit IS NULL OR quantity IS NULL THEN 1 ELSE 0 END) AS nulos_numericos
FROM superstore_veizaga.ventas;

-- Una fila con cualquier columna nula; todas las 21 columnas están incluidas.
SELECT COUNT(*) AS filas_con_algun_null
FROM superstore_veizaga.ventas
WHERE row_id IS NULL OR order_id IS NULL OR order_date IS NULL OR ship_date IS NULL
   OR ship_mode IS NULL OR customer_id IS NULL OR customer_name IS NULL
   OR segment IS NULL OR country IS NULL OR city IS NULL OR state IS NULL
   OR postal_code IS NULL OR region IS NULL OR product_id IS NULL
   OR category IS NULL OR sub_category IS NULL OR product_name IS NULL
   OR sales IS NULL OR quantity IS NULL OR discount IS NULL OR profit IS NULL;

-- Revisión de fechas y números en el CSV antes del CAST.
SELECT
  SUM(CASE WHEN unix_timestamp(order_date, 'M/d/yyyy') IS NULL THEN 1 ELSE 0 END) AS pedido_invalido_csv,
  SUM(CASE WHEN unix_timestamp(ship_date, 'M/d/yyyy') IS NULL THEN 1 ELSE 0 END) AS envio_invalido_csv,
  SUM(CASE WHEN CAST(sales AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS venta_invalida_csv,
  SUM(CASE WHEN CAST(discount AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS descuento_invalido_csv,
  SUM(CASE WHEN CAST(profit AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS ganancia_invalida_csv
FROM superstore_veizaga.superstore_csv;

-- Campos opcionales con valores vacíos.
SELECT
  SUM(CASE WHEN postal_code IS NULL OR trim(postal_code) = '' THEN 1 ELSE 0 END) AS postal_vacio,
  SUM(CASE WHEN order_id IS NULL OR trim(order_id) = '' THEN 1 ELSE 0 END) AS orden_vacia,
  SUM(CASE WHEN customer_id IS NULL OR trim(customer_id) = '' THEN 1 ELSE 0 END) AS cliente_vacio,
  SUM(CASE WHEN product_id IS NULL OR trim(product_id) = '' THEN 1 ELSE 0 END) AS producto_vacio,
  SUM(CASE WHEN region IS NULL OR trim(region) = '' THEN 1 ELSE 0 END) AS region_vacia
FROM superstore_veizaga.ventas;
