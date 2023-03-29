--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 13.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.images (
    id text NOT NULL,
    img_url text NOT NULL
);


ALTER TABLE public.images OWNER TO postgres;

--
-- Name: kpi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kpi (
    metric_value bigint,
    metric_name text
);


ALTER TABLE public.kpi OWNER TO postgres;

--
-- Name: new_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.new_products (
    "boutiqueOfficielle" boolean,
    brand text,
    category text,
    etranger boolean,
    "fastDelivery" boolean,
    href text,
    id text,
    name text,
    "timestamp" text
);


ALTER TABLE public.new_products OWNER TO postgres;

--
-- Name: prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prices (
    prod_id text NOT NULL,
    price numeric NOT NULL,
    stars numeric NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    id uuid NOT NULL,
    href text,
    discount numeric NOT NULL
);


ALTER TABLE public.prices OWNER TO postgres;

--
-- Name: prod_ranking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_ranking (
    category_main text,
    reviewcount double precision,
    href text,
    name text,
    img_url text,
    prod_id text,
    stars_max numeric,
    avg_price numeric,
    max_price numeric,
    min_price numeric,
    latest_price numeric,
    dist_from_average numeric
);


ALTER TABLE public.prod_ranking OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    "boutiqueOfficielle" text,
    brand text,
    category text,
    etranger text,
    "fastDelivery" text,
    href text,
    id text,
    img_url text,
    name text,
    reviewcount double precision,
    stars text,
    "timestamp" text,
    category_main text
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products_old (
    "boutiqueOfficielle" boolean,
    brand text,
    category text,
    etranger boolean,
    "fastDelivery" boolean,
    href text,
    id text NOT NULL,
    name text,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.products_old OWNER TO postgres;

--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: products_old products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products_old
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: href_ix; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX href_ix ON public.prices USING btree (href);


--
-- Name: ix_prod_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_prod_id ON public.prices USING btree (prod_id);


--
-- Name: prod_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prod_id_index ON public.prices USING btree (prod_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE images; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.images TO readwrite;


--
-- Name: TABLE new_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.new_products TO readwrite;


--
-- Name: TABLE prices; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.prices TO readwrite;


--
-- Name: TABLE products_old; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products_old TO readwrite;


--
-- PostgreSQL database dump complete
--
