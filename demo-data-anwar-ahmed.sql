-- =====================================================================
-- MK Optics — Demo data: Anwar Ahmed, 6 visits over ~12 months
-- =====================================================================
-- Illustrative only — NOT part of the app's required setup.
--
-- This replaces the earlier "Vikas Dhawan" test customer (that name and
-- phone number belonged to the app's actual developer/tester, not a
-- fictional demo customer — this renames the record to something
-- fictional and gives it a fake phone number) with a purpose-built
-- 12-month visit history designed to make the Customers page's
-- Insights panel show things a person skimming a table of dates and
-- numbers would genuinely miss:
--
--   1. Visit frequency quietly ACCELERATES — gaps of ~105, 91, 70, 49,
--      35 days. Nobody glancing at 6 dates does that subtraction in
--      their head; the Insights panel does.
--   2. Every single visit lands on a SATURDAY — a real habit, invisible
--      unless you actually check the day-of-week for all six dates.
--   3. Spend more than TRIPLES (₹2,800 → ₹9,800) while the prescription
--      barely moves (+0.25D total) — a signal that this customer is
--      paying for premium features/brand, not a stronger correction.
--      That only shows up by comparing two separate trends against
--      each other, which is exactly the kind of thing a rule-based
--      panel is good at and a busy staff member skimming a table isn't.
--
-- Safe to run once. Re-running it is fine too — it deletes this
-- customer's existing visits before re-inserting, so you won't end up
-- with duplicates.
-- =====================================================================

update customers
set name = 'Anwar Ahmed', phone = '+919812345678'
where phone = '+919673689933';

delete from visits
where customer_id = (select id from customers where phone = '+919812345678');

insert into visits (
  customer_id, visit_date, bill_no,
  od_sphere, od_cylinder, os_sphere, os_cylinder,
  prescribed_by, product_type, frame, lens, amount, channel,
  preferences_budget, pitch_next_time, created_at
)
select
  c.id, v.visit_date, v.bill_no,
  v.od_sphere, v.od_cylinder, v.os_sphere, v.os_cylinder,
  v.prescribed_by, v.product_type, v.frame, v.lens, v.amount, v.channel,
  v.preferences_budget, v.pitch_next_time, v.visit_date::timestamptz
from customers c
cross join (values
  ('2025-09-27'::date, 'DEMO-2001', '1.50', '—', '1.50', '—', 'Dr. MK', 'Spectacles', 'Fastrack Classic',  'Single Vision',                      2800, 'In-store', 'Budget-conscious, first visit',            'Ask about blue-light coating'),
  ('2026-01-10'::date, 'DEMO-2002', '1.50', '—', '1.50', '—', 'Dr. MK', 'Spectacles', 'Fastrack Classic',  'Single Vision + Blue-cut',           3200, 'In-store', 'Works long hours on laptop',                'Mention premium anti-glare'),
  ('2026-04-11'::date, 'DEMO-2003', '1.75', '—', '1.75', '—', 'Dr. MK', 'Spectacles', 'Ray-Ban Wayfarer',  'Single Vision + Anti-glare Premium', 4500, 'In-store', 'Wants a stylish upgrade',                   'Consider progressive next time'),
  ('2026-06-20'::date, 'DEMO-2004', '1.75', '—', '1.75', '—', 'Dr. MK', 'Spectacles', 'Ray-Ban Wayfarer',  'Progressive',                         6200, 'In-store', 'Liked the premium look and feel',           'Offer photochromic upgrade'),
  ('2026-08-08'::date, 'DEMO-2005', '1.75', '—', '1.75', '—', 'Dr. MK', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Premium',            8500, 'In-store', 'Prioritizes brand and comfort over price',  'Introduce titanium frame line'),
  ('2026-09-12'::date, 'DEMO-2006', '1.75', '—', '1.75', '—', 'Dr. MK', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Titanium Photochromic', 9800, 'In-store', 'Consistently upgrading to premium options', 'VIP loyalty offer / early access to new collections')
) as v(visit_date, bill_no, od_sphere, od_cylinder, os_sphere, os_cylinder, prescribed_by, product_type, frame, lens, amount, channel, preferences_budget, pitch_next_time)
where c.phone = '+919812345678';
