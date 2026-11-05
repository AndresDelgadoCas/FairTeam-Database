-- Fails if any table with a teacher_id column is not isolated per teacher.
-- Usage: psql -v ON_ERROR_STOP=1 -d fairteam_db -f scripts/verify_rls.sql

\echo 'Tablas con teacher_id y su aislamiento:'
SELECT c.relname AS tabla,
       c.relrowsecurity AS rls,
       c.relforcerowsecurity AS rls_forzado,
       EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid = c.oid
               AND p.polname = 'fairteam_tenant_isolation') AS politica,
       EXISTS (SELECT 1 FROM pg_trigger t WHERE t.tgrelid = c.oid
               AND t.tgname = 'fairteam_assign_tenant') AS trigger_insert
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
JOIN information_schema.columns col
  ON col.table_schema = 'public' AND col.table_name = c.relname AND col.column_name = 'teacher_id'
WHERE c.relkind = 'r'
ORDER BY c.relname;

DO $$
DECLARE
    missing TEXT;
BEGIN
    SELECT string_agg(c.relname, ', ' ORDER BY c.relname) INTO missing
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
    JOIN information_schema.columns col
      ON col.table_schema = 'public' AND col.table_name = c.relname AND col.column_name = 'teacher_id'
    WHERE c.relkind = 'r'
      AND (NOT c.relrowsecurity
           OR NOT c.relforcerowsecurity
           OR NOT EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid = c.oid
                          AND p.polname = 'fairteam_tenant_isolation'));
    IF missing IS NOT NULL THEN
        RAISE EXCEPTION 'Tablas sin aislamiento por docente: %', missing;
    END IF;
    RAISE NOTICE 'Todas las tablas con teacher_id están aisladas por docente.';
END $$;
