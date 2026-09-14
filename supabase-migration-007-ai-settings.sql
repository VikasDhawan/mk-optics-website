-- =====================================================================
-- MK Optics — Migration 007: bring-your-own AI keys (Gemini + Groq)
-- =====================================================================
-- Run this in the SQL Editor after migration 006.
--
-- A single settings row holding up to two free-tier AI keys:
--   - gemini_api_key: primary. Google's free tier (no card needed).
--   - groq_api_key: fallback, used automatically only if Gemini's
--     free daily quota is exhausted.
--
-- Only logged-in staff can read or write it — same "staff-only"
-- pattern as every other table. Neither key ever reaches a customer's
-- (or staff member's) browser: the ai-insight Edge Function
-- (supabase/functions/ai-insight) reads them server-side and makes
-- the calls itself.
--
-- "id boolean primary key default true, check (id)" guarantees at
-- most one row can ever exist — a real singleton. Safe to re-run.
-- =====================================================================

create table if not exists ai_settings (
  id boolean primary key default true,
  gemini_api_key text,
  groq_api_key text,
  updated_at timestamptz not null default now(),
  constraint ai_settings_singleton check (id)
);

alter table ai_settings enable row level security;

drop policy if exists "Logged-in staff can manage AI settings" on ai_settings;
create policy "Logged-in staff can manage AI settings"
  on ai_settings for all to authenticated using (true) with check (true);
