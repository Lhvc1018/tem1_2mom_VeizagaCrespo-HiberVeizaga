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
