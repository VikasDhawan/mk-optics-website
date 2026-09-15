-- Staff roles & governance.
--
-- Three roles: 'super_admin' (the developer/owner of the program itself),
-- 'admin' (the store owner — day-to-day access control, can edit customer
-- records, add staff, reset staff passwords), and 'employee' (normal
-- staff — everything except the above). Every staff login gets exactly
-- one row here.

create table if not exists staff_profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    role text not null default 'employee' check (role in ('super_admin', 'admin', 'employee')),
    name text,
    photo_url text,
    created_at timestamptz not null default now()
);

alter table staff_profiles enable row level security;

-- Every logged-in staff member can read everyone's profile (name/photo/role
-- are shown around the app — e.g. the "changed by" log, the Admin Settings
-- staff list — none of it is sensitive).
create policy "Staff can read all profiles"
    on staff_profiles for select
    using (auth.role() = 'authenticated');

-- A user may only ever update their own row directly (e.g. uploading their
-- own photo) — never someone else's.
create policy "Staff can update own profile"
    on staff_profiles for update
    using (id = auth.uid());

-- A user may set up their own row on first login, but only as 'employee' —
-- promotions to admin/super_admin only ever happen via the staff-admin
-- Edge Function (service-role, bypasses RLS), never from the browser.
create policy "Staff can insert own profile as employee"
    on staff_profiles for insert
    with check (id = auth.uid() and role = 'employee');

-- Belt-and-braces: even though the update policy's USING clause already
-- limits *which row* a user can touch, Postgres RLS has no built-in way to
-- stop someone from changing their *own* role column in that same row via
-- a plain client-side update() call. This trigger blocks any role change
-- unless it comes from the service-role connection (which is what the
-- staff-admin Edge Function uses for promotions/demotions).
create or replace function prevent_self_role_change()
returns trigger as $$
begin
    if new.role is distinct from old.role and auth.role() <> 'service_role' then
        raise exception 'Only an Admin/Super Admin action can change a staff role.';
    end if;
    return new;
end;
$$ language plpgsql security definer;

drop trigger if exists staff_profiles_prevent_self_role_change on staff_profiles;
create trigger staff_profiles_prevent_self_role_change
    before update on staff_profiles
    for each row execute function prevent_self_role_change();

-- Storage bucket for staff photos. Public read (a small headshot isn't
-- sensitive and needs to load in <img> tags without a signed URL), but
-- only the owning staff member can upload/replace/delete their own file.
-- Convention: each file is named "<user-id>.jpg" (or .png/.webp) directly
-- in the bucket root, so the policy can check the filename against auth.uid().
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy "Anyone can view avatars"
    on storage.objects for select
    using (bucket_id = 'avatars');

create policy "Staff can upload their own avatar"
    on storage.objects for insert
    with check (
        bucket_id = 'avatars'
        and auth.role() = 'authenticated'
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );

create policy "Staff can replace their own avatar"
    on storage.objects for update
    using (
        bucket_id = 'avatars'
        and auth.role() = 'authenticated'
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );

create policy "Staff can delete their own avatar"
    on storage.objects for delete
    using (
        bucket_id = 'avatars'
        and auth.role() = 'authenticated'
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );

-- IMPORTANT — one-time manual step after running this migration:
-- Make yourself Super Admin (replace with your real staff login email):
--
--   update staff_profiles set role = 'super_admin'
--   where id = (select id from auth.users where email = 'you@example.com');
--
-- If you haven't logged into the app even once since running this
-- migration, the row won't exist yet — log in once first (it self-creates
-- as 'employee' on first login), then run the update above.
