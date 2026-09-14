-- =====================================================================
-- MK Optics — Migration 006: prevent double-booked appointment slots
-- =====================================================================
-- Run this in the SQL Editor after migration 005.
--
-- Problem: the public booking page had no idea what times were already
-- taken, so two customers could pick the same date and time.
--
-- Fix: a single function, is_time_slot_taken(date, time), that answers
-- only true/false for one exact slot. It runs as SECURITY DEFINER so it
-- can see into `reminders` and `appointment_requests` to check, but it
-- never returns any row data — no names, no phone numbers, no list of
-- other bookings — so the public form can call it without ever seeing
-- the store's calendar. Anonymous visitors still cannot SELECT from
-- either table directly; only this narrow yes/no check is exposed.
--
-- Also adds a preferred_time column to `reminders`, so once staff turn
-- a request into a real follow-up, its time is stored as real data (not
-- just text buried in notes) and keeps blocking that slot. And splits
-- "Dismiss" into its own `dismissed` status, distinct from `reviewed`,
-- so a dismissed request correctly frees up its slot again.
--
-- Safe to re-run.
-- =====================================================================

alter table reminders add column if not exists preferred_time time;

create or replace function public.is_time_slot_taken(p_date date, p_time time)
returns boolean
language sql
security definer
set search_path = public
as $$
  select
    exists (
      select 1 from reminders
      where due_date = p_date and preferred_time = p_time and status = 'pending'
    )
    or exists (
      select 1 from appointment_requests
      where preferred_date = p_date and preferred_time = p_time and status = 'new'
    );
$$;

grant execute on function public.is_time_slot_taken(date, time) to anon, authenticated;
