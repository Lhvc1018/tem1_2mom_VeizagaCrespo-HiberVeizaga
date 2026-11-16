WITH mensual AS (
  SELECT date_format(order_date, 'yyyy-MM') AS mes,
         SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas
  GROUP BY date_format(order_date, 'yyyy-MM')
), ranking AS (
  SELECT mensual.*,
         RANK() OVER (ORDER BY ventas DESC) AS rango_alto,
         RANK() OVER (ORDER BY ventas ASC) AS rango_bajo
  FROM mensual
)
SELECT mes, ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       rango_alto, rango_bajo
FROM ranking WHERE rango_alto <= 3 OR rango_bajo <= 3
ORDER BY ventas DESC;
