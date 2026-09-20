-- =====================================================================
-- MK Optics — Demo dataset: 40 customers, 4 enquiries, 6 follow-ups
-- =====================================================================
-- FOR DEMO USE. Wipes existing customers/visits/reminders/referrals/
-- enquiries(leads)/appointment requests/reward sign-ups/consumable
-- orders/complaints and replaces them with a fresh, realistic dataset
-- sized for a live demo, with something to show on every staff app page:
--   - 40 customers (one — the first inserted — has a deliberate 6-visit
--     story designed to make the Quick Insight / Ask AI panels shine).
--   - 4 open enquiries (Enquiries page).
--   - 6 follow-ups: 2 overdue, 2 due today, 2 upcoming (Follow-Ups page).
--   - 5 referrals across all 3 stages (Referrals page).
--   - 8 consumable orders — requested/fulfilled/cancelled (Orders page).
--   - 5 customer messages/complaints — open/resolved, multiple languages
--     (Messages page).
--   - 4 reward sign-ups, mostly unreviewed (Dashboard's pending tile).
--   - 3 new appointment requests + 1 already reviewed (Follow-Ups' New
--     Appointment Requests queue and Dashboard).
-- Does NOT touch ai_settings (your AI keys) or staff logins.
-- Safe to re-run — it wipes and reseeds every time. `cascade` also
-- clears visits/reminders/referrals/consumable_orders/complaints, since
-- all of those reference customers with on-delete-cascade.
-- =====================================================================

truncate table customers, leads, appointment_requests, reward_signups restart identity cascade;

-- --- Customers + visits -------------------------------------------
insert into customers (name, phone, created_at) values ('Dinesh Kapoor', '+919859601079', '2025-09-27'::timestamptz);
insert into customers (name, phone, created_at) values ('Ashok Bhatt', '+919934077931', '2025-11-16'::timestamptz);
insert into customers (name, phone, created_at) values ('Lata Sharma', '+919751571758', '2026-05-04'::timestamptz);
insert into customers (name, phone, created_at) values ('Arjun Mehta', '+919613011188', '2025-09-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Usha Gupta', '+919056927468', '2026-04-02'::timestamptz);
insert into customers (name, phone, created_at) values ('Arjun Bhatt', '+918099480323', '2025-12-16'::timestamptz);
insert into customers (name, phone, created_at) values ('Geeta Joshi', '+917096603779', '2026-06-13'::timestamptz);
insert into customers (name, phone, created_at) values ('Pooja Bhatt', '+916383831789', '2026-04-04'::timestamptz);
insert into customers (name, phone, created_at) values ('Rani Singh', '+916235851465', '2026-03-02'::timestamptz);
insert into customers (name, phone, created_at) values ('Meera Bhatt', '+918113961419', '2025-11-16'::timestamptz);
insert into customers (name, phone, created_at) values ('Geeta Desai', '+919876270060', '2026-02-06'::timestamptz);
insert into customers (name, phone, created_at) values ('Vikram Singh', '+919994727236', '2026-04-29'::timestamptz);
insert into customers (name, phone, created_at) values ('Deepa Chopra', '+919777510801', '2025-11-04'::timestamptz);
insert into customers (name, phone, created_at) values ('Divya Gupta', '+919667153548', '2026-08-05'::timestamptz);
insert into customers (name, phone, created_at) values ('Rekha Verma', '+919084611496', '2025-12-02'::timestamptz);
insert into customers (name, phone, created_at) values ('Meera Patel', '+918016956018', '2026-06-25'::timestamptz);
insert into customers (name, phone, created_at) values ('Geeta Iyer', '+917090503471', '2025-11-28'::timestamptz);
insert into customers (name, phone, created_at) values ('Dinesh Saxena', '+916329849151', '2026-03-29'::timestamptz);
insert into customers (name, phone, created_at) values ('Sunita Verma', '+916254380014', '2025-10-23'::timestamptz);
insert into customers (name, phone, created_at) values ('Neha Kapoor', '+918124870370', '2026-08-13'::timestamptz);
insert into customers (name, phone, created_at) values ('Manoj Reddy', '+919867025848', '2026-04-23'::timestamptz);
insert into customers (name, phone, created_at) values ('Geeta Verma', '+919980979551', '2026-02-23'::timestamptz);
insert into customers (name, phone, created_at) values ('Nisha Joshi', '+919761599922', '2026-07-09'::timestamptz);
insert into customers (name, phone, created_at) values ('Lata Reddy', '+919690204860', '2025-11-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Rani Bhatt', '+919091925925', '2025-11-28'::timestamptz);
insert into customers (name, phone, created_at) values ('Mahesh Singh', '+918021293209', '2026-03-19'::timestamptz);
insert into customers (name, phone, created_at) values ('Nisha Kapoor', '+917064701774', '2025-11-16'::timestamptz);
insert into customers (name, phone, created_at) values ('Rajesh Verma', '+916330402005', '2026-05-15'::timestamptz);
insert into customers (name, phone, created_at) values ('Priti Bansal', '+916283878471', '2026-02-15'::timestamptz);
insert into customers (name, phone, created_at) values ('Meera Desai', '+918197217591', '2026-07-05'::timestamptz);
insert into customers (name, phone, created_at) values ('Priti Reddy', '+919861726851', '2026-07-05'::timestamptz);
insert into customers (name, phone, created_at) values ('Ashok Saxena', '+919925516975', '2025-09-22'::timestamptz);
insert into customers (name, phone, created_at) values ('Prakash Kumar', '+919772329088', '2025-12-08'::timestamptz);
insert into customers (name, phone, created_at) values ('Usha Verma', '+919679616125', '2026-03-30'::timestamptz);
insert into customers (name, phone, created_at) values ('Kavita Nair', '+919023569830', '2026-06-25'::timestamptz);
insert into customers (name, phone, created_at) values ('Seema Iyer', '+918024190200', '2026-05-09'::timestamptz);
insert into customers (name, phone, created_at) values ('Karan Desai', '+917079461804', '2026-07-28'::timestamptz);
insert into customers (name, phone, created_at) values ('Anjali Nair', '+916362304397', '2026-03-09'::timestamptz);
insert into customers (name, phone, created_at) values ('Geeta Saxena', '+916260538965', '2026-04-18'::timestamptz);
insert into customers (name, phone, created_at) values ('Shalini Chopra', '+918186100307', '2026-02-14'::timestamptz);

insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-09-27'::date, '1.50', '1.50', 'Spectacles', 'Fastrack Classic', 'Single Vision', 2800, 'Dr. MK', 'Budget-conscious, first visit', 'Have next premium option ready', null, null, null, null, '2025-09-27'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-01-10'::date, '1.50', '1.50', 'Spectacles', 'Fastrack Classic', 'Single Vision + Blue-cut', 3200, 'Dr. MK', 'Consistently upgrading to premium options', 'Have next premium option ready', null, null, null, null, '2026-01-10'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-11'::date, '1.75', '1.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Anti-glare', 4500, 'Dr. MK', 'Consistently upgrading to premium options', 'Have next premium option ready', null, null, null, null, '2026-04-11'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-20'::date, '1.75', '1.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Progressive', 6200, 'Dr. Anita Rao', 'Consistently upgrading to premium options', 'Have next premium option ready', null, null, null, null, '2026-06-20'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-08'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Premium', 8500, 'Dr. MK', 'Consistently upgrading to premium options', 'Have next premium option ready', null, null, null, null, '2026-08-08'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-12'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Premium', 9800, 'Dr. MK', 'Consistently upgrading to premium options', 'VIP loyalty offer / early access to new collections', null, null, null, null, '2026-09-12'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-25'::date, '-2.50', '-3.00', 'Contact Lenses', null, null, 2940, 'Dr. MK', null, null, 'Bausch + Lomb Ultra', 'Grey', '8.6', '14.0', '2026-08-25'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-16'::date, '0.50', '0.50', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision', 3266, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Offer progressive upgrade', null, null, null, null, '2025-11-16'::timestamptz
  from customers where phone = '+919934077931';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-01-20'::date, '1.25', '1.25', 'Spectacles', 'IDEE Metal', 'Single Vision + Blue-cut', 3118, 'Dr. MK', 'Very particular about frame color', 'Mention blue-light coating next time', null, null, null, null, '2026-01-20'::timestamptz
  from customers where phone = '+919934077931';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-17'::date, '-2.75', '-2.75', 'Contact Lenses', null, null, 1801, 'Dr. MK', null, null, 'Johnson & Johnson 1-Day', 'Grey', '8.6', '14.2', '2026-07-17'::timestamptz
  from customers where phone = '+919934077931';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-04'::date, '1.75', '1.75', 'Spectacles', 'Oakley Holbrook', 'Single Vision', 4294, 'Dr. Anita Rao', null, null, null, null, null, null, '2026-05-04'::timestamptz
  from customers where phone = '+919751571758';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-01'::date, '-0.50', '-1.25', 'Contact Lenses', null, null, 2395, 'Dr. Anita Rao', null, null, 'Alcon Air Optix', 'Hazel', '8.8', '14.2', '2026-09-01'::timestamptz
  from customers where phone = '+919751571758';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-09-26'::date, '5.50', '5.50', 'Spectacles', 'Lenskart Air', 'Bifocal', 6470, 'Dr. MK', 'Budget-conscious', 'Ask about sunglasses', null, null, null, null, '2025-09-26'::timestamptz
  from customers where phone = '+919613011188';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-23'::date, '-2.50', '-4.00', 'Contact Lenses', null, null, 1755, 'Dr. Anita Rao', null, null, 'Freshlook Colors', 'Green', '8.4', '14.0', '2026-08-23'::timestamptz
  from customers where phone = '+919613011188';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-02'::date, '4.00', '4.00', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Blue-cut', 3236, 'Dr. MK', 'Prefers lightweight frames', 'Offer progressive upgrade', null, null, null, null, '2026-04-02'::timestamptz
  from customers where phone = '+919056927468';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-06'::date, '3.25', '3.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision', 3796, 'Dr. Anita Rao', 'Very particular about frame color', null, null, null, null, null, '2026-06-06'::timestamptz
  from customers where phone = '+919056927468';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-22'::date, '0.75', '0.75', 'Spectacles', 'Police Sunwear', 'Single Vision + Anti-glare', 2793, 'Dr. MK', 'Works long hours on screen', 'Check on contact lens interest', null, null, null, null, '2026-07-22'::timestamptz
  from customers where phone = '+919056927468';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-25'::date, '-1.25', '-3.25', 'Contact Lenses', null, null, 2080, 'Dr. MK', null, null, 'Acuvue Oasys', 'Hazel', '8.8', '14.2', '2026-07-25'::timestamptz
  from customers where phone = '+919056927468';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-12-16'::date, '4.75', '4.75', 'Spectacles', 'Lenskart Air', 'Progressive Premium', 9978, 'Dr. Anita Rao', 'Very particular about frame color', 'Mention blue-light coating next time', null, null, null, null, '2025-12-16'::timestamptz
  from customers where phone = '+918099480323';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-02'::date, '5.25', '5.25', 'Spectacles', 'IDEE Metal', 'Single Vision + Blue-cut', 3228, 'Dr. MK', 'Very particular about frame color', 'Recommend anti-glare', null, null, null, null, '2026-04-02'::timestamptz
  from customers where phone = '+918099480323';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-25'::date, '-1.00', '-4.25', 'Contact Lenses', null, null, 1200, 'Dr. Anita Rao', null, null, 'Bausch + Lomb Ultra', 'Grey', '8.8', '14.2', '2026-07-25'::timestamptz
  from customers where phone = '+918099480323';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-13'::date, '0.25', '0.25', 'Spectacles', 'Police Sunwear', 'Single Vision + Blue-cut', 1802, 'Dr. MK', null, null, null, null, null, null, '2026-06-13'::timestamptz
  from customers where phone = '+917096603779';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-04'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus', 'Single Vision', 3522, 'Dr. MK', null, null, null, null, null, null, '2026-04-04'::timestamptz
  from customers where phone = '+916383831789';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-02'::date, '5.75', '5.75', 'Spectacles', 'Oakley Holbrook', 'Single Vision + Blue-cut', 1818, 'Dr. Anita Rao', 'Prioritizes comfort', 'Ask about sunglasses', null, null, null, null, '2026-03-02'::timestamptz
  from customers where phone = '+916235851465';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-11'::date, '2.50', '2.50', 'Spectacles', 'Woodland Rugged', 'Single Vision + Blue-cut', 3913, 'Dr. MK', 'Works long hours on screen', 'Ask about sunglasses', null, null, null, null, '2026-05-11'::timestamptz
  from customers where phone = '+916235851465';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-01'::date, '2.25', '2.25', 'Spectacles', 'Lenskart Air', 'Single Vision + Blue-cut', 3695, 'Dr. Anita Rao', 'Prefers known brands', 'Mention blue-light coating next time', null, null, null, null, '2026-06-01'::timestamptz
  from customers where phone = '+916235851465';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-16'::date, '4.50', '4.50', 'Spectacles', 'Woodland Rugged', 'Single Vision + Blue-cut', 3859, 'Dr. MK', 'Asked about installment payment', 'Introduce premium frame line', null, null, null, null, '2025-11-16'::timestamptz
  from customers where phone = '+918113961419';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-12-09'::date, '3.75', '3.75', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Anti-glare', 3475, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Mention blue-light coating next time', null, null, null, null, '2025-12-09'::timestamptz
  from customers where phone = '+918113961419';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-19'::date, '-2.25', '-1.50', 'Contact Lenses', null, null, 1975, 'Dr. Anita Rao', null, null, 'Acuvue Oasys', null, '8.8', '14.2', '2026-07-19'::timestamptz
  from customers where phone = '+918113961419';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-06'::date, '0.50', '0.50', 'Spectacles', 'Vincent Chase Round', 'Single Vision', 4714, 'Dr. MK', 'Asked about installment payment', 'Recommend anti-glare', null, null, null, null, '2026-02-06'::timestamptz
  from customers where phone = '+919876270060';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-11'::date, '1.25', '1.25', 'Spectacles', 'Ray-Ban Aviator', 'Progressive Premium', 7179, 'Dr. MK', null, 'Mention blue-light coating next time', null, null, null, null, '2026-03-11'::timestamptz
  from customers where phone = '+919876270060';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-19'::date, '0.50', '0.50', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision', 2938, 'Dr. MK', null, 'Check on contact lens interest', null, null, null, null, '2026-04-19'::timestamptz
  from customers where phone = '+919876270060';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-29'::date, '1.50', '1.50', 'Spectacles', 'Oakley Holbrook', 'Single Vision + Anti-glare', 1850, 'Dr. MK', 'Price-sensitive but loyal', 'Ask about sunglasses', null, null, null, null, '2026-04-29'::timestamptz
  from customers where phone = '+919994727236';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-04'::date, null, null, 'Sunglasses', 'Police Sunwear', null, 2667, 'Dr. Anita Rao', 'Works long hours on screen', null, null, null, null, null, '2025-11-04'::timestamptz
  from customers where phone = '+919777510801';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-21'::date, '-2.25', '-1.00', 'Contact Lenses', null, null, 2940, 'Dr. Anita Rao', null, null, 'Freshlook Colors', 'Blue', '8.8', '14.2', '2026-07-21'::timestamptz
  from customers where phone = '+919777510801';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-05'::date, null, null, 'Sunglasses', 'Oakley Holbrook', null, 2421, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Mention blue-light coating next time', null, null, null, null, '2026-08-05'::timestamptz
  from customers where phone = '+919667153548';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '5.50', '5.50', 'Spectacles', 'Lenskart Air', 'Single Vision + Anti-glare', 3545, 'Dr. MK', 'Asked about installment payment', 'Offer progressive upgrade', null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+919667153548';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-12-02'::date, '1.00', '1.00', 'Spectacles', 'Vincent Chase Round', 'Progressive Premium', 9661, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Offer progressive upgrade', null, null, null, null, '2025-12-02'::timestamptz
  from customers where phone = '+919084611496';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-01-16'::date, '4.00', '4.00', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision', 3344, 'Dr. Anita Rao', null, null, null, null, null, null, '2026-01-16'::timestamptz
  from customers where phone = '+919084611496';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-02'::date, '1.00', '1.00', 'Spectacles', 'Fastrack Classic', 'Single Vision', 4279, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Check on contact lens interest', null, null, null, null, '2026-05-02'::timestamptz
  from customers where phone = '+919084611496';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-11'::date, '-1.00', '-4.00', 'Contact Lenses', null, null, 2892, 'Dr. Anita Rao', null, null, 'Freshlook Colors', 'Hazel', '8.4', '14.2', '2026-08-11'::timestamptz
  from customers where phone = '+919084611496';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-25'::date, '5.50', '5.50', 'Spectacles', 'Vincent Chase Round', 'Single Vision', 3223, 'Dr. MK', null, 'Recommend anti-glare', null, null, null, null, '2026-06-25'::timestamptz
  from customers where phone = '+918016956018';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-28'::date, '3.00', '3.00', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 2071, 'Dr. Anita Rao', 'Prefers known brands', 'Mention blue-light coating next time', null, null, null, null, '2025-11-28'::timestamptz
  from customers where phone = '+917090503471';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-10'::date, '4.75', '4.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Progressive', 8826, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Ask about sunglasses', null, null, null, null, '2026-02-10'::timestamptz
  from customers where phone = '+917090503471';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-03'::date, '-2.50', '-0.50', 'Contact Lenses', null, null, 2348, 'Dr. Anita Rao', null, null, 'Acuvue Oasys', 'Green', '8.4', '14.2', '2026-08-03'::timestamptz
  from customers where phone = '+917090503471';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-29'::date, '3.25', '3.25', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 2160, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Introduce premium frame line', null, null, null, null, '2026-03-29'::timestamptz
  from customers where phone = '+916329849151';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-21'::date, '1.00', '1.00', 'Spectacles', 'IDEE Metal', 'Bifocal', 7494, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Check on contact lens interest', null, null, null, null, '2026-06-21'::timestamptz
  from customers where phone = '+916329849151';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-26'::date, '-2.75', '-3.50', 'Contact Lenses', null, null, 1283, 'Dr. Anita Rao', null, null, 'Johnson & Johnson 1-Day', null, '8.6', '14.2', '2026-08-26'::timestamptz
  from customers where phone = '+916329849151';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-10-23'::date, '5.25', '5.25', 'Spectacles', 'John Jacobs Classic', 'Single Vision + Anti-glare', 3755, 'Dr. Anita Rao', null, null, null, null, null, null, '2025-10-23'::timestamptz
  from customers where phone = '+916254380014';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-01-07'::date, null, null, 'Sunglasses', 'Titan Eyeplus Premium', null, 3014, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Mention blue-light coating next time', null, null, null, null, '2026-01-07'::timestamptz
  from customers where phone = '+916254380014';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-13'::date, null, null, 'Sunglasses', 'Lenskart Air', null, 1860, 'Dr. Anita Rao', 'Works long hours on screen', null, null, null, null, null, '2026-08-13'::timestamptz
  from customers where phone = '+918124870370';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, null, null, 'Sunglasses', 'Oakley Holbrook', null, 3095, 'Dr. MK', null, 'Introduce premium frame line', null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+918124870370';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '3.25', '3.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Anti-glare', 2098, 'Dr. MK', 'Prefers known brands', 'Offer progressive upgrade', null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+918124870370';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-23'::date, '5.50', '5.50', 'Spectacles', 'Vincent Chase Round', 'Single Vision', 3052, 'Dr. MK', null, null, null, null, null, null, '2026-04-23'::timestamptz
  from customers where phone = '+919867025848';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-25'::date, '0.50', '0.50', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Anti-glare', 2341, 'Dr. Anita Rao', 'Asked about installment payment', null, null, null, null, null, '2026-06-25'::timestamptz
  from customers where phone = '+919867025848';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-23'::date, '2.75', '2.75', 'Spectacles', 'Woodland Rugged', 'Single Vision', 2350, 'Dr. MK', null, 'Recommend anti-glare', null, null, null, null, '2026-02-23'::timestamptz
  from customers where phone = '+919980979551';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-30'::date, '1.75', '1.75', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 3473, 'Dr. MK', 'Prefers known brands', 'Check on contact lens interest', null, null, null, null, '2026-03-30'::timestamptz
  from customers where phone = '+919980979551';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-09'::date, '0.00', '0.00', 'Spectacles', 'Oakley Holbrook', 'Single Vision', 3538, 'Dr. MK', 'Prefers lightweight frames', 'Offer progressive upgrade', null, null, null, null, '2026-07-09'::timestamptz
  from customers where phone = '+919761599922';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-12'::date, '2.50', '2.50', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision', 3493, 'Dr. MK', 'Asked about installment payment', null, null, null, null, null, '2026-08-12'::timestamptz
  from customers where phone = '+919761599922';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-23'::date, '-1.00', '-1.75', 'Contact Lenses', null, null, 1603, 'Dr. MK', null, null, 'Alcon Air Optix', 'Green', '8.8', '14.2', '2026-08-23'::timestamptz
  from customers where phone = '+919761599922';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-26'::date, '3.25', '3.25', 'Spectacles', 'IDEE Metal', 'Single Vision + Anti-glare', 2936, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Offer progressive upgrade', null, null, null, null, '2025-11-26'::timestamptz
  from customers where phone = '+919690204860';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-03'::date, '0.50', '0.50', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 4336, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Offer progressive upgrade', null, null, null, null, '2026-03-03'::timestamptz
  from customers where phone = '+919690204860';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-30'::date, '0.75', '0.75', 'Spectacles', 'Oakley Holbrook', 'Single Vision + Blue-cut', 3423, 'Dr. MK', 'Asked about installment payment', 'Mention blue-light coating next time', null, null, null, null, '2026-05-30'::timestamptz
  from customers where phone = '+919690204860';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-28'::date, '4.75', '4.75', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Anti-glare', 3764, 'Dr. Anita Rao', 'Works long hours on screen', 'Check on contact lens interest', null, null, null, null, '2025-11-28'::timestamptz
  from customers where phone = '+919091925925';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-20'::date, '0.75', '0.75', 'Spectacles', 'IDEE Metal', 'Single Vision', 3685, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Recommend anti-glare', null, null, null, null, '2026-02-20'::timestamptz
  from customers where phone = '+919091925925';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-06'::date, null, null, 'Sunglasses', 'John Jacobs Classic', null, 2119, 'Dr. MK', 'Budget-conscious', null, null, null, null, null, '2026-05-06'::timestamptz
  from customers where phone = '+919091925925';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-05'::date, '-3.00', '-1.00', 'Contact Lenses', null, null, 1959, 'Dr. MK', null, null, 'Bausch + Lomb Ultra', null, '8.6', '14.0', '2026-08-05'::timestamptz
  from customers where phone = '+919091925925';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-19'::date, '1.50', '1.50', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision + Blue-cut', 3465, 'Dr. Anita Rao', 'Asked about installment payment', 'Ask about sunglasses', null, null, null, null, '2026-03-19'::timestamptz
  from customers where phone = '+918021293209';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-11-16'::date, '4.50', '4.50', 'Spectacles', 'Fastrack Classic', 'Single Vision + Anti-glare', 3808, 'Dr. MK', 'Prioritizes comfort', 'Offer progressive upgrade', null, null, null, null, '2025-11-16'::timestamptz
  from customers where phone = '+917064701774';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-15'::date, '1.25', '1.25', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Anti-glare', 2310, 'Dr. MK', 'Asked about installment payment', null, null, null, null, null, '2026-05-15'::timestamptz
  from customers where phone = '+916330402005';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-06'::date, null, null, 'Sunglasses', 'Fastrack Classic', null, 3001, 'Dr. MK', null, 'Check on contact lens interest', null, null, null, null, '2026-08-06'::timestamptz
  from customers where phone = '+916330402005';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-15'::date, '5.50', '5.50', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Blue-cut', 4100, 'Dr. MK', 'Asked about installment payment', 'Introduce premium frame line', null, null, null, null, '2026-02-15'::timestamptz
  from customers where phone = '+916283878471';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-05'::date, '4.25', '4.25', 'Spectacles', 'Lenskart Air', 'Single Vision', 4690, 'Dr. MK', 'Wants a stylish upgrade', 'Offer progressive upgrade', null, null, null, null, '2026-07-05'::timestamptz
  from customers where phone = '+918197217591';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-11'::date, '1.50', '1.50', 'Spectacles', 'Woodland Rugged', 'Progressive Premium', 5936, 'Dr. MK', 'Price-sensitive but loyal', 'Ask about sunglasses', null, null, null, null, '2026-08-11'::timestamptz
  from customers where phone = '+918197217591';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-05'::date, null, null, 'Sunglasses', 'John Jacobs Classic', null, 2580, 'Dr. Anita Rao', null, 'Ask about sunglasses', null, null, null, null, '2026-07-05'::timestamptz
  from customers where phone = '+919861726851';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '1.25', '1.25', 'Spectacles', 'John Jacobs Classic', 'Single Vision + Blue-cut', 1965, 'Dr. Anita Rao', 'Wants a stylish upgrade', null, null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+919861726851';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '5.00', '5.00', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision', 3747, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Recommend anti-glare', null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+919861726851';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-09-22'::date, '0.00', '0.00', 'Spectacles', 'Vincent Chase Round', 'Progressive', 7408, 'Dr. Anita Rao', 'Prefers known brands', 'Recommend anti-glare', null, null, null, null, '2025-09-22'::timestamptz
  from customers where phone = '+919925516975';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-12-16'::date, '3.25', '3.25', 'Spectacles', 'Fastrack Classic', 'Single Vision + Blue-cut', 1860, 'Dr. MK', null, 'Introduce premium frame line', null, null, null, null, '2025-12-16'::timestamptz
  from customers where phone = '+919925516975';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-21'::date, '5.00', '5.00', 'Spectacles', 'Titan Eyeplus', 'Single Vision', 1913, 'Dr. Anita Rao', null, 'Introduce premium frame line', null, null, null, null, '2026-02-21'::timestamptz
  from customers where phone = '+919925516975';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-08'::date, '-3.50', '-0.75', 'Contact Lenses', null, null, 2859, 'Dr. Anita Rao', null, null, 'Bausch + Lomb Ultra', 'Hazel', '8.8', '14.2', '2026-09-08'::timestamptz
  from customers where phone = '+919925516975';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2025-12-08'::date, '4.25', '4.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision', 4270, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Mention blue-light coating next time', null, null, null, null, '2025-12-08'::timestamptz
  from customers where phone = '+919772329088';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-11'::date, '1.50', '1.50', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision + Blue-cut', 3101, 'Dr. MK', 'Works long hours on screen', 'Offer progressive upgrade', null, null, null, null, '2026-03-11'::timestamptz
  from customers where phone = '+919772329088';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-30'::date, '5.25', '5.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Blue-cut', 3347, 'Dr. MK', 'Prefers known brands', null, null, null, null, null, '2026-03-30'::timestamptz
  from customers where phone = '+919679616125';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-27'::date, '0.00', '0.00', 'Spectacles', 'Titan Eyeplus', 'Single Vision', 4011, 'Dr. MK', 'Works long hours on screen', 'Recommend anti-glare', null, null, null, null, '2026-06-27'::timestamptz
  from customers where phone = '+919679616125';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-25'::date, '3.75', '3.75', 'Spectacles', 'Fastrack Classic', 'Single Vision', 3312, 'Dr. MK', 'Prioritizes comfort', null, null, null, null, null, '2026-06-25'::timestamptz
  from customers where phone = '+919023569830';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '2.50', '2.50', 'Spectacles', 'Fastrack Sporty', 'Single Vision + Anti-glare', 2809, 'Dr. Anita Rao', 'Budget-conscious', null, null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+919023569830';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-05-09'::date, '2.25', '2.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Blue-cut', 2166, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Recommend anti-glare', null, null, null, null, '2026-05-09'::timestamptz
  from customers where phone = '+918024190200';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-17'::date, '4.50', '4.50', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Blue-cut', 3496, 'Dr. MK', 'Budget-conscious', 'Recommend anti-glare', null, null, null, null, '2026-08-17'::timestamptz
  from customers where phone = '+918024190200';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-08-04'::date, '-2.50', '-1.00', 'Contact Lenses', null, null, 2613, 'Dr. MK', null, null, 'Bausch + Lomb Ultra', 'Grey', '8.8', '14.2', '2026-08-04'::timestamptz
  from customers where phone = '+918024190200';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-28'::date, '3.25', '3.25', 'Spectacles', 'Vincent Chase Round', 'Single Vision + Blue-cut', 2453, 'Dr. MK', 'Very particular about frame color', 'Introduce premium frame line', null, null, null, null, '2026-07-28'::timestamptz
  from customers where phone = '+917079461804';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-09-14'::date, '0.50', '0.50', 'Spectacles', 'Fastrack Sporty', 'Single Vision + Anti-glare', 2228, 'Dr. Anita Rao', 'Price-sensitive but loyal', null, null, null, null, null, '2026-09-14'::timestamptz
  from customers where phone = '+917079461804';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-09'::date, '3.25', '3.25', 'Spectacles', 'Lenskart Air', 'Single Vision', 2714, 'Dr. MK', 'Works long hours on screen', null, null, null, null, null, '2026-03-09'::timestamptz
  from customers where phone = '+916362304397';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-06-08'::date, '2.00', '2.00', 'Spectacles', 'Fastrack Classic', 'Single Vision + Blue-cut', 3322, 'Dr. Anita Rao', 'Asked about installment payment', 'Offer progressive upgrade', null, null, null, null, '2026-06-08'::timestamptz
  from customers where phone = '+916362304397';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-07-26'::date, '-3.25', '-1.00', 'Contact Lenses', null, null, 2846, 'Dr. MK', null, null, 'Acuvue Oasys', 'Hazel', '8.6', '14.0', '2026-07-26'::timestamptz
  from customers where phone = '+916362304397';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-04-18'::date, '0.00', '0.00', 'Spectacles', 'John Jacobs Classic', 'Single Vision', 3766, 'Dr. Anita Rao', 'Prefers known brands', 'Offer progressive upgrade', null, null, null, null, '2026-04-18'::timestamptz
  from customers where phone = '+916260538965';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-02-14'::date, '2.00', '2.00', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Blue-cut', 3764, 'Dr. MK', 'Budget-conscious', 'Recommend anti-glare', null, null, null, null, '2026-02-14'::timestamptz
  from customers where phone = '+918186100307';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, cl_brand, cl_color, cl_base_curve, cl_diameter, created_at)
  select id, '2026-03-26'::date, '2.25', '2.25', 'Spectacles', 'Vincent Chase Round', 'Progressive', 8466, 'Dr. MK', 'Very particular about frame color', 'Mention blue-light coating next time', null, null, null, null, '2026-03-26'::timestamptz
  from customers where phone = '+918186100307';

