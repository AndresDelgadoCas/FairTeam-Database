-- Average per student and period side by side, ordered "Corte 1, Corte 2, ..." like the app.
SELECT s.name AS estudiante,
       g.period AS corte,
       round(avg(g.grade), 2) AS promedio,
       round(avg(g.grade) - lag(avg(g.grade)) OVER (
           PARTITION BY s.id
           ORDER BY NULLIF(substring(g.period FROM '(\d+)\D*$'), '')::int NULLS LAST, g.period
       ), 2) AS cambio
FROM grades g
JOIN students s ON s.id = g.student_id
GROUP BY s.id, s.name, g.period
ORDER BY s.name, NULLIF(substring(g.period FROM '(\d+)\D*$'), '')::int NULLS LAST, g.period;
