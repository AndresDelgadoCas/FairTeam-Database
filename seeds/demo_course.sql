-- Fictional demo course for a teacher who already has an account.
-- Usage: psql -v ON_ERROR_STOP=1 -v teacher_email="'docente@ejemplo.edu'" -d fairteam_db -f seeds/demo_course.sql
-- All names are invented. Re-running it is safe: an existing "Curso demo FairTeam" is left as is.

BEGIN;

SELECT set_config('app.teacher_id', id::text, true)
FROM teacher_users WHERE email = :teacher_email;

DO $$
BEGIN
    IF NULLIF(current_setting('app.teacher_id', true), '') IS NULL THEN
        RAISE EXCEPTION 'No existe un docente con ese correo; regístralo primero en la aplicación.';
    END IF;
END $$;

INSERT INTO courses (name, period, description)
SELECT 'Curso demo FairTeam', '2026-2', 'Datos ficticios para probar el asistente Búho.'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE teacher_id = current_setting('app.teacher_id')::bigint AND lower(name) = 'curso demo fairteam');

INSERT INTO subjects (name)
SELECT subject FROM (VALUES ('Matemáticas'), ('Programación'), ('Física')) AS s(subject)
WHERE NOT EXISTS (SELECT 1 FROM subjects WHERE teacher_id = current_setting('app.teacher_id')::bigint AND lower(name) = lower(s.subject));

INSERT INTO students (name, email, academic_level, course_id)
SELECT student.name, student.email, 'MEDIUM', course.id
FROM (VALUES
    ('Laura Méndez', 'laura.mendez@demo.fairteam'),
    ('Camilo Rojas', 'camilo.rojas@demo.fairteam'),
    ('Valentina Ortiz', 'valentina.ortiz@demo.fairteam'),
    ('Mateo Herrera', 'mateo.herrera@demo.fairteam'),
    ('Sara Quintero', 'sara.quintero@demo.fairteam'),
    ('Julián Pardo', 'julian.pardo@demo.fairteam'),
    ('Daniela Ríos', 'daniela.rios@demo.fairteam'),
    ('Andrés Vega', 'andres.vega@demo.fairteam')
) AS student(name, email)
CROSS JOIN (SELECT id FROM courses WHERE teacher_id = current_setting('app.teacher_id')::bigint AND lower(name) = 'curso demo fairteam') AS course
ON CONFLICT DO NOTHING;

-- Three "cortes" with deterministic grades: some students improve, some fall behind.
INSERT INTO grades (student_id, subject_id, grade, period, course_id)
SELECT st.id, su.id,
       LEAST(5.0, GREATEST(1.0, round((
           2.4 + (st.rn % 5) * 0.55            -- base level per student
           + (cut.n - 2) * ((st.rn % 3) - 1) * 0.35  -- trend: up, flat or down
           + (su.rn - 2) * 0.15                 -- some subjects are harder
       )::numeric, 1))),
       'Corte ' || cut.n,
       st.course_id
FROM (SELECT s.*, row_number() OVER (ORDER BY s.id) AS rn FROM students s
      JOIN courses c ON c.id = s.course_id AND c.teacher_id = current_setting('app.teacher_id')::bigint
                                AND lower(c.name) = 'curso demo fairteam') AS st
CROSS JOIN (SELECT id, row_number() OVER (ORDER BY id) AS rn FROM subjects
            WHERE teacher_id = current_setting('app.teacher_id')::bigint AND name IN ('Matemáticas', 'Programación', 'Física')) AS su
CROSS JOIN generate_series(1, 3) AS cut(n)
WHERE NOT EXISTS (SELECT 1 FROM grades g WHERE g.student_id = st.id AND g.subject_id = su.id
                  AND g.period = 'Corte ' || cut.n);

-- Keep academic_level consistent with the average, using the same 3.0 / 4.0 cut points as the app.
UPDATE students s SET academic_level = CASE
        WHEN avg_grade < 3.0 THEN 'LOW'
        WHEN avg_grade < 4.0 THEN 'MEDIUM'
        ELSE 'HIGH' END
FROM (SELECT student_id, round(avg(grade), 1) AS avg_grade FROM grades GROUP BY student_id) a
WHERE a.student_id = s.id AND s.teacher_id = current_setting('app.teacher_id')::bigint AND s.email LIKE '%@demo.fairteam';

COMMIT;

-- The teacher setting above was local to the transaction; set it again so the summary is visible.
SELECT set_config('app.teacher_id', id::text, false) AS docente
FROM teacher_users WHERE email = :teacher_email \gset

\echo 'Curso demo listo:'
SELECT c.name AS curso, count(DISTINCT s.id) AS estudiantes, count(g.id) AS notas
FROM courses c LEFT JOIN students s ON s.course_id = c.id LEFT JOIN grades g ON g.student_id = s.id
WHERE lower(c.name) = 'curso demo fairteam'
  AND c.teacher_id = (SELECT id FROM teacher_users WHERE email = :teacher_email)
GROUP BY c.name;
