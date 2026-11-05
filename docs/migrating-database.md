# Cambiar a una base de datos nueva en Render

Solo el **backend** se conecta a PostgreSQL. El frontend y el servicio de IA no necesitan cambios.

## 1. Datos de conexión

En la página de la base nueva en Render copia la *External Database URL* (para copiar datos desde tu
equipo) y la *Internal Database URL* (para el backend, si está en la misma región y cuenta).

## 2. Copiar los datos (opcional)

Si quieres conservar cursos, estudiantes y notas, hazlo **antes** de arrancar el backend contra la base
nueva, porque Flyway crearía tablas vacías y la copia se detendría:

```bash
scripts/copy_database.sh "<External URL de la base vieja>" "<External URL de la base nueva>"
```

El script copia esquema, datos e historial de Flyway, restablece `FORCE ROW LEVEL SECURITY` en ambas
bases y verifica el aislamiento. Necesita `psql`, `pg_dump` y `pg_restore` de una versión igual o mayor
que la del servidor.

Si no copias datos, el backend crea el esquema completo al arrancar (migraciones V1 en adelante).

## 3. Variables del backend

Spring no acepta la URL `postgresql://usuario:clave@host/base` tal cual. Sepárala así:

| Variable | Valor |
| --- | --- |
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://<host>/<base>` (sin usuario ni clave) |
| `SPRING_DATASOURCE_USERNAME` | `<usuario>` |
| `SPRING_DATASOURCE_PASSWORD` | `<clave>` |

Con la URL externa agrega `?sslmode=require` al final de `SPRING_DATASOURCE_URL`.

## 4. Comprobar

1. Revisa en los logs del backend que Flyway termine sin errores.
2. Inicia sesión en la aplicación y abre un curso.
3. Opcional: `psql "<URL nueva>" -f scripts/verify_rls.sql`.

Nunca subas las URLs con contraseña al repositorio. Si una contraseña se compartió por chat o correo,
rótala en Render (*Rotate password*) y actualiza solo `SPRING_DATASOURCE_PASSWORD`.
