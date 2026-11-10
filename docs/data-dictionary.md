# Diccionario de datos

Generado con `scripts/data_dictionary.sql` a partir del esquema real.


## ai_evaluations

Evaluaciones sugeridas por IA que el docente revisa.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('ai_evaluations_id_seq') |  |
| submission_id | bigint | no |  | assignment_submissions.id |
| status | character varying(255) | no | 'PENDING' |  |
| suggested_grade | numeric(5,2) | sí |  |  |
| feedback | text | sí |  |  |
| criteria_results | jsonb | no | '{}' |  |
| reviewed_by | bigint | sí |  |  |
| reviewed_at | timestamp without time zone | sí |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## assignment_submissions

Entregas de los estudiantes.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('assignment_submissions_id_seq') |  |
| assignment_id | bigint | no |  | assignments.id |
| student_id | bigint | no |  | students.id |
| submission_text | text | sí |  |  |
| file_url | text | sí |  |  |
| submitted_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| status | character varying(255) | no | 'SUBMITTED' |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## assignments

Trabajos asignados por el docente.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('assignments_id_seq') |  |
| subject_id | bigint | no |  | subjects.id |
| teacher_id | bigint | no |  | teacher_users.id |
| title | character varying(150) | no |  |  |
| description | text | sí |  |  |
| instructions | text | sí |  |  |
| due_date | timestamp without time zone | sí |  |  |
| max_score | numeric(10,2) | no | 5.00 |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |

## attendance_records