-- --- Enquiries -------------------------------------------------
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Farhan Sheikh', '+919845011223', 'Progressive lenses', 'Wanted to compare prices elsewhere', 'Very interested, said he''d be back this week', 'open', current_date - 1);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Kavya Menon', '+919845033445', 'Sunglasses (Ray-Ban)', 'Price concern', 'Liked the Aviator but felt it was expensive', 'open', current_date - 7);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Rohit Bafna', '+919845055667', 'Contact lenses', 'Needed to consult with spouse', 'First-time contact lens wearer, a bit nervous', 'open', current_date - 1);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Alisha Fernandes', '+919845077889', 'Kids'' spectacles', 'Wanted to check other stores nearby', 'Daughter, age 9, needs mild correction', 'open', current_date - 4);

-- --- Follow-ups (2 overdue, 2 due today, 2 upcoming) -----------
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (-6), 'pending'
  from customers where phone = '+919980979551';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Consumables', current_date + (-2), 'pending'
  from customers where phone = '+916383831789';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (0), 'pending'
  from customers where phone = '+919751571758';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Discount offer', current_date + (0), 'pending'
  from customers where phone = '+919777510801';
insert into reminders (customer_id, type, due_date, status)
  select id, 'New collection', current_date + (5), 'pending'
  from customers where phone = '+917090503471';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (14), 'pending'
  from customers where phone = '+918021293209';

