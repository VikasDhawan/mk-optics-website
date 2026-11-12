-- Migration 017: section titles for Help, and first seed articles.
-- Run once in the SQL Editor (it bypasses row-level security, as intended for seeding).
-- Safe to re-run: existing slugs are left alone.
--
-- Seed articles below cover only what has been checked against the app.
-- Other topics (Enquiries, Referrals, Orders, Messages, Calendar, Dashboard)
-- are added once the manual outline is agreed.

alter table help_articles add column if not exists section_title text not null default 'Help';

insert into help_articles (slug, section_no, section_title, title, body_md, min_role, sort_order) values

('welcome', 0, 'Getting started', 'How this Help section works',
'This Help section shows only the topics your role allows. If you can''t see a topic, it is handled by an Admin or Super Admin.

- **Employee:** everyday customer and counter work.
- **Admin:** everything an Employee does, plus customer edits and adding staff.
- **Super Admin:** everything, including AI Setup and writing Help articles.',
'employee', 1),

('logging-in', 0, 'Getting started', 'Logging in',
'Log in with your **10-digit mobile number** and the password your Admin gave you.

- Type the 10 digits only. Do not add +91 or spaces.
- You do not need to change the password after your first login.
- If login fails, check the number and password with your Admin.',
'employee', 2),

('add-customer', 1, 'Customers', 'Adding a new customer',
'Employees can add a new customer from the Counter Intake page. Employees can also record visit details for a customer.

Employees cannot change an existing customer''s details. Ask an Admin if a detail needs correcting.',
'employee', 1),

('edit-customer', 1, 'Customers', 'Editing a customer',
'Only Admin and Super Admin can change a customer''s name or mobile number, or any other details on an existing record.

On the Customers page, click **✏️ Edit** next to the name or mobile number. Employees do not see these buttons.',
'admin', 2),

('prescription-consent', 1, 'Customers', 'Recording prescription consent',
'Before you save a customer''s prescription, ask the customer to agree, then tick **Customer consent** on the Counter Intake page.

- The tick clears after each save, so every new prescription needs a fresh tick.
- If the box is not ticked, the prescription will not save.',
'employee', 3),

('guardian-consent', 1, 'Customers', 'Under-18 customers and guardian consent',
'When you add a customer who is under 18 at the counter, record the guardian''s consent with the customer''s details. The app saves that consent with the date and the staff member who recorded it.',
'employee', 4),

('add-staff', 2, 'Admin: staff', 'Adding a staff member',
'Go to **Admin Settings → Add New Staff**.

- Enter the person''s name and 10-digit mobile number.
- Enter a temporary password of at least 8 characters.
- Give the mobile number and password to the person directly. They cannot register themselves.
- Admins can add Employees. Only Super Admin can add another Admin.',
'admin', 1),

('reset-password', 2, 'Admin: staff', 'Resetting a staff password',
'Go to **Admin Settings** and use the reset option next to the person''s name.

- Admins can reset passwords for Employees.
- Only Super Admin can reset an Admin''s password.
- Share the new temporary password directly with the person.',
'admin', 2),

('ai-setup', 3, 'Super Admin only', 'AI Setup',
'AI Setup is available to Super Admin only. This page will be documented when AI Setup is live.',
'super_admin', 1)

on conflict (slug) do nothing;
