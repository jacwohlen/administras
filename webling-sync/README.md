# Sync members from webling with administra

This script is using webling api key to fetch all members from Webling.
Every member gets pushed into supabase db.

Data Fields

- Member Id
- Firstname
- Lastname
- Birthday
- Groups
- Cell Phone

## Setup

1. Get Webling API Token (readonly)

```
pip install requests

export WEBLING_API_KEY=<your webling key>
export WEBLING_API_KEY=<your webling domain> e.g. jacwohlen

export SUPABASE_URL=
export SUPABASE_ANON_KEY=

python webling.py
```
