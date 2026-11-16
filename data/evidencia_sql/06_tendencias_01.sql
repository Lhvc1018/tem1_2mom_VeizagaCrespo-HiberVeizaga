WITH mensual AS (
  SELECT date_format(order_date, 'yyyy-MM') AS mes,
         SUM(sales) AS ventas, SUM(profit) AS ganancia
  FROM superstore_veizaga.ventas
  GROUP BY date_format(order_date, 'yyyy-MM')
), ventanas AS (
  SELECT mes, ventas, ganancia,
         LAG(ventas, 1) OVER (ORDER BY mes) AS ventas_mes_previo,
         LAG(ventas, 12) OVER (ORDER BY mes) AS ventas_anio_previo,
         AVG(ventas) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS media_tres_meses
  FROM mensual
)
SELECT mes, ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       ROUND(100 * (ventas - ventas_mes_previo) / ventas_mes_previo, 2) AS variacion_mensual_pct,
       ROUND(100 * (ventas - ventas_anio_previo) / ventas_anio_previo, 2) AS variacion_anual_pct,
       ROUND(media_tres_meses, 2) AS promedio_movil_tres_meses
FROM ventanas ORDER BY mes;
