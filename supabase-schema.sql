-- =====================================================================
-- MK Optics — Supabase schema
-- =====================================================================
-- Run this in the Supabase SQL editor (Project > SQL Editor > New query).
--
-- This file creates FIVE tables (think: five labeled folders in a
-- filing cabinet). Each comment block explains what real-world thing
-- that table is standing in for, before the technical column list.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1) CUSTOMERS — one row per person, ever.
--    Mobile number is the customer's unique ID: the app will look
--    someone up by phone number first, so the same person never gets
--    accidentally added twice.
-- ---------------------------------------------------------------------
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  phone text not null unique,
  name text not null,
  email text,

  -- Rewards program (the QR-code sign-up flow)
  rewards_opted_in boolean not null default false,
  joined_rewards_at timestamptz,

  -- Referrals: who brought this customer in, if anyone
  referred_by uuid references customers (id) on delete set null,

  -- A quick flag staff can set for VIP/high-value customers
  high_value boolean not null default false,

  -- A running note of preferences that isn't tied to one specific visit
  -- (e.g. "prefers metal frames, budget-conscious") — this is separate
  -- from the per-visit notes in the `visits` table below, which are
  -- about what happened THAT day.
  general_notes text,

  created_at timestamptz not null default now()
);

create index if not exists customers_phone_idx on customers (phone);
create index if not exists customers_name_idx on customers (lower(name));


-- ---------------------------------------------------------------------
-- 2) VISITS — one row per sale/prescription capture, linked to a
--    customer. This is what the Counter Intake screen saves.
-- ---------------------------------------------------------------------
create table if not exists visits (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers (id) on delete cascade,

  visit_date date not null default current_date,
  bill_no text,

  -- Prescription: Distance
  od_sphere text,
  od_cylinder text,
  od_axis text,
  od_prism text,
  od_base text,
  os_sphere text,
  os_cylinder text,
  os_axis text,
  os_prism text,
  os_base text,

  -- Prescription: Add
  add_od_sphere text,
  add_os_sphere text,

  additional_information text,
  prescribed_by text,

  -- Purchase
  product_type text, -- e.g. Spectacles / Sunglasses / Contact Lenses
  frame text,
  lens text,
  amount numeric,
  channel text,

  -- Notes for next visit
  preferences_budget text,
  pitch_next_time text,
  next_reminder_date date,
  reminder_for text,
  remarks text,

  created_at timestamptz not null default now()
);

create index if not exists visits_customer_idx on visits (customer_id);


-- ---------------------------------------------------------------------
-- 3) LEADS — people who enquired or tried something on but did NOT
--    buy. This is a different category from `customers`: it's the
--    "Recover Lost Sales" list (e.g. "tried frames, price concern").
--    A lead can later be converted into a real customer once they buy.
-- ---------------------------------------------------------------------
create table if not exists leads (
  id uuid primary key default gen_random_uuid(),

  -- A lead may not have a full customer record yet, so we store their
  -- name/phone directly here rather than requiring a customer_id.
  name text not null,
  phone text,

  interest text,            -- e.g. "Progressive lenses", "Sunglasses"
  reason_not_bought text,   -- e.g. "Price concern"
  status text not null default 'open', -- open | followed_up | converted | lost

  enquiry_date date not null default current_date,
  notes text,

  -- Filled in once/if this lead becomes a paying customer
  converted_customer_id uuid references customers (id) on delete set null,

  created_at timestamptz not null default now()
);

create index if not exists leads_phone_idx on leads (phone);
create index if not exists leads_status_idx on leads (status);


-- ---------------------------------------------------------------------
-- 4) REMINDERS — every "do this, for this person, by this date" task:
--    eye-test due dates, contact-lens refill reminders, review
--    requests, referral asks, and offers. This one table is what
--    powers the "daily follow-up list" staff check each morning —
--    it's just "reminders due today or overdue."
-- ---------------------------------------------------------------------
create table if not exists reminders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers (id) on delete cascade,

  -- eye_test | contact_lens_refill | review_request | referral_ask |
  -- offer | social_post | custom
  type text not null,

  due_date date not null,
  channel text default 'whatsapp', -- whatsapp | call | in-store
  status text not null default 'pending', -- pending | sent | done | skipped
  notes text,

  created_at timestamptz not null default now()
);

create index if not exists reminders_due_idx on reminders (due_date, status);
create index if not exists reminders_customer_idx on reminders (customer_id);


-- ---------------------------------------------------------------------
-- 5) REFERRALS — tracks the link between the person who referred and
--    the new person who came in because of it, so discounts can be
--    given to BOTH sides once the referral results in a purchase.
-- ---------------------------------------------------------------------
create table if not exists referrals (
  id uuid primary key default gen_random_uuid(),

  referrer_customer_id uuid not null references customers (id) on delete cascade,

  -- The referred person may not exist as a customer yet when the
  -- referral is first sent, so we keep their name/phone directly too.
  referred_name text,
  referred_phone text,
  referred_customer_id uuid references customers (id) on delete set null,

  status text not null default 'invited', -- invited | joined | purchased
  referrer_discount_given boolean not null default false,
  referred_discount_given boolean not null default false,

  created_at timestamptz not null default now()
);

create index if not exists referrals_referrer_idx on referrals (referrer_customer_id);


-- =====================================================================
-- SECURITY — Row Level Security (RLS)
-- =====================================================================
-- This is like a rule that says "only people who are logged into this
-- app may read or write these folders." Since this is an internal
-- staff tool, we start with a simple rule (any logged-in/authenticated
-- user can read and write) and can tighten it later (e.g. per-branch
-- staff accounts) once you have staff logins set up.
-- =====================================================================

alter table customers enable row level security;
alter table visits enable row level security;
alter table leads enable row level security;
alter table reminders enable row level security;
alter table referrals enable row level security;

create policy "Authenticated users can read customers"
  on customers for select to authenticated using (true);
create policy "Authenticated users can write customers"
  on customers for insert to authenticated with check (true);
create policy "Authenticated users can update customers"
  on customers for update to authenticated using (true);

create policy "Authenticated users can read visits"
  on visits for select to authenticated using (true);
create policy "Authenticated users can write visits"
  on visits for insert to authenticated with check (true);

create policy "Authenticated users can read leads"
  on leads for select to authenticated using (true);
create policy "Authenticated users can write leads"
  on leads for insert to authenticated with check (true);
create policy "Authenticated users can update leads"
  on leads for update to authenticated using (true);

create policy "Authenticated users can read reminders"
  on reminders for select to authenticated using (true);
create policy "Authenticated users can write reminders"
  on reminders for insert to authenticated with check (true);
create policy "Authenticated users can update reminders"
  on reminders for update to authenticated using (true);

create policy "Authenticated users can read referrals"
  on referrals for select to authenticated using (true);
create policy "Authenticated users can write referrals"
  on referrals for insert to authenticated with check (true);
create policy "Authenticated users can update referrals"
  on referrals for update to authenticated using (true);
