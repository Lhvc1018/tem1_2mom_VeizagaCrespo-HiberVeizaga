# Diccionario de datos

El archivo Sample Superstore contiene 9.994 filas y 21 columnas. El CSV original usa Windows-1252; el proceso de carga lo convierte a UTF-8. Las fechas originales usan mes/día/año.

| Columna original | Columna Hive | Tipo Hive | Descripción y restricción |
|---|---|---|---|
| Row ID | row_id | INT | Identificador de línea; se audita unicidad. |
| Order ID | order_id | STRING | Identificador de orden; puede repetirse por producto. |
| Order Date | order_date | DATE | Fecha del pedido, convertida desde M/d/yyyy. |
| Ship Date | ship_date | DATE | Fecha del envío; no debe preceder al pedido. |
| Ship Mode | ship_mode | STRING | Modalidad de envío. |
| Customer ID | customer_id | STRING | Identificador de cliente. |
| Customer Name | customer_name | STRING | Nombre del cliente. |
| Segment | segment | STRING | Segmento comercial. |
| Country | country | STRING | País del pedido. |
| City | city | STRING | Ciudad. |
| State | state | STRING | Estado o jurisdicción. |
| Postal Code | postal_code | STRING | Código postal; puede faltar y debe preservar ceros iniciales. |
| Region | region | STRING | Región comercial. |
| Product ID | product_id | STRING | Identificador de producto. |
| Category | category | STRING | Categoría del producto. |
| Sub-Category | sub_category | STRING | Subcategoría del producto. |
| Product Name | product_name | STRING | Nombre; puede contener comas, por eso se usa OpenCSVSerde. |
| Sales | sales | DOUBLE | Venta de la línea; debe ser positiva para análisis comercial. |
| Quantity | quantity | INT | Unidades de la línea. |
| Discount | discount | DOUBLE | Fracción de descuento esperada entre 0 y 1. |
| Profit | profit | DOUBLE | Ganancia de la línea; puede ser negativa. |

Los identificadores se conservan como texto cuando tienen letras o guiones. Los importes se redondean al presentarlos, no al almacenarlos.
