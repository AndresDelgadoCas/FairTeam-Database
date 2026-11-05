# Consultas útiles

Consultas de solo lectura para revisar los datos de un docente desde `psql` o pgAdmin.
Las tablas tienen aislamiento por docente, así que primero indica de quién son los datos:

```sql
SELECT set_config('app.teacher_id', id::text, false) FROM teacher_users WHERE email = 'docente@ejemplo.edu';
```

Los niveles usan los mismos cortes que la aplicación: menos de 3,0 refuerzo; de 3,0 a menos de 4,0 seguimiento; 4,0 o más buen progreso, sobre el promedio redondeado a un decimal.

Desde la terminal también puedes fijar el docente al conectarte:

```bash
PGOPTIONS="-c app.teacher_id=12" psql -d fairteam_db -f queries/course_summary.sql
```

Si te conectas como superusuario, PostgreSQL ignora el aislamiento y verás los datos de todos los docentes.
