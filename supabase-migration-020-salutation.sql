-- Migration 020: salutation on staff profiles (Mr / Ms / Mrs).
-- Used only to choose the default profile silhouette in the sidebar.
-- Staff set their own on My Profile (the existing "update own profile" policy
-- already allows this). Safe to re-run.

alter table staff_profiles add column if not exists salutation text
  check (salutation in ('Mr', 'Ms', 'Mrs'));
