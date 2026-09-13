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
   `supabase-schema.sql` to create the `customers` and `visits` tables.
3. Copy `supabase-config.example.js` to `supabase-config.js` and fill in your
   project's URL and anon/public key (Project Settings > API).
   `supabase-config.js` is gitignored so your keys don't need to be committed.
4. Open `counter-intake.html` in a browser (or serve the folder with any
   static file server). If Supabase isn't configured yet, the page shows a
   banner and search/save actions are disabled until you complete the steps
   above.

### WhatsApp confirmations

"Save & Send WhatsApp Confirmation" saves the visit to Supabase, then opens
a `wa.me` link pre-filled with a confirmation message to the customer's
number. This uses WhatsApp's free click-to-chat links — no WhatsApp Business
API account is required, but a staff member does need to tap send in the
WhatsApp window that opens.

## Roadmap

- Public appointment booking flow (planned follow-up).
