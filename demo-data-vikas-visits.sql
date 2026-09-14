-- =====================================================================
-- MK Optics — Demo data: 5 extra past visits for Vikas Dhawan
-- =====================================================================
-- Illustrative only — NOT part of the app's required setup. Run this in
-- the SQL Editor if you want to see what the Customers page's history
-- table and "Insights" panel look like once a customer has several
-- visits on file, instead of just one.
--
-- These 5 rows are added ALONGSIDE whatever real visit(s) Vikas Dhawan
-- already has (his existing 2026-09-13 visit is untouched) — together
-- they tell a simple, deliberate story: gradually increasing myopia,
-- reading power (presbyopia) appearing partway through, a shift from
-- single-vision to progressive lenses, and roughly one visit every
-- 4-5 months. That's exactly the kind of pattern the Insights panel
-- looks for.
--
-- Safe to run once. Running it twice will insert the rows again
-- (there's no natural "already ran this" marker for demo data), so if
-- you want a clean slate afterwards, delete rows in `visits` where
-- bill_no starts with 'DEMO-' before re-running.
-- =====================================================================

insert into visits (
  customer_id, visit_date, bill_no,
  od_sphere, od_cylinder, os_sphere, os_cylinder,
  add_od_sphere, add_os_sphere,
  prescribed_by, product_type, frame, lens, amount, channel,
  preferences_budget, pitch_next_time, created_at
)
select
  c.id, v.visit_date, v.bill_no,
  v.od_sphere, v.od_cylinder, v.os_sphere, v.os_cylinder,
  v.add_od_sphere, v.add_os_sphere,
  v.prescribed_by, v.product_type, v.frame, v.lens, v.amount, v.channel,
  v.preferences_budget, v.pitch_next_time, v.visit_date::timestamptz
from customers c
cross join (values
  ('2024-09-15'::date, 'DEMO-1001', '2.00', '—', '2.00', '—', null,   null,   'Dr. MK', 'Spectacles', 'Ray-Ban Classic',  'Single Vision',              3500, 'In-store', 'Budget-conscious, first pair', 'Suggest lighter frame next time'),
  ('2025-01-20'::date, 'DEMO-1002', '2.25', '—', '2.25', '—', null,   null,   'Dr. MK', 'Spectacles', 'Titan Metal',      'Single Vision',              3800, 'In-store', 'Wants durable metal frame',     'Ask about sunglasses'),
  ('2025-05-10'::date, 'DEMO-1003', '2.50', '—', '2.50', '—', null,   null,   'Dr. MK', 'Spectacles', 'Ray-Ban Aviator',  'Single Vision + Blue-cut',   4200, 'In-store', 'Screen time increased',        'Recommend blue-light coating'),
  ('2025-09-18'::date, 'DEMO-1004', '2.75', '—', '2.75', '—', '0.75', '0.75', 'Dr. MK', 'Spectacles', 'Prada Sporty',     'Progressive',                6800, 'In-store', 'Struggling with near vision',  'Check on progressive comfort'),
  ('2026-01-25'::date, 'DEMO-1005', '2.75', '—', '3.00', '—', '0.75', '0.75', 'Dr. MK', 'Consumables', 'Prada Sporty',    'Lens cleaning kit + solution', 2200, 'In-store', 'Happy with progressives',     'Due for annual eye test')
) as v(visit_date, bill_no, od_sphere, od_cylinder, os_sphere, os_cylinder, add_od_sphere, add_os_sphere, prescribed_by, product_type, frame, lens, amount, channel, preferences_budget, pitch_next_time)
where c.name = 'Vikas Dhawan' and c.phone = '+919673689933';
