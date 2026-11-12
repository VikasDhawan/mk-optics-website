-- Migration 021: add Dr to the salutation options (Mr / Ms / Mrs / Dr).
-- Run after migration 020. Safe to re-run.

alter table staff_profiles drop constraint if exists staff_profiles_salutation_check;
alter table staff_profiles add constraint staff_profiles_salutation_check
  check (salutation in ('Mr', 'Ms', 'Mrs', 'Dr'));