-- --- Referrals ---------------------------------------------------
insert into referrals (referrer_customer_id, referred_name, referred_phone, status, created_at)
  select id, 'Suresh Nair', '+919845099001', 'invited', now() - interval '3 days'
  from customers where phone = '+919859601079';
insert into referrals (referrer_customer_id, referred_name, referred_phone, status, referrer_discount_given, created_at)
  select id, 'Anita Rao', '+919845099002', 'joined', true, now() - interval '10 days'
  from customers where phone = '+919934077931';
insert into referrals (referrer_customer_id, referred_name, referred_phone, status, referrer_discount_given, referred_discount_given, created_at)
  select id, 'Vivek Shah', '+919845099003', 'purchased', true, true, now() - interval '25 days'
  from customers where phone = '+917096603779';
insert into referrals (referrer_customer_id, referred_phone, status, created_at)
  select id, '+919845099004', 'invited', now() - interval '1 day'
  from customers where phone = '+918016956018';
insert into referrals (referrer_customer_id, referred_name, referred_phone, status, referrer_discount_given, created_at)
  select id, 'Poonam Iyer', '+919845099005', 'joined', true, now() - interval '6 days'
  from customers where phone = '+916329849151';

-- --- Consumable orders (Orders page) -----------------------------
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Contact lens solution (usual brand)', 'Ran out, needs it before the weekend', 'requested', now() - interval '1 day'
  from customers where phone = '+919859601079';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Monthly disposables — Bausch + Lomb Ultra', null, 'requested', now() - interval '3 hours'
  from customers where phone = '+919934077931';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Spectacle case + cleaning cloth', 'Lost the original case', 'requested', now() - interval '2 days'
  from customers where phone = '+916235851465';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Contact lens solution (Acuvue)', null, 'requested', now() - interval '5 hours'
  from customers where phone = '+918113961419';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Anti-glare lens cleaning spray', null, 'requested', now() - interval '30 minutes'
  from customers where phone = '+917090503471';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Daily disposables — Johnson & Johnson 1-Day', 'Needs 3 boxes', 'fulfilled', now() - interval '6 days'
  from customers where phone = '+919751571758';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Contact lens solution (usual brand)', null, 'fulfilled', now() - interval '9 days'
  from customers where phone = '+919056927468';
