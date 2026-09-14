-- =====================================================================
-- MK Optics — Migration 007: bring-your-own AI key
-- =====================================================================
-- Run this in the SQL Editor after migration 006.
--
-- A single settings row where staff paste their own Anthropic API key
-- (see ai-settings.html). Only logged-in staff can read or write it —
-- same "staff-only" pattern as every other table. The key never
-- reaches the AI provider from the customer's browser: the ai-insight
-- Edge Function (supabase/functions/ai-insight) reads it server-side
-- and makes the call itself, so the key is never sent to, or visible
-- from, any browser tab.
--
-- "id boolean primary key default true, check (id)" is a standard
-- trick to guarantee at most one row ever exists — a real singleton.
-- Safe to re-run.
-- =====================================================================

create table if not exists ai_settings (
  id boolean primary key default true,
  provider text not null default 'anthropic',
  api_key text,
  updated_at timestamptz not null default now(),
  constraint ai_settings_singleton check (id)
);

alter table ai_settings enable row level security;

drop policy if exists "Logged-in staff can manage AI settings" on ai_settings;
create policy "Logged-in staff can manage AI settings"
  on ai_settings for all to authenticated using (true) with check (true);
