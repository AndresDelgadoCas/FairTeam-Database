# FairTeam Database

Base de datos del proyecto **FairTeam**, una plataforma orientada a la formación de equipos académicos equilibrados mediante información de estudiantes, calificaciones, habilidades, disponibilidad y preferencias. 

## Descripción del proyecto

FairTeam busca facilitar la organización de equipos de trabajo académicos, considerando el rendimiento y las habilidades de los estudiantes para apoyar la formación de grupos equilibrados y la identificación de necesidades de refuerzo académico.

Este repositorio contiene el esquema SQL de la base de datos utilizada por el backend de FairTeam.

## Tecnologías utilizadas

- **Motor de base de datos:** PostgreSQL.
- **Lenguaje:** SQL.
- **Backend:** Java con Spring Boot.
- **Persistencia:** Spring Data JPA / Hibernate.
- **Despliegue:** PostgreSQL alojado en Render.

## Estructura de la base de datos

El modelo reúne las tablas académicas base y las que agregó Flyway (`courses`, `course_materials`, `course_grading_schemes`). El detalle de cada columna está en el [diccionario de datos](docs/data-dictionary.md) y las relaciones en el [diagrama entidad-relación](docs/er-diagram.md).

| Tabla | Descripción |
|---|---|
| `courses` | Cursos o grupos docentes, aislados por cuenta. |
| `students` | Información de los estudiantes, asociada a un curso. |
| `subjects` | Asignaturas académicas. |
| `grades` | Calificaciones de los estudiantes, asociadas a su curso. |
| `skills` | Catálogo de habilidades. |
| `student_skills` | Habilidades asociadas a cada estudiante. |
| `student_availability` | Disponibilidad de los estudiantes. |
| `projects` | Proyectos académicos para formar equipos. |
| `project_skill_requirements` | Habilidades requeridas por los proyectos. |
| `student_project_preferences` | Preferencias de los estudiantes respecto a proyectos. |
| `teams` | Equipos de trabajo creados. |
| `team_students` | Relación entre equipos y estudiantes. |
| `workshops` | Talleres de refuerzo académico. |
| `workshop_recommendations` | Recomendaciones de talleres. |
| `course_materials` | Material de clase subido para generar talleres con IA (migración V6). |
| `attendance_records` | Asistencia por clase: presente, falta, tarde o excusa (migración V8). |
| `student_interventions` | Apoyos registrados por el docente para cada estudiante (migración V8). |
| `course_grading_schemes` | Cortes y pesos de cada curso (ej. 30/30/40) para el simulador de notas; aislada por docente (migración V7). |
| `grade_item_weights` | Columnas de cada corte con su orden y porcentaje; `courses.max_grade` guarda la escala del curso (migración V9). |
| `course_rubrics`, `course_rubric_criteria`, `course_rubric_scores`, `course_rubric_comments` | Rúbricas analíticas, niveles por estudiante y comentarios (migración V10). |
| `course_activities` | Talleres, quizzes y actividades a la medida guardados en el servidor; las rúbricas se enlazan con `activity_id` (migración V11). |
| `teacher_guide_progress` | Avance de cada docente en la guía "Primeros pasos", para que siga a la cuenta en cualquier equipo (migración V12). |

## Archivo principal

El archivo `schema.sql` contiene las instrucciones SQL para crear la estructura de la base de datos, incluyendo tablas, relaciones, restricciones e índices definidos en el esquema.

El backend completa este esquema al arrancar mediante Flyway: crea las tablas de autenticación y evaluación, agrega el aislamiento por docente y repara de forma idempotente el esquema de bases existentes. `migrations/` es una copia documental; `src/main/resources/db/migration/` dentro del repositorio del backend es la fuente que ejecuta Flyway.

## Instalación y configuración

### Requisitos previos

- PostgreSQL instalado.
- Una base de datos creada para el proyecto.
- Una herramienta de administración como pgAdmin o `psql`.

### Pasos

1. Clonar este repositorio:

   ```bash
   git clone https://github.com/AndresDelgadoCas/FairTeam-Database.git
   ```

2. Crear una base de datos vacía en PostgreSQL, por ejemplo, `fairteam_db`.

3. Abrir el archivo `schema.sql` desde pgAdmin o ejecutarlo con `psql`.

4. Ejecutar el script solo para preparar el esquema académico inicial de una base nueva. Después, configura el backend para conectarse; Flyway aplicará las migraciones restantes al iniciar.

Para desarrollo local también puedes construir todo de una vez (esquema y migraciones en orden):

```bash
scripts/setup_local.sh fairteam_db
```

**Importante:** no ejecutes `schema.sql` ni los archivos de migración manualmente sobre producción. En una base existente, deja que el backend ejecute Flyway; `schema.sql` solo prepara una base nueva.

## Datos de demostración y consultas

- `seeds/demo_course.sql`: crea un curso ficticio con 8 estudiantes, 3 asignaturas y 3 cortes para un docente ya registrado. Se puede ejecutar varias veces sin duplicar datos.
- `queries/`: resumen por curso, estudiantes que necesitan apoyo, distribución de notas, asignaturas más difíciles, tendencia por corte y notas faltantes. Ver [queries/README.md](queries/README.md).

```bash
psql -v teacher_email="'docente@ejemplo.edu'" -d fairteam_db -f seeds/demo_course.sql
```

## Integración con el backend

La base de datos se conecta al backend de FairTeam desarrollado con Spring Boot. El backend utiliza Spring Data JPA e Hibernate para acceder a la información.

El backend desplegado está disponible en:

https://backend-proyect-junz.onrender.com

La aplicación backend es la encargada de gestionar las operaciones sobre la base de datos. El frontend debe consumir la API del backend y no conectarse directamente a PostgreSQL.

## Despliegue

La base de datos de FairTeam está desplegada en Render mediante un servicio PostgreSQL.

Las credenciales y los datos privados de conexión se administran mediante variables de entorno. No deben publicarse en este repositorio.

## Seguridad y pruebas

El aislamiento por docente se explica en [docs/row-level-security.md](docs/row-level-security.md). Dos scripts lo comprueban y GitHub Actions los ejecuta en PostgreSQL 16 y 17:

```bash
psql -v ON_ERROR_STOP=1 -d fairteam_db -f scripts/verify_rls.sql
psql -v ON_ERROR_STOP=1 -d fairteam_db -f tests/isolation_test.sql
```

## Cambiar de base de datos

Para pasar a otra base en Render (copiar datos y configurar el backend) sigue [docs/migrating-database.md](docs/migrating-database.md). Un `pg_dump` directo falla por `FORCE ROW LEVEL SECURITY`; `scripts/copy_database.sh` lo resuelve.

## Decisiones de arquitectura

La base de datos no implementa patrones OO como Factory o Decorator. Su responsabilidad es persistencia relacional: claves foráneas, restricciones, índices, migraciones versionadas e idempotentes y Row Level Security para aislar los datos por docente. La aplicación sigue el límite `Frontend → API backend → PostgreSQL`; el navegador nunca se conecta directamente a la base. Flyway, desde el backend, es el mecanismo que aplica los cambios de esquema.

## Autoría

**Proyecto:** FairTeam  
**Repositorio de base de datos:** [FairTeam-Database](https://github.com/AndresDelgadoCas/FairTeam-Database)  
**Repositorio del backend:** [Backend-proyect](https://github.com/AndresDelgadoCas/Backend-proyect)
