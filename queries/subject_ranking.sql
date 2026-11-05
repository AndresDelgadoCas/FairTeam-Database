-- Subjects from hardest to easiest in each course, to decide where the next workshop helps most.
SELECT c.name AS curso,
       su.name AS asignatura,
       round(avg(g.grade), 2) AS promedio,
       count(DISTINCT g.student_id) FILTER (WHERE g.grade < 3.0) AS estudiantes_bajo_3,
       rank() OVER (PARTITION BY c.id ORDER BY avg(g.grade)) AS dificultad
FROM grades g
JOIN subjects su ON su.id = g.subject_id
JOIN courses c ON c.id = g.course_id
GROUP BY c.id, c.name, su.name
ORDER BY c.name, dificultad;
