-- =====================================================================
-- MK Optics — Migration 013: close a storage policy gap for customers
-- =====================================================================
-- Run this in the SQL Editor after migration 012.
--
-- The `avatars` storage bucket's upload/replace/delete policies (from
-- migration 010) checked `auth.role() = 'authenticated'` — true for
-- ANY logged-in Supabase user, not just staff. That was safe when only
-- staff could ever hold a session; now that customers can log in via
-- customer-portal.html too, a customer session could upload/overwrite
-- a file in this PUBLIC bucket (their own UID as the filename, so it
-- wouldn't overwrite a real staff photo — low severity, but still an
-- unintended write path with no legitimate use, plus needless storage
-- cost). Same is_staff() fix as everywhere else.
--
-- Safe to re-run: every policy is dropped before being recreated.
-- =====================================================================

drop policy if exists "Staff can upload their own avatar" on storage.objects;
create policy "Staff can upload their own avatar"
    on storage.objects for insert
    with check (
        bucket_id = 'avatars'
        and public.is_staff()
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );

drop policy if exists "Staff can replace their own avatar" on storage.objects;
create policy "Staff can replace their own avatar"
    on storage.objects for update
    using (
        bucket_id = 'avatars'
        and public.is_staff()
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );

drop policy if exists "Staff can delete their own avatar" on storage.objects;
create policy "Staff can delete their own avatar"
    on storage.objects for delete
    using (
        bucket_id = 'avatars'
        and public.is_staff()
        and (storage.filename(name)) like (auth.uid()::text || '.%')
    );
