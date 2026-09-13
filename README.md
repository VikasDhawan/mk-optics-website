# mk-optics-website
Website prototype for M&K Optics

## Pages

- `index.html` — public marketing site.
- `counter-intake.html` — internal Counter Intake app for staff to look up
  customers, record a sale, capture the prescription, and send a WhatsApp
  confirmation. Responsive down to mobile widths.

## Setting up the Counter Intake app (Supabase)

The Counter Intake app stores customers and visits in [Supabase](https://supabase.com)
(free tier is enough for this).

1. Create a free project at supabase.com.
2. Open the SQL Editor in your project and run the contents of
   `supabase-schema.sql`. This creates five tables: `customers`,
   `visits` (prescription + purchase per visit), `leads` (enquiries
   that didn't convert to a sale), `reminders` (eye-test, contact-lens
   refill, review/referral asks, offers, social posts — one table
   drives the daily follow-up list), and `referrals` (who referred
   whom, and whether each side's discount was given). Each table has a
   plain-English comment above it in the file explaining what it's for.
3. Copy `supabase-config.example.js` to `supabase-config.js` and fill in your
   project's URL and anon/public key (Project Settings > API).
   `supabase-config.js` is gitignored so your keys don't need to be committed.
4. Create at least one staff account: Supabase dashboard > Authentication >
   Users > **Add user** — fill in **Phone** (with country code, e.g.
   `+919845012345`, no spaces) and a password, leave Email blank. Turn on
   "Auto Confirm" if offered, so it doesn't wait on an SMS confirmation
   that will never arrive. This is who will log into the Counter Intake app.
5. Run `supabase-migration-002-require-login.sql` in the SQL Editor. This
   locks the database down to "only logged-in staff can read/write" — do
   this only after step 4, so you have a way to log in once it's locked.
6. Open `counter-intake.html` in a browser (or serve the folder with any
   static file server). If Supabase isn't configured yet, the page shows a
   banner and skips the login screen entirely (nothing to log into). Once
   configured, you'll see a staff login screen — sign in with the account
   from step 4. The Counter Intake page currently reads/writes only
   `customers` and `visits` — the `leads`, `reminders`, and `referrals`
   tables are in place for the follow-up features below but aren't wired
   into a screen yet.

### Staff login

The app uses Supabase's built-in login (Supabase Auth) — no custom
password-handling code. Staff log in with their **mobile number and a
password** (not email), matching how customers are identified elsewhere
in the app. This uses phone+password sign-in, not SMS one-time codes, so
no SMS provider or cost is involved. Add or remove staff accounts anytime
from Supabase dashboard > Authentication > Users; there's no separate
"sign up" screen in the app itself (staff don't self-register). Once
logged in, the browser stays signed in until "Sign out" is clicked
(bottom of the sidebar).

If a staff member forgets their password, there's no self-service "forgot
password" flow for phone-based accounts (that requires SMS, which we're
not using) — an admin resets it manually from Supabase dashboard >
Authentication > Users > (select the user) > Reset password.

### WhatsApp confirmations

"Save & Send WhatsApp Confirmation" saves the visit to Supabase, then opens
a `wa.me` link pre-filled with a confirmation message to the customer's
number. This uses WhatsApp's free click-to-chat links — no WhatsApp Business
API account is required, but a staff member does need to tap send in the
WhatsApp window that opens.

## Roadmap

- Per-staff permissions (e.g. only managers can see amounts/reports) —
  today, any logged-in staff account can do anything in the app.
- Public appointment booking flow.
- A "Daily Follow-Ups" screen reading from the `reminders` table (who
  to message, remind, or offer today).
- A "Leads" screen for logging walk-ins/enquiries who didn't buy.
- Rewards QR sign-up flow and referral tracking screens.
- AI recommendation engine (what to sell next, contact-lens refill
  timing) — needs 6-12 months of real customer data before it's useful,
  per the growth-system plan this schema is based on.
