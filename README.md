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

El modelo actual reúne 13 tablas académicas base y la tabla `courses`, incorporada por Flyway para organizar los grupos docentes:

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

**Importante:** no ejecutes `schema.sql` ni los archivos de migración manualmente sobre producción. En una base existente, deja que el backend ejecute Flyway; `schema.sql` solo prepara una base nueva.

## Integración con el backend

La base de datos se conecta al backend de FairTeam desarrollado con Spring Boot. El backend utiliza Spring Data JPA e Hibernate para acceder a la información.

El backend desplegado está disponible en:

https://backend-proyect-junz.onrender.com

La aplicación backend es la encargada de gestionar las operaciones sobre la base de datos. El frontend debe consumir la API del backend y no conectarse directamente a PostgreSQL.

## Despliegue

La base de datos de FairTeam está desplegada en Render mediante un servicio PostgreSQL.

Las credenciales y los datos privados de conexión se administran mediante variables de entorno. No deben publicarse en este repositorio.

## Decisiones de arquitectura

La base de datos no implementa patrones OO como Factory o Decorator. Su responsabilidad es persistencia relacional: claves foráneas, restricciones, índices, migraciones versionadas e idempotentes y Row Level Security para aislar los datos por docente. La aplicación sigue el límite `Frontend → API backend → PostgreSQL`; el navegador nunca se conecta directamente a la base. Flyway, desde el backend, es el mecanismo que aplica los cambios de esquema.

## Autoría

**Proyecto:** FairTeam  
**Repositorio de base de datos:** [FairTeam-Database](https://github.com/AndresDelgadoCas/FairTeam-Database)  
**Repositorio del backend:** [Backend-proyect](https://github.com/AndresDelgadoCas/Backend-proyect)
