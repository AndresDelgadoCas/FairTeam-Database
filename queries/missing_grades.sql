-- Student, subject and period combinations that exist in the course but have no grade yet.
WITH expected AS (
    SELECT DISTINCT s.id AS student_id, s.name AS student, s.course_id, g2.subject_id, g2.period
    FROM students s
    JOIN grades g2 ON g2.course_id = s.course_id
)
SELECT c.name AS curso, e.student AS estudiante, su.name AS asignatura, e.period AS corte
FROM expected e
JOIN courses c ON c.id = e.course_id
JOIN subjects su ON su.id = e.subject_id
WHERE NOT EXISTS (
    SELECT 1 FROM grades g
    WHERE g.student_id = e.student_id AND g.subject_id = e.subject_id AND g.period = e.period
)
ORDER BY c.name, e.student, su.name, e.period;