insert into consumable_orders (customer_id, item, notes, status, created_at)
  select id, 'Nose pads (replacement)', 'Changed mind, picked up in-store instead', 'cancelled', now() - interval '4 days'
  from customers where phone = '+918024190200';

-- --- Customer messages / complaints (Messages page) --------------
insert into complaints (customer_id, message, language, status, created_at)
  select id, 'Mera order abhi tak nahi mila, kab tak milega?', 'Hindi', 'open', now() - interval '2 hours'
  from customers where phone = '+919859601079';
insert into complaints (customer_id, message, language, status, created_at)
  select id, 'The frame I bought last week has a loose hinge already. Can someone take a look?', 'English', 'open', now() - interval '1 day'
  from customers where phone = '+918099480323';
insert into complaints (customer_id, message, language, status, created_at)
  select id, 'என் கண்ணாடியின் பவர் தவறாக இருப்பது போல் தெரிகிறது.', 'Tamil', 'open', now() - interval '5 hours'
  from customers where phone = '+917090503471';
insert into complaints (customer_id, message, language, status, created_at)
  select id, 'Thank you for the quick service last visit — really appreciated it.', 'English', 'resolved', now() - interval '8 days'
  from customers where phone = '+919667153548';
insert into complaints (customer_id, message, language, status, created_at)
  select id, 'माझा चष्मा दुरुस्त झाला, धन्यवाद.', 'Marathi', 'resolved', now() - interval '12 days'
  from customers where phone = '+916383831789';

