

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


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."check_user_domain"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
  BEGIN
    IF NEW.email NOT LIKE '%@jacwohlen.ch' THEN
      raise exception 'INCORRECT_DOMAIN';
    END IF;

    RETURN NEW;
  END;
  $$;


ALTER FUNCTION "public"."check_user_domain"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_checklist_members"("d" "text", "tid" integer) RETURNS TABLE("trainingid" smallint, "memberid" integer, "lastname" "text", "firstname" "text", "labels" "jsonb", "img" "text", "date" "text", "ismaintrainer" boolean)
    LANGUAGE "plpgsql"
    AS $_$
declare
begin
  return query
    select participants."trainingId", participants."memberId", members."lastname", members."firstname", members."labels", members."img", logs."date", logs."isMainTrainer"
    from participants
    full outer join logs on participants."memberId" = logs."memberId" and logs."date" = $1 and logs."trainingId" = $2
    inner join members on members.id =  participants."memberId"
    where participants."trainingId" = $2;
end;
$_$;


ALTER FUNCTION "public"."get_checklist_members"("d" "text", "tid" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_athletes"("year" "text") RETURNS TABLE("memberid" integer, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $_$
declare
begin
  return query
select logs."memberId", members.lastname, members.firstname, count(*)
    from logs
    inner join members on members."id" = logs."memberId"
    where logs."date" like CONCAT($1, '%')
    group by logs."memberId", members.lastname, members.firstname
    order by count desc;
end;
$_$;


ALTER FUNCTION "public"."get_top_athletes"("year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_athletes_by_section"("year" "text") RETURNS TABLE("section" "text", "memberid" integer, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname, 
  count(*) 
from 
  logs 
  inner join members on members."id" = logs."memberId" 
  inner join trainings on trainings."id" = logs."trainingId" 
where 
  logs."date" like concat(year, '%') 
group by 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname 
order by 
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_athletes_by_section"("year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_athletes_for_training"("training" integer, "year" "text") RETURNS TABLE("rank" bigint, "section" "text", "memberid" smallint, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select
  ROW_NUMBER() OVER (ORDER BY count(*) DESC, members.lastname) AS rank, 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname, 
  count(*)
from 
  logs 
  inner join members on members."id" = logs."memberId" 
  inner join trainings on trainings."id" = logs."trainingId" 
where 
  logs."date" like concat(year, '%') and
  trainings.id = training
group by 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname 
order by 
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_athletes_for_training"("training" integer, "year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_athletes_from_section"("sect" "text", "year" "text") RETURNS TABLE("rank" bigint, "section" "text", "memberid" integer, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select
  ROW_NUMBER() OVER (ORDER BY count(*) DESC, members.lastname) AS rank, 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname, 
  count(*)
from 
  logs 
  inner join members on members."id" = logs."memberId" 
  inner join trainings on trainings."id" = logs."trainingId" 
where 
  logs."date" like concat(year, '%') and
  LOWER(trainings.section) = LOWER(sect)
group by 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname 
order by 
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_athletes_from_section"("sect" "text", "year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_trainers_by_section"("year" "text") RETURNS TABLE("section" "text", "memberid" integer, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select
  trainings.section,
  logs."memberId",
  members.lastname,
  members.firstname,
  count(*)
from
  logs
  inner join members on members."id" = logs."memberId"
  inner join trainings on trainings."id" = logs."trainingId"
where
  logs."isMainTrainer" is true and
  logs."date" like concat(year, '%')
group by
  trainings.section,
  logs."memberId",
  members.lastname,
  members.firstname
order by
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_trainers_by_section"("year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_trainers_for_training"("training" integer, "year" "text") RETURNS TABLE("rank" bigint, "section" "text", "memberid" smallint, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select
  ROW_NUMBER() OVER (ORDER BY count(*) DESC, members.lastname) AS rank, 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname, 
  count(*)
from 
  logs 
  inner join members on members."id" = logs."memberId" 
  inner join trainings on trainings."id" = logs."trainingId" 
where 
  logs."date" like concat(year, '%') and
  trainings.id = training and
  logs."isMainTrainer" is true
group by 
  trainings.section, 
  logs."memberId", 
  members.lastname, 
  members.firstname 
order by 
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_trainers_for_training"("training" integer, "year" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_top_trainers_from_section"("sect" "text", "year" "text") RETURNS TABLE("rank" bigint, "section" "text", "memberid" integer, "lastname" "text", "firstname" "text", "count" bigint)
    LANGUAGE "plpgsql"
    AS $$
declare
begin
  return query
select
  ROW_NUMBER() OVER (ORDER BY count(*) DESC, members.lastname) AS rank,
  trainings.section,
  logs."memberId",
  members.lastname,
  members.firstname,
  count(*)
from
  logs
  inner join members on members."id" = logs."memberId"
  inner join trainings on trainings."id" = logs."trainingId"
where
  logs."isMainTrainer" is true and
  logs."date" like concat(year, '%') and
  LOWER(trainings.section) = LOWER(sect)
group by
  trainings.section,
  logs."memberId",
  members.lastname,
  members.firstname
order by
  count desc, members.lastname;
end;
$$;


ALTER FUNCTION "public"."get_top_trainers_from_section"("sect" "text", "year" "text") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."logs" (
    "date" "text" NOT NULL,
    "trainingId" smallint,
    "memberId" integer,
    "id" smallint NOT NULL,
    "isMainTrainer" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."logs" OWNER TO "postgres";


ALTER TABLE "public"."logs" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."logs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."members" (
    "id" integer NOT NULL,
    "labels" "jsonb",
    "birthday" "text",
    "lastname" "text" NOT NULL,
    "firstname" "text" NOT NULL,
    "mobile" "text",
    "img" "text",
    "imgUploaded" timestamp with time zone
);


ALTER TABLE "public"."members" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."members_id_seq"
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."members_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."members_id_seq" OWNED BY "public"."members"."id";



ALTER TABLE "public"."members" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."members_id_seq1"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."participants" (
    "id" bigint NOT NULL,
    "trainingId" smallint NOT NULL,
    "memberId" integer NOT NULL
);


ALTER TABLE "public"."participants" OWNER TO "postgres";


ALTER TABLE "public"."participants" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."participants_duplicate_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."trainings" (
    "weekday" "text",
    "dateFrom" "text",
    "title" "text",
    "section" "text",
    "dateTo" "text",
    "id" smallint NOT NULL
);


ALTER TABLE "public"."trainings" OWNER TO "postgres";


ALTER TABLE "public"."trainings" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."trainings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE OR REPLACE VIEW "public"."view_logs_summary" WITH ("security_invoker"='on') AS
 SELECT "logs"."date",
    "logs"."trainingId",
    "count"("logs"."memberId") AS "count",
    "count"(
        CASE
            WHEN ("logs"."isMainTrainer" = true) THEN 1
            ELSE NULL::integer
        END) AS "trainerCount"
   FROM "public"."logs"
  GROUP BY "logs"."date", "logs"."trainingId";


ALTER TABLE "public"."view_logs_summary" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_search_members" WITH ("security_invoker"='on') AS
 SELECT "members"."id",
    "concat"("members"."lastname", ' ', "members"."firstname") AS "fullname",
    "members"."firstname",
    "members"."lastname"
   FROM "public"."members";


ALTER TABLE "public"."view_search_members" OWNER TO "postgres";


ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_id_key" UNIQUE ("id");



ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."members"
    ADD CONSTRAINT "members_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_duplicate_pkey" PRIMARY KEY ("trainingId", "memberId");



ALTER TABLE ONLY "public"."trainings"
    ADD CONSTRAINT "trainings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."members"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_trainingId_fkey" FOREIGN KEY ("trainingId") REFERENCES "public"."trainings"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."members"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."participants"
    ADD CONSTRAINT "participants_trainingId_fkey" FOREIGN KEY ("trainingId") REFERENCES "public"."trainings"("id") ON DELETE CASCADE;



CREATE POLICY "Enable delete for all authenticated users" ON "public"."logs" FOR DELETE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable delete for all authenticated users" ON "public"."members" FOR DELETE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable delete for all authenticated users" ON "public"."participants" FOR DELETE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable delete for all authenticated users" ON "public"."trainings" FOR DELETE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable insert for all authenticated users" ON "public"."logs" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Enable insert for all authenticated users" ON "public"."members" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Enable insert for all authenticated users" ON "public"."participants" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Enable insert for all authenticated users" ON "public"."trainings" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Enable read access for all authenticated users" ON "public"."members" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable read access for all authenticated users" ON "public"."participants" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable read access for all authenticated users" ON "public"."trainings" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable read access for all autthenticated users" ON "public"."logs" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable update access for all authenticated users" ON "public"."logs" FOR UPDATE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable update access for all authenticated users" ON "public"."members" FOR UPDATE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable update access for all authenticated users" ON "public"."participants" FOR UPDATE TO "authenticated", "anon" USING (true);



CREATE POLICY "Enable update access for all authenticated users" ON "public"."trainings" FOR UPDATE TO "authenticated", "anon" USING (true);



ALTER TABLE "public"."logs" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."participants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."trainings" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."check_user_domain"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_user_domain"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_user_domain"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_checklist_members"("d" "text", "tid" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_checklist_members"("d" "text", "tid" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_checklist_members"("d" "text", "tid" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_athletes"("year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_athletes"("year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_athletes"("year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_athletes_by_section"("year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_athletes_by_section"("year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_athletes_by_section"("year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_athletes_for_training"("training" integer, "year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_athletes_for_training"("training" integer, "year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_athletes_for_training"("training" integer, "year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_athletes_from_section"("sect" "text", "year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_athletes_from_section"("sect" "text", "year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_athletes_from_section"("sect" "text", "year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_trainers_by_section"("year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_trainers_by_section"("year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_trainers_by_section"("year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_trainers_for_training"("training" integer, "year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_trainers_for_training"("training" integer, "year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_trainers_for_training"("training" integer, "year" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_top_trainers_from_section"("sect" "text", "year" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_top_trainers_from_section"("sect" "text", "year" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_top_trainers_from_section"("sect" "text", "year" "text") TO "service_role";



























GRANT ALL ON TABLE "public"."logs" TO "anon";
GRANT ALL ON TABLE "public"."logs" TO "authenticated";
GRANT ALL ON TABLE "public"."logs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."logs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."logs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."logs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."members" TO "anon";
GRANT ALL ON TABLE "public"."members" TO "authenticated";
GRANT ALL ON TABLE "public"."members" TO "service_role";



GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."members_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."members_id_seq1" TO "anon";
GRANT ALL ON SEQUENCE "public"."members_id_seq1" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."members_id_seq1" TO "service_role";



GRANT ALL ON TABLE "public"."participants" TO "anon";
GRANT ALL ON TABLE "public"."participants" TO "authenticated";
GRANT ALL ON TABLE "public"."participants" TO "service_role";



GRANT ALL ON SEQUENCE "public"."participants_duplicate_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."participants_duplicate_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."participants_duplicate_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."trainings" TO "anon";
GRANT ALL ON TABLE "public"."trainings" TO "authenticated";
GRANT ALL ON TABLE "public"."trainings" TO "service_role";



GRANT ALL ON SEQUENCE "public"."trainings_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."trainings_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."trainings_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."view_logs_summary" TO "anon";
GRANT ALL ON TABLE "public"."view_logs_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."view_logs_summary" TO "service_role";



GRANT ALL ON TABLE "public"."view_search_members" TO "anon";
GRANT ALL ON TABLE "public"."view_search_members" TO "authenticated";
GRANT ALL ON TABLE "public"."view_search_members" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
