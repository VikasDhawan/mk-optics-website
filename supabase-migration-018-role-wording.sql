-- Migration 018: keep role words out of articles that other roles can see.
-- Employees must never see the word "Admin"; Admins must never see "Super Admin".
-- Safe to re-run.

update help_articles set body_md = $$This Help section shows only the topics for your login. If a topic isn't on your screen, it is handled by your manager.

- Use the sidebar to move between pages.
- Each topic opens when you tap or click its heading.$$
where slug = 'welcome';

update help_articles set body_md = $$Log in with your **10-digit mobile number** and the password your manager gave you.

- Type the 10 digits only. Do not add +91 or spaces.
- You do not need to change the password after your first login.
- If login fails, check the number and password with your manager.$$
where slug = 'logging-in';

update help_articles set body_md = $$You can add a new customer from the Counter Intake page, and record visit details for a customer.

You can't change an existing customer's details. Ask your manager if a detail needs correcting.$$
where slug = 'add-customer';

-- Admin-level articles: no "Super Admin" wording.
update help_articles set body_md = $$You can add Employees from Admin Settings. Adding another Admin account isn't available from your login.

- Enter the person's name and 10-digit mobile number.
- Enter a temporary password of at least 8 characters.
- Give the mobile number and password to the person directly. They cannot register themselves.$$
where slug = 'add-staff';

update help_articles set body_md = $$Go to **Admin Settings** and use the reset option next to the person's name.

- You can reset passwords for Employees.
- Passwords for other Admin accounts can't be reset from your login.
- Share the new temporary password directly with the person.$$
where slug = 'reset-password';

insert into help_articles (slug, section_no, section_title, title, body_md, min_role, sort_order) values

('admin-access', 2, 'Admin: staff', 'What Admins can do',
$$As an Admin you can do everything an Employee can, plus:

- Edit a customer's name, mobile number and other details.
- Add Employees and reset their passwords.$$,
'admin', 3),

('admin-accounts', 3, 'Super Admin only', 'Managing Admin accounts',
$$Only Super Admin can manage Admin accounts.

- Create a new Admin account when someone needs Admin access.
- Reset the password of any Admin account.

Admins can't reset each other's passwords, and Employees can't reset any Admin password.$$,
'super_admin', 2)

on conflict (slug) do nothing;