-- --- Reward sign-ups (Dashboard pending-review tile) --------------
insert into reward_signups (name, phone, opted_in_offers, reviewed, created_at) values ('Sanjay Rathore', '+919845066001', true, false, now() - interval '2 days');
insert into reward_signups (name, phone, opted_in_offers, reviewed, created_at) values ('Priya Malhotra', '+919845066002', true, false, now() - interval '1 day');
insert into reward_signups (name, phone, opted_in_offers, reviewed, created_at) values ('Vivaan Kapoor', '+919845066003', false, false, now() - interval '6 hours');
insert into reward_signups (name, phone, opted_in_offers, reviewed, created_at) values ('Kiran Aggarwal', '+919845066004', true, true, now() - interval '15 days');

-- --- Appointment requests (Follow-Ups' New Appointment Requests) --
insert into appointment_requests (name, phone, preferred_date, notes, status, created_at) values ('Ritu Kapoor', '+919845077001', current_date + 3, 'Prefers a morning slot', 'new', now() - interval '1 day');
insert into appointment_requests (name, phone, preferred_date, notes, status, created_at) values ('Amit Trivedi', '+919845077002', current_date + 1, null, 'new', now() - interval '4 hours');
insert into appointment_requests (name, phone, preferred_date, notes, status, created_at) values ('Sneha Rao', '+919845077003', current_date + 7, 'First-time visitor, wants an eye test', 'new', now() - interval '20 minutes');
insert into appointment_requests (name, phone, preferred_date, notes, status, created_at) values ('Deepak Oberoi', '+919845077004', current_date - 2, 'Already called and booked in person', 'reviewed', now() - interval '10 days');
