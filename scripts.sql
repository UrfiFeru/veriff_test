-- Table: public.countries_lnd

-- DROP TABLE public.countries_lnd;

CREATE TABLE public.countries_lnd
(
    uuid character varying COLLATE pg_catalog."default",
    country character varying COLLATE pg_catalog."default" NOT NULL,
    inserted_at TIMESTAMP DEFAULT now(),
    CONSTRAINT countries_lnd_pkey PRIMARY KEY (country)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.countries_lnd
    OWNER to postgres;
	
	
-- Table: public.events_lnd

-- DROP TABLE public.events_lnd;

CREATE TABLE public.events_lnd
(
    uuid character varying COLLATE pg_catalog."default" NOT NULL,
    session_uuid character varying COLLATE pg_catalog."default" NOT NULL,
    event_type character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp without time zone NOT NULL,
    inserted_at TIMESTAMP DEFAULT now(),
    CONSTRAINT events_pkey PRIMARY KEY (uuid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.events_lnd
    OWNER to postgres;
	
	
-- Table: public.sessions_lnd

-- DROP TABLE public.sessions_lnd;

CREATE TABLE public.sessions_lnd
(
    uuid character varying COLLATE pg_catalog."default" NOT NULL,
    status character varying COLLATE pg_catalog."default" NOT NULL,
    verifier_uuid character varying COLLATE pg_catalog."default" NOT NULL,
    country_uuid character varying COLLATE pg_catalog."default" NOT NULL,
    inserted_at TIMESTAMP DEFAULT now(),
    CONSTRAINT sessions_pkey PRIMARY KEY (uuid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.sessions_lnd
    OWNER to postgres;
	
	
-- Table: public.verifiers_lnd

-- DROP TABLE public.verifiers_lnd;

CREATE TABLE public.verifiers_lnd
(
    uuid character varying COLLATE pg_catalog."default" NOT NULL,
    verifier_name character varying COLLATE pg_catalog."default" NOT NULL,
    inserted_at TIMESTAMP DEFAULT now(),
    CONSTRAINT verifiers_pkey PRIMARY KEY (uuid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.verifiers_lnd
    OWNER to postgres;
	
	
-- Table: public.session_dim

-- DROP TABLE public.session_dim;

CREATE TABLE public.session_dim
(
    id integer NOT NULL DEFAULT nextval('session_dim_id_seq'::regclass),
    session_uuid character varying COLLATE pg_catalog."default",
    start_event_id text COLLATE pg_catalog."default",
    end_event_id text COLLATE pg_catalog."default",
    start_time timestamp without time zone,
    end_time timestamp without time zone
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.session_dim
    OWNER to postgres;
	
	
-- Table: public.verification_fact

-- DROP TABLE public.verification_fact;

CREATE TABLE public.verification_fact
(
    id integer NOT NULL DEFAULT nextval('verification_fact_id_seq'::regclass),
    session_key integer,
    session_uuid character varying COLLATE pg_catalog."default",
    country_id character varying COLLATE pg_catalog."default",
    verifier_id character varying COLLATE pg_catalog."default",
    status character varying COLLATE pg_catalog."default",
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    country_name character varying COLLATE pg_catalog."default",
    verifier_name character varying COLLATE pg_catalog."default",
    session_length double precision
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.verification_fact
    OWNER to postgres;	
	
