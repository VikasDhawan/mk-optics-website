-- =====================================================================
-- MK Optics — Demo dataset: 40 customers, 4 enquiries, 6 follow-ups
-- =====================================================================
-- FOR DEMO USE. Wipes existing customers/visits/reminders/referrals/
-- enquiries(leads)/appointment requests/reward sign-ups and replaces
-- them with a fresh, realistic dataset sized for a live demo:
--   - 40 customers (one — the first inserted — has a deliberate 6-visit
--     story designed to make the Quick Insight / Ask AI panels shine).
--   - 4 open enquiries (Enquiries page).
--   - 6 follow-ups: 2 overdue, 2 due today, 2 upcoming (Follow-Ups page).
-- Does NOT touch ai_settings (your AI keys) or staff logins.
-- Safe to re-run — it wipes and reseeds every time.
-- =====================================================================

truncate table customers, leads, appointment_requests, reward_signups restart identity cascade;

-- --- Customers + visits -------------------------------------------
insert into customers (name, phone, created_at) values ('Dinesh Kapoor', '+919859601079', '2025-09-27'::timestamptz);
insert into customers (name, phone, created_at) values ('Manoj Mehta', '+919966278548', '2026-06-14'::timestamptz);
insert into customers (name, phone, created_at) values ('Divya Singh', '+919720066357', '2026-05-21'::timestamptz);
insert into customers (name, phone, created_at) values ('Kavita Nair', '+919666375770', '2025-11-12'::timestamptz);
insert into customers (name, phone, created_at) values ('Neha Kapoor', '+919098496912', '2026-08-15'::timestamptz);
insert into customers (name, phone, created_at) values ('Ajay Rao', '+918013059799', '2026-05-07'::timestamptz);
insert into customers (name, phone, created_at) values ('Sunita Desai', '+917053097607', '2026-04-27'::timestamptz);
insert into customers (name, phone, created_at) values ('Amit Desai', '+916348598379', '2025-10-03'::timestamptz);
insert into customers (name, phone, created_at) values ('Priya Chopra', '+916264006558', '2026-02-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Nisha Saxena', '+918180433255', '2025-10-30'::timestamptz);
insert into customers (name, phone, created_at) values ('Sonia Kumar', '+919895656249', '2026-06-11'::timestamptz);
insert into customers (name, phone, created_at) values ('Arjun Agarwal', '+919998943671', '2025-09-24'::timestamptz);
insert into customers (name, phone, created_at) values ('Rahul Mehta', '+919752916666', '2026-05-10'::timestamptz);
insert into customers (name, phone, created_at) values ('Prakash Mehta', '+919660130400', '2026-07-03'::timestamptz);
insert into customers (name, phone, created_at) values ('Priya Desai', '+919084661264', '2026-01-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Ajay Bhatt', '+918012523148', '2026-02-13'::timestamptz);
insert into customers (name, phone, created_at) values ('Karan Singh', '+917010757716', '2026-03-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Seema Iyer', '+916334465663', '2025-10-17'::timestamptz);
insert into customers (name, phone, created_at) values ('Pooja Agarwal', '+916251191743', '2025-10-09'::timestamptz);
insert into customers (name, phone, created_at) values ('Prakash Saxena', '+918115396219', '2026-02-07'::timestamptz);
insert into customers (name, phone, created_at) values ('Shalini Nair', '+919896588347', '2025-12-09'::timestamptz);
insert into customers (name, phone, created_at) values ('Usha Agarwal', '+919919578703', '2026-01-06'::timestamptz);
insert into customers (name, phone, created_at) values ('Rani Rao', '+919737347993', '2025-09-21'::timestamptz);
insert into customers (name, phone, created_at) values ('Usha Mehta', '+919642802468', '2026-07-18'::timestamptz);
insert into customers (name, phone, created_at) values ('Anjali Singh', '+919013719907', '2026-02-16'::timestamptz);
insert into customers (name, phone, created_at) values ('Karan Joshi', '+918087381557', '2026-01-26'::timestamptz);
insert into customers (name, phone, created_at) values ('Sonia Bhatt', '+917088808255', '2025-11-23'::timestamptz);
insert into customers (name, phone, created_at) values ('Amit Iyer', '+916329978780', '2026-05-13'::timestamptz);
insert into customers (name, phone, created_at) values ('Priya Saxena', '+916218954089', '2026-04-28'::timestamptz);
insert into customers (name, phone, created_at) values ('Vikram Gupta', '+918190555554', '2026-01-17'::timestamptz);
insert into customers (name, phone, created_at) values ('Sonia Rao', '+919881102622', '2026-06-17'::timestamptz);
insert into customers (name, phone, created_at) values ('Vijay Chopra', '+919986001542', '2026-02-11'::timestamptz);
insert into customers (name, phone, created_at) values ('Ramesh Patel', '+919760815200', '2025-11-01'::timestamptz);
insert into customers (name, phone, created_at) values ('Dinesh Agarwal', '+919644083332', '2026-05-06'::timestamptz);
insert into customers (name, phone, created_at) values ('Seema Bansal', '+919072883872', '2025-11-25'::timestamptz);
insert into customers (name, phone, created_at) values ('Ravi Kumar', '+918028438657', '2026-04-27'::timestamptz);
insert into customers (name, phone, created_at) values ('Prakash Desai', '+917040225308', '2026-06-07'::timestamptz);
insert into customers (name, phone, created_at) values ('Sanjay Bansal', '+916385867283', '2026-01-08'::timestamptz);
insert into customers (name, phone, created_at) values ('Ravi Gupta', '+916227260416', '2026-03-14'::timestamptz);
insert into customers (name, phone, created_at) values ('Swati Kapoor', '+918127263117', '2026-05-02'::timestamptz);

insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-09-27'::date, '1.50', '1.50', 'Spectacles', 'Fastrack Classic', 'Single Vision', 2800, 'Dr. MK', 'Budget-conscious, first visit', 'Have next premium option ready', '2025-09-27'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-10'::date, '1.50', '1.50', 'Spectacles', 'Fastrack Classic', 'Single Vision + Blue-cut', 3200, 'Dr. Anita Rao', 'Consistently upgrading to premium options', 'Have next premium option ready', '2026-01-10'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-11'::date, '1.75', '1.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Anti-glare', 4500, 'Dr. MK', 'Consistently upgrading to premium options', 'Have next premium option ready', '2026-04-11'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-20'::date, '1.75', '1.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Progressive', 6200, 'Dr. MK', 'Consistently upgrading to premium options', 'Have next premium option ready', '2026-06-20'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-08'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Premium', 8500, 'Dr. Anita Rao', 'Consistently upgrading to premium options', 'Have next premium option ready', '2026-08-08'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-09-12'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus Premium', 'Progressive Premium', 9800, 'Dr. MK', 'Consistently upgrading to premium options', 'VIP loyalty offer / early access to new collections', '2026-09-12'::timestamptz
  from customers where phone = '+919859601079';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-14'::date, '2.00', '2.00', 'Spectacles', 'John Jacobs Classic', 'Single Vision', 3395, 'Dr. MK', null, 'Introduce premium frame line', '2026-06-14'::timestamptz
  from customers where phone = '+919966278548';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-21'::date, '0.25', '0.25', 'Spectacles', 'Woodland Rugged', 'Bifocal', 6179, 'Dr. Anita Rao', null, 'Offer progressive upgrade', '2026-05-21'::timestamptz
  from customers where phone = '+919720066357';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-07-23'::date, null, null, 'Sunglasses', 'IDEE Metal', null, 2343, 'Dr. MK', 'Prefers known brands', 'Check on contact lens interest', '2026-07-23'::timestamptz
  from customers where phone = '+919720066357';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-12'::date, '1.75', '1.75', 'Spectacles', 'Police Sunwear', 'Single Vision + Blue-cut', 4648, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Introduce premium frame line', '2025-11-12'::timestamptz
  from customers where phone = '+919666375770';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-15'::date, '3.00', '3.00', 'Spectacles', 'Ray-Ban Wayfarer', 'Bifocal', 7620, 'Dr. MK', 'Asked about installment payment', 'Introduce premium frame line', '2026-08-15'::timestamptz
  from customers where phone = '+919098496912';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-09-14'::date, '5.75', '5.75', 'Spectacles', 'John Jacobs Classic', 'Progressive', 6470, 'Dr. Anita Rao', null, null, '2026-09-14'::timestamptz
  from customers where phone = '+919098496912';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-09-14'::date, null, null, 'Sunglasses', 'Titan Eyeplus', null, 1829, 'Dr. Anita Rao', 'Price-sensitive but loyal', null, '2026-09-14'::timestamptz
  from customers where phone = '+919098496912';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-07'::date, '5.25', '5.25', 'Spectacles', 'Fastrack Sporty', 'Progressive Premium', 7515, 'Dr. Anita Rao', 'Very particular about frame color', 'Check on contact lens interest', '2026-05-07'::timestamptz
  from customers where phone = '+918013059799';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-27'::date, '3.25', '3.25', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision', 3796, 'Dr. MK', 'Very particular about frame color', null, '2026-04-27'::timestamptz
  from customers where phone = '+917053097607';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-10-03'::date, '3.75', '3.75', 'Spectacles', 'Ray-Ban Aviator', 'Single Vision + Anti-glare', 2465, 'Dr. Anita Rao', 'Asked about installment payment', 'Mention blue-light coating next time', '2025-10-03'::timestamptz
  from customers where phone = '+916348598379';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-26'::date, '4.25', '4.25', 'Spectacles', 'Police Sunwear', 'Single Vision', 2465, 'Dr. MK', null, 'Check on contact lens interest', '2026-02-26'::timestamptz
  from customers where phone = '+916264006558';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-10-30'::date, '5.25', '5.25', 'Spectacles', 'Oakley Holbrook', 'Single Vision + Blue-cut', 4165, 'Dr. MK', 'Prioritizes comfort', 'Mention blue-light coating next time', '2025-10-30'::timestamptz
  from customers where phone = '+918180433255';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-11'::date, null, null, 'Sunglasses', 'Oakley Holbrook', null, 3124, 'Dr. MK', 'Works long hours on screen', 'Ask about sunglasses', '2026-06-11'::timestamptz
  from customers where phone = '+919895656249';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-09-24'::date, '4.75', '4.75', 'Spectacles', 'Woodland Rugged', 'Progressive', 8409, 'Dr. MK', null, 'Offer progressive upgrade', '2025-09-24'::timestamptz
  from customers where phone = '+919998943671';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-10'::date, '5.00', '5.00', 'Spectacles', 'IDEE Metal', 'Bifocal', 9717, 'Dr. Anita Rao', 'Works long hours on screen', 'Offer progressive upgrade', '2026-05-10'::timestamptz
  from customers where phone = '+919752916666';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-07-03'::date, '0.00', '0.00', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 1857, 'Dr. MK', 'Asked about installment payment', 'Offer progressive upgrade', '2026-07-03'::timestamptz
  from customers where phone = '+919660130400';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-09-14'::date, '4.00', '4.00', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision', 2430, 'Dr. Anita Rao', 'Prioritizes comfort', null, '2026-09-14'::timestamptz
  from customers where phone = '+919660130400';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-09-14'::date, '3.75', '3.75', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision', 2942, 'Dr. Anita Rao', 'Prioritizes comfort', 'Check on contact lens interest', '2026-09-14'::timestamptz
  from customers where phone = '+919660130400';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-26'::date, '2.00', '2.00', 'Spectacles', 'John Jacobs Classic', 'Single Vision + Anti-glare', 3452, 'Dr. Anita Rao', 'Prefers lightweight frames', 'Check on contact lens interest', '2026-01-26'::timestamptz
  from customers where phone = '+919084661264';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-13'::date, '5.25', '5.25', 'Spectacles', 'Vincent Chase Round', 'Progressive', 5945, 'Dr. Anita Rao', 'Very particular about frame color', null, '2026-02-13'::timestamptz
  from customers where phone = '+918012523148';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-01'::date, '3.50', '3.50', 'Spectacles', 'Lenskart Air', 'Single Vision + Anti-glare', 3538, 'Dr. MK', 'Prefers lightweight frames', null, '2026-04-01'::timestamptz
  from customers where phone = '+918012523148';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-16'::date, '0.25', '0.25', 'Spectacles', 'Police Sunwear', 'Bifocal', 7244, 'Dr. Anita Rao', 'Works long hours on screen', 'Mention blue-light coating next time', '2026-06-16'::timestamptz
  from customers where phone = '+918012523148';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-03-26'::date, '2.00', '2.00', 'Spectacles', 'Vincent Chase Round', 'Progressive', 7699, 'Dr. MK', 'Works long hours on screen', 'Recommend anti-glare', '2026-03-26'::timestamptz
  from customers where phone = '+917010757716';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-07-10'::date, '0.50', '0.50', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Anti-glare', 2701, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Mention blue-light coating next time', '2026-07-10'::timestamptz
  from customers where phone = '+917010757716';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-10-17'::date, '4.00', '4.00', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision + Anti-glare', 4050, 'Dr. Anita Rao', 'Budget-conscious', null, '2025-10-17'::timestamptz
  from customers where phone = '+916334465663';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-07'::date, null, null, 'Sunglasses', 'Police Sunwear', null, 2667, 'Dr. MK', 'Works long hours on screen', null, '2025-11-07'::timestamptz
  from customers where phone = '+916334465663';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-10-09'::date, '5.75', '5.75', 'Spectacles', 'Vincent Chase Round', 'Single Vision', 3705, 'Dr. Anita Rao', 'Asked about installment payment', 'Mention blue-light coating next time', '2025-10-09'::timestamptz
  from customers where phone = '+916251191743';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-07'::date, null, null, 'Sunglasses', 'Vincent Chase Round', null, 2509, 'Dr. Anita Rao', null, null, '2026-02-07'::timestamptz
  from customers where phone = '+918115396219';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-22'::date, '1.50', '1.50', 'Spectacles', 'Fastrack Sporty', 'Single Vision + Blue-cut', 2060, 'Dr. Anita Rao', null, null, '2026-04-22'::timestamptz
  from customers where phone = '+918115396219';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-04'::date, null, null, 'Sunglasses', 'Titan Eyeplus', null, 2073, 'Dr. MK', 'Price-sensitive but loyal', null, '2026-08-04'::timestamptz
  from customers where phone = '+918115396219';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-12-09'::date, '3.00', '3.00', 'Spectacles', 'Woodland Rugged', 'Single Vision + Anti-glare', 4412, 'Dr. MK', 'Asked about installment payment', 'Recommend anti-glare', '2025-12-09'::timestamptz
  from customers where phone = '+919896588347';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-28'::date, '4.75', '4.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Anti-glare', 2576, 'Dr. MK', 'Price-sensitive but loyal', 'Ask about sunglasses', '2026-02-28'::timestamptz
  from customers where phone = '+919896588347';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-06'::date, '0.25', '0.25', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision', 4602, 'Dr. Anita Rao', 'Asked about installment payment', 'Check on contact lens interest', '2026-01-06'::timestamptz
  from customers where phone = '+919919578703';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-09-21'::date, '2.50', '2.50', 'Spectacles', 'IDEE Metal', 'Single Vision + Anti-glare', 4181, 'Dr. Anita Rao', 'Prefers known brands', null, '2025-09-21'::timestamptz
  from customers where phone = '+919737347993';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-07-18'::date, '0.00', '0.00', 'Spectacles', 'IDEE Metal', 'Bifocal', 5359, 'Dr. MK', 'Prefers lightweight frames', null, '2026-07-18'::timestamptz
  from customers where phone = '+919642802468';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-16'::date, '1.00', '1.00', 'Spectacles', 'John Jacobs Classic', 'Progressive Premium', 9276, 'Dr. MK', null, 'Ask about sunglasses', '2026-02-16'::timestamptz
  from customers where phone = '+919013719907';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-03-11'::date, '3.25', '3.25', 'Spectacles', 'Fastrack Sporty', 'Single Vision + Blue-cut', 2995, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Mention blue-light coating next time', '2026-03-11'::timestamptz
  from customers where phone = '+919013719907';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-26'::date, '2.75', '2.75', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Anti-glare', 2494, 'Dr. MK', 'Works long hours on screen', 'Introduce premium frame line', '2026-01-26'::timestamptz
  from customers where phone = '+918087381557';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-23'::date, null, null, 'Sunglasses', 'Oakley Holbrook', null, 3005, 'Dr. MK', 'Prefers known brands', 'Check on contact lens interest', '2025-11-23'::timestamptz
  from customers where phone = '+917088808255';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-12-17'::date, '5.25', '5.25', 'Spectacles', 'John Jacobs Classic', 'Single Vision + Anti-glare', 4387, 'Dr. MK', 'Prioritizes comfort', 'Mention blue-light coating next time', '2025-12-17'::timestamptz
  from customers where phone = '+917088808255';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-13'::date, '4.75', '4.75', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Anti-glare', 1831, 'Dr. Anita Rao', 'Prioritizes comfort', 'Check on contact lens interest', '2026-05-13'::timestamptz
  from customers where phone = '+916329978780';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-03'::date, '1.75', '1.75', 'Spectacles', 'Titan Eyeplus Premium', 'Single Vision + Anti-glare', 2634, 'Dr. Anita Rao', 'Asked about installment payment', 'Mention blue-light coating next time', '2026-06-03'::timestamptz
  from customers where phone = '+916329978780';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-27'::date, '5.00', '5.00', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision', 2624, 'Dr. Anita Rao', null, 'Introduce premium frame line', '2026-06-27'::timestamptz
  from customers where phone = '+916329978780';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-28'::date, '3.75', '3.75', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Blue-cut', 3241, 'Dr. Anita Rao', 'Very particular about frame color', null, '2026-04-28'::timestamptz
  from customers where phone = '+916218954089';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-14'::date, '2.50', '2.50', 'Spectacles', 'Police Sunwear', 'Single Vision + Anti-glare', 2822, 'Dr. MK', 'Asked about installment payment', 'Offer progressive upgrade', '2026-08-14'::timestamptz
  from customers where phone = '+916218954089';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-17'::date, '0.25', '0.25', 'Spectacles', 'Woodland Rugged', 'Single Vision + Blue-cut', 3385, 'Dr. Anita Rao', 'Prefers lightweight frames', null, '2026-01-17'::timestamptz
  from customers where phone = '+918190555554';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-17'::date, '4.00', '4.00', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision', 3056, 'Dr. Anita Rao', 'Works long hours on screen', 'Introduce premium frame line', '2026-06-17'::timestamptz
  from customers where phone = '+919881102622';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-11'::date, null, null, 'Sunglasses', 'John Jacobs Classic', null, 2807, 'Dr. Anita Rao', 'Budget-conscious', 'Check on contact lens interest', '2026-02-11'::timestamptz
  from customers where phone = '+919986001542';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-23'::date, null, null, 'Sunglasses', 'Titan Eyeplus Premium', null, 2198, 'Dr. Anita Rao', null, 'Recommend anti-glare', '2026-04-23'::timestamptz
  from customers where phone = '+919986001542';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-01'::date, '1.75', '1.75', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Blue-cut', 4137, 'Dr. Anita Rao', 'Asked about installment payment', 'Ask about sunglasses', '2025-11-01'::timestamptz
  from customers where phone = '+919760815200';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-25'::date, '5.50', '5.50', 'Spectacles', 'Woodland Rugged', 'Single Vision + Anti-glare', 3217, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Introduce premium frame line', '2025-11-25'::timestamptz
  from customers where phone = '+919760815200';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-06'::date, '0.50', '0.50', 'Spectacles', 'Fastrack Sporty', 'Single Vision', 4336, 'Dr. Anita Rao', 'Wants a stylish upgrade', 'Offer progressive upgrade', '2026-05-06'::timestamptz
  from customers where phone = '+919644083332';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-02'::date, '0.75', '0.75', 'Spectacles', 'Oakley Holbrook', 'Single Vision + Blue-cut', 3423, 'Dr. MK', 'Asked about installment payment', 'Mention blue-light coating next time', '2026-08-02'::timestamptz
  from customers where phone = '+919644083332';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2025-11-25'::date, '4.25', '4.25', 'Spectacles', 'Woodland Rugged', 'Single Vision', 4469, 'Dr. MK', 'Asked about installment payment', 'Ask about sunglasses', '2025-11-25'::timestamptz
  from customers where phone = '+919072883872';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-02-24'::date, '3.75', '3.75', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision + Anti-glare', 1981, 'Dr. Anita Rao', 'Prefers known brands', 'Ask about sunglasses', '2026-02-24'::timestamptz
  from customers where phone = '+919072883872';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-20'::date, '0.25', '0.25', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Anti-glare', 3179, 'Dr. Anita Rao', 'Budget-conscious', null, '2026-05-20'::timestamptz
  from customers where phone = '+919072883872';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-27'::date, '1.00', '1.00', 'Spectacles', 'Ray-Ban Wayfarer', 'Single Vision', 3168, 'Dr. MK', 'Works long hours on screen', null, '2026-04-27'::timestamptz
  from customers where phone = '+918028438657';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-09'::date, '3.00', '3.00', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Blue-cut', 2360, 'Dr. Anita Rao', 'Price-sensitive but loyal', 'Introduce premium frame line', '2026-06-09'::timestamptz
  from customers where phone = '+918028438657';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-07'::date, '2.00', '2.00', 'Spectacles', 'John Jacobs Classic', 'Single Vision + Anti-glare', 2985, 'Dr. MK', 'Wants a stylish upgrade', 'Offer progressive upgrade', '2026-06-07'::timestamptz
  from customers where phone = '+917040225308';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-08'::date, '3.75', '3.75', 'Spectacles', 'Titan Eyeplus Premium', 'Bifocal', 8417, 'Dr. Anita Rao', 'Prioritizes comfort', 'Ask about sunglasses', '2026-08-08'::timestamptz
  from customers where phone = '+917040225308';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-29'::date, '4.00', '4.00', 'Spectacles', 'IDEE Metal', 'Single Vision + Anti-glare', 3153, 'Dr. MK', 'Prefers lightweight frames', 'Mention blue-light coating next time', '2026-08-29'::timestamptz
  from customers where phone = '+917040225308';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-01-08'::date, '0.75', '0.75', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Anti-glare', 3284, 'Dr. MK', null, null, '2026-01-08'::timestamptz
  from customers where phone = '+916385867283';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-04-03'::date, '4.00', '4.00', 'Spectacles', 'Vincent Chase Cateye', 'Single Vision + Blue-cut', 2927, 'Dr. Anita Rao', 'Prefers known brands', null, '2026-04-03'::timestamptz
  from customers where phone = '+916385867283';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-03-14'::date, null, null, 'Sunglasses', 'Fastrack Classic', null, 1826, 'Dr. MK', 'Wants a stylish upgrade', 'Ask about sunglasses', '2026-03-14'::timestamptz
  from customers where phone = '+916227260416';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-06-06'::date, '2.75', '2.75', 'Spectacles', 'Titan Eyeplus', 'Single Vision + Blue-cut', 2480, 'Dr. MK', 'Price-sensitive but loyal', 'Check on contact lens interest', '2026-06-06'::timestamptz
  from customers where phone = '+916227260416';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-08-23'::date, '0.75', '0.75', 'Spectacles', 'IDEE Metal', 'Single Vision + Blue-cut', 2158, 'Dr. MK', null, 'Check on contact lens interest', '2026-08-23'::timestamptz
  from customers where phone = '+916227260416';
