-- End-to-end check of per-teacher isolation, run as a non-superuser (superusers bypass RLS).
-- Usage: psql -v ON_ERROR_STOP=1 -d fairteam_db -f tests/isolation_test.sql
-- Everything runs inside a transaction that is rolled back, so the database is left untouched.

BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'fairteam_isolation_tester') THEN
        CREATE ROLE fairteam_isolation_tester NOLOGIN;
    END IF;
END $$;
GRANT USAGE ON SCHEMA public TO fairteam_isolation_tester;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO fairteam_isolation_tester;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO fairteam_isolation_tester;

INSERT INTO teacher_users (full_name, email, password_hash)
VALUES ('Docente A (prueba)', 'a@isolation.test', 'not-a-real-hash'),
       ('Docente B (prueba)', 'b@isolation.test', 'not-a-real-hash');

SET LOCAL ROLE fairteam_isolation_tester;

-- Teacher A creates a course; the trigger fills teacher_id from the session.
SELECT set_config('app.teacher_id', (SELECT id FROM teacher_users WHERE email = 'a@isolation.test')::text, true);
INSERT INTO courses (name, period) VALUES ('Curso de prueba A', '2026-2');

DO $$
BEGIN
    IF (SELECT count(*) FROM courses WHERE name = 'Curso de prueba A') <> 1 THEN
        RAISE EXCEPTION 'El docente A no ve su propio curso';
    END IF;
END $$;

-- Teacher B must not see it, nor be able to change it.
SELECT set_config('app.teacher_id', (SELECT id FROM teacher_users WHERE email = 'b@isolation.test')::text, true);

DO $$
DECLARE
    changed INTEGER;
BEGIN
    IF (SELECT count(*) FROM courses WHERE name = 'Curso de prueba A') <> 0 THEN
        RAISE EXCEPTION 'El docente B puede ver el curso del docente A';
    END IF;
    UPDATE courses SET name = 'Modificado' WHERE name = 'Curso de prueba A';
    GET DIAGNOSTICS changed = ROW_COUNT;
    IF changed <> 0 THEN
        RAISE EXCEPTION 'El docente B puede modificar el curso del docente A';
    END IF;
END $$;

-- Writing a row for another teacher must be rejected by the WITH CHECK clause.
DO $$
BEGIN
    BEGIN
        INSERT INTO courses (teacher_id, name)
        VALUES ((SELECT id FROM teacher_users WHERE email = 'a@isolation.test'), 'Intruso');
        RAISE EXCEPTION 'Se permitió insertar un curso para otro docente';
    EXCEPTION WHEN insufficient_privilege THEN
        NULL;
    END;
END $$;

-- Without a teacher in the session nothing is visible.
SELECT set_config('app.teacher_id', '', true);
DO $$
BEGIN
    IF (SELECT count(*) FROM courses) <> 0 THEN
        RAISE EXCEPTION 'Sin docente en la sesión se ven cursos';
    END IF;
    RAISE NOTICE 'Aislamiento por docente verificado.';
END $$;

ROLLBACK;
