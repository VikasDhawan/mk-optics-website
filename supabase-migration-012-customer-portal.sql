-- =====================================================================
-- MK Optics — Migration 012: customer self-service portal
-- =====================================================================
-- Run this in the SQL Editor after migration 011.
--
-- Adds customer login and four self-service screens for customers,
-- reached from customer-portal.html:
--   1. Prescription & visit history — reads the existing `visits` table.
--   2. Book an appointment — reuses `appointment_requests`, now
--      linkable to a logged-in customer instead of always anonymous.
--   3. Order consumables (contact lens, solution, etc.) — new table.
--   4. Send a complaint, in any language — new table.
-- Plus a small `offers` table so the portal can show current
-- seasonal/festive discounts without any push infrastructure.
--
-- LOGIN MODEL — phone + PIN, no SMS cost:
-- Customer login is phone number + a PIN, same trust model this app
-- already uses for staff (an admin sets a staff member's password
-- directly — no SMS, no email verification). Staff set a customer's
-- PIN in person from the Customers page ("Portal Access"), which calls
-- the customer-portal-admin Edge Function. There is no self-registration
-- flow and no SMS/OTP provider needed anywhere in this migration.
--
-- A customer's login is stored the same way a staff mobile-number login
-- is: mapped to an internal fake address (e.g.
-- "9876543210@customer.mkoptics.local"), never a real email, with a
-- different suffix than staff logins ("@staff.mkoptics.local") so the
-- two account types can never collide. `customers.auth_user_id` links a
-- customer row to their Supabase Auth user once that login exists.
--
-- CRITICAL SECURITY FIX included in this migration, not optional:
-- Every "staff-only" policy added in migration 002 (and 004's
-- appointment_requests policies) only checked `to authenticated` —
-- true for ANY logged-in Supabase user. That was safe while only staff
-- could ever hold a session. Now that customers can also authenticate,
-- those same policies would let a customer read every OTHER customer's
-- full record, prescriptions, and visit history. This migration
-- replaces every one of those checks with "is this user's id present
-- in staff_profiles" via a new is_staff() helper.
--
-- SECOND FIX, also not optional: staff_profiles' own "insert own
-- profile as employee" policy (migration 010) lets any first-time
-- logged-in user create their own staff_profiles row as 'employee' —
-- that's how auth-gate.js self-provisions a brand new staff login. A
-- logged-in customer would satisfy that same policy and hand
-- themselves staff-level access. This migration narrows it to sessions
-- that are NOT already linked to a customers row — which every
-- customer-portal login always is, by construction, since
-- customer-portal-admin only ever creates a login already linked via
-- auth_user_id. See the matching hardening in auth-gate.js (a rejected
-- self-insert is no longer treated as "employee anyway").
--
-- Safe to re-run: every policy is dropped before being recreated.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Link a customer to their portal login, once one exists.
-- ---------------------------------------------------------------------
alter table customers add column if not exists auth_user_id uuid references auth.users (id) on delete set null;
create unique index if not exists customers_auth_user_id_idx on customers (auth_user_id) where auth_user_id is not null;


-- ---------------------------------------------------------------------
-- Helper: is the current logged-in user a staff member?
-- security definer so it can check staff_profiles regardless of RLS on
-- that table (same pattern as is_time_slot_taken in migration 006).
-- ---------------------------------------------------------------------
create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from staff_profiles where id = auth.uid());
$$;

-- ---------------------------------------------------------------------
-- Helper: the customers.id row belonging to the current logged-in
-- customer, matched via auth_user_id. Returns null for staff (never
-- linked from a customers row) or anyone with no portal login yet.
-- ---------------------------------------------------------------------
create or replace function public.current_customer_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from customers where auth_user_id = auth.uid();
$$;


-- =====================================================================
-- FIX 1 — tighten every existing "staff-only" policy to actually check
-- staff, not just "logged in at all."
-- =====================================================================

drop policy if exists "Logged-in staff can read customers" on customers;
create policy "Logged-in staff can read customers"
  on customers for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can write customers" on customers;
create policy "Logged-in staff can write customers"
  on customers for insert to authenticated with check (is_staff());

drop policy if exists "Logged-in staff can update customers" on customers;
create policy "Logged-in staff can update customers"
  on customers for update to authenticated using (is_staff());

drop policy if exists "Logged-in staff can read visits" on visits;
create policy "Logged-in staff can read visits"
  on visits for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can write visits" on visits;
create policy "Logged-in staff can write visits"
  on visits for insert to authenticated with check (is_staff());

drop policy if exists "Logged-in staff can read leads" on leads;
create policy "Logged-in staff can read leads"
  on leads for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can write leads" on leads;
create policy "Logged-in staff can write leads"
  on leads for insert to authenticated with check (is_staff());

drop policy if exists "Logged-in staff can update leads" on leads;
create policy "Logged-in staff can update leads"
  on leads for update to authenticated using (is_staff());

drop policy if exists "Logged-in staff can read reminders" on reminders;
create policy "Logged-in staff can read reminders"
  on reminders for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can write reminders" on reminders;
create policy "Logged-in staff can write reminders"
  on reminders for insert to authenticated with check (is_staff());

drop policy if exists "Logged-in staff can update reminders" on reminders;
create policy "Logged-in staff can update reminders"
  on reminders for update to authenticated using (is_staff());

drop policy if exists "Logged-in staff can read referrals" on referrals;
create policy "Logged-in staff can read referrals"
  on referrals for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can write referrals" on referrals;
create policy "Logged-in staff can write referrals"
  on referrals for insert to authenticated with check (is_staff());

