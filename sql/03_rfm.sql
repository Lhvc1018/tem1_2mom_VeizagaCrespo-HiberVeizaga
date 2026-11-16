SET hive.strict.checks.cartesian.product=false;
DROP VIEW IF EXISTS superstore_veizaga.rfm_clientes;
CREATE VIEW superstore_veizaga.rfm_clientes AS
WITH referencia AS (
  SELECT MAX(order_date) AS fecha_maxima FROM superstore_veizaga.ventas
), cliente AS (
  SELECT customer_id, MAX(customer_name) AS customer_name,
         MAX(order_date) AS ultima_compra,
         COUNT(DISTINCT order_id) AS frequency,
         SUM(sales) AS monetary
  FROM superstore_veizaga.ventas
  GROUP BY customer_id
), medidas AS (
  SELECT c.*, DATEDIFF(r.fecha_maxima, c.ultima_compra) AS recency
  FROM cliente c CROSS JOIN referencia r
), puntajes AS (
  SELECT medidas.*,
         NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
         NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
         NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM medidas
)
SELECT puntajes.*,
       CASE WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
            WHEN r_score <= 2 AND (f_score >= 3 OR m_score >= 3) THEN 'En riesgo'
            WHEN f_score >= 4 THEN 'Recurrente'
            ELSE 'Otros' END AS segmento_rfm
FROM puntajes;

SELECT segmento_rfm, COUNT(*) AS clientes,
       ROUND(SUM(monetary), 2) AS ventas_acumuladas,
       ROUND(AVG(recency), 2) AS recency_promedio
FROM superstore_veizaga.rfm_clientes
GROUP BY segmento_rfm ORDER BY ventas_acumuladas DESC;

SELECT customer_id, customer_name, recency, frequency,
       ROUND(monetary, 2) AS monetary, r_score, f_score, m_score, segmento_rfm
FROM superstore_veizaga.rfm_clientes
ORDER BY monetary DESC LIMIT 20;
