SET hive.strict.checks.cartesian.product=false;
SELECT customer_id, customer_name, recency, frequency,
       ROUND(monetary, 2) AS monetary, r_score, f_score, m_score, segmento_rfm
FROM superstore_veizaga.rfm_clientes
ORDER BY monetary DESC LIMIT 20;
