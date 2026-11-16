CREATE DATABASE IF NOT EXISTS superstore_veizaga;

CREATE TABLE IF NOT EXISTS superstore_veizaga.superstore_csv (
  row_id STRING,
  order_id STRING,
  order_date STRING,
  ship_date STRING,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales STRING,
  quantity STRING,
  discount STRING,
  profit STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');

LOAD DATA LOCAL INPATH '/tmp/superstore_utf8.csv'
OVERWRITE INTO TABLE superstore_veizaga.superstore_csv;

CREATE TABLE IF NOT EXISTS superstore_veizaga.ventas (
  row_id INT,
  order_id STRING,
  order_date DATE,
  ship_date DATE,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales DOUBLE,
  quantity INT,
  discount DOUBLE,
  profit DOUBLE
)
STORED AS ORC;

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

DESCRIBE FORMATTED superstore_veizaga.ventas;
SELECT COUNT(*) AS total_registros FROM superstore_veizaga.ventas;
SELECT row_id, order_id, order_date, ship_date, region, product_id, sales, profit
FROM superstore_veizaga.ventas LIMIT 10;
