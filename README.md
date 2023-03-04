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

Backend: firebase (auth, firestore)

## Contribution

More than welcome, I am looking for a productve partnership...
I believe this product has high potential and we could ease a lot of lives in the judo world.
As I am a busy man I invested little time. I can bring a network of customers for this idea.
In case you see the potential and also believe in open source please drop me a line.

## Development Setup

1. Create Firebase account
2. Source environment with data from firebase account

```
export PUBLIC_FIREBASE_API_KEY=
export PUBLIC_FIREBASE_AUTH_DOMAIN=
export PUBLIC_FIREBASE_DATABASE_URL=
export PUBLIC_FIREBASE_PROJECT_ID=
export PUBLIC_FIREBASE_STORAGE_BUCKET=
export PUBLIC_FIREBASE_MESSAGING_SENDER_ID=
export PUBLIC_FIREBASE_APP_ID=

# This requies firestore rules to be setup as well. Check example at end of README
export PUBLIC_GOOGLE_LOGIN_DOMAIN=<your-google-domain-if-want-to-restrict>
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
To make this happen, Firebase Auth needs a configuration to allow Google Auth.
Further the firestore database rules need to restrict reads and writes from
authenticated users with matching domain.
And lastly set the environment `APP_GOOGLE_LOGIN_DOMAIN` accordingly.

Example Config (allow Google Accounts with domain `jacwohlen.ch`)

```
...
export PUBLIC_GOOGLE_LOGIN_DOMAIN=jacwohlen.ch
```

Firestore rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null
      && validAccount(request.auth.token.email);
    }
  }
}

function validAccount(userEmail){
	return userEmail.split('@')[1] == 'jacwohlen.ch'; # your domain
}

```

## Tips

- Tip use `nvm install --lts` to install long term support version of `node`.

## Todos

[Todo](./TODO.md)

## SQL

1. Create View for logs summary

```sql
create view view_logs_summary as
select date, "trainingId", count("memberId") from logs group by date, "trainingId"
```

2. Create function for checklist

```sql
-- drop function get_checklist_members(d text, tId int);
CREATE OR REPLACE function get_checklist_members(d text, tId int)
returns table (trainingId int2, memberId int2, lastname text, firstname text, labels jsonb, img text, date text) language plpgsql
as
$$
declare
begin
  return query
    select participants."trainingId", participants."memberId", members."lastname", members."firstname", members."labels", members."img", logs."date"
    from participants
    full outer join logs on participants."memberId" = logs."memberId" and logs."date" = $1
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
