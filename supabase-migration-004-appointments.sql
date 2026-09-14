-- =====================================================================
-- MK Optics — Migration 004: online appointment requests
-- =====================================================================
-- Run this in the SQL Editor after migrations 002 and 003.
--
-- Same shape as migration 003's reward_signups: the booking page
-- (book-appointment.html) has no login (customers fill it in
-- themselves), so anonymous visitors may only INSERT here, never read
-- the list back. Staff review these on the Follow-Ups page and turn
-- each into a real `reminders` row — that's the point a request
-- actually becomes a customer-linked follow-up and shows up on the
-- calendar. Safe to re-run (every policy is dropped before recreated).
-- =====================================================================

create table if not exists appointment_requests (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  preferred_date date,
  notes text,
  status text not null default 'new', -- new | reviewed
  created_at timestamptz not null default now()
);

create index if not exists appointment_requests_status_idx on appointment_requests (status);

alter table appointment_requests enable row level security;

drop policy if exists "Anyone can submit an appointment request" on appointment_requests;
create policy "Anyone can submit an appointment request"
  on appointment_requests for insert to anon, authenticated with check (true);

drop policy if exists "Logged-in staff can read appointment requests" on appointment_requests;
create policy "Logged-in staff can read appointment requests"
  on appointment_requests for select to authenticated using (true);

drop policy if exists "Logged-in staff can update appointment requests" on appointment_requests;
create policy "Logged-in staff can update appointment requests"
  on appointment_requests for update to authenticated using (true);
