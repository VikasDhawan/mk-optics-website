# mk-optics-website
Website prototype for M&K Optics

## Pages

**Public**
- `index.html` — marketing site. "Book an Eye Test" / "Book an
  Appointment" link to `book-appointment.html`.
- `rewards-signup.html` — QR-code sign-up page for customers to join the
  rewards program themselves at the counter. No login; deliberately
  narrow write access (see Security below).
- `book-appointment.html` — online appointment request form (Name,
  Mobile, Preferred Date, Preferred Time, Notes). No login; same
  narrow-write pattern as rewards sign-up. Staff turn each request into
  a real follow-up from the Follow-Ups page.

**Staff (all behind login, all share the same sidebar/navigation)**
- `dashboard.html` — the staff app's home page: key numbers (total
  customers, visits and revenue this month, follow-ups due, open leads,
  pending rewards sign-ups) and a queue to review pending rewards
  sign-ups — add each as a real customer, or dismiss duplicates/spam.
- `counter-intake.html` — look up or add a customer by mobile number,
  capture prescription + purchase, save, and send a WhatsApp confirmation.
  A toggle at the top switches between **Eyewear** and **Contact Lens**
  purchases — each has its own prescription shape (contact lenses drop
  Prism/Base and add Base Curve/Diameter) and purchase fields (Frame +
  Lens vs Brand + Color). Re-opening a customer, or just switching the
  toggle, pre-fills their *last purchase of that specific type* — the
  point being a returning contact lens customer's brand and exact color
  are recalled automatically, since staff often remember the brand but
  not the exact shade.
- `follow-ups.html` — every reminder due today or overdue, with a
  one-tap WhatsApp message and "Mark Done." Also has a "New Appointment
  Requests" queue (online bookings) — "Add to Follow-Ups" finds/creates
  the customer and creates the actual reminder, which is what makes a
  request show up in the list below and on the Calendar.
- `customers.html` — search any customer and see their full contact
  details, preferences/notes (editable), pending reminders, and complete
  purchase + prescription history across every visit. Once a customer
  has 3+ visits, a **Quick Insight** story card appears: one headline
  number (estimated annual value of the relationship), a small bar
  chart of spend over time, one narrative paragraph, and one concrete
  next action — all free, computed instantly in the browser from that
  customer's own numbers, no external service involved. Below it, an
  **"Ask AI for a deeper read"** button (only does anything once a key
  is added on the AI Setup page) sends that same history to Gemini (or
  Groq as an automatic fallback) via the `ai-insight` Edge Function
  with a pre-written, sales-focused prompt, and returns a genuinely
  generated (not templated) insight — useful for reading the free-text
  staff notes across visits, which the free Quick Insight can't do.
  Purchase & Prescription History below that is split into two tabs,
  **Eyewear** and **Contact Lens** — a fundamentally different kind of
  purchase (brand/color instead of frame/lens, a different
  prescription shape), so they're never mixed into one list.
  Name and Mobile Number are editable via a small "✏️ Edit" button next
  to each — deliberately not a plain text field you can click into, so
  a stray click can't silently change a customer's identity. Editing
  the name asks for a type-and-confirm popup; editing the mobile number
  additionally requires typing the new number twice (like a password
  change) so a typo can't slip through unnoticed. Every change is
  logged (old value, new value, who, when) and the last 10 changes to
  that customer's name/mobile show in a "Recent Name/Mobile Changes"
  section, so an accidental edit can always be traced and manually
  corrected.
- `ai-settings.html` — add your own free-tier Google Gemini API key (and
  optionally a Groq key as an automatic backup) to turn on the "Ask AI"
  feature above. Bring-your-own-key: both keys live only in this shop's
  own Supabase project — this app and its other installs never see or
  are involved in anyone's AI usage. Gemini is tried first; if its free
  daily limit is ever used up, the app automatically retries with Groq,
  with nothing for staff to do. If both are used up for the day, "Ask
  AI" says so and suggests a paid ChatGPT Plus/Pro account as a manual
  option (not something the app can call automatically, since it's a
  subscription for a person, not a programmable key). Leave both empty
  and the app works exactly as before, using only the free Quick Insight.
  Visible only to **Super Admin** — the Admin (store owner) can still
  turn the whole feature on/off from Admin Settings, but never sees or
  edits the actual keys.
