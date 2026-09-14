-- =====================================================================
-- MK Optics — Migration 003: rewards QR sign-up
-- =====================================================================
-- Run this in the SQL Editor after supabase-schema.sql and migration 002.
--
-- The rewards sign-up page (rewards-signup.html) is meant to be scanned
-- and filled in by CUSTOMERS themselves at the counter — it has no staff
-- login. That means it can't use the "only logged-in staff" security
-- rule the rest of the app uses. Instead of loosening the main
-- `customers` table back open (which we deliberately locked down in
-- migration 002), this creates a separate, narrow table that anonymous
-- visitors may only ADD to, never read or edit. Staff review and merge
-- these into the real customer list from the Dashboard page.
--
-- Safe to re-run: every statement below either has "if not exists" or
-- drops-then-recreates the policy first, so running this twice (e.g.
-- after it partially succeeded) won't error.
-- =====================================================================

create table if not exists reward_signups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  opted_in_offers boolean not null default true,
  reviewed boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists reward_signups_reviewed_idx on reward_signups (reviewed);

alter table reward_signups enable row level security;

-- Anyone (even not logged in) may submit a sign-up, but may not read the
-- list back — so one customer's phone number isn't visible to another
-- customer using the same public page.
drop policy if exists "Anyone can submit a rewards sign-up" on reward_signups;
create policy "Anyone can submit a rewards sign-up"
  on reward_signups for insert to anon, authenticated with check (true);

-- Only logged-in staff can see and manage the submitted list.
drop policy if exists "Logged-in staff can read reward signups" on reward_signups;
create policy "Logged-in staff can read reward signups"
  on reward_signups for select to authenticated using (true);

drop policy if exists "Logged-in staff can update reward signups" on reward_signups;
create policy "Logged-in staff can update reward signups"
  on reward_signups for update to authenticated using (true);
