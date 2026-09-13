-- =====================================================================
-- MK Optics — Migration 002: require staff login
-- =====================================================================
-- Run this AFTER you have created at least one staff account (Supabase
-- dashboard > Authentication > Users > Add user), so you don't lock
-- yourself out of the app before you have a way back in.
--
-- This replaces the temporary "anyone with the app link can read/write"
-- rules from supabase-schema.sql with "only logged-in staff can
-- read/write." Run this in the SQL Editor just like the first file.
-- =====================================================================

drop policy if exists "Anyone with the app can read customers (testing only)" on customers;
drop policy if exists "Anyone with the app can write customers (testing only)" on customers;
drop policy if exists "Anyone with the app can update customers (testing only)" on customers;

drop policy if exists "Anyone with the app can read visits (testing only)" on visits;
drop policy if exists "Anyone with the app can write visits (testing only)" on visits;

drop policy if exists "Anyone with the app can read leads (testing only)" on leads;
drop policy if exists "Anyone with the app can write leads (testing only)" on leads;
drop policy if exists "Anyone with the app can update leads (testing only)" on leads;

drop policy if exists "Anyone with the app can read reminders (testing only)" on reminders;
drop policy if exists "Anyone with the app can write reminders (testing only)" on reminders;
drop policy if exists "Anyone with the app can update reminders (testing only)" on reminders;

drop policy if exists "Anyone with the app can read referrals (testing only)" on referrals;
drop policy if exists "Anyone with the app can write referrals (testing only)" on referrals;
drop policy if exists "Anyone with the app can update referrals (testing only)" on referrals;

create policy "Logged-in staff can read customers"
  on customers for select to authenticated using (true);
create policy "Logged-in staff can write customers"
  on customers for insert to authenticated with check (true);
create policy "Logged-in staff can update customers"
  on customers for update to authenticated using (true);

create policy "Logged-in staff can read visits"
  on visits for select to authenticated using (true);
create policy "Logged-in staff can write visits"
  on visits for insert to authenticated with check (true);

create policy "Logged-in staff can read leads"
  on leads for select to authenticated using (true);
create policy "Logged-in staff can write leads"
  on leads for insert to authenticated with check (true);
create policy "Logged-in staff can update leads"
  on leads for update to authenticated using (true);

create policy "Logged-in staff can read reminders"
  on reminders for select to authenticated using (true);
create policy "Logged-in staff can write reminders"
  on reminders for insert to authenticated with check (true);
create policy "Logged-in staff can update reminders"
  on reminders for update to authenticated using (true);

create policy "Logged-in staff can read referrals"
  on referrals for select to authenticated using (true);
create policy "Logged-in staff can write referrals"
  on referrals for insert to authenticated with check (true);
create policy "Logged-in staff can update referrals"
  on referrals for update to authenticated using (true);