- `admin-settings.html` — visible to **Admin and Super Admin** only.
  Create new staff logins (name, email, temporary password, role —
  only Super Admin can create another Admin), reset an existing staff
  member's password, and turn the AI Insights feature on/off store-wide.
  Admin can create/reset employees; only Super Admin can create or
  demote an Admin account, matching the role rules below.
- `my-profile.html` — every logged-in staff member's own page: upload a
  photo (shown in the sidebar everywhere, and in the Admin Settings
  staff list), and see their own name/email/role read-only.
- `enquiries.html` — log walk-ins/enquiries who didn't buy, follow up via
  WhatsApp, and convert an enquiry into a real customer record (creating
  one if it doesn't already exist) or mark it lost.
- `referrals.html` — look up the referring customer, log who they
  referred, ask them via WhatsApp, advance status (invited → joined →
  purchased), and track whether each side's discount was given.
- `calendar.html` — a month-grid view of every reminder/appointment by
  date (built ourselves rather than integrating an external calendar
  service — no OAuth, no API keys, no free-tier limits, and it's
  automatically staff-only since it's just another page behind login).
  Click a day to see who's booked.

Every staff page's sidebar shows a red count badge next to "Follow-Ups"
when there are new, unreviewed appointment requests waiting. It also
shows the logged-in person's photo (if they've uploaded one on My
Profile) next to their email.

**Shared**
- `app-shared.css` / `auth-gate.js` — layout, login screen, and the
  staff-login gate used by every staff page above. `auth-gate.js` also
  looks up (or, on first login, creates) the signed-in person's role
  from `staff_profiles` and exposes it as `window.MKAuth.role` /
  `window.MKAuth.roleReady` for pages to hide or show things by role.
  A fix or design change here applies everywhere at once. Any new
  staff page should reuse both rather than copying its own version.

### Staff roles

Three roles, each strictly a superset of the one below it:

| Role | Who | Can do |
|---|---|---|
| **Employee** | Normal staff | Everything except the two rows below — Counter Intake, Customers, Follow-Ups, Enquiries, Referrals, Calendar, and uploading their own photo on My Profile. |
| **Admin** | The store owner | Everything Employee can, **plus**: the "✏️ Edit" pencils next to a customer's Name/Mobile Number, Admin Settings (add employee logins, reset an employee's password, turn AI Insights on/off store-wide). |
| **Super Admin** | The developer (you) | Everything Admin can, **plus**: AI Setup (the actual Gemini/Groq keys — Admin only sees an on/off switch, never the keys), creating or demoting Admin accounts, resetting anyone's password including another Admin's. |

New logins created directly in the Supabase dashboard (rather than
through Admin Settings) default to Employee the first time they sign
in — see the one-time "make yourself Super Admin" step in migration 010
below. This role model is enforced two ways: the UI hides what a role
shouldn't see, and the database (Row Level Security) independently
refuses role changes and AI-key access outside these rules — so it
isn't just a matter of which buttons are visible.

## Setting up (Supabase)

The app stores everything in [Supabase](https://supabase.com) (free tier
is enough).

1. Create a free project at supabase.com.
2. SQL Editor → run `supabase-schema.sql`. Creates `customers`, `visits`,
   `leads`, `reminders`, `referrals` — each with a plain-English comment
   explaining what it's for.
3. Copy `supabase-config.example.js` to `supabase-config.js`, fill in your
   project's URL and anon/public key (Project Settings → API Keys).
   `supabase-config.js` is gitignored — your keys don't need to be
   committed.
