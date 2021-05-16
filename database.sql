/*
 *   DROP SCHEMA FOR ALL TABLES.
*/
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

/*
 *   FUNCTIONS
*/
CREATE OR REPLACE FUNCTION validate_email_by_domain(user_id INTEGER, web_address CHARACTER VARYING(255)) 
RETURNS BOOLEAN AS $$
DECLARE
	DECLARE user_email_address varchar(320);
    DECLARE result boolean;
BEGIN
	SELECT email_address INTO user_email_address FROM users where id = user_id;
    SELECT web_address like '%' || SUBSTRING(user_email_address,POSITION('@' in user_email_address) + 1) INTO result;
	IF result = false THEN
		raise 'E-mail(%) and web address(%) must have the same domain name.',user_email_address,web_address;
	END IF;
	RETURN result;
END; $$ LANGUAGE plpgsql;

/*
 *   TABLES
*/
CREATE TABLE public.users(
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	email_address CHARACTER VARYING(320) NOT NULL,
	password CHARACTER VARYING(25) NOT NULL,
	CONSTRAINT pk_users PRIMARY KEY (id),
	CONSTRAINT uc_users_email_address UNIQUE (email_address)
);

CREATE TABLE public.candidates(
	id INTEGER NOT NULL,
	first_name CHARACTER VARYING(35) NOT NULL,
	last_name CHARACTER VARYING(35) NOT NULL,
	identification_number CHARACTER VARYING(11) NOT NULL,
    birth_date DATE NOT NULL,
	CONSTRAINT pk_candidates PRIMARY KEY (id),
	CONSTRAINT fk_candidates_users FOREIGN KEY (id) REFERENCES public.users (id) ON DELETE CASCADE,
	CONSTRAINT uc_candidates_identification_number UNIQUE (identification_number)
);

CREATE TABLE public.employers(
	id INTEGER NOT NULL,
	company_name CHARACTER VARYING(255) NOT NULL,
	web_address CHARACTER VARYING(255) NOT NULL,
	CONSTRAINT pk_employers PRIMARY KEY (id),
	CONSTRAINT fk_employers_users FOREIGN KEY (id) REFERENCES public.users (id) ON DELETE CASCADE,
    CONSTRAINT chk_employers_web_address CHECK (validate_email_by_domain(id,web_address))
);

CREATE TABLE public.employer_phones(
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	employer_id INTEGER NOT NULL,
	phone_number CHARACTER VARYING(12) NOT NULL,
	CONSTRAINT pk_employer_phones PRIMARY KEY (id),
	CONSTRAINT fk_employer_phones_employer_id FOREIGN KEY (employer_id) REFERENCES public.employers (id) ON DELETE CASCADE
);

CREATE TABLE public.employees(
	id INTEGER NOT NULL,
	first_name CHARACTER VARYING(35) NOT NULL,
	last_name CHARACTER VARYING(35) NOT NULL,
	CONSTRAINT pk_employees PRIMARY KEY (id),
	CONSTRAINT fk_employees_users FOREIGN KEY (id) REFERENCES public.users (id) ON DELETE CASCADE
);

CREATE TABLE public.verification_codes(
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	code CHARACTER VARYING(38) NOT NULL,
	is_verified boolean DEFAULT false NOT NULL,
	CONSTRAINT pk_verification_codes PRIMARY KEY (id),
	CONSTRAINT uc_verification_codes_code UNIQUE (code)
);

CREATE TABLE public.verification_codes_candidates(
	id INTEGER NOT NULL,
	candidate_id INTEGER NOT NULL,
	CONSTRAINT pk_verification_codes_candidates PRIMARY KEY (id),
	CONSTRAINT fk_verification_codes_candidates_verification_codes FOREIGN KEY (id) REFERENCES public.verification_codes (id) ON DELETE CASCADE,
	CONSTRAINT fk_verification_codes_candidates_candidates FOREIGN KEY (candidate_id) REFERENCES public.candidates (id) ON DELETE CASCADE
);

CREATE TABLE public.verification_codes_employers(
	id INTEGER NOT NULL,
	employer_id INTEGER NOT NULL,
	CONSTRAINT pk_verification_codes_employers PRIMARY KEY (id),
	CONSTRAINT fk_verification_codes_employers_verification_codes FOREIGN KEY (id) REFERENCES public.verification_codes (id) ON DELETE CASCADE,
	CONSTRAINT fk_verification_codes_employers_employers FOREIGN KEY (employer_id) REFERENCES public.employers (id) ON DELETE CASCADE
);

CREATE TABLE public.employee_confirms(
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	employee_id INTEGER NOT NULL,
	is_confirmed BOOLEAN DEFAULT false NOT NULL,
	CONSTRAINT pk_employee_confirms PRIMARY KEY (id),
	CONSTRAINT fk_employee_confirms_employees FOREIGN KEY (employee_id) REFERENCES public.employees (id) ON DELETE CASCADE
);

CREATE TABLE public.employee_confirms_employers(
	id INTEGER NOT NULL,
	employer_id INTEGER NOT NULL,
	CONSTRAINT pk_employee_confirms_employers PRIMARY KEY (id),
	CONSTRAINT fk_employee_confirms_employers_employee_confirms FOREIGN KEY (id) REFERENCES public.employee_confirms (id) ON DELETE CASCADE,
	CONSTRAINT fk_employee_confirms_employers_employers FOREIGN KEY (employer_id) REFERENCES public.employers (id) ON DELETE CASCADE
);

CREATE TABLE public.job_titles(
	id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
	title CHARACTER VARYING(255) NOT NULL,
	CONSTRAINT pk_job_titles PRIMARY KEY (id),
	CONSTRAINT uc_job_titles_title UNIQUE (title)
);

/*
 *   INSERT JOB TITLES
*/
INSERT INTO public.job_titles (title) 
VALUES ('Software Developer'),('Software Architect');

/*
 *   INSERT CANDIDATE AND EMPLOYER
*/
DO $$
    DECLARE candidate_id integer;
BEGIN
	INSERT INTO public.users (email_address,password) VALUES('karcanozbal@outlook.com.tr','123456') RETURNING id INTO candidate_id;
	INSERT INTO public.candidates (id,first_name,last_name,identification_number,birth_date) VALUES(candidate_id,'Karcan','Özbal','11111111111','1993-11-16');
END $$;

DO $$
    DECLARE employer_id integer;
BEGIN
	INSERT INTO public.users (email_address,password) VALUES('karcanozbal@k-software.com','123456') RETURNING id INTO employer_id;
	INSERT INTO public.employers (id,company_name,web_address) VALUES(employer_id,'Karcan Yazılım A.Ş.','www.k-software.com');
	INSERT INTO public.employer_phones(employer_id,phone_number) VALUES(employer_id,'8505552233'),(employer_id,'8505552234'),(employer_id,'8505552235');
END $$;
