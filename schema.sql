--
-- PostgreSQL database dump
--

\restrict NaLnz3X5qf8UnNGoJusYzpjCEgwtdkcE7pCKClv6ceU1aDsjq83uamiYmtDgzXV

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-05 16:57:44

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 16452)
-- Name: grades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grades (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    grade numeric(3,2) NOT NULL,
    period character varying(20) NOT NULL,
    CONSTRAINT chk_grade_value CHECK (((grade >= (0)::numeric) AND (grade <= (5)::numeric)))
);


--
-- TOC entry 223 (class 1259 OID 16451)
-- Name: grades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 223
-- Name: grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grades_id_seq OWNED BY public.grades.id;


--
-- TOC entry 232 (class 1259 OID 16540)
-- Name: project_skill_requirements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_skill_requirements (
    project_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    min_level integer NOT NULL,
    CONSTRAINT chk_required_skill_level CHECK (((min_level >= 1) AND (min_level <= 5)))
);


--
-- TOC entry 231 (class 1259 OID 16526)
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    team_size integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_team_size CHECK ((team_size > 0))
);


--
-- TOC entry 230 (class 1259 OID 16525)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 230
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 226 (class 1259 OID 16477)
-- Name: skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills (
    id bigint NOT NULL,
    name character varying(100) NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16476)
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 225
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- TOC entry 229 (class 1259 OID 16507)
-- Name: student_availability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_availability (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    day_of_week integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    CONSTRAINT chk_availability_time CHECK ((start_time < end_time)),
    CONSTRAINT chk_day_of_week CHECK (((day_of_week >= 1) AND (day_of_week <= 7)))
);


--
-- TOC entry 228 (class 1259 OID 16506)
-- Name: student_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 228
-- Name: student_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_availability_id_seq OWNED BY public.student_availability.id;


--
-- TOC entry 234 (class 1259 OID 16560)
-- Name: student_project_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_project_preferences (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    student_id bigint NOT NULL,
    preferred_student_id bigint NOT NULL,
    preference_type character varying(10) NOT NULL,
    CONSTRAINT chk_different_students CHECK ((student_id <> preferred_student_id)),
    CONSTRAINT chk_preference_type CHECK (((preference_type)::text = ANY ((ARRAY['PREFER'::character varying, 'AVOID'::character varying])::text[])))
);


--
-- TOC entry 233 (class 1259 OID 16559)
-- Name: student_project_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_project_preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 233
-- Name: student_project_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_project_preferences_id_seq OWNED BY public.student_project_preferences.id;


--
-- TOC entry 227 (class 1259 OID 16487)
-- Name: student_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_skills (
    student_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    level integer NOT NULL,
    CONSTRAINT chk_skill_level CHECK (((level >= 1) AND (level <= 5)))
);


--
-- TOC entry 220 (class 1259 OID 16425)
-- Name: students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.students (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    email character varying(180),
    academic_level character varying(10) DEFAULT 'MEDIUM'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_student_academic_level CHECK (((academic_level)::text = ANY ((ARRAY['HIGH'::character varying, 'MEDIUM'::character varying, 'LOW'::character varying])::text[])))
);


--
-- TOC entry 219 (class 1259 OID 16424)
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 219
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- TOC entry 222 (class 1259 OID 16441)
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjects (
    id bigint NOT NULL,
    name character varying(120) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16440)
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 221
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;


--
-- TOC entry 237 (class 1259 OID 16608)
-- Name: team_students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_students (
    team_id bigint NOT NULL,
    student_id bigint NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 16589)
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    formation_strategy character varying(100),
    score numeric(5,2),
    explanation text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_team_score CHECK (((score IS NULL) OR ((score >= (0)::numeric) AND (score <= (100)::numeric))))
);


