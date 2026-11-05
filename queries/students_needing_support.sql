-- Students below 3.0, or between 3.0 and 4.0 whose last period dropped, worst first.
WITH per_period AS (
    SELECT g.student_id, g.period,
           avg(g.grade) AS average,
           NULLIF(substring(g.period FROM '(\d+)\D*$'), '')::int AS period_number
    FROM grades g GROUP BY g.student_id, g.period
), ranked AS (
    SELECT *, row_number() OVER (PARTITION BY student_id ORDER BY period_number DESC NULLS LAST, period DESC) AS from_last
    FROM per_period
), trend AS (
    SELECT student_id,
           round(max(average) FILTER (WHERE from_last = 1)
                 - max(average) FILTER (WHERE from_last = 2), 2) AS change
    FROM ranked GROUP BY student_id
)
SELECT c.name AS curso, s.name AS estudiante,
       round(avg(g.grade), 1) AS promedio,
       t.change AS cambio_ultimo_corte,
       CASE WHEN round(avg(g.grade), 1) < 3.0 THEN 'Necesita refuerzo' ELSE 'Va bajando' END AS motivo
FROM students s
JOIN courses c ON c.id = s.course_id
JOIN grades g ON g.student_id = s.id
LEFT JOIN trend t ON t.student_id = s.id
GROUP BY c.name, s.id, s.name, t.change
HAVING round(avg(g.grade), 1) < 3.0
    OR (round(avg(g.grade), 1) < 4.0 AND t.change < -0.2)
ORDER BY promedio, cambio_ultimo_corte NULLS LAST;