Asistencia por clase: presente, falta, tarde o excusa.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('attendance_records_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| student_id | bigint | no |  | students.id |
| session_date | date | no |  |  |
| status | character varying(10) | no |  |  |
| updated_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |

## course_activities

Talleres, quizzes y actividades a la medida guardados por curso, con su tema y contenido.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_activities_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| kind | character varying(20) | no |  |  |
| title | character varying(200) | no |  |  |
| topic | character varying(150) | sí |  |  |
| subject_id | bigint | sí |  | subjects.id |
| target_level | character varying(10) | sí |  |  |
| content | jsonb | no |  |  |
| created_at | timestamp without time zone | no | now() |  |
| updated_at | timestamp without time zone | no | now() |  |

## course_grading_schemes

Pesos de los cortes de un curso (ej. 30/30/40) para el simulador.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_grading_schemes_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| weights | character varying(60) | no |  |  |
| passing_grade | numeric(3,1) | no | 3.0 |  |
| updated_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |

## course_materials

Material de clase subido por el docente para generar talleres.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_materials_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| file_name | character varying(255) | no |  |  |
| content_type | character varying(150) | no |  |  |
| file_size | bigint | no |  |  |
| content | bytea | no |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |

## course_rubric_comments

Comentario del docente a un estudiante sobre una rúbrica.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_rubric_comments_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| rubric_id | bigint | no |  | course_rubrics.id |
| student_id | bigint | no |  | students.id |
| comment | character varying(1000) | no |  |  |

## course_rubric_criteria

Criterios de una rúbrica con su peso y la descripción de los cuatro niveles.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_rubric_criteria_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| rubric_id | bigint | no |  | course_rubrics.id |
| position | integer | no | 0 |  |
| name | character varying(150) | no |  |  |
| description | text | sí |  |  |
| weight | numeric(5,2) | no |  |  |
| level_excellent | text | no |  |  |
| level_good | text | no |  |  |
| level_basic | text | no |  |  |
| level_insufficient | text | no |  |  |

## course_rubric_scores

Nivel alcanzado por cada estudiante en cada criterio (0 Excelente a 3 Insuficiente).

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_rubric_scores_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| rubric_id | bigint | no |  | course_rubrics.id |
| criterion_id | bigint | no |  | course_rubric_criteria.id |
| student_id | bigint | no |  | students.id |
| level | smallint | no |  |  |

## course_rubrics

Rúbricas analíticas de un curso y la columna del libro de notas donde se publicaron.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('course_rubrics_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| title | character varying(150) | no |  |  |
| description | text | sí |  |  |
| period | character varying(20) | sí |  |  |
| subject_id | bigint | sí |  | subjects.id |
| created_at | timestamp without time zone | no | now() |  |
| updated_at | timestamp without time zone | no | now() |  |
| activity_id | bigint | sí |  | course_activities.id |

## courses

Cursos o grupos de cada docente.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('courses_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| name | character varying(120) | no |  |  |
| period | character varying(40) | sí |  |  |
| description | character varying(500) | sí |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| max_grade | numeric(7,2) | no | 5 |  |

## grade_item_weights

Columnas de cada corte con su orden y porcentaje dentro del corte.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('grade_item_weights_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| period | character varying(20) | no |  |  |
| subject_id | bigint | no |  | subjects.id |
| weight | numeric(5,2) | sí |  |  |
| position | integer | no | 0 |  |

## grades

Notas de 0,0 a 5,0 por estudiante, asignatura y corte.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('grades_id_seq') |  |
| student_id | bigint | no |  | students.id |
| subject_id | bigint | no |  | subjects.id |
| grade | numeric(6,4) | no |  |  |
| period | character varying(20) | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |
| course_id | bigint | sí |  | courses.id |

## grading_rubrics

Rúbricas de evaluación.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('grading_rubrics_id_seq') |  |
| assignment_id | bigint | no |  | assignments.id |
| name | character varying(150) | no |  |  |
| description | text | sí |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## project_skill_requirements

Habilidades que necesita cada proyecto.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| project_id | bigint | no |  | projects.id |
| skill_id | bigint | no |  | skills.id |
| min_level | integer | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## projects

Proyectos para los que se forman equipos.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('projects_id_seq') |  |
| name | character varying(150) | no |  |  |
| description | text | sí |  |  |
| team_size | integer | no |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## rubric_criteria

Criterios y pesos de cada rúbrica.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('rubric_criteria_id_seq') |  |
| rubric_id | bigint | no |  | grading_rubrics.id |
| name | character varying(150) | no |  |  |
| description | text | sí |  |  |
| max_score | numeric(10,2) | no |  |  |
| weight | numeric(5,2) | no | 1.00 |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## skills

Catálogo de habilidades para formar equipos.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('skills_id_seq') |  |
| name | character varying(100) | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## student_availability

Franjas en que el estudiante puede trabajar en equipo.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('student_availability_id_seq') |  |
| student_id | bigint | no |  | students.id |
| day_of_week | integer | no |  |  |
| start_time | time without time zone | no |  |  |
| end_time | time without time zone | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## student_interventions

Apoyos que el docente registró para cada estudiante.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('student_interventions_id_seq') |  |
| teacher_id | bigint | no |  | teacher_users.id |
| course_id | bigint | no |  | courses.id |
| student_id | bigint | no |  | students.id |
| kind | character varying(20) | no |  |  |
| note | character varying(500) | no | '' |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |

## student_project_preferences

Con quién prefiere trabajar cada estudiante.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('student_project_preferences_id_seq') |  |
| project_id | bigint | no |  | projects.id |
| student_id | bigint | no |  | students.id |
| preferred_student_id | bigint | no |  | students.id |
| preference_type | character varying(10) | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## student_skills

Nivel de cada estudiante en una habilidad.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| student_id | bigint | no |  | students.id |
| skill_id | bigint | no |  | skills.id |
| level | integer | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## students

Estudiantes de un curso; academic_level se recalcula con el promedio.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('students_id_seq') |  |
| name | character varying(120) | no |  |  |
| email | character varying(180) | sí |  |  |
| academic_level | character varying(10) | no | 'MEDIUM' |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| teacher_id | bigint | sí |  | teacher_users.id |
| course_id | bigint | sí |  | courses.id |

## subjects

Asignaturas que califica el docente.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('subjects_id_seq') |  |
| name | character varying(120) | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## teacher_guide_progress

Avance de cada docente en la guía "Primeros pasos" (pasos hechos y saltados, si está abierta o minimizada).

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| teacher_id | bigint | no |  | teacher_users.id |
| state | jsonb | no |  |  |
| updated_at | timestamp without time zone | no | now() |  |

## teacher_users

Cuentas de docentes. La contraseña se guarda como hash BCrypt.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('teacher_users_id_seq') |  |
| full_name | character varying(255) | no |  |  |
| email | character varying(255) | no |  |  |
| password_hash | character varying(255) | no |  |  |
| role | character varying(255) | no | 'TEACHER' |  |
| active | boolean | no | true |  |
| created_at | timestamp without time zone | sí |  |  |

## team_students

Integrantes de cada equipo.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| team_id | bigint | no |  | teams.id |
| student_id | bigint | no |  | students.id |
| teacher_id | bigint | sí |  | teacher_users.id |

## teams

Equipos generados para un proyecto.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('teams_id_seq') |  |
| project_id | bigint | no |  | projects.id |
| name | character varying(100) | no |  |  |
| formation_strategy | character varying(100) | sí |  |  |
| score | numeric(5,2) | sí |  |  |
| explanation | text | sí |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## tenant_bootstrap_lock

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | integer | no |  |  |

## workshop_recommendations

Talleres sugeridos a estudiantes concretos.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('workshop_recommendations_id_seq') |  |
| student_id | bigint | no |  | students.id |
| workshop_id | bigint | no |  | workshops.id |
| reason | text | no |  |  |
| recommendation_score | numeric(5,2) | sí |  |  |
| created_at | timestamp without time zone | no | CURRENT_TIMESTAMP |  |
| teacher_id | bigint | sí |  | teacher_users.id |

## workshops

Talleres y quizzes de refuerzo generados con IA.

| Columna | Tipo | Nulo | Por defecto | Referencia |
| --- | --- | --- | --- | --- |
| id | bigint | no | nextval('workshops_id_seq') |  |
| name | character varying(150) | no |  |  |
| description | text | sí |  |  |
| topic | character varying(120) | no |  |  |
| teacher_id | bigint | sí |  | teacher_users.id |
