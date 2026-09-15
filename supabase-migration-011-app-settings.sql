-- App-wide settings the store owner (Admin) can toggle, plus locking the
-- AI API keys down to Super Admin only.

-- A single-row table (same singleton pattern as ai_settings) for switches
-- that Admin — not just Super Admin — is allowed to flip. Today that's
-- just "is the Ask AI feature turned on at all," but it's a home for
-- future admin-level toggles too.
create table if not exists app_settings (
    id boolean primary key default true,
    ai_enabled boolean not null default true,
    updated_at timestamptz not null default now(),
    constraint app_settings_singleton check (id)
);

insert into app_settings (id) values (true) on conflict (id) do nothing;

alter table app_settings enable row level security;

create policy "Staff can read app settings"
    on app_settings for select
    using (auth.role() = 'authenticated');

-- Only Admin/Super Admin may flip these switches.
create policy "Admins can update app settings"
    on app_settings for update
    using (
        exists (
            select 1 from staff_profiles
            where id = auth.uid() and role in ('admin', 'super_admin')
        )
    );

-- Tighten the AI keys themselves to Super Admin only — the store owner
-- (Admin) can turn the feature on/off via app_settings above, but never
-- sees or edits the actual Gemini/Groq keys.
drop policy if exists "Logged-in staff can manage AI settings" on ai_settings;

create policy "Super Admin can read AI settings"
    on ai_settings for select
    using (
        exists (
            select 1 from staff_profiles
            where id = auth.uid() and role = 'super_admin'
        )
    );

create policy "Super Admin can write AI settings"
    on ai_settings for insert
    with check (
        exists (
            select 1 from staff_profiles
            where id = auth.uid() and role = 'super_admin'
        )
    );

create policy "Super Admin can update AI settings"
    on ai_settings for update
    using (
        exists (
            select 1 from staff_profiles
            where id = auth.uid() and role = 'super_admin'
        )
    );