drop policy if exists "Logged-in staff can update referrals" on referrals;
create policy "Logged-in staff can update referrals"
  on referrals for update to authenticated using (is_staff());

drop policy if exists "Logged-in staff can read appointment requests" on appointment_requests;
create policy "Logged-in staff can read appointment requests"
  on appointment_requests for select to authenticated using (is_staff());

drop policy if exists "Logged-in staff can update appointment requests" on appointment_requests;
create policy "Logged-in staff can update appointment requests"
  on appointment_requests for update to authenticated using (is_staff());

drop policy if exists "Staff can read all profiles" on staff_profiles;
create policy "Staff can read all profiles"
  on staff_profiles for select using (is_staff());


-- =====================================================================
-- FIX 2 — a customer-portal login may never self-provision a
-- staff_profiles row. Only a session with NO matching customers row
-- (i.e. a genuine staff email/mobile+password login) may self-create
-- as 'employee'.
-- =====================================================================

drop policy if exists "Staff can insert own profile as employee" on staff_profiles;
create policy "Staff can insert own profile as employee"
  on staff_profiles for insert
  with check (
    id = auth.uid()
    and role = 'employee'
    and not exists (select 1 from customers where auth_user_id = auth.uid())
  );


-- =====================================================================
-- Customer-facing access: customers may only ever see their OWN row(s),
-- matched via current_customer_id(), never anyone else's. There is no
-- customer self-insert policy on `customers` — a customer's row and
-- their portal login are only ever created together by staff, via the
-- customer-portal-admin Edge Function (service role, bypasses RLS).
-- =====================================================================

drop policy if exists "Customer can read own record" on customers;
create policy "Customer can read own record"
  on customers for select to authenticated
  using (id = public.current_customer_id());

drop policy if exists "Customer can read own visits" on visits;
create policy "Customer can read own visits"
  on visits for select to authenticated
  using (customer_id = public.current_customer_id());


-- =====================================================================
-- Appointment requests: link to a logged-in customer when there is one
-- (the public, no-login booking form keeps working exactly as before —
-- customer_id just stays null for those).
-- =====================================================================

alter table appointment_requests add column if not exists customer_id uuid references customers (id) on delete set null;
create index if not exists appointment_requests_customer_idx on appointment_requests (customer_id);

drop policy if exists "Customer can submit own appointment request" on appointment_requests;
create policy "Customer can submit own appointment request"
  on appointment_requests for insert to authenticated
  with check (customer_id = public.current_customer_id());

drop policy if exists "Customer can read own appointment requests" on appointment_requests;
create policy "Customer can read own appointment requests"
  on appointment_requests for select to authenticated
  using (customer_id = public.current_customer_id());


-- =====================================================================
-- Order consumables (contact lens, solution, etc.)
-- =====================================================================

create table if not exists consumable_orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers (id) on delete cascade,

  item text not null,       -- e.g. "Contact lens solution (usual brand)"
  notes text,
  status text not null default 'requested' check (status in ('requested', 'fulfilled', 'cancelled')),

  created_at timestamptz not null default now()
);

create index if not exists consumable_orders_customer_idx on consumable_orders (customer_id);
create index if not exists consumable_orders_status_idx on consumable_orders (status);

alter table consumable_orders enable row level security;

drop policy if exists "Customer can request own consumable order" on consumable_orders;
create policy "Customer can request own consumable order"
  on consumable_orders for insert to authenticated
  with check (customer_id = public.current_customer_id());

drop policy if exists "Customer can read own consumable orders" on consumable_orders;
create policy "Customer can read own consumable orders"
  on consumable_orders for select to authenticated
  using (customer_id = public.current_customer_id());

drop policy if exists "Staff can read all consumable orders" on consumable_orders;
create policy "Staff can read all consumable orders"
  on consumable_orders for select to authenticated using (is_staff());

drop policy if exists "Staff can update consumable orders" on consumable_orders;
create policy "Staff can update consumable orders"
  on consumable_orders for update to authenticated using (is_staff());


-- =====================================================================
-- Complaints, in any language
-- =====================================================================

create table if not exists complaints (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references customers (id) on delete cascade,

  message text not null,
  language text,     -- best-effort label (e.g. "Hindi"), not enforced
  status text not null default 'open' check (status in ('open', 'resolved')),

  created_at timestamptz not null default now()
);

create index if not exists complaints_customer_idx on complaints (customer_id);
create index if not exists complaints_status_idx on complaints (status);

alter table complaints enable row level security;

drop policy if exists "Customer can submit own complaint" on complaints;
create policy "Customer can submit own complaint"
  on complaints for insert to authenticated
  with check (customer_id = public.current_customer_id());

drop policy if exists "Customer can read own complaints" on complaints;
create policy "Customer can read own complaints"
  on complaints for select to authenticated
  using (customer_id = public.current_customer_id());

drop policy if exists "Staff can read all complaints" on complaints;
create policy "Staff can read all complaints"
  on complaints for select to authenticated using (is_staff());

drop policy if exists "Staff can update complaints" on complaints;
create policy "Staff can update complaints"
  on complaints for update to authenticated using (is_staff());


-- =====================================================================
-- Offers — seasonal/festive discounts shown on the customer portal.
-- =====================================================================

create table if not exists offers (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  valid_until date,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table offers enable row level security;

drop policy if exists "Anyone logged in can read active offers" on offers;
create policy "Anyone logged in can read active offers"
  on offers for select to authenticated
  using (active = true);

drop policy if exists "Staff can manage offers" on offers;
create policy "Staff can manage offers"
  on offers for all to authenticated
  using (is_staff())
  with check (is_staff());
