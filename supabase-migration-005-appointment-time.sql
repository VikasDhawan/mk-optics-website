-- =====================================================================
-- MK Optics — Migration 005: add a time to appointment requests
-- =====================================================================
-- Run this in the SQL Editor after migration 004.
--
-- The booking form originally only captured a preferred DATE, so staff
-- had no way to know what time a customer wanted — this adds an
-- optional preferred_time column alongside it. Safe to re-run.
-- =====================================================================

alter table appointment_requests add column if not exists preferred_time time;
