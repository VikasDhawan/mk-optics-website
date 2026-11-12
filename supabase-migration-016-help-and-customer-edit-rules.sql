-- Migration 016: Help articles with role-based visibility, and Admin-only
-- customer edits.
--
-- Role ranks: employee (1) < admin (2) < super_admin (3).
-- An article is visible to a staff member whose rank is >= the article's min_role.
-- Enforced in the database by RLS, so employees never receive restricted text.

-- ---------------------------------------------------------------------
-- Role helpers (security definer so they can read staff_profiles).
-- ---------------------------------------------------------------------
create or replace function public.role_rank(r text)
returns int
language sql
immutable
as $$
  select case r when 'employee' then 1 when 'admin' then 2 when 'super_admin' then 3 else 0 end;
$$;

create or replace function public.current_staff_rank()
returns int
language sql
stable
security definer
set search_path = public
as $$
  select public.role_rank(role) from staff_profiles where id = auth.uid();
$$;

-- ---------------------------------------------------------------------
-- help_articles
-- ---------------------------------------------------------------------
create table if not exists help_articles (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  section_no int not null,
  title text not null,
  body_md text not null default '',
  min_role text not null default 'employee'
    check (min_role in ('employee', 'admin', 'super_admin')),
  sort_order int not null default 0,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users (id) on delete set null
);

create index if not exists help_articles_order_idx on help_articles (section_no, sort_order);

alter table help_articles enable row level security;

-- Read: any staff member, but only articles at or below their own rank.
drop policy if exists "Staff read help articles at their role" on help_articles;
create policy "Staff read help articles at their role"
  on help_articles for select to authenticated
  using (public.is_staff() and public.role_rank(min_role) <= public.current_staff_rank());

-- Write: Super Admin only (the program owner maintains the manual).
drop policy if exists "Super Admin inserts help articles" on help_articles;
create policy "Super Admin inserts help articles"
  on help_articles for insert to authenticated
  with check (public.current_staff_rank() = 3);

drop policy if exists "Super Admin updates help articles" on help_articles;
create policy "Super Admin updates help articles"
  on help_articles for update to authenticated
  using (public.current_staff_rank() = 3)
  with check (public.current_staff_rank() = 3);

drop policy if exists "Super Admin deletes help articles" on help_articles;
create policy "Super Admin deletes help articles"
  on help_articles for delete to authenticated
  using (public.current_staff_rank() = 3);

-- ---------------------------------------------------------------------
-- Customers: only Admin / Super Admin may modify a customer record.
-- Employees keep read access and may still create new customers (the
-- insert policy from migration 012 is unchanged).
-- ---------------------------------------------------------------------
drop policy if exists "Logged-in staff can update customers" on customers;
drop policy if exists "Admins can update customers" on customers;
create policy "Admins can update customers"
  on customers for update to authenticated
  using (public.current_staff_rank() >= 2)
  with check (public.current_staff_rank() >= 2);
