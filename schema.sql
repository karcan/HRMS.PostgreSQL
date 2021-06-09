/*
 *   DROP SCHEMA FOR ALL TABLES.
*/
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

/*
 *   FUNCTIONS
*/
CREATE OR REPLACE FUNCTION validation_employers(_user_id INTEGER, _website VARCHAR(255)) 
RETURNS BOOLEAN 
AS $$
DECLARE
	_email VARCHAR(320);
    result BOOLEAN;
BEGIN

    -- Validation Begin : check email and website is the same domain name.
	SELECT email INTO _email FROM users where user_id = _user_id;
    SELECT _website like '%' || SUBSTRING(_email,POSITION('@' in _email) + 1) INTO result;

	IF result = false THEN
		raise '[email] and [website] must have the same domain name.';
	END IF;
    -- Validation End

	RETURN result;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validation_resume_qualifications(grade NUMERIC(1,0))
RETURNS BOOLEAN 
AS $$
DECLARE
    result BOOLEAN;
BEGIN
    IF grade NOT BETWEEN 1 AND 5 THEN
        raise '[grade] must be between 1 and 5.';
        SELECT false INTO result;
    END IF;

    RETURN result;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validation_resume_languages(grade NUMERIC(1,0))
RETURNS BOOLEAN 
AS $$
DECLARE
    result BOOLEAN;
BEGIN
    IF grade NOT BETWEEN 1 AND 5 THEN
        raise '[grade] must be between 1 and 5.';
        SELECT false INTO result;
    END IF;

    RETURN result;
END; $$ LANGUAGE plpgsql;

/*
 *   TABLES
*/
CREATE TABLE public.users(
    user_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT false,
    email VARCHAR(320) NOT NULL,
    password VARCHAR(25) NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uc_users_email UNIQUE (email)
);

CREATE TABLE public.user_confirms(
    user_confirm_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    user_id INTEGER NOT NULL,
    confirmed_user_id INTEGER NOT NULL,
    confirmed_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_user_confirms PRIMARY KEY (user_confirm_id),
    CONSTRAINT fk_user_confirms_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_user_confirms_confirmed_user_id_users FOREIGN KEY (confirmed_user_id) REFERENCES public.users (user_id)

);

CREATE TABLE public.user_verifications(
    user_verification_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL,
    code VARCHAR(38) NOT NULL,
    expiry_date TIMESTAMPTZ NOT NULL,
    verification_date TIMESTAMPTZ,
    CONSTRAINT pk_user_verifications PRIMARY KEY (user_verification_id),
    CONSTRAINT fk_user_verifications_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id)
);

CREATE TABLE public.countries(
    country_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    name VARCHAR(60) NOT NULL,
    iso VARCHAR(2) NOT NULL,
    phone_code VARCHAR(16) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    CONSTRAINT pk_countries PRIMARY KEY (country_id),
    CONSTRAINT fk_countries_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_countries_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id)
);

CREATE TABLE public.states(
    state_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    country_id INTEGER NOT NULL,
    name VARCHAR(60) NOT NULL,
    code VARCHAR(10) NOT NULL,
    CONSTRAINT pk_states PRIMARY KEY (state_id),
    CONSTRAINT fk_states_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_states_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_states_country_id_countries FOREIGN KEY (country_id) REFERENCES public.countries (country_id)
);

CREATE TABLE public.cities(
    city_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    state_id INTEGER NOT NULL,
    name VARCHAR(70) NOT NULL,
    CONSTRAINT pk_cities PRIMARY KEY (city_id),
    CONSTRAINT fk_cities_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_cities_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_cities_state_id_states FOREIGN KEY (state_id) REFERENCES public.states (state_id)
);

CREATE TABLE public.user_phones(
    user_phone_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    user_id INTEGER NOT NULL,
    country_id INTEGER NOT NULL,
    phone VARCHAR(12) NOT NULL,
    CONSTRAINT pk_user_phones PRIMARY KEY (user_phone_id),
    CONSTRAINT fk_user_phones_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_user_phones_country_id_countries FOREIGN KEY (country_id) REFERENCES public.countries (country_id)
);

CREATE TABLE public.candidates(
    user_id INTEGER NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    identity_number VARCHAR(11) NOT NULL,
    birth_date DATE NOT NULL,
    CONSTRAINT pk_candidates PRIMARY KEY (user_id),
    CONSTRAINT fk_candidates_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    CONSTRAINT uc_candidates_identity_number UNIQUE (identity_number)
);

CREATE TABLE public.employers(
    user_id INTEGER NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    website VARCHAR(255) NOT NULL,
    CONSTRAINT pk_employers PRIMARY KEY (user_id),
    CONSTRAINT fk_employers_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE,
    CONSTRAINT chk_employers_web_address CHECK (validation_employers(user_id,website))
);

CREATE TABLE public.employees(
    user_id INTEGER NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (user_id),
    CONSTRAINT fk_employees_user_id_users FOREIGN KEY (user_id) REFERENCES public.users (user_id) ON DELETE CASCADE
);