insert into visits (customer_id, visit_date, od_sphere, os_sphere, product_type, frame, lens, amount, prescribed_by, preferences_budget, pitch_next_time, created_at)
  select id, '2026-05-02'::date, '2.25', '2.25', 'Spectacles', 'Ray-Ban Aviator', 'Progressive Premium', 9843, 'Dr. MK', 'Prefers lightweight frames', 'Check on contact lens interest', '2026-05-02'::timestamptz
  from customers where phone = '+918127263117';

-- --- Enquiries -------------------------------------------------
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Farhan Sheikh', '+919845011223', 'Progressive lenses', 'Wanted to compare prices elsewhere', 'Very interested, said he''d be back this week', 'open', current_date - 9);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Kavya Menon', '+919845033445', 'Sunglasses (Ray-Ban)', 'Price concern', 'Liked the Aviator but felt it was expensive', 'open', current_date - 1);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Rohit Bafna', '+919845055667', 'Contact lenses', 'Needed to consult with spouse', 'First-time contact lens wearer, a bit nervous', 'open', current_date - 8);
insert into leads (name, phone, interest, reason_not_bought, notes, status, enquiry_date) values ('Alisha Fernandes', '+919845077889', 'Kids'' spectacles', 'Wanted to check other stores nearby', 'Daughter, age 9, needs mild correction', 'open', current_date - 7);

-- --- Follow-ups (2 overdue, 2 due today, 2 upcoming) -----------
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (-6), 'pending'
  from customers where phone = '+916334465663';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Consumables', current_date + (-2), 'pending'
  from customers where phone = '+919986001542';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (0), 'pending'
  from customers where phone = '+917040225308';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Discount offer', current_date + (0), 'pending'
  from customers where phone = '+916218954089';
insert into reminders (customer_id, type, due_date, status)
  select id, 'New collection', current_date + (5), 'pending'
  from customers where phone = '+919072883872';
insert into reminders (customer_id, type, due_date, status)
  select id, 'Eye test', current_date + (14), 'pending'
  from customers where phone = '+919666375770';