--
-- TOC entry 235 (class 1259 OID 16588)
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 235
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- TOC entry 241 (class 1259 OID 16638)
-- Name: workshop_recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_recommendations (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    workshop_id bigint NOT NULL,
    reason text NOT NULL,
    recommendation_score numeric(5,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_recommendation_score CHECK (((recommendation_score IS NULL) OR ((recommendation_score >= (0)::numeric) AND (recommendation_score <= (100)::numeric))))
);


--
-- TOC entry 240 (class 1259 OID 16637)
-- Name: workshop_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workshop_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 240
-- Name: workshop_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workshop_recommendations_id_seq OWNED BY public.workshop_recommendations.id;


--
-- TOC entry 239 (class 1259 OID 16626)
-- Name: workshops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshops (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    topic character varying(120) NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 16625)
-- Name: workshops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workshops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 238
-- Name: workshops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workshops_id_seq OWNED BY public.workshops.id;


--
-- TOC entry 4917 (class 2604 OID 16455)
-- Name: grades id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades ALTER COLUMN id SET DEFAULT nextval('public.grades_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16529)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 16480)
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16510)
-- Name: student_availability id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_availability ALTER COLUMN id SET DEFAULT nextval('public.student_availability_id_seq'::regclass);


--
-- TOC entry 4922 (class 2604 OID 16563)
-- Name: student_project_preferences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_project_preferences ALTER COLUMN id SET DEFAULT nextval('public.student_project_preferences_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 16428)
-- Name: students id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- TOC entry 4916 (class 2604 OID 16444)
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 16592)
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 16641)
-- Name: workshop_recommendations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_recommendations ALTER COLUMN id SET DEFAULT nextval('public.workshop_recommendations_id_seq'::regclass);


--
-- TOC entry 4925 (class 2604 OID 16629)
-- Name: workshops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops ALTER COLUMN id SET DEFAULT nextval('public.workshops_id_seq'::regclass);


--
-- TOC entry 4948 (class 2606 OID 16463)
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (id);


--
-- TOC entry 4967 (class 2606 OID 16548)
-- Name: project_skill_requirements project_skill_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_skill_requirements
    ADD CONSTRAINT project_skill_requirements_pkey PRIMARY KEY (project_id, skill_id);


--
-- TOC entry 4964 (class 2606 OID 16539)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 16486)
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- TOC entry 4956 (class 2606 OID 16484)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- TOC entry 4962 (class 2606 OID 16519)
-- Name: student_availability student_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_availability
    ADD CONSTRAINT student_availability_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 16572)
-- Name: student_project_preferences student_project_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_project_preferences
    ADD CONSTRAINT student_project_preferences_pkey PRIMARY KEY (id);


--
-- TOC entry 4959 (class 2606 OID 16495)
-- Name: student_skills student_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_skills
    ADD CONSTRAINT student_skills_pkey PRIMARY KEY (student_id, skill_id);


--
-- TOC entry 4940 (class 2606 OID 16439)
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- TOC entry 4942 (class 2606 OID 16437)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- TOC entry 4944 (class 2606 OID 16450)
-- Name: subjects subjects_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_name_key UNIQUE (name);


--
-- TOC entry 4946 (class 2606 OID 16448)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 4975 (class 2606 OID 16614)
-- Name: team_students team_students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_students
    ADD CONSTRAINT team_students_pkey PRIMARY KEY (team_id, student_id);


--
-- TOC entry 4972 (class 2606 OID 16602)
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 16465)
-- Name: grades uq_student_subject_period; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT uq_student_subject_period UNIQUE (student_id, subject_id, period);


--
-- TOC entry 4980 (class 2606 OID 16652)
-- Name: workshop_recommendations workshop_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_recommendations
    ADD CONSTRAINT workshop_recommendations_pkey PRIMARY KEY (id);


--
-- TOC entry 4977 (class 2606 OID 16636)
-- Name: workshops workshops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops
    ADD CONSTRAINT workshops_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 1259 OID 16666)
-- Name: idx_availability_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_availability_student ON public.student_availability USING btree (student_id);


