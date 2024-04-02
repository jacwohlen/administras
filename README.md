# Administra - Absense Tracker (My First Sveltekit App)

Administra allows to create training sessions and track people's
attendance.

## Features

- Login using Google Auth or Email/Passowrd
- Create training classes with meta data (title, start, end, weekday, section)
- Add participants to a training class
- Mark participants as present for a particular date
- Statistics: View attendance of a training class per year
- ...

## Technical Aspects

Current stack: npm, node, sveltekit, skeleton (tailwindcss)

Backend: supabase (postgres)

## Contribution

More than welcome, I am looking for a productve partnership...
I believe this product has high potential and we could ease a lot of lives in the judo world.
As I am a busy man I invested little time. I can bring a network of customers for this idea.
In case you see the potential and also believe in open source please drop me a line.

## Development Setup

1. Create Supabase account
2. Source environment variables for supabase

```bash
PUBLIC_SUPABASE_URL=""
PUBLIC_SUPABASE_ANON_KEY=""
PUBLIC_MODE=DEV # PROD, DEV
```

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Testing

tbd

## Building

To create a production version of the app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

## Deployment

> To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs/adapters) for your target environment.

## Restricted Login (Google Authentication with specific Domain)

This Webapp restricts login to Google Accounts with a given domain.
To make this happen, we added some policies to the supabase backend.

Supabase Config: tbd

## Tips

- Tip use `nvm install --lts` to install long term support version of `node`.

## Todos

[Todo](./TODO.md)

## Prepare Supabase Postgres DB

TODO

- [ ] SQL to create tables/views
- [ ] SQL to create procedures/functions
- [ ] SQL to create policies to control access

1. Create View for logs summary

```sql
create view view_logs_summary as
select date, "trainingId", count("memberId") from logs group by date, "trainingId"
```

2. Create function for checklist

```sql
-- drop function get_checklist_members(d text, tId int);
CREATE OR REPLACE function get_checklist_members(d text, tId int)
returns table (trainingId int2, memberId int2, lastname text, firstname text, labels jsonb, img text, date text, isMainTrainer boolean) language plpgsql
as
$$
declare
begin
  return query
    select participants."trainingId", participants."memberId", members."lastname", members."firstname", members."labels", members."img", logs."date", logs."isMainTrainer"
    from participants
    full outer join logs on participants."memberId" = logs."memberId" and logs."date" = $1 and logs."trainingId" = $2
    inner join members on members.id =  participants."memberId"
    where participants."trainingId" = $2;
end;
$$;
-- select * from get_checklist_members(text '2022-12-19', 47);
```

3. Create View to faciliate seaching members

```sql
create view view_search_members as
  select id, concat(lastname, ' ', firstname) as fullname, firstname, lastname from members
```

4. Create functions for stats

```sql
-- drop function get_top_athletes(d text);
CREATE OR REPLACE function get_top_athletes(year text)
returns table (memberId int2, lastname text, firstname text, count bigint) language plpgsql
as
$$
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
$$;

--select * from get_top_athletes(text '2022');
```

```sql
-- drop function get_top_athletes_by_section(d text);
CREATE OR REPLACE function get_top_athletes_by_section (year text)
returns table (section text, memberId int2, lastname text, firstname text, count bigint)
language plpgsql as $$
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
  count desc;
end;
$$;

--select * from get_top_athletes_by_section(text '2022');
```

5. Secure Login (restrict to google accounts of given domain)

```sql
-- create function with validates email to be from domain "jacwohlen.ch"
CREATE OR REPLACE FUNCTION validate_google_domain()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if the user's email domain is 'jacwohlen.ch'
  IF NEW.email LIKE '%@jacwohlen.ch' THEN
    -- If valid, allow the operation to proceed
    RETURN NEW;
  ELSE
    -- If invalid, raise an error
    RAISE EXCEPTION 'Invalid email domain. Only jacwohlen.ch is allowed.';
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- create trigger which fires if new login
CREATE TRIGGER check_user_domain
BEFORE INSERT OR UPDATE ON auth.users
FOR EACH ROW
EXECUTE FUNCTION validate_google_domain();
```
