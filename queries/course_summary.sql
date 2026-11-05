-- One row per course: students, grades recorded and average, plus how many need support.
WITH student_avg AS (
    SELECT s.course_id, s.id, round(avg(g.grade), 1) AS average
    FROM students s LEFT JOIN grades g ON g.student_id = s.id
    GROUP BY s.course_id, s.id
)
SELECT c.name AS curso,
       c.period AS periodo,
       count(sa.id) AS estudiantes,
       (SELECT count(*) FROM grades g WHERE g.course_id = c.id) AS notas,
       round(avg(sa.average), 2) AS promedio,
       count(*) FILTER (WHERE sa.average < 3.0) AS refuerzo,
       count(*) FILTER (WHERE sa.average >= 3.0 AND sa.average < 4.0) AS seguimiento,
       count(*) FILTER (WHERE sa.average >= 4.0) AS buen_progreso,
       count(*) FILTER (WHERE sa.id IS NOT NULL AND sa.average IS NULL) AS sin_notas
FROM courses c
LEFT JOIN student_avg sa ON sa.course_id = c.id
GROUP BY c.id, c.name, c.period
ORDER BY c.name;
