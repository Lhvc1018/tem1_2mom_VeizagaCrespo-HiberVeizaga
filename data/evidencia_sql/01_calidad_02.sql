SELECT COUNT(*) AS filas_con_algun_null
FROM superstore_veizaga.ventas
WHERE row_id IS NULL OR order_id IS NULL OR order_date IS NULL OR ship_date IS NULL
   OR ship_mode IS NULL OR customer_id IS NULL OR customer_name IS NULL
   OR segment IS NULL OR country IS NULL OR city IS NULL OR state IS NULL
   OR postal_code IS NULL OR region IS NULL OR product_id IS NULL
   OR category IS NULL OR sub_category IS NULL OR product_name IS NULL
   OR sales IS NULL OR quantity IS NULL OR discount IS NULL OR profit IS NULL;