--
-- TOC entry 4949 (class 1259 OID 16663)
-- Name: idx_grades_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_grades_student ON public.grades USING btree (student_id);


--
-- TOC entry 4950 (class 1259 OID 16664)
-- Name: idx_grades_subject; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_grades_subject ON public.grades USING btree (subject_id);


--
-- TOC entry 4965 (class 1259 OID 16667)
-- Name: idx_project_requirements_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_project_requirements_skill ON public.project_skill_requirements USING btree (skill_id);


--
-- TOC entry 4957 (class 1259 OID 16665)
-- Name: idx_student_skills_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_student_skills_skill ON public.student_skills USING btree (skill_id);


--
-- TOC entry 4973 (class 1259 OID 16669)
-- Name: idx_team_students_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_team_students_student ON public.team_students USING btree (student_id);


--
-- TOC entry 4970 (class 1259 OID 16668)
-- Name: idx_teams_project; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_teams_project ON public.teams USING btree (project_id);


--
-- TOC entry 4978 (class 1259 OID 16670)
-- Name: idx_workshop_recommendations_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_workshop_recommendations_student ON public.workshop_recommendations USING btree (student_id);


--
-- TOC entry 4985 (class 2606 OID 16520)
-- Name: student_availability fk_availability_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_availability
    ADD CONSTRAINT fk_availability_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4981 (class 2606 OID 16466)
-- Name: grades fk_grade_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4982 (class 2606 OID 16471)
-- Name: grades fk_grade_subject; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT fk_grade_subject FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE RESTRICT;


--
-- TOC entry 4988 (class 2606 OID 16583)
-- Name: student_project_preferences fk_preference_preferred_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_project_preferences
    ADD CONSTRAINT fk_preference_preferred_student FOREIGN KEY (preferred_student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4989 (class 2606 OID 16573)
-- Name: student_project_preferences fk_preference_project; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_project_preferences
    ADD CONSTRAINT fk_preference_project FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 4990 (class 2606 OID 16578)
-- Name: student_project_preferences fk_preference_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_project_preferences
    ADD CONSTRAINT fk_preference_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4986 (class 2606 OID 16549)
-- Name: project_skill_requirements fk_project_requirement_project; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_skill_requirements
    ADD CONSTRAINT fk_project_requirement_project FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 4987 (class 2606 OID 16554)
-- Name: project_skill_requirements fk_project_requirement_skill; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_skill_requirements
    ADD CONSTRAINT fk_project_requirement_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- TOC entry 4994 (class 2606 OID 16653)
-- Name: workshop_recommendations fk_recommendation_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_recommendations
    ADD CONSTRAINT fk_recommendation_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4995 (class 2606 OID 16658)
-- Name: workshop_recommendations fk_recommendation_workshop; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_recommendations
    ADD CONSTRAINT fk_recommendation_workshop FOREIGN KEY (workshop_id) REFERENCES public.workshops(id) ON DELETE CASCADE;


--
-- TOC entry 4983 (class 2606 OID 16501)
-- Name: student_skills fk_student_skill_skill; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_skills
    ADD CONSTRAINT fk_student_skill_skill FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- TOC entry 4984 (class 2606 OID 16496)
-- Name: student_skills fk_student_skill_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_skills
    ADD CONSTRAINT fk_student_skill_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4991 (class 2606 OID 16603)
-- Name: teams fk_team_project; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_team_project FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 4992 (class 2606 OID 16620)
-- Name: team_students fk_team_student_student; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_students
    ADD CONSTRAINT fk_team_student_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- TOC entry 4993 (class 2606 OID 16615)
-- Name: team_students fk_team_student_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_students
    ADD CONSTRAINT fk_team_student_team FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


-- Completed on 2026-10-05 16:57:44

--
-- PostgreSQL database dump complete
--

\unrestrict NaLnz3X5qf8UnNGoJusYzpjCEgwtdkcE7pCKClv6ceU1aDsjq83uamiYmtDgzXV

