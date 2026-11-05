-- Prints the data dictionary as Markdown, straight from the catalog, so docs never drift.
-- Usage: psql -qAt -d fairteam_db -f scripts/data_dictionary.sql > docs/data-dictionary.md

SELECT '# Diccionario de datos' || E'\n\n' ||
       'Generado con `scripts/data_dictionary.sql` a partir del esquema real.' || E'\n';

SELECT E'\n## ' || t.table_name || E'\n\n' ||
       coalesce(obj_description(format('public.%I', t.table_name)::regclass) || E'\n\n', '') ||
       E'| Columna | Tipo | Nulo | Por defecto | Referencia |\n| --- | --- | --- | --- | --- |\n' ||
       string_agg(
           format('| %s | %s | %s | %s | %s |',
                  c.column_name,
                  CASE WHEN c.character_maximum_length IS NOT NULL
                       THEN c.data_type || '(' || c.character_maximum_length || ')'
                       WHEN c.data_type = 'numeric' AND c.numeric_precision IS NOT NULL
                       THEN 'numeric(' || c.numeric_precision || ',' || c.numeric_scale || ')'
                       ELSE c.data_type END,
                  CASE WHEN c.is_nullable = 'YES' THEN 'sí' ELSE 'no' END,
                  coalesce(replace(regexp_replace(c.column_default, '::[a-z ]+', '', 'g'), '|', '\|'), ''),
                  coalesce((
                      SELECT string_agg(ccu.table_name || '.' || ccu.column_name, ', ')
                      FROM information_schema.key_column_usage kcu
                      JOIN information_schema.table_constraints tc
                        ON tc.constraint_name = kcu.constraint_name AND tc.constraint_type = 'FOREIGN KEY'
                       AND tc.table_schema = 'public'
                      JOIN information_schema.constraint_column_usage ccu
                        ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = 'public'
                      WHERE kcu.table_schema = 'public' AND kcu.table_name = t.table_name
                        AND kcu.column_name = c.column_name), '')),
           E'\n' ORDER BY c.ordinal_position)
FROM information_schema.tables t
JOIN information_schema.columns c ON c.table_schema = t.table_schema AND c.table_name = t.table_name
WHERE t.table_schema = 'public' AND t.table_type = 'BASE TABLE' AND t.table_name <> 'flyway_schema_history'
GROUP BY t.table_name
ORDER BY t.table_name;
