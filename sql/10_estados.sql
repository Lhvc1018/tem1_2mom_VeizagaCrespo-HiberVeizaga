-- Análisis complementario 11: cinco estados con mayor y menor ganancia.
WITH estados AS (
  SELECT state AS estado,
         ROUND(SUM(sales), 2) AS ventas,
         ROUND(SUM(profit), 2) AS ganancia
  FROM superstore_veizaga.ventas
  GROUP BY state
), ranking AS (
  SELECT estado, ventas, ganancia,
         ROW_NUMBER() OVER (ORDER BY ganancia DESC, estado) AS puesto_alto,
         ROW_NUMBER() OVER (ORDER BY ganancia ASC, estado) AS puesto_bajo
  FROM estados
)
SELECT estado, ventas, ganancia, puesto_alto, puesto_bajo
FROM ranking
WHERE puesto_alto <= 5 OR puesto_bajo <= 5
ORDER BY ganancia DESC;
