# Diagrama entidad-relación

Relaciones principales. Todas las tablas académicas tienen además `teacher_id → teacher_users.id`,
que se omite en el diagrama para que sea legible (ver [aislamiento](row-level-security.md)).

```mermaid
erDiagram
    teacher_users ||--o{ courses : "dicta"
    courses ||--o{ students : "agrupa"
    courses ||--o{ course_materials : "guarda"
    courses ||--o| course_grading_schemes : "pondera"
    students ||--o{ grades : "recibe"
    subjects ||--o{ grades : "califica"
    courses ||--o{ grades : "contiene"
    students ||--o{ student_skills : "tiene"
    skills ||--o{ student_skills : "describe"
    students ||--o{ student_availability : "indica"
    projects ||--o{ project_skill_requirements : "requiere"
    skills ||--o{ project_skill_requirements : "se pide en"
    projects ||--o{ teams : "forma"
    teams ||--o{ team_students : "integra"
    students ||--o{ team_students : "pertenece"
    students ||--o{ student_project_preferences : "prefiere"
    workshops ||--o{ workshop_recommendations : "se recomienda"
    students ||--o{ workshop_recommendations : "recibe"
    assignments ||--o{ assignment_submissions : "recibe"
    students ||--o{ assignment_submissions : "entrega"
    assignment_submissions ||--o| ai_evaluations : "evalúa"
    grading_rubrics ||--o{ rubric_criteria : "define"
    assignments ||--o{ grading_rubrics : "se evalúa con"
    subjects ||--o{ assignments : "agrupa"
    projects ||--o{ student_project_preferences : "recibe"

    teacher_users {
        bigint id PK
        varchar email UK
        varchar password_hash
    }
    courses {
        bigint id PK
        bigint teacher_id FK
        varchar name
        varchar period
    }
    students {
        bigint id PK
        bigint course_id FK
        varchar name
        varchar academic_level
    }
    grades {
        bigint id PK
        bigint student_id FK
        bigint subject_id FK
        numeric grade
        varchar period
    }
    subjects {
        bigint id PK
        varchar name
    }
```

El detalle de cada columna está en el [diccionario de datos](data-dictionary.md).