4. Create your own first staff account: Authentication → Users → **Add
   user** — Email + password (doesn't need to be a real inbox; accounts
   are created directly here, not via self-signup — this is the one
   account that has to be made this way, since Admin Settings itself
   doesn't exist yet without being logged in as someone). Turn on "Auto
   Confirm" if offered. Every staff account *after* this one is created
   through Admin Settings instead (see the Roles section below), where
   you can type a mobile number instead of an email — see "Staff
   login" for why this one bootstrap account still needs a real email
   typed directly into Supabase.
5. SQL Editor → run `supabase-migration-002-require-login.sql`. Locks the
   database to "only logged-in staff can read/write" — run this *after*
   step 4, so you have a way to log in once it's locked.
6. SQL Editor → run `supabase-migration-003-reward-signups.sql`. Adds the
   `reward_signups` table the public sign-up page writes to.
7. SQL Editor → run `supabase-migration-004-appointments.sql`. Adds the
   `appointment_requests` table the booking page writes to.
8. SQL Editor → run `supabase-migration-005-appointment-time.sql`. Adds
   the preferred-time column to `appointment_requests`.
9. SQL Editor → run `supabase-migration-006-slot-conflicts.sql`. Adds a
   preferred-time column to `reminders` and a narrow yes/no function the
   booking page uses to stop double-booking the same date and time.
10. SQL Editor → run `supabase-migration-007-ai-settings.sql`. Adds the
    (empty, optional) table that holds a shop's own AI keys — required
    for the "Ask AI" feature to exist at all, but the app works fully
    without ever filling it in.
11. **Optional, only if you want "Ask AI" to work**: first install the
    Supabase CLI if you don't have it (`npm install -g supabase`, or see
    supabase.com/docs/guides/cli), then from this repo's folder run:
    `supabase login`, `supabase link --project-ref <your-project-ref>`,
    and `supabase functions deploy ai-insight`. Then open
    `ai-settings.html`, get a free key at aistudio.google.com/apikey
    (no card needed), paste it in under Gemini, and click "Test
    Connection." Optionally also add a free Groq key from
    console.groq.com/keys as an automatic backup. Skip this step
    entirely and the app works exactly as before.
12. SQL Editor → run `supabase-migration-008-contact-lens.sql`. Adds
    contact-lens-specific columns (brand, color, base curve, diameter)
    to `visits`, needed for the Contact Lens purchase type on Counter
    Intake and its tab on the Customers page.
13. SQL Editor → run `supabase-migration-009-customer-edit-log.sql`. Adds
    the table that records every name/mobile-number change made on the
    Customers page, so accidental edits can be traced.
14. SQL Editor → run `supabase-migration-010-roles.sql`. Adds the
    `staff_profiles` table (role/name/photo — this is what Admin
    Settings, the Edit pencils, and AI Setup all check), and the
    `avatars` storage bucket for My Profile photo uploads. **Then**,
    the one manual step this whole role system needs: log into the app
    once with your own account (so your row gets created), then in the
    SQL Editor run —
    ```sql
    update staff_profiles set role = 'super_admin'
    where id = (select id from auth.users where email = 'you@example.com');
    ```
    (replace with your real staff login email). Every other account
    stays Employee until you or an Admin change it — new Admin accounts
    are created from Admin Settings itself once you've done this once.
15. SQL Editor → run `supabase-migration-011-app-settings.sql`. Adds the
    store-wide switches table (currently just "is AI Insights on") and
    locks the `ai_settings` (Gemini/Groq keys) table down to Super Admin
    only — Admin can flip the on/off switch but never sees the keys.
