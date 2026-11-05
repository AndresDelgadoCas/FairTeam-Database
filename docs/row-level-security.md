# Aislamiento por docente (Row Level Security)

Cada docente solo ve y modifica sus propios datos, aunque todos compartan la misma base.

## Cómo funciona

1. Las tablas académicas tienen la columna `teacher_id`.
2. En cada petición, el backend ejecuta `set_config('app.teacher_id', <id del token>, true)` dentro de la transacción (`TenantIsolationFilter`).
3. La política `fairteam_tenant_isolation` filtra las filas: solo pasan las que tienen ese `teacher_id`.
   La cláusula `WITH CHECK` impide insertar o mover filas a otro docente.
4. El trigger `fairteam_assign_tenant` completa `teacher_id` en los `INSERT` que no lo indican.
5. `FORCE ROW LEVEL SECURITY` aplica la política también al dueño de las tablas, que es el usuario con el que se conecta Render.

Sin `app.teacher_id` en la sesión no se ve ninguna fila. Un superusuario de PostgreSQL ignora estas políticas,
por eso la aplicación nunca debe conectarse como superusuario.

## Comprobarlo

```bash
psql -v ON_ERROR_STOP=1 -d fairteam_db -f scripts/verify_rls.sql     # todas las tablas tienen RLS, forzado y política
psql -v ON_ERROR_STOP=1 -d fairteam_db -f tests/isolation_test.sql   # dos docentes de prueba no se ven entre sí
```

La prueba de aislamiento crea un rol sin privilegios y dos docentes dentro de una transacción que se revierte,
así que no deja datos.

## Al agregar una tabla nueva

Agrega su nombre a la lista de `R__ensure_teacher_data_isolation.sql` en el backend (y a la copia de este
repositorio). Si se olvida, `verify_rls.sql` falla y lo indica.
