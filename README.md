# mk-optics-website
Website prototype for M&K Optics

## Pages

**Public**
- `index.html` — marketing site.
- `rewards-signup.html` — QR-code sign-up page for customers to join the
  rewards program themselves at the counter. No login; deliberately
  narrow write access (see Security below).

**Staff (all behind login, all share the same sidebar/navigation)**
- `dashboard.html` — the staff app's home page: key numbers (total
  customers, visits and revenue this month, follow-ups due, open leads,
  pending rewards sign-ups) and a queue to review pending rewards
  sign-ups — add each as a real customer, or dismiss duplicates/spam.
- `counter-intake.html` — look up or add a customer by mobile number,
  capture prescription + purchase, save, and send a WhatsApp confirmation.
- `follow-ups.html` — every reminder due today or overdue, with a
  one-tap WhatsApp message and "Mark Done."
- `customers.html` — search any customer and see their full contact
  details, preferences/notes (editable), pending reminders, and complete
  purchase + prescription history across every visit.
- `leads.html` — log walk-ins/enquiries who didn't buy, follow up via
  WhatsApp, and convert a lead into a real customer record (creating one
  if it doesn't already exist) or mark it lost.
- `referrals.html` — look up the referring customer, log who they
  referred, ask them via WhatsApp, advance status (invited → joined →
  purchased), and track whether each side's discount was given.

**Shared**
- `app-shared.css` / `auth-gate.js` — layout, login screen, and the
  staff-login gate used by every staff page above. A fix or design
  change here applies everywhere at once. Any new staff page should
  reuse both rather than copying its own version.

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
4. Create at least one staff account: Authentication → Users → **Add
   user** — Email + password (doesn't need to be a real inbox; accounts
   are created directly here, not via self-signup). Turn on "Auto
   Confirm" if offered.

   (We initially tried phone-number login to match the customer-ID
   convention, but Supabase's "Phone" sign-in method is off by default
   and enabling it may require a paid SMS provider even for
   password-only logins — not worth the friction, so it's email.)
5. SQL Editor → run `supabase-migration-002-require-login.sql`. Locks the
   database to "only logged-in staff can read/write" — run this *after*
   step 4, so you have a way to log in once it's locked.
6. SQL Editor → run `supabase-migration-003-reward-signups.sql`. Adds the
   `reward_signups` table the public sign-up page writes to.
7. Open `counter-intake.html` (or any staff page) in a browser, or serve
   the folder with any static file server. Sign in with the account from
   step 4.

### Staff login

Supabase's built-in login (Supabase Auth) — no custom password code.
Email + password; no self-registration (add/remove accounts from
Authentication → Users). Sessions persist until "Sign out" (bottom of
the sidebar). Forgotten password → admin resets it manually from the
same Users screen.

### Security model

- Staff pages: RLS requires a logged-in session for every read/write.
- `rewards-signup.html`: no login, by design (customers fill it in
  themselves). Rather than reopening the main `customers` table to
  anonymous writes, anonymous visitors may only **insert** into the
  separate `reward_signups` table — they can't read it back, so one
  customer can't see another's submission. Staff review and merge these
  into real customer records from the **Dashboard**.
- Per-staff permissions (e.g. restricting who sees sale amounts) aren't
  built — any logged-in staff account can do anything in the app.

### WhatsApp messages

Every "send via WhatsApp" button opens a `wa.me` click-to-chat link
pre-filled with a message — free, no WhatsApp Business API account
needed, but a staff member must tap send in the window that opens.

## Deliberately not built yet

- **AI recommendation engine** (what to sell next, contact-lens refill
  timing) — the growth-system plan this schema is based on marks this
  "Future Feature, needs 6-12 months of data." Building UI for it now
  would have nothing real behind it.
- **Public appointment booking** — a separate, larger feature.
- **Per-staff permissions / roles.**

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