16. Deploy the new `staff-admin` Edge Function — same one-time CLI setup
    as step 11 if you haven't already (`supabase login`, `supabase link
    --project-ref <your-project-ref>`), then:
    `supabase functions deploy staff-admin`. This is what lets Admin
    Settings actually create staff logins and reset passwords — without
    it, Admin Settings will load but those two actions will fail.
17. Open `counter-intake.html` (or any staff page) in a browser, or serve
    the folder with any static file server. Sign in with the account from
    step 4.

### Staff login

Supabase's built-in login (Supabase Auth) — no custom password code.
Staff can sign in with **either a mobile number or an email**, plus a
password; no self-registration (accounts are only created via Admin
Settings, or directly in Authentication → Users). Sessions persist
until "Sign out" (bottom of the sidebar). Forgotten password → Admin
or Super Admin resets it from Admin Settings.

Supabase Auth itself only understands email+password — its native
phone sign-in needs a paid SMS provider even just to verify a number,
which isn't worth the friction for a password-only login. So a plain
10-digit mobile number typed on the login screen (or in Admin
Settings' "Add New Staff" form) is converted, only inside the browser,
into a fake address like `9876543210@staff.mkoptics.local` before
being sent to Supabase — nothing is ever actually emailed there, it's
just used as a unique login ID. Everywhere the app shows who's logged
in (the sidebar, My Profile, the Admin Settings staff list), that fake
address is converted back to just the number for display. A real email
address, if someone prefers one, is passed through unchanged — both
work side by side.

### Security model

- Staff pages: RLS requires a logged-in session for every read/write.
- `rewards-signup.html` and `book-appointment.html`: no login, by design
  (customers fill these in themselves). Rather than reopening the main
  `customers`/`reminders` tables to anonymous writes, anonymous visitors
  may only **insert** into separate, narrow tables (`reward_signups`,
  `appointment_requests`) — they can't read them back, so one customer
  can't see another's submission. Staff review and convert these into
  real records from the **Dashboard** (sign-ups) and **Follow-Ups**
  (appointment requests).
- `book-appointment.html` also calls `is_time_slot_taken(date, time)`, a
  database function that answers only true/false for one exact slot —
  it can see into `reminders`/`appointment_requests` to check, but never
  returns any row data, so a customer can check availability without
  ever seeing the store's calendar or other people's bookings.
- Staff roles (Employee / Admin / Super Admin — see the table above)
  gate the sensitive actions: editing a customer's name/mobile,
  creating staff logins, resetting passwords, and the AI keys
  themselves. Everything else (sale amounts, prescriptions, customer
  notes) is still visible to every logged-in staff account — the app
  doesn't restrict *viewing* data by role, only the handful of actions
  listed above.
- The AI keys (`ai_settings.gemini_api_key` / `groq_api_key`) are
  readable/writable only by **Super Admin** (enforced by RLS, not just
  hidden in the UI) — Admin can turn the AI Insights feature on/off from
  Admin Settings (a separate `app_settings.ai_enabled` switch) without
  ever seeing the keys. Regardless of who can read them, neither key is
  ever sent to or read from any browser during normal "Ask AI" use: the
  `ai-insight` Edge Function reads them server-side (using the
  service-role connection, which bypasses RLS the same way any trusted
  backend process would) and makes the Gemini/Groq API call itself; the
  browser only ever receives the finished text answer.
- Creating a staff login or resetting a password happens through the
  `staff-admin` Edge Function, never directly from the browser —
  Supabase's regular client library has no "create another user" or
  "set someone else's password" call using the public anon key, by
  design. The function itself re-checks the caller's role server-side
  before doing anything (an Admin calling it can't create another Admin
  or reset another Admin's password just by editing the request).

### WhatsApp messages

Every "send via WhatsApp" button opens a `wa.me` click-to-chat link
pre-filled with a message — free, no WhatsApp Business API account
needed, but a staff member must tap send in the window that opens.

## Deliberately not built yet

- **A trained AI recommendation engine** (what to sell next across the
  whole customer base, contact-lens refill timing patterns learned from
  many shops' data) — the growth-system plan this schema is based on
  marks this "Future Feature, needs 6-12 months of data" across many
  customers. What IS built: a free rule-based "Quick Insight" on every
  customer's own history (no data collection period needed), plus an
  optional "Ask AI" button that calls Claude directly with a
  pre-written prompt if a shop adds their own API key (see
  `ai-settings.html`) — genuinely generated insight, not a template,
  but still reading one customer's history at a time rather than
  learning patterns across the whole customer base.
- **Fine-grained per-staff permissions beyond the three roles** (e.g.
  restricting a specific employee from seeing sale amounts, or
  per-branch access) — Employee/Admin/Super Admin is deliberately the
  whole model for now.

## Testing

Every page's logic (search, save, status changes, conversions) was
verified with a scripted browser run against a mock Supabase client
before being handed off — not just checked for syntax. Live end-to-end
testing against a real Supabase project still needs to happen in an
ordinary browser, since this development environment's network cannot
reach Supabase's servers.

## Project documentation

The product requirements, technical architecture, data model, API spec,
non-functional requirements, roadmap, and statement of work behind this
build live in [`docs/`](docs/README.md). Standalone review pages (a
client-facing growth-plan proposal, and a clickable pre-Supabase UI
prototype) are in [`prototype/`](prototype/index.html) — kept for
reference; the pages above are the real, working implementation.
