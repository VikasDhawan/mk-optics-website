-- Records every change made to a customer's name or mobile number, so an
-- accidental edit (fat-fingered phone number, wrong name typed in) can be
-- traced back and manually corrected. The Customers page writes one row
-- here every time staff confirm a name/phone change through the "Edit"
-- button — never on any other field, and never automatically.
create table if not exists customer_edit_log (
    id uuid primary key default gen_random_uuid(),
    customer_id uuid references customers(id) on delete cascade,
    field text not null,
    old_value text,
    new_value text,
    changed_by text,
    created_at timestamptz not null default now()
);

alter table customer_edit_log enable row level security;

create policy "Staff can read edit log"
    on customer_edit_log for select
    using (auth.role() = 'authenticated');

create policy "Staff can insert edit log"
    on customer_edit_log for insert
    with check (auth.role() = 'authenticated');
