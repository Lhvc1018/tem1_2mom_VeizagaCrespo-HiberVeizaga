LOAD DATA LOCAL INPATH '/tmp/superstore_utf8.csv'
OVERWRITE INTO TABLE superstore_veizaga.superstore_csv;

INSERT OVERWRITE TABLE superstore_veizaga.ventas
SELECT
  CAST(row_id AS INT), order_id,
  CAST(from_unixtime(unix_timestamp(order_date, 'M/d/yyyy'), 'yyyy-MM-dd') AS DATE),
  CAST(from_unixtime(unix_timestamp(ship_date, 'M/d/yyyy'), 'yyyy-MM-dd') AS DATE),
  ship_mode, customer_id, customer_name, segment, country, city, state,
  postal_code, region, product_id, category, sub_category, product_name,
  CAST(sales AS DOUBLE), CAST(quantity AS INT), CAST(discount AS DOUBLE),
  CAST(profit AS DOUBLE)
FROM superstore_veizaga.superstore_csv;
