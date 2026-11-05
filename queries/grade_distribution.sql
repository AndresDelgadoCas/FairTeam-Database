-- How student averages spread across half-point bands, per course (same bands as the histogram in the app).
WITH averages AS (
    SELECT s.course_id, round(avg(g.grade), 1) AS average
    FROM students s JOIN grades g ON g.student_id = s.id
    GROUP BY s.course_id, s.id
), bands AS (
    SELECT course_id,
           LEAST(floor(average * 2) / 2, 4.5) AS band_start
    FROM averages
)
SELECT c.name AS curso,
       to_char(b.band_start, 'FM0.0') || ' – ' ||
           CASE WHEN b.band_start = 4.5 THEN '5.0' ELSE to_char(b.band_start + 0.5, 'FM0.0') END AS rango,
       count(*) AS estudiantes,
       repeat('█', count(*)::int) AS barra
FROM bands b JOIN courses c ON c.id = b.course_id
GROUP BY c.name, b.band_start
ORDER BY c.name, b.band_start;
