SELECT category, sub_category, COUNT(*) AS registros,
       ROUND(SUM(profit), 2) AS ganancia,
       SUM(CASE WHEN profit <= 0 THEN 1 ELSE 0 END) AS no_rentables,
       ROUND(100 * SUM(CASE WHEN profit <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_rentables_pct
FROM superstore_veizaga.ventas WHERE discount > 0.5
GROUP BY category, sub_category ORDER BY ganancia ASC;