CREATE TABLE public.job_titles(
    job_title_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    title VARCHAR(50) NOT NULL,
    CONSTRAINT pk_job_titles PRIMARY KEY (job_title_id),
    CONSTRAINT fk_job_titles_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_job_titles_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT uc_job_titles_title UNIQUE (title)
);

CREATE TABLE public.jobs(
    job_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    job_title_id INTEGER NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(2000) NOT NULL,
    state_id INTEGER NOT NULL,
    min_salary NUMERIC(18,4),
    max_salary NUMERIC(18,4),
    applicant_quota NUMERIC(3,0) NOT NULL,
    last_application_date DATE,
    CONSTRAINT pk_jobs PRIMARY KEY (job_id),
    CONSTRAINT fk_jobs_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_jobs_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_jobs_job_title_id_job_titles FOREIGN KEY (job_title_id) REFERENCES public.job_titles (job_title_id),
    CONSTRAINT fk_jobs_state_id_states FOREIGN KEY (state_id) REFERENCES public.states (state_id)
);

CREATE TABLE public.website_types(
    website_type_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    name VARCHAR(15) NOT NULL,
    CONSTRAINT pk_website_types PRIMARY KEY (website_type_id),
    CONSTRAINT fk_website_types_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_website_types_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT uc_website_types_name UNIQUE (name)
);

CREATE TABLE public.qualifications(
    qualification_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_qualifications PRIMARY KEY (qualification_id),
    CONSTRAINT fk_qualifications_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_qualifications_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT uc_qualifications_name UNIQUE (name)
);

CREATE TABLE public.languages(
    language_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_languages PRIMARY KEY (language_id),
    CONSTRAINT fk_languages_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_languages_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id),
    CONSTRAINT uc_languages_name UNIQUE (name)
);

CREATE TABLE public.resumes(
    resume_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_user_id INTEGER NOT NULL,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_user_id INTEGER NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    profile_picture_url VARCHAR(255),
    cover_letter VARCHAR(255),
    CONSTRAINT pk_resumes PRIMARY KEY (resume_id),
    CONSTRAINT fk_resumes_created_user_id_users FOREIGN KEY (created_user_id) REFERENCES public.users (user_id),
    CONSTRAINT fk_resumes_modified_user_id_users FOREIGN KEY (modified_user_id) REFERENCES public.users (user_id)
);

CREATE TABLE public.resume_qualifications(
    resume_qualification_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY(INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    resume_id INTEGER NOT NULL,
    qualification_id INTEGER NOT NULL,
    grade NUMERIC(1,0) NOT NULL,
    CONSTRAINT pk_resume_qualifications PRIMARY KEY (resume_qualification_id),
    CONSTRAINT fk_resume_qualifications_resume_id_resumes FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id),
    CONSTRAINT fk_resume_qualifications_qualification_id_qualifications FOREIGN KEY (resume_qualification_id) REFERENCES public.qualifications(qualification_id),
    CONSTRAINT ck_resume_qualifications_grade CHECK (validation_resume_qualifications(grade))
);

CREATE TABLE public.resume_websites(
    resume_website_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    resume_id INTEGER NOT NULL,
    website_type_id INTEGER NOT NULL,
    website varchar(255) NOT NULL,
    CONSTRAINT pk_resume_websites PRIMARY KEY (resume_website_id),
    CONSTRAINT fk_resume_websites_resume_id_resumes FOREIGN KEY (resume_id) REFERENCES public.resumes (resume_id),
    CONSTRAINT fk_resume_websites_website_type_id_website_types FOREIGN KEY (website_type_id) REFERENCES public.website_types(website_type_id)
);

CREATE TABLE public.resume_languages(
    resume_language_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    resume_id INTEGER NOT NULL,
    language_id INTEGER NOT NULL,
    grade NUMERIC(1,0) NOT NULL,
    CONSTRAINT pk_resume_languages PRIMARY KEY (resume_language_id),
    CONSTRAINT fk_resume_languages_resume_id_resumes FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id),
    CONSTRAINT fk_resume_languages_language_id_languages FOREIGN KEY(language_id) REFERENCES public.languages(language_id),
    CONSTRAINT ck_resume_languages_grade CHECK (validation_resume_languages(grade))
);

CREATE TABLE public.resume_educations(
    resume_education_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    resume_id INTEGER NOT NULL,
    school_name VARCHAR(255) NOT NULL,
    department_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    is_graduate BOOLEAN NOT NULL,
    graduate_date DATE,
    CONSTRAINT pk_resume_educations PRIMARY KEY(resume_education_id),
    CONSTRAINT fk_resume_educations_resume_id_resumes FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id)
);

CREATE TABLE public.resume_experiences(
    resume_experience_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 1 START 1),
    created_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    is_active BOOLEAN NOT NULL DEFAULT true,
    resume_id INTEGER NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    job_title_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    is_continued BOOLEAN NOT NULL,
    end_date DATE,
    CONSTRAINT pk_resume_experiences PRIMARY KEY(resume_experience_id),
    CONSTRAINT fk_resume_experiences_resume_id_resumes FOREIGN KEY (resume_id) REFERENCES public.resumes(resume_id),
    CONSTRAINT fk_resume_experiences_job_title_id_job_titles FOREIGN KEY(job_title_id) REFERENCES public.job_titles(job_title_id)
);