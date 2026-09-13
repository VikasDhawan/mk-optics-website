-- MK Optics — Supabase schema
-- Run this in the Supabase SQL editor (Project > SQL Editor > New query).

create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  created_at timestamptz not null default now()
);

create index if not exists customers_phone_idx on customers (phone);
create index if not exists customers_name_idx on customers (lower(name));

create table if not exists visits (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers (id) on delete cascade,

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
  frame text,
  lens text,
  amount numeric,
  channel text,

  -- Notes for next visit
  preferences_budget text,
  pitch_next_time text,
  next_reminder_date date,
  reminder_for text,

  created_at timestamptz not null default now()
);

create index if not exists visits_customer_idx on visits (customer_id);

-- Enable Row Level Security. Since this is an internal counter-staff tool,
-- start with a permissive policy for authenticated users and tighten later.
alter table customers enable row level security;
alter table visits enable row level security;

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
