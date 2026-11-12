-- Migration 022: log every Excel data download.
-- Run after migration 021. Safe to re-run.
-- Admins and Super Admins can record a download; only Super Admins can read the log.

create table if not exists data_exports (
  id uuid primary key default gen_random_uuid(),
  exported_by uuid references auth.users (id) on delete set null,
  exported_by_email text,
  file_name text not null,
  tables_exported text[] not null default '{}',
  row_counts jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table data_exports enable row level security;

drop policy if exists "Admins can record exports" on data_exports;
create policy "Admins can record exports" on data_exports
  for insert to authenticated
  with check (current_staff_rank() >= 2 and exported_by = auth.uid());

drop policy if exists "Super Admins can read export log" on data_exports;
create policy "Super Admins can read export log" on data_exports
  for select to authenticated
  using (current_staff_rank() >= 3);
