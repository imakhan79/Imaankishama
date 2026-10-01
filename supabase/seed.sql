/*
# Iman Ki Shama — Demo Seed Data (all modules)

Populates every LMS module with realistic, internally consistent demo data:
users (all roles/statuses), courses (every status), lectures, materials,
library books, lecture attachments, enrollments, progress/activity/watch
events, attendance, ratings, bookmarks, material views, question bank (every
type/status), exam templates, exams/quizzes, registrations, attempts,
responses, assignments + submissions, worksheet submissions, live sessions +
attendance + recordings, fees (structures, discounts, assessments,
installments, payments, refunds), KPI configs + snapshots, alerts, audit logs,
login events, student analytics and certificates.

Safe to re-run:
- Content rows use fixed ids; derived rows use deterministic md5-based ids.
- Every insert is ON CONFLICT DO NOTHING (or guarded with NOT EXISTS).
- Pseudo-random values come from hashtext(), so re-runs are identical.
- Everything runs in one transaction — a failure leaves the DB untouched.

Volume: 2 admins, 9 professors, 74 students, 18 courses (66 lectures),
~270 enrollments and everything derived from them (progress, attendance,
exam attempts, submissions, fees, KPIs, alerts, logins …).

All seed accounts use the password:  Seed@12345
  admin:      ayesha.siddiqui@imaankishama.test   (also bilal.ahmed@…)
  professor:  abdullah.rahman@imaankishama.test   (and 8 others)
  student:    ahmed.raza@imaankishama.test        (and 73 others)

Apply with:  node run-seed.mjs   (needs DATABASE_URL), or paste into the
Supabase SQL editor.
*/

BEGIN;

-- Normally added by 20260803010000_demo_recorded_lectures.sql, but that migration
-- references production-only user ids and fails on a fresh database.
ALTER TABLE lectures ADD COLUMN IF NOT EXISTS thumbnail_url text NOT NULL DEFAULT '';

-- ════════════════════════════════════════════════════════════════════════════
-- 1. USERS (auth.users → profiles via handle_new_user trigger)
-- ════════════════════════════════════════════════════════════════════════════
CREATE TEMP TABLE seed_users (
  n int, id uuid, email text, full_name text, role text, status text, phone text, joined interval
) ON COMMIT DROP;

INSERT INTO seed_users VALUES
  ( 1, 'e0000000-0000-4000-8000-000000000001', 'ayesha.siddiqui@imaankishama.test', 'Ayesha Siddiqui',      'admin',     'active',             '+92 300 1110001', '180 days'),
  ( 2, 'e0000000-0000-4000-8000-000000000002', 'bilal.ahmed@imaankishama.test',     'Bilal Ahmed',          'admin',     'active',             '+92 300 1110002', '170 days'),
  (11, 'e0000000-0000-4000-8000-000000000011', 'abdullah.rahman@imaankishama.test', 'Dr. Abdullah Rahman',  'professor', 'active',             '+92 321 2220011', '160 days'),
  (12, 'e0000000-0000-4000-8000-000000000012', 'maryam.qureshi@imaankishama.test',  'Ustadha Maryam Qureshi','professor','active',             '+92 321 2220012', '150 days'),
  (13, 'e0000000-0000-4000-8000-000000000013', 'hamza.khan@imaankishama.test',      'Mufti Hamza Khan',     'professor', 'active',             '+92 321 2220013', '150 days'),
  (14, 'e0000000-0000-4000-8000-000000000014', 'khadija.noor@imaankishama.test',    'Dr. Khadija Noor',     'professor', 'active',             '+92 321 2220014', '140 days'),
  (15, 'e0000000-0000-4000-8000-000000000015', 'imran.malik@imaankishama.test',     'Ustad Imran Malik',    'professor', 'pending_activation', '+92 321 2220015', '3 days'),
  (16, 'e0000000-0000-4000-8000-000000000016', 'saad.hashmi@imaankishama.test',     'Dr. Saad Hashmi',      'professor', 'active',             '+92 321 2220016', '130 days'),
  (17, 'e0000000-0000-4000-8000-000000000017', 'zubair.anwar@imaankishama.test',    'Mufti Zubair Anwar',   'professor', 'active',             '+92 321 2220017', '125 days'),
  (18, 'e0000000-0000-4000-8000-000000000018', 'sana.rafiq@imaankishama.test',      'Ustadha Sana Rafiq',   'professor', 'active',             '+92 321 2220018', '115 days'),
  (19, 'e0000000-0000-4000-8000-000000000019', 'tariq.mehmood@imaankishama.test',   'Shaykh Tariq Mehmood', 'professor', 'active',             '+92 321 2220019', '105 days'),
  (21, 'e0000000-0000-4000-8000-000000000021', 'ahmed.raza@imaankishama.test',      'Ahmed Raza',           'student',   'active',             '+92 333 3330021', '130 days'),
  (22, 'e0000000-0000-4000-8000-000000000022', 'fatima.zahra@imaankishama.test',    'Fatima Zahra',         'student',   'active',             '+92 333 3330022', '120 days'),
  (23, 'e0000000-0000-4000-8000-000000000023', 'usman.ali@imaankishama.test',       'Usman Ali',            'student',   'active',             '+92 333 3330023', '110 days'),
  (24, 'e0000000-0000-4000-8000-000000000024', 'zainab.hussain@imaankishama.test',  'Zainab Hussain',       'student',   'active',             '+92 333 3330024', '100 days'),
  (25, 'e0000000-0000-4000-8000-000000000025', 'hassan.javed@imaankishama.test',    'Hassan Javed',         'student',   'active',             '+92 333 3330025', '90 days'),
  (26, 'e0000000-0000-4000-8000-000000000026', 'amina.tariq@imaankishama.test',     'Amina Tariq',          'student',   'active',             '+92 333 3330026', '80 days'),
  (27, 'e0000000-0000-4000-8000-000000000027', 'omar.farooq@imaankishama.test',     'Omar Farooq',          'student',   'active',             '+92 333 3330027', '70 days'),
  (28, 'e0000000-0000-4000-8000-000000000028', 'hafsa.iqbal@imaankishama.test',     'Hafsa Iqbal',          'student',   'active',             '+92 333 3330028', '60 days'),
  (29, 'e0000000-0000-4000-8000-000000000029', 'yusuf.sheikh@imaankishama.test',    'Yusuf Sheikh',         'student',   'active',             '+92 333 3330029', '50 days'),
  (30, 'e0000000-0000-4000-8000-000000000030', 'sumayyah.akhtar@imaankishama.test', 'Sumayyah Akhtar',      'student',   'active',             '+92 333 3330030', '40 days'),
  (31, 'e0000000-0000-4000-8000-000000000031', 'ibrahim.mirza@imaankishama.test',   'Ibrahim Mirza',        'student',   'suspended',          '+92 333 3330031', '95 days'),
  (32, 'e0000000-0000-4000-8000-000000000032', 'ruqayyah.shah@imaankishama.test',   'Ruqayyah Shah',        'student',   'graduated',          '+92 333 3330032', '175 days'),
  (33, 'e0000000-0000-4000-8000-000000000033', 'saad.chaudhry@imaankishama.test',   'Saad Chaudhry',        'student',   'withdrawn',          '+92 333 3330033', '85 days'),
  (34, 'e0000000-0000-4000-8000-000000000034', 'aisha.kareem@imaankishama.test',    'Aisha Kareem',         'student',   'pending_activation', '+92 333 3330034', '1 day');

-- 60 more students (n = 35..94) with deterministic names; every (first, last) pair is unique.
INSERT INTO seed_users
SELECT n, ('e0000000-0000-4000-8000-0000000000' || n)::uuid,
       lower(f.name || '.' || l.name || n) || '@imaankishama.test',
       f.name || ' ' || l.name, 'student',
       CASE WHEN n % 17 = 0 THEN 'inactive' WHEN n % 29 = 0 THEN 'suspended' WHEN n % 31 = 0 THEN 'graduated' ELSE 'active' END,
       '+92 345 ' || (4440000 + n), (((n * 37) % 200 + 5) || ' days')::interval
FROM generate_series(35, 94) n
CROSS JOIN LATERAL (SELECT (ARRAY['Abdullah','Maryam','Hamza','Khadija','Ali','Safiya','Bilal','Noor','Talha','Hira',
                                  'Zubair','Iqra','Musa','Laiba','Idris','Mahnoor','Anas','Areeba','Haris','Esha',
                                  'Rayyan','Maham','Ayaan','Zara','Faisal','Sana','Junaid','Rabia','Shoaib','Mehwish'])[1 + n % 30] AS name) f
CROSS JOIN LATERAL (SELECT (ARRAY['Khan','Ahmed','Malik','Butt','Qureshi','Siddiqui','Chaudhry','Raza','Hussain','Sheikh',
                                  'Mirza','Abbasi','Rana','Hashmi','Ansari','Baig','Javed','Iqbal','Akhtar','Farooqi'])[1 + (n * 7) % 20] AS name) l;

INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
)
SELECT '00000000-0000-0000-0000-000000000000', u.id, 'authenticated', 'authenticated', u.email,
       extensions.crypt('Seed@12345', extensions.gen_salt('bf')), now() - u.joined,
       '{"provider":"email","providers":["email"]}'::jsonb,
       jsonb_build_object('full_name', u.full_name, 'role', u.role),
       now() - u.joined, now(), '', '', '', ''
FROM seed_users u
WHERE NOT EXISTS (SELECT 1 FROM auth.users a WHERE a.id = u.id OR a.email = u.email);

INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
SELECT md5('seed-identity-' || u.id)::uuid, u.id, u.id::text,
       jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
       'email', now(), now() - u.joined, now()
FROM seed_users u
WHERE EXISTS (SELECT 1 FROM auth.users a WHERE a.id = u.id)
  AND NOT EXISTS (SELECT 1 FROM auth.identities i WHERE i.provider = 'email' AND i.provider_id = u.id::text);

-- The trigger creates a bare profile; set role/status/name/phone explicitly.
INSERT INTO profiles (id, email, full_name, role, status, phone, created_at)
SELECT u.id, u.email, u.full_name, u.role, u.status, u.phone, now() - u.joined
FROM seed_users u
WHERE EXISTS (SELECT 1 FROM auth.users a WHERE a.id = u.id)
ON CONFLICT (id) DO UPDATE SET
  email = EXCLUDED.email, full_name = EXCLUDED.full_name, role = EXCLUDED.role,
  status = EXCLUDED.status, phone = EXCLUDED.phone, created_at = EXCLUDED.created_at;

-- ════════════════════════════════════════════════════════════════════════════
-- 2. COURSES (every status) & LECTURES
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO courses (id, title, description, category, professor_id, status, thumbnail_url, created_at) VALUES
  ('e1000000-0000-4000-8000-000000000001', 'Tajweed Essentials: Reciting the Quran Correctly', 'Learn the makharij (points of articulation) and the core rules of tajweed so you can recite the Quran as it was revealed.', 'Quran', 'e0000000-0000-4000-8000-000000000011', 'published', '', now() - interval '120 days'),
  ('e1000000-0000-4000-8000-000000000002', 'Tafseer of Juz Amma', 'Meaning, context and practical lessons of the short surahs most of us recite daily in salah.', 'Tafseer', 'e0000000-0000-4000-8000-000000000011', 'published', '', now() - interval '110 days'),
  ('e1000000-0000-4000-8000-000000000003', 'Foundations of Aqeedah', 'Tawheed and the six pillars of Iman, grounded in the Quran (Surah An-Nisa 4:136) and authentic Sunnah.', 'Aqeedah', 'e0000000-0000-4000-8000-000000000013', 'published', '', now() - interval '100 days'),
  ('e1000000-0000-4000-8000-000000000004', 'Seerah: The Makkan Period', 'The life of the Prophet Muhammad ﷺ from his birth to the Hijrah — revelation, da''wah and steadfastness.', 'Seerah', 'e0000000-0000-4000-8000-000000000014', 'published', '', now() - interval '95 days'),
  ('e1000000-0000-4000-8000-000000000005', 'Fiqh of Taharah & Salah', 'Purification, wudu, ghusl, tayammum, and the conditions, pillars and common mistakes of prayer.', 'Fiqh', 'e0000000-0000-4000-8000-000000000013', 'published', '', now() - interval '90 days'),
  ('e1000000-0000-4000-8000-000000000006', 'Akhlaq: Building Islamic Character', 'Truthfulness, trustworthiness, patience and gratitude — turning knowledge into character.', 'Akhlaq', 'e0000000-0000-4000-8000-000000000014', 'approved', '', now() - interval '30 days'),
  ('e1000000-0000-4000-8000-000000000007', 'Daily Adhkar & Masnoon Duas', 'Morning and evening adhkar and everyday supplications from the Sunnah, with meaning and pronunciation.', 'Duas & Dhikr', 'e0000000-0000-4000-8000-000000000012', 'pending', '', now() - interval '6 days'),
  ('e1000000-0000-4000-8000-000000000008', 'Quranic Arabic for Beginners', 'The Arabic alphabet, harakat and high-frequency Quranic vocabulary.', 'Quran', 'e0000000-0000-4000-8000-000000000012', 'draft', '', now() - interval '2 days'),
  ('e1000000-0000-4000-8000-000000000009', 'Seerah: The Madinan Period (2025 Cohort)', 'From the Hijrah to the Farewell Pilgrimage. Archived after the 2025 cohort completed.', 'Seerah', 'e0000000-0000-4000-8000-000000000014', 'archived', '', now() - interval '170 days'),
  ('e1000000-0000-4000-8000-000000000010', 'Tafseer of Surah Al-Kahf', 'The four great stories of Surah Al-Kahf and their protection against the trials of faith, wealth, knowledge and power.', 'Tafseer', 'e0000000-0000-4000-8000-000000000011', 'published', '', now() - interval '85 days'),
  ('e1000000-0000-4000-8000-000000000011', 'Aqeedah: Names & Attributes of Allah', 'Knowing Allah through Al-Asma ul-Husna and living by their meanings.', 'Aqeedah', 'e0000000-0000-4000-8000-000000000016', 'published', '', now() - interval '80 days'),
  ('e1000000-0000-4000-8000-000000000012', 'Seerah: Lives of the Sahabah', 'Biographies of the noble companions and the lessons of their sacrifice, courage and character.', 'Seerah', 'e0000000-0000-4000-8000-000000000014', 'published', '', now() - interval '75 days'),
  ('e1000000-0000-4000-8000-000000000013', 'Fiqh of Fasting (Sawm)', 'Rulings of Ramadan and voluntary fasts: conditions, invalidators, exemptions, I''tikaf and Laylat al-Qadr.', 'Fiqh', 'e0000000-0000-4000-8000-000000000017', 'published', '', now() - interval '70 days'),
  ('e1000000-0000-4000-8000-000000000014', 'Fiqh of Zakat & Sadaqah', 'Who pays zakat, on what, how much, and to whom — plus Zakat al-Fitr and voluntary charity.', 'Fiqh', 'e0000000-0000-4000-8000-000000000017', 'published', '', now() - interval '65 days'),
  ('e1000000-0000-4000-8000-000000000015', 'Akhlaq: Rights of Parents & Family', 'Honouring parents, spouses, children, relatives and neighbours as taught by the Quran and Sunnah.', 'Akhlaq', 'e0000000-0000-4000-8000-000000000018', 'published', '', now() - interval '60 days'),
  ('e1000000-0000-4000-8000-000000000016', 'Daily Iman: Building a Muslim Routine', 'A practical programme for daily salah, Quran, dhikr and self-accountability (muhasabah).', 'Daily Iman', 'e0000000-0000-4000-8000-000000000018', 'published', '', now() - interval '55 days'),
  ('e1000000-0000-4000-8000-000000000017', 'Hajj & Umrah: A Step-by-Step Guide', 'Types of Hajj, ihram, the rites of Umrah and the days of Hajj, with etiquette for visiting Madinah.', 'Fiqh', 'e0000000-0000-4000-8000-000000000019', 'published', '', now() - interval '50 days'),
  ('e1000000-0000-4000-8000-000000000018', 'Duas from the Quran', 'The supplications of the Prophets and the believers as recorded in the Quran.', 'Duas & Dhikr', 'e0000000-0000-4000-8000-000000000012', 'approved', '', now() - interval '12 days')
ON CONFLICT (id) DO NOTHING;

INSERT INTO lectures (id, course_id, title, description, duration_seconds, learning_objectives, publish_date, order_index, thumbnail_url) VALUES
  ('e2000000-0000-4000-8000-000000000011', 'e1000000-0000-4000-8000-000000000001', 'Introduction to Tajweed & Its Importance', 'What tajweed is, why it matters, and how to approach learning it.', 1500, 'Define tajweed and explain why correct recitation is required.', now() - interval '60 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000012', 'e1000000-0000-4000-8000-000000000001', 'Makharij: Points of Articulation', 'The five main areas of articulation and the letters that emerge from each.', 2100, 'Identify the makhraj of each Arabic letter.', now() - interval '45 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000013', 'e1000000-0000-4000-8000-000000000001', 'Rules of Noon Saakin & Tanween', 'Izhar, Idghaam, Iqlab and Ikhfa with worked examples from Juz Amma.', 2400, 'Apply the four rules of noon saakin and tanween while reciting.', now() - interval '20 days', 3, ''),
  ('e2000000-0000-4000-8000-000000000021', 'e1000000-0000-4000-8000-000000000002', 'Surah An-Naba: The Great News', 'The opening surah of Juz Amma and its description of the Day of Judgement.', 2400, 'Summarise the themes of Surah An-Naba.', now() - interval '55 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000022', 'e1000000-0000-4000-8000-000000000002', 'Surah Al-Asr: The Formula of Success', 'Four qualities that save a person from loss: Iman, good deeds, enjoining truth and patience.', 1800, 'Explain the four conditions for success in Surah Al-Asr.', now() - interval '40 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000023', 'e1000000-0000-4000-8000-000000000002', 'The Three Quls: Al-Ikhlas, Al-Falaq & An-Nas', 'Pure Tawheed and seeking refuge in Allah — meanings and virtues.', 2400, 'Explain the meanings and virtues of the last three surahs.', now() - interval '15 days', 3, ''),
  ('e2000000-0000-4000-8000-000000000031', 'e1000000-0000-4000-8000-000000000003', 'Tawheed: The Oneness of Allah', 'Tawheed in Lordship, worship, and Allah''s names and attributes.', 2400, 'Describe the categories of Tawheed.', now() - interval '50 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000032', 'e1000000-0000-4000-8000-000000000003', 'The Six Pillars of Iman (Surah An-Nisa 4:136)', 'Belief in Allah, His angels, books, messengers, the Last Day and Al-Qadr.', 2700, 'List and explain the six pillars of Iman.', now() - interval '35 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000033', 'e1000000-0000-4000-8000-000000000003', 'Belief in Al-Qadr: Divine Decree', 'Understanding divine decree, human choice, and trust in Allah.', 2100, 'Explain belief in Al-Qadr and its effect on daily life.', now() - interval '10 days', 3, ''),
  ('e2000000-0000-4000-8000-000000000041', 'e1000000-0000-4000-8000-000000000004', 'Arabia Before Islam & the Birth of the Prophet ﷺ', 'Social and religious life in pre-Islamic Arabia and the Year of the Elephant.', 2100, 'Describe the setting into which the Prophet ﷺ was born.', now() - interval '48 days', 1, 'https://img.youtube.com/vi/leWJExocCsQ/hqdefault.jpg'),
  ('e2000000-0000-4000-8000-000000000042', 'e1000000-0000-4000-8000-000000000004', 'The First Revelation in Cave Hira', 'The descent of the first verses of Surah Al-Alaq and the beginning of prophethood.', 2100, 'Narrate the events of the first revelation.', now() - interval '30 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000043', 'e1000000-0000-4000-8000-000000000004', 'Persecution in Makkah & Migration to Abyssinia', 'Trials of the early Muslims and the refuge granted by the Negus.', 2700, 'Explain why the Muslims migrated to Abyssinia.', now() - interval '12 days', 3, ''),
  ('e2000000-0000-4000-8000-000000000051', 'e1000000-0000-4000-8000-000000000005', 'Taharah: Wudu, Ghusl & Tayammum', 'Types of purification, how to perform them, and what nullifies them.', 2400, 'Perform wudu, ghusl and tayammum correctly.', now() - interval '42 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000052', 'e1000000-0000-4000-8000-000000000005', 'Conditions & Pillars of Salah', 'What must be in place before prayer and what makes up the prayer itself.', 2700, 'Distinguish the conditions, pillars and sunnahs of salah.', now() - interval '25 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000053', 'e1000000-0000-4000-8000-000000000005', 'Common Mistakes in Prayer', 'Frequent errors in salah and how to correct them. (Scheduled release.)', 1800, 'Identify and correct common mistakes in salah.', now() + interval '3 days', 3, ''),
  ('e2000000-0000-4000-8000-000000000061', 'e1000000-0000-4000-8000-000000000006', 'Truthfulness (Sidq) & Trustworthiness (Amanah)', 'Why truthfulness leads to righteousness and how to keep trusts.', 1800, 'Apply sidq and amanah in daily dealings.', now() - interval '5 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000062', 'e1000000-0000-4000-8000-000000000006', 'Patience (Sabr) & Gratitude (Shukr)', 'Two halves of Iman: patience in hardship and gratitude in ease.', 2100, 'Describe the types of sabr and the practice of shukr.', now() - interval '5 days', 2, ''),
  ('e2000000-0000-4000-8000-000000000071', 'e1000000-0000-4000-8000-000000000007', 'Morning & Evening Adhkar', 'The core adhkar for morning and evening and their virtues.', 1500, 'Recite the core morning and evening adhkar.', now() + interval '10 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000081', 'e1000000-0000-4000-8000-000000000008', 'The Arabic Alphabet & Harakat', 'Letter shapes, pronunciation and short vowels.', 1320, 'Read and write the Arabic alphabet with harakat.', now() + interval '14 days', 1, 'https://img.youtube.com/vi/bJ1MAanBZJE/hqdefault.jpg'),
  ('e2000000-0000-4000-8000-000000000091', 'e1000000-0000-4000-8000-000000000009', 'The Hijrah & Building the Madinan Society', 'The migration to Madinah, the masjid and the brotherhood of Muhajirun and Ansar.', 2400, 'Explain how the first Muslim community was established.', now() - interval '160 days', 1, ''),
  ('e2000000-0000-4000-8000-000000000092', 'e1000000-0000-4000-8000-000000000009', 'The Farewell Pilgrimage', 'The final Hajj of the Prophet ﷺ and the Farewell Sermon.', 2100, 'Summarise the key messages of the Farewell Sermon.', now() - interval '150 days', 2, '')
ON CONFLICT (id) DO NOTHING;

-- Lectures for courses 10–18. Id = e2…-000000000<course 2 digits><order 1 digit>;
-- released weekly from the course start date (later ones are scheduled in the future).
CREATE TEMP TABLE seed_lec (course int, ord int, title text) ON COMMIT DROP;
INSERT INTO seed_lec VALUES
  (10,1,'Introduction & the Virtue of Reciting Al-Kahf on Friday'),(10,2,'The People of the Cave: The Trial of Faith'),
  (10,3,'The Owner of the Two Gardens: The Trial of Wealth'),(10,4,'Musa & Al-Khidr: The Trial of Knowledge'),
  (10,5,'Dhul-Qarnayn: The Trial of Power'),(10,6,'Lessons of Al-Kahf Against the Fitnah of Dajjal'),
  (11,1,'Introduction to Al-Asma ul-Husna'),(11,2,'Ar-Rahman & Ar-Raheem: Allah''s Mercy'),
  (11,3,'Al-Ghafoor & At-Tawwab: Forgiveness & Repentance'),(11,4,'Ar-Razzaq & Al-Wakeel: Provision & Trust'),
  (11,5,'Living by the Names of Allah'),
  (12,1,'Abu Bakr as-Siddiq (RA)'),(12,2,'Umar ibn al-Khattab (RA)'),(12,3,'Uthman ibn Affan (RA)'),
  (12,4,'Ali ibn Abi Talib (RA)'),(12,5,'Khadijah & Aisha (RA): Mothers of the Believers'),(12,6,'Bilal ibn Rabah (RA)'),
  (13,1,'The Virtues & Obligation of Ramadan'),(13,2,'Conditions & Pillars of the Fast'),
  (13,3,'What Breaks the Fast — and What Doesn''t'),(13,4,'Exemptions, Qada & Fidyah'),(13,5,'I''tikaf & Laylat al-Qadr'),
  (14,1,'Zakat in the Quran & Sunnah'),(14,2,'Nisab & Hawl: When Zakat Becomes Due'),
  (14,3,'Calculating Zakat on Savings, Gold & Silver'),(14,4,'The Eight Categories of Recipients (9:60)'),
  (14,5,'Zakat al-Fitr & Voluntary Sadaqah'),
  (15,1,'Birr al-Walidayn: Honouring Parents (17:23–24)'),(15,2,'Rights of Spouses'),(15,3,'Raising Children with Iman'),
  (15,4,'Silat ar-Rahim: Ties of Kinship'),(15,5,'Rights of Neighbours'),
  (16,1,'The Fajr Routine'),(16,2,'A Daily Quran Habit'),(16,3,'Dhikr Throughout the Day'),
  (16,4,'Night Reflection & Muhasabah'),(16,5,'Setting Weekly Iman Goals'),
  (17,1,'Types of Hajj: Tamattu'', Qiran & Ifrad'),(17,2,'Ihram & Its Restrictions'),(17,3,'The Rites of Umrah'),
  (17,4,'The Days of Hajj: 8th to 13th Dhul Hijjah'),(17,5,'Etiquette of Visiting Madinah'),
  (18,1,'The Rabbana Duas'),(18,2,'Duas of the Prophets'),(18,3,'Etiquette of Making Dua');

INSERT INTO lectures (id, course_id, title, description, duration_seconds, learning_objectives, publish_date, order_index, thumbnail_url)
SELECT ('e2000000-0000-4000-8000-000000000' || s.course || s.ord)::uuid, c.id, s.title,
       'Lecture ' || s.ord || ' of "' || c.title || '": ' || s.title || '.',
       1200 + abs(hashtext(s.title)) % 1800,
       'Understand and apply the key lessons of "' || s.title || '".',
       c.created_at + ((s.ord * 9) || ' days')::interval, s.ord, ''
FROM seed_lec s
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-0000000000' || s.course)::uuid
ON CONFLICT (id) DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 3. COURSE MATERIALS, LIBRARY BOOKS & LECTURE ATTACHMENTS
--    (inserted before enrollments so the new-material trigger doesn't flood alerts)
-- ════════════════════════════════════════════════════════════════════════════
-- Lecture notes (PDF) for every seeded lecture
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at)
SELECT ('e3000000-0000-4000-8000-000000000' || right(l.id::text, 3))::uuid, l.course_id, l.id, 'pdf',
       'Lecture Notes — ' || l.title,
       'https://example.com/seed/notes/lecture-' || right(l.id::text, 3) || '.pdf',
       350000 + (abs(hashtext(l.id::text)) % 900000), 0, least(l.publish_date, now())
FROM lectures l
WHERE l.id::text LIKE 'e2000000-%'
ON CONFLICT (id) DO NOTHING;

-- Recordings (only verified, embeddable videos already used elsewhere in this project)
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at) VALUES
  ('e3100000-0000-4000-8000-000000000041', 'e1000000-0000-4000-8000-000000000004', 'e2000000-0000-4000-8000-000000000041', 'video', 'Arabia Before Islam — Recording', 'https://www.youtube.com/watch?v=leWJExocCsQ', 0, 2100, now() - interval '48 days'),
  ('e3100000-0000-4000-8000-000000000081', 'e1000000-0000-4000-8000-000000000008', 'e2000000-0000-4000-8000-000000000081', 'video', 'The Arabic Alphabet — Recording', 'https://www.youtube.com/watch?v=bJ1MAanBZJE', 0, 1320, now() - interval '2 days')
ON CONFLICT (id) DO NOTHING;

-- Library books (course-level)
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at) VALUES
  ('e3200000-0000-4000-8000-000000000001', 'e1000000-0000-4000-8000-000000000001', NULL, 'book', 'Tajweed Rules of the Quran, Part 1 — Kareema Carol Czerepinski', 'https://example.com/seed/library/tajweed-rules-part-1.pdf', 8400000, 0, now() - interval '118 days'),
  ('e3200000-0000-4000-8000-000000000002', 'e1000000-0000-4000-8000-000000000002', NULL, 'book', 'Tafsir Ibn Kathir — Juz Amma (Abridged)', 'https://example.com/seed/library/tafsir-ibn-kathir-juz-amma.pdf', 12600000, 0, now() - interval '108 days'),
  ('e3200000-0000-4000-8000-000000000003', 'e1000000-0000-4000-8000-000000000003', NULL, 'book', 'Al-Aqidah al-Tahawiyyah (with Commentary)', 'https://example.com/seed/library/aqidah-tahawiyyah.pdf', 5200000, 0, now() - interval '98 days'),
  ('e3200000-0000-4000-8000-000000000004', 'e1000000-0000-4000-8000-000000000004', NULL, 'book', 'Ar-Raheeq Al-Makhtum (The Sealed Nectar) — Safiur Rahman Mubarakpuri', 'https://example.com/seed/library/the-sealed-nectar.pdf', 15800000, 0, now() - interval '93 days'),
  ('e3200000-0000-4000-8000-000000000005', 'e1000000-0000-4000-8000-000000000005', NULL, 'book', 'Fiqh us-Sunnah, Vol. 1: Purification & Prayer — Sayyid Sabiq', 'https://example.com/seed/library/fiqh-us-sunnah-vol1.pdf', 9900000, 0, now() - interval '88 days'),
  ('e3200000-0000-4000-8000-000000000006', 'e1000000-0000-4000-8000-000000000006', NULL, 'book', 'Riyad as-Salihin — Imam an-Nawawi', 'https://example.com/seed/library/riyad-as-salihin.pdf', 21000000, 0, now() - interval '28 days'),
  ('e3200000-0000-4000-8000-000000000007', 'e1000000-0000-4000-8000-000000000007', NULL, 'book', 'Hisnul Muslim (Fortress of the Muslim) — Sa''id al-Qahtani', 'https://example.com/seed/library/hisnul-muslim.pdf', 3100000, 0, now() - interval '5 days'),
  ('e3200000-0000-4000-8000-000000000010', 'e1000000-0000-4000-8000-000000000010', NULL, 'book', 'Tafsir Ibn Kathir — Surah Al-Kahf', 'https://example.com/seed/library/tafsir-ibn-kathir-al-kahf.pdf', 7400000, 0, now() - interval '84 days'),
  ('e3200000-0000-4000-8000-000000000012', 'e1000000-0000-4000-8000-000000000012', NULL, 'book', 'Men Around the Messenger — Khalid Muhammad Khalid', 'https://example.com/seed/library/men-around-the-messenger.pdf', 11200000, 0, now() - interval '74 days'),
  ('e3200000-0000-4000-8000-000000000013', 'e1000000-0000-4000-8000-000000000013', NULL, 'book', 'Fiqh us-Sunnah — Sayyid Sabiq (Chapters on Fasting)', 'https://example.com/seed/library/fiqh-us-sunnah-fasting.pdf', 6100000, 0, now() - interval '69 days'),
  ('e3200000-0000-4000-8000-000000000014', 'e1000000-0000-4000-8000-000000000014', NULL, 'book', 'Fiqh us-Sunnah — Sayyid Sabiq (Chapters on Zakah)', 'https://example.com/seed/library/fiqh-us-sunnah-zakah.pdf', 5800000, 0, now() - interval '64 days'),
  ('e3200000-0000-4000-8000-000000000015', 'e1000000-0000-4000-8000-000000000015', NULL, 'book', 'Riyad as-Salihin — Chapters on Parents & Kinship', 'https://example.com/seed/library/riyad-as-salihin-family.pdf', 4300000, 0, now() - interval '59 days'),
  ('e3200000-0000-4000-8000-000000000016', 'e1000000-0000-4000-8000-000000000016', NULL, 'book', 'Hisnul Muslim (Pocket Edition) — Sa''id al-Qahtani', 'https://example.com/seed/library/hisnul-muslim-pocket.pdf', 2900000, 0, now() - interval '54 days'),
  ('e3200000-0000-4000-8000-000000000017', 'e1000000-0000-4000-8000-000000000017', NULL, 'book', 'Fiqh us-Sunnah — Sayyid Sabiq (Chapters on Hajj & Umrah)', 'https://example.com/seed/library/fiqh-us-sunnah-hajj.pdf', 6600000, 0, now() - interval '49 days')
ON CONFLICT (id) DO NOTHING;

-- Syllabus notes + worksheets
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at)
SELECT ('e3300000-0000-4000-8000-0000000000' || right(c.id::text, 2))::uuid, c.id, NULL, 'note',
       'Course Syllabus — ' || c.title, 'https://example.com/seed/syllabus/course-' || right(c.id::text, 2) || '.pdf',
       180000, 0, c.created_at
FROM courses c WHERE c.id::text LIKE 'e1000000-%'
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at) VALUES
  ('e3400000-0000-4000-8000-000000000012', 'e1000000-0000-4000-8000-000000000001', 'e2000000-0000-4000-8000-000000000012', 'worksheet', 'Worksheet: Match Each Letter to Its Makhraj', 'https://example.com/seed/worksheets/makharij.pdf', 220000, 0, now() - interval '45 days'),
  ('e3400000-0000-4000-8000-000000000022', 'e1000000-0000-4000-8000-000000000002', 'e2000000-0000-4000-8000-000000000022', 'worksheet', 'Worksheet: Surah Al-Asr Reflection Questions', 'https://example.com/seed/worksheets/al-asr.pdf', 190000, 0, now() - interval '40 days'),
  ('e3400000-0000-4000-8000-000000000032', 'e1000000-0000-4000-8000-000000000003', 'e2000000-0000-4000-8000-000000000032', 'worksheet', 'Worksheet: The Six Pillars of Iman', 'https://example.com/seed/worksheets/pillars-of-iman.pdf', 210000, 0, now() - interval '35 days'),
  ('e3400000-0000-4000-8000-000000000052', 'e1000000-0000-4000-8000-000000000005', 'e2000000-0000-4000-8000-000000000052', 'worksheet', 'Worksheet: Conditions vs Pillars of Salah', 'https://example.com/seed/worksheets/salah.pdf', 200000, 0, now() - interval '25 days')
ON CONFLICT (id) DO NOTHING;

-- One worksheet per new course, on lecture 2 (same id scheme: e34…-000000000<course><2>)
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at)
SELECT ('e3400000-0000-4000-8000-000000000' || s.course || '2')::uuid, l.course_id, l.id, 'worksheet',
       'Worksheet: ' || l.title, 'https://example.com/seed/worksheets/lecture-' || s.course || '2.pdf',
       180000 + abs(hashtext(l.title)) % 60000, 0, least(l.publish_date, now())
FROM seed_lec s
JOIN lectures l ON l.id = ('e2000000-0000-4000-8000-000000000' || s.course || s.ord)::uuid
WHERE s.ord = 2
ON CONFLICT (id) DO NOTHING;

INSERT INTO lecture_attachments (id, lecture_id, type, url, title, size_bytes, duration_seconds) VALUES
  ('e3500000-0000-4000-8000-000000000001', 'e2000000-0000-4000-8000-000000000022', 'reference', 'https://www.youtube.com/playlist?list=PLLSbPBshw4tBeAXprgSWX8g-7PWmG28n4', 'Dr. Israr Ahmed — Bayan-ul-Quran (playlist)', 0, 0),
  ('e3500000-0000-4000-8000-000000000002', 'e2000000-0000-4000-8000-000000000032', 'pdf', 'https://example.com/seed/handouts/an-nisa-4-136.pdf', 'Handout: Surah An-Nisa 4:136 — Text & Translation', 140000, 0),
  ('e3500000-0000-4000-8000-000000000003', 'e2000000-0000-4000-8000-000000000041', 'book', 'https://example.com/seed/library/the-sealed-nectar.pdf', 'The Sealed Nectar — Chapter 1', 15800000, 0),
  ('e3500000-0000-4000-8000-000000000004', 'e2000000-0000-4000-8000-000000000052', 'worksheet', 'https://example.com/seed/worksheets/salah.pdf', 'Practice Sheet: Pillars of Salah', 200000, 0),
  ('e3500000-0000-4000-8000-000000000005', 'e2000000-0000-4000-8000-000000000013', 'video', 'https://example.com/seed/videos/noon-saakin-examples.mp4', 'Worked Examples: Noon Saakin in Juz Amma', 54000000, 840)
ON CONFLICT (id) DO NOTHING;

-- Slides for every seeded lecture
INSERT INTO lecture_attachments (id, lecture_id, type, url, title, size_bytes, duration_seconds)
SELECT md5('seed-slides-' || l.id)::uuid, l.id, 'pdf',
       'https://example.com/seed/slides/lecture-' || right(l.id::text, 3) || '.pdf',
       'Slides — ' || l.title, 900000 + abs(hashtext('sl' || l.id::text)) % 2000000, 0
FROM lectures l WHERE l.id::text LIKE 'e2000000-%'
ON CONFLICT (id) DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 4. ENROLLMENTS
-- ════════════════════════════════════════════════════════════════════════════
CREATE TEMP TABLE seed_enroll (course int, student int, status text) ON COMMIT DROP;
INSERT INTO seed_enroll VALUES
  (1,21,'active'),(1,22,'active'),(1,23,'active'),(1,24,'active'),(1,25,'active'),(1,26,'active'),(1,31,'active'),
  (2,21,'active'),(2,22,'active'),(2,27,'active'),(2,28,'active'),(2,29,'active'),
  (3,21,'active'),(3,23,'active'),(3,24,'active'),(3,25,'active'),(3,26,'active'),(3,27,'active'),(3,30,'active'),(3,33,'withdrawn'),
  (4,22,'active'),(4,23,'active'),(4,25,'active'),(4,28,'active'),(4,29,'active'),(4,30,'active'),
  (5,21,'active'),(5,24,'active'),(5,26,'active'),(5,27,'active'),(5,30,'active'),
  (9,21,'completed'),(9,32,'completed');

-- Bulk students (35–94): each joins ~28% of the published courses.
INSERT INTO seed_enroll
SELECT c.n, u.n,
       CASE WHEN u.status IN ('inactive', 'withdrawn') THEN 'withdrawn'
            WHEN u.status = 'graduated' OR x.h < 3 THEN 'completed'
            ELSE 'active' END
FROM seed_users u
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(10),(11),(12),(13),(14),(15),(16),(17)) c(n)
CROSS JOIN LATERAL (SELECT abs(hashtext('enr' || u.n || '-' || c.n)) % 100 AS h) x
WHERE u.n >= 35 AND x.h < 28;

INSERT INTO enrollments (id, course_id, student_id, status, progress_pct, enrolled_at, completed_at)
SELECT md5('seed-enr-' || s.course || '-' || s.student)::uuid,
       ('e1000000-0000-4000-8000-0000000000' || lpad(s.course::text, 2, '0'))::uuid,
       ('e0000000-0000-4000-8000-0000000000' || s.student)::uuid,
       s.status, 0,
       least(now() - interval '1 day', c.created_at + ((s.student % 30) || ' days')::interval),
       CASE WHEN s.status = 'completed' THEN least(now() - interval '1 day', c.created_at + ((s.student % 30 + 45) || ' days')::interval) END
FROM seed_enroll s
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-0000000000' || lpad(s.course::text, 2, '0'))::uuid
ON CONFLICT DO NOTHING;

-- The enrollment trigger notifies professors; mark those seed notifications as read.
UPDATE alerts SET read_at = now()
WHERE type = 'new_enrollment' AND read_at IS NULL
  AND user_id IN (SELECT id FROM seed_users WHERE role = 'professor');

-- ════════════════════════════════════════════════════════════════════════════
-- 5. LEARNING ACTIVITY: progress, activity, watch events, attendance, ratings
-- ════════════════════════════════════════════════════════════════════════════
CREATE TEMP TABLE seed_progress ON COMMIT DROP AS
SELECT e.student_id, l.id AS lecture_id, l.course_id, l.duration_seconds, l.publish_date, h,
       CASE WHEN e.status = 'completed' THEN 100
            WHEN h < 55 THEN 100
            WHEN h < 80 THEN 40 + (h - 55) * 2
            ELSE 10 + (h - 80) END::numeric AS pct
FROM enrollments e
JOIN lectures l ON l.course_id = e.course_id AND l.publish_date <= now()
CROSS JOIN LATERAL (SELECT abs(hashtext(e.student_id::text || l.id::text)) % 100 AS h) x
WHERE e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND e.status IN ('active', 'completed')
  AND (e.status = 'completed' OR h >= 15);

INSERT INTO lecture_progress (id, student_id, lecture_id, last_position_seconds, completion_pct, total_watch_seconds,
                              pause_count, resume_count, started_at, last_viewed_at, completed_at)
SELECT md5('seed-lp-' || p.student_id || p.lecture_id)::uuid, p.student_id, p.lecture_id,
       round(p.duration_seconds * p.pct / 100), p.pct, round(p.duration_seconds * p.pct / 100 * (1 + (p.h % 20) / 100.0)),
       p.h % 6, p.h % 6,
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval),
       least(now(), p.publish_date + ((p.h % 5 + 1) || ' days')::interval),
       CASE WHEN p.pct >= 100 THEN least(now(), p.publish_date + ((p.h % 5 + 1) || ' days')::interval) END
FROM seed_progress p
ON CONFLICT DO NOTHING;

INSERT INTO lecture_activity (id, user_id, lecture_id, started_at, last_position, total_watch_seconds, pause_count,
                              resume_count, bookmark_count, completed_at, completion_percentage)
SELECT md5('seed-la-' || p.student_id || p.lecture_id)::uuid, p.student_id, p.lecture_id,
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval),
       round(p.duration_seconds * p.pct / 100), round(p.duration_seconds * p.pct / 100 * (1 + (p.h % 20) / 100.0)),
       p.h % 6, p.h % 6, CASE WHEN p.h % 7 = 0 THEN 1 ELSE 0 END,
       CASE WHEN p.pct >= 100 THEN least(now(), p.publish_date + ((p.h % 5 + 1) || ' days')::interval) END,
       p.pct
FROM seed_progress p
ON CONFLICT DO NOTHING;

INSERT INTO watch_events (id, student_id, lecture_id, event_type, position_seconds, created_at)
SELECT md5('seed-we-' || p.student_id || p.lecture_id || ev.t)::uuid, p.student_id, p.lecture_id, ev.t,
       round(p.duration_seconds * p.pct / 100 * ev.frac),
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval + (ev.mins || ' minutes')::interval)
FROM seed_progress p
CROSS JOIN (VALUES ('start', 0.0, 0), ('pause', 0.4, 12), ('resume', 0.4, 15), ('complete', 1.0, 45)) ev(t, frac, mins)
WHERE ev.t <> 'complete' OR p.pct >= 100
ON CONFLICT DO NOTHING;

-- Triggers recorded 'present' attendance (dated today) for >=90% completions — back-date them.
UPDATE lecture_attendance la
SET attended_at = lp.completed_at, attendance_date = lp.completed_at::date
FROM lecture_progress lp
WHERE lp.student_id = la.student_id AND lp.lecture_id = la.lecture_id
  AND lp.completed_at IS NOT NULL
  AND lp.id = md5('seed-lp-' || lp.student_id || lp.lecture_id)::uuid;

-- Partial watchers → late; enrolled-but-never-watched → absent.
INSERT INTO lecture_attendance (id, student_id, lecture_id, course_id, status, attended_at, attendance_date)
SELECT md5('seed-att-' || p.student_id || p.lecture_id)::uuid, p.student_id, p.lecture_id, p.course_id, 'late',
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval),
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval)::date
FROM seed_progress p WHERE p.pct < 90 AND p.pct >= 40
ON CONFLICT DO NOTHING;

INSERT INTO lecture_attendance (id, student_id, lecture_id, course_id, status, attended_at, attendance_date)
SELECT md5('seed-att-' || e.student_id || l.id)::uuid, e.student_id, l.id, l.course_id, 'absent',
       l.publish_date + interval '1 day', (l.publish_date + interval '1 day')::date
FROM enrollments e
JOIN lectures l ON l.course_id = e.course_id AND l.publish_date <= now() - interval '1 day'
WHERE e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND e.status = 'active'
  AND NOT EXISTS (SELECT 1 FROM seed_progress p WHERE p.student_id = e.student_id AND p.lecture_id = l.id)
ON CONFLICT DO NOTHING;

INSERT INTO lecture_ratings (id, student_id, lecture_id, rating, created_at)
SELECT md5('seed-rt-' || p.student_id || p.lecture_id)::uuid, p.student_id, p.lecture_id,
       CASE WHEN p.h % 10 < 6 THEN 5 WHEN p.h % 10 < 9 THEN 4 ELSE 3 END,
       least(now(), p.publish_date + ((p.h % 5 + 1) || ' days')::interval)
FROM seed_progress p WHERE p.pct >= 100 AND p.h % 3 <> 0
ON CONFLICT DO NOTHING;

UPDATE enrollments e
SET progress_pct = sub.avg_pct
FROM (
  SELECT en.id, round(coalesce(avg(coalesce(lp.completion_pct, 0)), 0), 2) AS avg_pct
  FROM enrollments en
  JOIN lectures l ON l.course_id = en.course_id AND l.publish_date <= now()
  LEFT JOIN lecture_progress lp ON lp.lecture_id = l.id AND lp.student_id = en.student_id
  WHERE en.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  GROUP BY en.id
) sub
WHERE e.id = sub.id;

-- Bookmarks (lecture + material)
INSERT INTO bookmarks (id, student_id, lecture_id, material_id, created_at) VALUES
  ('e3600000-0000-4000-8000-000000000001', 'e0000000-0000-4000-8000-000000000021', 'e2000000-0000-4000-8000-000000000013', NULL, now() - interval '18 days'),
  ('e3600000-0000-4000-8000-000000000002', 'e0000000-0000-4000-8000-000000000021', 'e2000000-0000-4000-8000-000000000032', NULL, now() - interval '30 days'),
  ('e3600000-0000-4000-8000-000000000003', 'e0000000-0000-4000-8000-000000000022', 'e2000000-0000-4000-8000-000000000042', NULL, now() - interval '25 days'),
  ('e3600000-0000-4000-8000-000000000004', 'e0000000-0000-4000-8000-000000000023', 'e2000000-0000-4000-8000-000000000031', NULL, now() - interval '40 days'),
  ('e3600000-0000-4000-8000-000000000005', 'e0000000-0000-4000-8000-000000000024', 'e2000000-0000-4000-8000-000000000051', NULL, now() - interval '35 days'),
  ('e3600000-0000-4000-8000-000000000006', 'e0000000-0000-4000-8000-000000000021', NULL, 'e3200000-0000-4000-8000-000000000001', now() - interval '50 days'),
  ('e3600000-0000-4000-8000-000000000007', 'e0000000-0000-4000-8000-000000000022', NULL, 'e3200000-0000-4000-8000-000000000004', now() - interval '28 days'),
  ('e3600000-0000-4000-8000-000000000008', 'e0000000-0000-4000-8000-000000000027', NULL, 'e3200000-0000-4000-8000-000000000002', now() - interval '20 days'),
  ('e3600000-0000-4000-8000-000000000009', 'e0000000-0000-4000-8000-000000000030', NULL, 'e3400000-0000-4000-8000-000000000032', now() - interval '15 days')
ON CONFLICT DO NOTHING;

INSERT INTO bookmarks (id, student_id, lecture_id, material_id, created_at)
SELECT md5('seed-bm-' || p.student_id || p.lecture_id)::uuid, p.student_id, p.lecture_id, NULL,
       least(now(), p.publish_date + ((p.h % 5) || ' days')::interval)
FROM seed_progress p WHERE p.h % 9 = 0
ON CONFLICT DO NOTHING;

-- Material views
INSERT INTO material_views (id, material_id, student_id, viewed_at, duration_seconds)
SELECT md5('seed-mv-' || m.id || e.student_id)::uuid, m.id, e.student_id,
       least(now(), m.created_at + ((abs(hashtext(m.id::text || e.student_id::text)) % 10) || ' days')::interval),
       60 + abs(hashtext(e.student_id::text || m.id::text)) % 1500
FROM course_materials m
JOIN enrollments e ON e.course_id = m.course_id AND e.status IN ('active', 'completed')
WHERE m.id::text LIKE 'e3%' AND m.created_at <= now()
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND abs(hashtext(m.id::text || e.student_id::text)) % 100 < 60
ON CONFLICT DO NOTHING;

-- Worksheet submissions
INSERT INTO worksheet_submissions (id, student_id, material_id, status, submitted_at, answer_text, score, feedback, updated_at)
SELECT md5('seed-ws-' || m.id || e.student_id)::uuid, e.student_id, m.id,
       CASE WHEN x.h < 45 THEN 'graded' WHEN x.h < 80 THEN 'submitted' ELSE 'in_progress' END,
       least(now(), m.created_at + ((x.h % 7 + 1) || ' days')::interval),
       'My answers for "' || m.title || '" are written below, based on the lecture and notes.',
       CASE WHEN x.h < 45 THEN 6 + (x.h % 5) END,
       CASE WHEN x.h < 45 THEN (ARRAY['Excellent work, MashaAllah.', 'Good effort — review the last section again.', 'Well done, clear and accurate.'])[1 + x.h % 3] END,
       least(now(), m.created_at + ((x.h % 7 + 2) || ' days')::interval)
FROM course_materials m
JOIN enrollments e ON e.course_id = m.course_id AND e.status = 'active'
CROSS JOIN LATERAL (SELECT abs(hashtext('ws' || m.id::text || e.student_id::text)) % 100 AS h) x
WHERE m.type = 'worksheet' AND m.id::text LIKE 'e34%'
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND x.h < 90
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 6. QUESTION BANK (every type & status) and EXAM TEMPLATES
-- correct_answer formats match the app: mcq [idx], multiple_select [idx,…],
-- true_false boolean, short_answer "text", essay [].
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO question_bank (id, subject, course_id, topic, difficulty, type, question_text, options, correct_answer, explanation,
                           marks, time_seconds, status, category, tags, created_by, approved_by, approved_at, submitted_at) VALUES
  ('e4000000-0000-4000-8000-000000000001', 'Quran', 'e1000000-0000-4000-8000-000000000001', 'Arabic Letters', 'easy', 'mcq',
   'How many letters are there in the Arabic alphabet?', '["26","28","29","30"]', '[1]',
   'The Arabic alphabet has 28 letters.', 1, 30, 'approved', 'Tajweed', '{alphabet,basics}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '58 days', now() - interval '59 days'),
  ('e4000000-0000-4000-8000-000000000002', 'Quran', 'e1000000-0000-4000-8000-000000000001', 'Noon Saakin & Tanween', 'medium', 'true_false',
   'Idghaam means merging a noon saakin or tanween into the letter that follows it.', '["True","False"]', 'true',
   'Idghaam literally means "merging" — the noon sound merges into the following letter of يرملون.', 1, 30, 'approved', 'Tajweed', '{noon-saakin}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '40 days', now() - interval '41 days'),
  ('e4000000-0000-4000-8000-000000000003', 'Quran', 'e1000000-0000-4000-8000-000000000001', 'Qalqalah', 'medium', 'mcq',
   'Which group of letters are the letters of Qalqalah?', '["ق ط ب ج د","ا و ي","ء ه ع ح غ خ","ي ر م ل و ن"]', '[0]',
   'The Qalqalah letters are collected in the phrase قطب جد.', 2, 45, 'approved', 'Tajweed', '{qalqalah}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '40 days', now() - interval '41 days'),
  ('e4000000-0000-4000-8000-000000000004', 'Quran', 'e1000000-0000-4000-8000-000000000001', 'Noon Saakin & Tanween', 'hard', 'short_answer',
   'What is the name of the rule applied when a noon saakin or tanween is followed by the letter ب?', '[]', '"Iqlab"',
   'Iqlab: the noon sound is changed into a hidden meem with ghunnah.', 2, 60, 'approved', 'Tajweed', '{noon-saakin,iqlab}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '20 days', now() - interval '21 days'),
  ('e4000000-0000-4000-8000-000000000005', 'Tafseer', 'e1000000-0000-4000-8000-000000000002', 'Surah Al-Ikhlas', 'easy', 'mcq',
   'According to authentic hadith, Surah Al-Ikhlas is equal to what portion of the Quran?', '["One quarter","One third","One half","One tenth"]', '[1]',
   'Sahih al-Bukhari: Surah Al-Ikhlas is equivalent to one third of the Quran.', 1, 30, 'approved', 'Juz Amma', '{ikhlas,virtues}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '50 days', now() - interval '51 days'),
  ('e4000000-0000-4000-8000-000000000006', 'Tafseer', 'e1000000-0000-4000-8000-000000000002', 'Juz Amma', 'easy', 'mcq',
   'Which surah is the first surah of Juz Amma?', '["An-Naba","Al-Mulk","Al-Fatiha","Al-Fajr"]', '[0]',
   'Juz 30 (Juz Amma) begins with Surah An-Naba (78).', 1, 30, 'approved', 'Juz Amma', '{juz-amma}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '50 days', now() - interval '51 days'),
  ('e4000000-0000-4000-8000-000000000007', 'Tafseer', 'e1000000-0000-4000-8000-000000000002', 'The Three Quls', 'medium', 'multiple_select',
   'Which of these surahs are known as Al-Mu''awwidhatayn (the two surahs of seeking refuge)?', '["Al-Falaq","Al-Ikhlas","An-Nas","Al-Kawthar"]', '[0,2]',
   'Al-Mu''awwidhatayn are Surah Al-Falaq and Surah An-Nas.', 2, 45, 'approved', 'Juz Amma', '{falaq,nas}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '15 days', now() - interval '16 days'),
  ('e4000000-0000-4000-8000-000000000008', 'Tafseer', 'e1000000-0000-4000-8000-000000000002', 'Surah Al-Asr', 'hard', 'essay',
   'Explain the four qualities mentioned in Surah Al-Asr that save a person from loss, and how you can practise each one this week.', '[]', '[]',
   'Iman, righteous deeds, advising one another to truth, and advising one another to patience.', 5, 600, 'approved', 'Juz Amma', '{al-asr,reflection}',
   'e0000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', now() - interval '38 days', now() - interval '39 days'),
  ('e4000000-0000-4000-8000-000000000009', 'Aqeedah', 'e1000000-0000-4000-8000-000000000003', 'Pillars of Iman', 'easy', 'mcq',
   'How many pillars of Iman are there?', '["Five","Six","Seven","Four"]', '[1]',
   'Belief in Allah, His angels, His books, His messengers, the Last Day, and Al-Qadr.', 1, 30, 'approved', 'Iman', '{pillars}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '45 days', now() - interval '46 days'),
  ('e4000000-0000-4000-8000-000000000010', 'Aqeedah', 'e1000000-0000-4000-8000-000000000003', 'Pillars of Iman', 'medium', 'multiple_select',
   'Which of the following are among the six pillars of Iman?', '["Belief in Allah","Belief in the Angels","Fasting in Ramadan","Belief in Al-Qadr"]', '[0,1,3]',
   'Fasting is a pillar of Islam, not a pillar of Iman.', 2, 45, 'approved', 'Iman', '{pillars}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '45 days', now() - interval '46 days'),
  ('e4000000-0000-4000-8000-000000000011', 'Aqeedah', 'e1000000-0000-4000-8000-000000000003', 'Surah An-Nisa 4:136', 'medium', 'true_false',
   'Surah An-Nisa 4:136 mentions disbelief in the angels as a cause of going far astray.', '["True","False"]', 'true',
   '"…whoever disbelieves in Allah, His angels, His books, His messengers and the Last Day has certainly gone far astray."', 1, 30, 'approved', 'Iman', '{an-nisa}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '33 days', now() - interval '34 days'),
  ('e4000000-0000-4000-8000-000000000012', 'Aqeedah', 'e1000000-0000-4000-8000-000000000003', 'Tawheed', 'easy', 'short_answer',
   'What is the Arabic term for the Oneness of Allah?', '[]', '"Tawheed"',
   'Tawheed — affirming that Allah is One in His Lordship, worship, names and attributes.', 1, 30, 'draft', 'Iman', '{tawheed}',
   'e0000000-0000-4000-8000-000000000013', NULL, NULL, NULL),
  ('e4000000-0000-4000-8000-000000000013', 'Seerah', 'e1000000-0000-4000-8000-000000000004', 'Birth of the Prophet ﷺ', 'easy', 'mcq',
   'In approximately which year (CE) was the Prophet Muhammad ﷺ born?', '["570","610","622","632"]', '[0]',
   'He ﷺ was born around 570 CE, the Year of the Elephant.', 1, 30, 'approved', 'Makkan Period', '{birth}',
   'e0000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000002', now() - interval '44 days', now() - interval '45 days'),
  ('e4000000-0000-4000-8000-000000000014', 'Seerah', 'e1000000-0000-4000-8000-000000000004', 'First Revelation', 'easy', 'mcq',
   'In which cave did the first revelation descend?', '["Cave Thawr","Cave Hira","Mount Uhud","Quba"]', '[1]',
   'The first revelation came in Cave Hira on Jabal an-Nur.', 1, 30, 'approved', 'Makkan Period', '{revelation}',
   'e0000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000002', now() - interval '28 days', now() - interval '29 days'),
  ('e4000000-0000-4000-8000-000000000015', 'Seerah', 'e1000000-0000-4000-8000-000000000004', 'First Revelation', 'easy', 'true_false',
   'The first verses revealed were from Surah Al-Alaq.', '["True","False"]', 'true',
   '"Read in the name of your Lord who created" (96:1–5).', 1, 30, 'approved', 'Makkan Period', '{revelation,al-alaq}',
   'e0000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000002', now() - interval '28 days', now() - interval '29 days'),
  ('e4000000-0000-4000-8000-000000000016', 'Seerah', 'e1000000-0000-4000-8000-000000000004', 'Early Muslims', 'medium', 'mcq',
   'Who was the first free adult man to accept Islam?', '["Umar ibn al-Khattab","Abu Bakr as-Siddiq","Uthman ibn Affan","Hamza ibn Abdul-Muttalib"]', '[1]',
   'Abu Bakr as-Siddiq (RA) was the first free adult man to accept Islam.', 2, 45, 'approved', 'Makkan Period', '{sahabah}',
   'e0000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000002', now() - interval '28 days', now() - interval '29 days'),
  ('e4000000-0000-4000-8000-000000000017', 'Seerah', 'e1000000-0000-4000-8000-000000000004', 'Migration to Abyssinia', 'hard', 'essay',
   'Why did a group of Muslims migrate to Abyssinia, and what lessons does this hold for Muslims facing hardship today?', '[]', '[]',
   'Persecution in Makkah; the just Christian king (the Negus) granted protection; lessons of sabr, tawakkul and seeking safety.', 5, 600, 'approved', 'Makkan Period', '{abyssinia,hijrah}',
   'e0000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000002', now() - interval '11 days', now() - interval '12 days'),
  ('e4000000-0000-4000-8000-000000000018', 'Fiqh', 'e1000000-0000-4000-8000-000000000005', 'Salah', 'easy', 'mcq',
   'How many obligatory (fard) prayers are there each day?', '["Three","Four","Five","Six"]', '[2]',
   'Fajr, Dhuhr, Asr, Maghrib and Isha.', 1, 30, 'approved', 'Salah', '{salah}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '40 days', now() - interval '41 days'),
  ('e4000000-0000-4000-8000-000000000019', 'Fiqh', 'e1000000-0000-4000-8000-000000000005', 'Taharah', 'medium', 'multiple_select',
   'Which of the following nullify wudu?', '["Passing wind","Deep sleep","Drinking water","Using the toilet"]', '[0,1,3]',
   'Drinking water does not break wudu.', 2, 45, 'approved', 'Taharah', '{wudu}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '40 days', now() - interval '41 days'),
  ('e4000000-0000-4000-8000-000000000020', 'Fiqh', 'e1000000-0000-4000-8000-000000000005', 'Taharah', 'easy', 'true_false',
   'Tayammum is permitted when water is unavailable.', '["True","False"]', 'true',
   'Surah Al-Ma''idah 5:6 permits dry ablution with clean earth when water cannot be found.', 1, 30, 'approved', 'Taharah', '{tayammum}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '40 days', now() - interval '41 days'),
  ('e4000000-0000-4000-8000-000000000021', 'Fiqh', 'e1000000-0000-4000-8000-000000000005', 'Salah', 'easy', 'short_answer',
   'How many rak''ahs are in the fard of Fajr? (Answer with a number.)', '[]', '"2"',
   'The fard of Fajr is two rak''ahs.', 1, 30, 'approved', 'Salah', '{fajr}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '24 days', now() - interval '25 days'),
  ('e4000000-0000-4000-8000-000000000022', 'Fiqh', 'e1000000-0000-4000-8000-000000000005', 'Salah', 'easy', 'mcq',
   'Towards which direction do Muslims face in prayer?', '["Jerusalem","The Ka''bah in Makkah","Madinah","East"]', '[1]',
   'The qiblah is the Ka''bah in Makkah. (Archived: duplicate of a newer question.)', 1, 30, 'archived', 'Salah', '{qiblah}',
   'e0000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000001', now() - interval '80 days', now() - interval '81 days'),
  ('e4000000-0000-4000-8000-000000000023', 'Akhlaq', 'e1000000-0000-4000-8000-000000000006', 'Good Character', 'easy', 'mcq',
   'Complete the hadith: "The best among you are those who are best in…"', '["wealth","character","lineage","speech"]', '[1]',
   'Sahih al-Bukhari: "The best among you are those who have the best character."', 1, 30, 'submitted', 'Character', '{akhlaq,hadith}',
   'e0000000-0000-4000-8000-000000000014', NULL, NULL, now() - interval '2 days')
ON CONFLICT (id) DO NOTHING;

-- Questions for courses 10–18 (compact form; marks/time/approval derived from type & course)
CREATE TEMP TABLE seed_q (q int, course int, topic text, difficulty text, type text, question text, options jsonb, answer jsonb, explanation text, status text) ON COMMIT DROP;
INSERT INTO seed_q VALUES
  (24,10,'Virtues','easy','mcq','On which day is reciting Surah Al-Kahf especially recommended?','["Monday","Friday","Thursday","Sunday"]','[1]','Authentic narrations encourage reciting Al-Kahf on Friday.','approved'),
  (25,10,'Musa & Al-Khidr','easy','mcq','Which righteous servant of Allah did Musa (AS) meet and learn from in Surah Al-Kahf?','["Luqman","Al-Khidr","Dhul-Qarnayn","Uzair"]','[1]','Musa (AS) travelled to meet Al-Khidr to gain knowledge (18:60–82).','approved'),
  (26,10,'Dhul-Qarnayn','medium','true_false','Dhul-Qarnayn built a barrier to hold back Ya''juj and Ma''juj.','["True","False"]','true','Surah Al-Kahf 18:94–97.','approved'),
  (27,10,'Overview','medium','multiple_select','Which of these stories are narrated in Surah Al-Kahf?','["The People of the Cave","Musa and Al-Khidr","Yusuf and his brothers","Dhul-Qarnayn"]','[0,1,3]','The story of Yusuf (AS) is in Surah Yusuf.','approved'),
  (28,11,'Al-Ghafoor','easy','mcq','Which Name of Allah means "The Ever-Forgiving"?','["Ar-Razzaq","Al-Ghafoor","Al-Malik","Al-Aziz"]','[1]','Al-Ghafoor — the One who forgives abundantly.','approved'),
  (29,11,'Ar-Razzaq','easy','mcq','What does the Name "Ar-Razzaq" mean?','["The Provider","The Creator","The Judge","The Witness"]','[0]','Ar-Razzaq — the One who provides for all creation.','approved'),
  (30,11,'Al-Asma ul-Husna','easy','true_false','The Quran states that to Allah belong the Most Beautiful Names.','["True","False"]','true','Surah Al-A''raf 7:180.','approved'),
  (31,11,'At-Tawwab','medium','short_answer','Which Name of Allah means "the One who accepts repentance"?','[]','"At-Tawwab"','At-Tawwab — the One who returns to His servants with acceptance of repentance.','approved'),
  (32,12,'Umar (RA)','easy','mcq','Which companion was given the title Al-Faruq?','["Abu Bakr","Umar ibn al-Khattab","Uthman ibn Affan","Ali ibn Abi Talib"]','[1]','Umar (RA) was called Al-Faruq — the one who distinguishes truth from falsehood.','approved'),
  (33,12,'Uthman (RA)','medium','mcq','Which companion was known as Dhun-Nurayn ("possessor of the two lights")?','["Abu Bakr","Umar ibn al-Khattab","Uthman ibn Affan","Ali ibn Abi Talib"]','[2]','Uthman (RA) married two daughters of the Prophet ﷺ.','approved'),
  (34,12,'Bilal (RA)','easy','mcq','Who was the first mu''adhdhin to call the adhan?','["Bilal ibn Rabah","Abu Hurairah","Zayd ibn Harithah","Salman al-Farisi"]','[0]','Bilal (RA) was chosen to call the adhan in Madinah.','approved'),
  (35,12,'Khadijah (RA)','easy','true_false','Khadijah (RA) was the first person to accept Islam.','["True","False"]','true','Khadijah (RA) believed in the Prophet ﷺ from the first revelation.','approved'),
  (36,13,'Ramadan','easy','mcq','In which month is fasting obligatory for Muslims?','["Shawwal","Ramadan","Sha''ban","Muharram"]','[1]','Surah Al-Baqarah 2:183–185.','approved'),
  (37,13,'Invalidators','medium','multiple_select','Which of the following invalidate the fast when done deliberately?','["Eating","Drinking","Eating out of forgetfulness","Marital relations"]','[0,1,3]','Eating or drinking forgetfully does not break the fast (Bukhari & Muslim).','approved'),
  (38,13,'Invalidators','easy','true_false','Eating or drinking out of forgetfulness breaks the fast.','["True","False"]','false','"Whoever forgets while fasting and eats or drinks, let him complete his fast." (Bukhari & Muslim)','approved'),
  (39,13,'Laylat al-Qadr','easy','mcq','The Quran describes Laylat al-Qadr as better than:','["A hundred months","A thousand months","One year","Ten nights"]','[1]','Surah Al-Qadr 97:3.','approved'),
  (40,14,'Recipients','medium','mcq','How many categories of zakat recipients are listed in Surah At-Tawbah 9:60?','["Five","Six","Eight","Ten"]','[2]','Surah At-Tawbah 9:60 lists eight categories.','approved'),
  (41,14,'Calculation','easy','mcq','What is the standard rate of zakat on savings and gold?','["1%","2.5%","5%","10%"]','[1]','One fortieth (2.5%) after a lunar year above the nisab.','approved'),
  (42,14,'Zakat al-Fitr','easy','true_false','Zakat al-Fitr is to be given before the Eid al-Fitr prayer.','["True","False"]','true','Narrated by Ibn Umar (RA) in Bukhari & Muslim.','approved'),
  (43,14,'Nisab','medium','short_answer','What is the term for the minimum amount of wealth on which zakat becomes due?','[]','"Nisab"','Nisab — the threshold of zakatable wealth.','approved'),
  (44,15,'Parents','easy','mcq','In Surah Al-Isra 17:23, which word are we told not to say to our parents?','["Uff","No","Leave","Later"]','[0]','"…say not to them [so much as] uff, and do not repel them."','approved'),
  (45,15,'Kinship','easy','true_false','Islam commands maintaining ties of kinship (silat ar-rahim).','["True","False"]','true','Surah An-Nisa 4:1 and many ahadith.','approved'),
  (46,15,'Parents','easy','mcq','Complete the narration: "Paradise lies at the feet of…"','["fathers","mothers","teachers","scholars"]','[1]','Reported in Sunan an-Nasa''i.','approved'),
  (47,15,'Parents','hard','essay','Describe three practical ways you will honour your parents this week, with a supporting ayah or hadith for each.','[]','[]','Answers should reference 17:23–24 or relevant ahadith.','approved'),
  (48,16,'Salah','easy','mcq','Which prayer is performed before sunrise?','["Fajr","Dhuhr","Asr","Isha"]','[0]','Fajr is prayed between true dawn and sunrise.','approved'),
  (49,16,'Muhasabah','easy','true_false','Muhasabah means holding oneself to account.','["True","False"]','true','Self-accountability: reviewing one''s deeds and intentions.','approved'),
  (50,16,'Dhikr','medium','mcq','Which dhikr is described as "light on the tongue, heavy on the scales"?','["SubhanAllahi wa bihamdihi, SubhanAllahil-''Azim","Allahu Akbar","La hawla wa la quwwata illa billah","Astaghfirullah"]','[0]','Sahih al-Bukhari, the final hadith of the collection.','approved'),
  (51,16,'Routine','hard','essay','Design your personal daily Iman routine (salah, Quran, dhikr, muhasabah) and explain how you will stay consistent.','[]','[]','Look for realistic, specific and measurable habits.','approved'),
  (52,17,'Hajj','easy','mcq','In which Islamic month does Hajj take place?','["Ramadan","Dhul Hijjah","Muharram","Rajab"]','[1]','Hajj is performed in Dhul Hijjah.','approved'),
  (53,17,'Umrah','medium','multiple_select','Which of these are rites of Umrah?','["Entering ihram","Tawaf of the Ka''bah","Sa''i between Safa and Marwah","Standing at Arafah"]','[0,1,2]','Standing at Arafah is a pillar of Hajj, not Umrah.','approved'),
  (54,17,'Days of Hajj','easy','true_false','The Day of Arafah is the 9th of Dhul Hijjah.','["True","False"]','true','The standing at Arafah takes place on 9 Dhul Hijjah.','approved'),
  (55,17,'Umrah','medium','short_answer','What is the name of the ritual walk between Safa and Marwah?','[]','"Sa''i"','Sa''i — seven circuits between Safa and Marwah.','approved'),
  (56,18,'Duas of the Prophets','easy','mcq','Which prophet made the dua "La ilaha illa Anta, subhanaka, inni kuntu minaz-zalimin"?','["Ibrahim","Yunus","Musa","Nuh"]','[1]','The dua of Yunus (AS) — Surah Al-Anbiya 21:87.','submitted'),
  (57,18,'Rabbana Duas','easy','true_false','"Rabbana atina fid-dunya hasanah…" is from Surah Al-Baqarah.','["True","False"]','true','Surah Al-Baqarah 2:201.','draft');

INSERT INTO question_bank (id, subject, course_id, topic, difficulty, type, question_text, options, correct_answer, explanation,
                           marks, time_seconds, status, category, tags, created_by, approved_by, approved_at, submitted_at)
SELECT ('e4000000-0000-4000-8000-0000000000' || q.q)::uuid, c.category, c.id, q.topic, q.difficulty, q.type, q.question,
       q.options, q.answer, q.explanation,
       CASE q.type WHEN 'essay' THEN 5 WHEN 'multiple_select' THEN 2 WHEN 'short_answer' THEN 2 ELSE 1 END,
       CASE q.type WHEN 'essay' THEN 600 WHEN 'multiple_select' THEN 45 ELSE 30 END,
       q.status, c.category, ARRAY[lower(replace(q.topic, ' ', '-'))], c.professor_id,
       CASE WHEN q.status = 'approved' THEN ('e0000000-0000-4000-8000-00000000000' || (1 + q.q % 2))::uuid END,
       CASE WHEN q.status = 'approved' THEN c.created_at + interval '3 days' END,
       CASE WHEN q.status IN ('approved', 'submitted') THEN least(now(), c.created_at + interval '2 days') END
FROM seed_q q
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-0000000000' || q.course)::uuid
ON CONFLICT (id) DO NOTHING;

INSERT INTO exam_templates (id, name, course_id, total_marks, duration_seconds) VALUES
  ('e5000000-0000-4000-8000-000000000001', 'Aqeedah Standard Quiz', 'e1000000-0000-4000-8000-000000000003', 4, 900),
  ('e5000000-0000-4000-8000-000000000002', 'Seerah Midterm Template', 'e1000000-0000-4000-8000-000000000004', 10, 2700)
ON CONFLICT (id) DO NOTHING;

INSERT INTO exam_template_questions (template_id, question_id, quantity) VALUES
  ('e5000000-0000-4000-8000-000000000001', 'e4000000-0000-4000-8000-000000000009', 1),
  ('e5000000-0000-4000-8000-000000000001', 'e4000000-0000-4000-8000-000000000010', 1),
  ('e5000000-0000-4000-8000-000000000001', 'e4000000-0000-4000-8000-000000000011', 1),
  ('e5000000-0000-4000-8000-000000000002', 'e4000000-0000-4000-8000-000000000013', 1),
  ('e5000000-0000-4000-8000-000000000002', 'e4000000-0000-4000-8000-000000000014', 1),
  ('e5000000-0000-4000-8000-000000000002', 'e4000000-0000-4000-8000-000000000015', 1),
  ('e5000000-0000-4000-8000-000000000002', 'e4000000-0000-4000-8000-000000000016', 1),
  ('e5000000-0000-4000-8000-000000000002', 'e4000000-0000-4000-8000-000000000017', 1)
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 7. EXAMS & QUIZZES, QUESTIONS, REGISTRATIONS, ATTEMPTS, RESPONSES
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO exams (id, course_id, title, description, type, duration_minutes, pass_marks, shuffle_questions, shuffle_options,
                   allow_resume, auto_evaluate, publish_date, scheduled_start, scheduled_end, status, created_by, created_at) VALUES
  ('e6000000-0000-4000-8000-000000000001', 'e1000000-0000-4000-8000-000000000001', 'Tajweed Quiz 1: Letters & Noon Saakin', 'Short quiz on the Arabic letters, qalqalah and the rules of noon saakin.', 'quiz', 15, 50, true, true, true, true,
   now() - interval '18 days', now() - interval '18 days', now() + interval '12 days', 'published', 'e0000000-0000-4000-8000-000000000011', now() - interval '19 days'),
  ('e6000000-0000-4000-8000-000000000002', 'e1000000-0000-4000-8000-000000000002', 'Juz Amma Midterm', 'Covers Surah An-Naba, Al-Asr and the three Quls. Includes one essay question graded by the instructor.', 'exam', 45, 50, true, true, false, true,
   now() - interval '12 days', now() - interval '12 days', now() + interval '5 days', 'published', 'e0000000-0000-4000-8000-000000000011', now() - interval '14 days'),
  ('e6000000-0000-4000-8000-000000000003', 'e1000000-0000-4000-8000-000000000003', 'Aqeedah Quiz: Pillars of Iman', 'Built from the Aqeedah Standard Quiz template.', 'quiz', 15, 50, true, true, true, true,
   now() - interval '30 days', now() - interval '30 days', now() - interval '20 days', 'closed', 'e0000000-0000-4000-8000-000000000013', now() - interval '31 days'),
  ('e6000000-0000-4000-8000-000000000004', 'e1000000-0000-4000-8000-000000000004', 'Seerah Midterm: The Makkan Period', 'Scheduled midterm covering lectures 1–3. Registration is open.', 'exam', 45, 60, true, true, false, true,
   now() - interval '1 day', now() + interval '7 days', now() + interval '7 days 2 hours', 'published', 'e0000000-0000-4000-8000-000000000014', now() - interval '3 days'),
  ('e6000000-0000-4000-8000-000000000005', 'e1000000-0000-4000-8000-000000000005', 'Fiqh of Salah — Final Exam', 'Draft final exam; questions still being finalised.', 'exam', 60, 50, true, true, false, true,
   now() + interval '20 days', now() + interval '25 days', now() + interval '25 days 2 hours', 'draft', 'e0000000-0000-4000-8000-000000000013', now() - interval '1 day'),
  ('e6000000-0000-4000-8000-000000000006', 'e1000000-0000-4000-8000-000000000009', 'Seerah (Madinan) Final — 2025', 'Final exam for the 2025 cohort.', 'exam', 60, 50, true, true, false, true,
   now() - interval '145 days', now() - interval '145 days', now() - interval '145 days' + interval '2 hours', 'archived', 'e0000000-0000-4000-8000-000000000014', now() - interval '150 days')
ON CONFLICT (id) DO NOTHING;

CREATE TEMP TABLE seed_exam_q (exam int, q int, ord int) ON COMMIT DROP;
INSERT INTO seed_exam_q VALUES
  (1,1,0),(1,2,1),(1,3,2),(1,4,3),
  (2,5,0),(2,6,1),(2,7,2),(2,8,3),
  (3,9,0),(3,10,1),(3,11,2),
  (4,13,0),(4,14,1),(4,15,2),(4,16,3),(4,17,4),
  (5,18,0),(5,19,1),(5,20,2),(5,21,3);

INSERT INTO exam_questions (id, exam_id, question_id, order_index, marks)
SELECT md5('seed-eq-' || s.exam || '-' || s.q)::uuid,
       ('e6000000-0000-4000-8000-00000000000' || s.exam)::uuid,
       ('e4000000-0000-4000-8000-0000000000' || lpad(s.q::text, 2, '0'))::uuid,
       s.ord, qb.marks
FROM seed_exam_q s
JOIN question_bank qb ON qb.id = ('e4000000-0000-4000-8000-0000000000' || lpad(s.q::text, 2, '0'))::uuid
ON CONFLICT DO NOTHING;

-- Generated: a unit quiz for every new published course (10–17) + midterms for 10, 12, 13, 14.
INSERT INTO exams (id, course_id, title, description, type, duration_minutes, pass_marks, shuffle_questions, shuffle_options,
                   allow_resume, auto_evaluate, publish_date, scheduled_start, scheduled_end, status, created_by, created_at)
SELECT md5('seed-quiz-' || c.id)::uuid, c.id, split_part(c.title, ':', 1) || ' — Unit Quiz',
       'Auto-graded quiz covering the first lectures of "' || c.title || '".', 'quiz', 20, 50, true, true, true, true,
       now() - w.started, now() - w.started, now() - w.started + interval '21 days',
       CASE WHEN now() - w.started + interval '21 days' < now() THEN 'closed' ELSE 'published' END,
       c.professor_id, now() - w.started - interval '2 days'
FROM courses c
CROSS JOIN LATERAL (SELECT ((10 + abs(hashtext('quiz' || c.id::text)) % 25) || ' days')::interval AS started) w
WHERE c.id::text LIKE 'e1000000-%' AND right(c.id::text, 2)::int BETWEEN 10 AND 17
ON CONFLICT DO NOTHING;

INSERT INTO exams (id, course_id, title, description, type, duration_minutes, pass_marks, shuffle_questions, shuffle_options,
                   allow_resume, auto_evaluate, publish_date, scheduled_start, scheduled_end, status, created_by, created_at)
SELECT md5('seed-mid-' || c.id)::uuid, c.id, split_part(c.title, ':', 1) || ' — Midterm',
       'Scheduled midterm for "' || c.title || '". Registration is open.', 'exam', 45, 60, true, true, false, true,
       now() - interval '2 days', now() + w.starts, now() + w.starts + interval '2 hours', 'published',
       c.professor_id, now() - interval '3 days'
FROM courses c
CROSS JOIN LATERAL (SELECT ((5 + abs(hashtext('mid' || c.id::text)) % 15) || ' days')::interval AS starts) w
WHERE c.id IN ('e1000000-0000-4000-8000-000000000010', 'e1000000-0000-4000-8000-000000000012',
               'e1000000-0000-4000-8000-000000000013', 'e1000000-0000-4000-8000-000000000014')
ON CONFLICT DO NOTHING;

INSERT INTO exam_questions (id, exam_id, question_id, order_index, marks)
SELECT md5('seed-eq-' || ex.id || qb.id)::uuid, ex.id, qb.id,
       row_number() OVER (PARTITION BY ex.id ORDER BY qb.id) - 1, qb.marks
FROM exams ex
JOIN question_bank qb ON qb.course_id = ex.course_id AND qb.status = 'approved'
WHERE ex.id IN (SELECT md5('seed-quiz-' || id)::uuid FROM courses UNION ALL SELECT md5('seed-mid-' || id)::uuid FROM courses)
ON CONFLICT DO NOTHING;

-- Register every active student for every open (published/closed) exam in a seeded course
INSERT INTO exam_registrations (id, exam_id, student_id, registered_at, registered_by)
SELECT md5('seed-reg-' || ex.id || e.student_id)::uuid, ex.id, e.student_id,
       least(now(), greatest(ex.created_at, e.enrolled_at) + interval '1 day'),
       ('e0000000-0000-4000-8000-00000000000' || (1 + abs(hashtext(e.student_id::text)) % 2))::uuid
FROM exams ex
JOIN enrollments e ON e.course_id = ex.course_id AND e.status = 'active'
WHERE ex.course_id::text LIKE 'e1000000-%' AND ex.status IN ('published', 'closed')
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
ON CONFLICT DO NOTHING;

-- Attempts for exams that have opened. ~90% of registrants attempt; exams with essays leave
-- about half the attempts 'submitted' (awaiting manual grading); open quizzes have a few in progress.
CREATE TEMP TABLE seed_attempts ON COMMIT DROP AS
SELECT md5('seed-attempt-' || r.exam_id || r.student_id)::uuid AS id, r.exam_id, r.student_id, ex.duration_minutes,
       ex.scheduled_start, x.h,
       CASE WHEN ex.status = 'published' AND x.h >= 92 THEN 'in_progress'
            WHEN x.h % 2 = 0 AND EXISTS (SELECT 1 FROM exam_questions eq JOIN question_bank q ON q.id = eq.question_id
                                         WHERE eq.exam_id = ex.id AND q.type = 'essay') THEN 'submitted'
            ELSE 'graded' END AS status
FROM exam_registrations r
JOIN exams ex ON ex.id = r.exam_id
CROSS JOIN LATERAL (SELECT abs(hashtext('att' || r.exam_id::text || r.student_id::text)) % 100 AS h) x
WHERE ex.scheduled_start <= now()
  AND r.id = md5('seed-reg-' || r.exam_id || r.student_id)::uuid
  AND x.h >= 10;

INSERT INTO exam_attempts (id, exam_id, student_id, started_at, submitted_at, status, score, total_marks, time_spent_seconds, auto_evaluated)
SELECT a.id, a.exam_id, a.student_id, t.started,
       CASE WHEN a.status <> 'in_progress' THEN t.started + ((a.duration_minutes * (40 + a.h % 55) / 100) || ' minutes')::interval END,
       a.status, 0, 0,
       CASE WHEN a.status <> 'in_progress' THEN a.duration_minutes * 60 * (40 + a.h % 55) / 100 ELSE 120 END,
       a.status <> 'in_progress'
FROM seed_attempts a
CROSS JOIN LATERAL (SELECT least(now() - interval '2 hours', a.scheduled_start + ((a.h % 6) || ' days')::interval) AS started) t
ON CONFLICT DO NOTHING;

-- Responses: ~70% correct, deterministic per (attempt, question).
INSERT INTO exam_responses (attempt_id, question_id, answer_text, selected_option_ids, is_correct, marks_awarded, graded_by, graded_at)
SELECT a.id, qb.id,
       CASE qb.type
         WHEN 'true_false'   THEN CASE WHEN ok THEN qb.correct_answer::text ELSE (NOT (qb.correct_answer::text)::boolean)::text END
         WHEN 'short_answer' THEN CASE WHEN ok THEN qb.correct_answer #>> '{}' ELSE 'Not sure' END
         WHEN 'essay'        THEN 'In my understanding, the key points are: ' || qb.explanation || ' I will try to apply this in my daily routine, in sha Allah.'
       END,
       CASE qb.type
         WHEN 'mcq' THEN ARRAY[CASE WHEN ok THEN (qb.correct_answer->>0)::int
                                    ELSE ((qb.correct_answer->>0)::int + 1) % jsonb_array_length(qb.options) END]
         WHEN 'multiple_select' THEN CASE WHEN ok THEN ARRAY(SELECT jsonb_array_elements_text(qb.correct_answer)::int)
                                          ELSE ARRAY[(qb.correct_answer->>0)::int] END
       END,
       CASE WHEN qb.type = 'essay' THEN CASE WHEN a.status = 'graded' THEN true END ELSE ok END,
       CASE WHEN qb.type = 'essay' THEN CASE WHEN a.status = 'graded' THEN eq.marks - (x.h % 3) END
            WHEN ok THEN eq.marks ELSE 0 END,
       CASE WHEN qb.type = 'essay' AND a.status = 'graded' THEN ex.created_by END,
       CASE WHEN qb.type = 'essay' AND a.status = 'graded' THEN least(now(), a.scheduled_start + interval '7 days') END
FROM seed_attempts a
JOIN exams ex ON ex.id = a.exam_id
JOIN exam_questions eq ON eq.exam_id = a.exam_id
JOIN question_bank qb ON qb.id = eq.question_id
CROSS JOIN LATERAL (SELECT abs(hashtext('resp' || a.id::text || qb.id::text)) % 100 AS h) x
CROSS JOIN LATERAL (SELECT x.h < 70 AS ok) y
WHERE a.status <> 'in_progress' OR eq.order_index < 2
ON CONFLICT DO NOTHING;

UPDATE exam_attempts at
SET score = s.score, total_marks = s.total
FROM (
  SELECT a.id,
         coalesce((SELECT sum(r.marks_awarded) FROM exam_responses r WHERE r.attempt_id = a.id), 0) AS score,
         (SELECT sum(eq.marks) FROM exam_questions eq WHERE eq.exam_id = a.exam_id) AS total
  FROM seed_attempts a
) s
WHERE at.id = s.id AND at.status <> 'in_progress';

-- ════════════════════════════════════════════════════════════════════════════
-- 8. ASSIGNMENTS & SUBMISSIONS
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO assignments (id, course_id, professor_id, title, description, instructions, due_date, max_score, rubric, status, created_at) VALUES
  ('e7000000-0000-4000-8000-000000000001', 'e1000000-0000-4000-8000-000000000001', 'e0000000-0000-4000-8000-000000000011', 'Recite & Record: Noon Saakin Rules',
   'Record yourself reciting Surah Al-Mulk 1–5 applying the rules of noon saakin and tanween.',
   E'1. Recite slowly with tarteel.\n2. Mark every noon saakin / tanween in a printed copy and name the rule.\n3. Upload the audio file and the marked copy as one PDF/zip.',
   now() + interval '7 days', 100, '[{"criterion":"Correct application of rules","max_points":50},{"criterion":"Makharij accuracy","max_points":30},{"criterion":"Fluency","max_points":20}]', 'published', now() - interval '14 days'),
  ('e7000000-0000-4000-8000-000000000002', 'e1000000-0000-4000-8000-000000000002', 'e0000000-0000-4000-8000-000000000011', 'Reflection Essay: Surah Al-Asr in Daily Life',
   'A 500-word reflection on the four qualities in Surah Al-Asr.',
   E'Write about each of the four qualities and give one concrete action you took this week for each.',
   now() - interval '5 days', 100, '[{"criterion":"Understanding of the surah","max_points":40},{"criterion":"Personal reflection","max_points":40},{"criterion":"Clarity","max_points":20}]', 'published', now() - interval '35 days'),
  ('e7000000-0000-4000-8000-000000000003', 'e1000000-0000-4000-8000-000000000003', 'e0000000-0000-4000-8000-000000000013', 'Pillars of Iman Mind Map',
   'Create a mind map of the six pillars of Iman with a supporting ayah or hadith for each.',
   E'Use Surah An-Nisa 4:136 as your starting point. Hand-drawn (scanned) or digital is fine.',
   now() + interval '10 days', 50, '[{"criterion":"Completeness","max_points":30},{"criterion":"Evidence cited","max_points":20}]', 'published', now() - interval '9 days'),
  ('e7000000-0000-4000-8000-000000000004', 'e1000000-0000-4000-8000-000000000004', 'e0000000-0000-4000-8000-000000000014', 'Timeline of the Makkan Period',
   'Build an illustrated timeline from the birth of the Prophet ﷺ to the Hijrah.',
   E'Include at least 12 dated events with one-line descriptions.',
   now() - interval '20 days', 100, '[]', 'closed', now() - interval '45 days'),
  ('e7000000-0000-4000-8000-000000000005', 'e1000000-0000-4000-8000-000000000005', 'e0000000-0000-4000-8000-000000000013', 'Wudu Step-by-Step Checklist',
   'Prepare a checklist of the fard and sunnah acts of wudu, with evidence.',
   E'Separate the obligatory acts from the sunnah acts and cite Surah Al-Ma''idah 5:6.',
   now() + interval '3 days', 50, '[]', 'published', now() - interval '20 days'),
  ('e7000000-0000-4000-8000-000000000006', 'e1000000-0000-4000-8000-000000000006', 'e0000000-0000-4000-8000-000000000014', 'Character Journal (7 Days)',
   'Keep a daily journal of one act of sidq, amanah, sabr or shukr.', '', NULL, 100, '[]', 'draft', now() - interval '4 days')
ON CONFLICT (id) DO NOTHING;

-- Two generated assignments per new published course: a past-due reflection and an upcoming task.
INSERT INTO assignments (id, course_id, professor_id, title, description, instructions, due_date, max_score, rubric, status, created_at)
SELECT md5('seed-asg-' || c.id || '-' || k.k)::uuid, c.id, c.professor_id,
       CASE k.k WHEN 1 THEN 'Reflection Journal: ' ELSE 'Research Task: ' END || l.title,
       CASE k.k WHEN 1 THEN 'Write a one-page reflection on "' || l.title || '" and how it applies to your life.'
                ELSE 'Research "' || l.title || '" using the course book and cite at least two sources.' END,
       E'Submit a single PDF. Include references to the Quran and/or authentic hadith where relevant.',
       CASE k.k WHEN 1 THEN now() - ((3 + abs(hashtext('d1' || c.id::text)) % 15) || ' days')::interval
                ELSE now() + ((2 + abs(hashtext('d2' || c.id::text)) % 14) || ' days')::interval END,
       CASE k.k WHEN 1 THEN 50 ELSE 100 END,
       '[{"criterion":"Understanding","max_points":40},{"criterion":"Use of evidence","max_points":40},{"criterion":"Presentation","max_points":20}]',
       CASE WHEN k.k = 1 AND abs(hashtext('st' || c.id::text)) % 3 = 0 THEN 'closed' ELSE 'published' END,
       c.created_at + interval '7 days'
FROM courses c
CROSS JOIN (VALUES (1), (2)) k(k)
JOIN seed_lec l ON l.course = right(c.id::text, 2)::int AND l.ord = CASE k.k WHEN 1 THEN 1 ELSE 3 END
WHERE c.id::text LIKE 'e1000000-%' AND c.status = 'published'
ON CONFLICT DO NOTHING;

INSERT INTO assignment_submissions (id, assignment_id, student_id, file_url, file_name, file_size_bytes, submitted_at, status, score, feedback, graded_by, graded_at)
SELECT md5('seed-sub-' || asg.id || e.student_id)::uuid, asg.id, e.student_id,
       'https://example.com/seed/submissions/' || md5('seed-sub-' || asg.id || e.student_id) || '.pdf',
       lower(replace(split_part(p.full_name, ' ', 1), '.', '')) || '_' || right(asg.id::text, 1) || '.pdf',
       150000 + x.h * 9000,
       CASE WHEN past AND x.h % 5 = 0 THEN least(now(), asg.due_date + interval '2 days')
            ELSE least(now(), coalesce(asg.due_date, now()) - ((x.h % 6 + 1) || ' days')::interval) END,
       CASE WHEN past AND x.h % 5 = 0 AND x.h % 2 = 1 THEN 'late'
            WHEN past THEN 'graded' ELSE 'submitted' END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN round(asg.max_score * (60 + x.h % 39) / 100) END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1)
            THEN (ARRAY['Excellent reflection — JazakAllahu khayran.', 'Good work. Add more evidence next time.', 'Well structured and thoughtful.', 'Solid effort; revise the second section.'])[1 + x.h % 4] END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN asg.professor_id END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN least(now(), asg.due_date + interval '4 days') END
FROM assignments asg
JOIN enrollments e ON e.course_id = asg.course_id AND e.status = 'active'
JOIN profiles p ON p.id = e.student_id
CROSS JOIN LATERAL (SELECT abs(hashtext('sub' || asg.id::text || e.student_id::text)) % 100 AS h) x
CROSS JOIN LATERAL (SELECT asg.due_date < now() AS past) y
WHERE asg.course_id::text LIKE 'e1000000-%' AND asg.status IN ('published', 'closed')
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND x.h >= CASE WHEN past THEN 10 ELSE 45 END
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 9. LIVE SESSIONS, ATTENDANCE & RECORDINGS
-- ════════════════════════════════════════════════════════════════════════════
CREATE TEMP TABLE seed_live (course int, s int, title text, start_offset interval) ON COMMIT DROP;
INSERT INTO seed_live VALUES
  (1, 1, 'Live Halaqah: Makharij Practice Circle',          '-14 days'),
  (1, 2, 'Live Halaqah: Noon Saakin Q&A',                    '-3 days'),
  (1, 3, 'Live Recitation Clinic (in progress)',             '-10 minutes'),
  (2, 1, 'Live Tafseer: Surah An-Naba Discussion',           '-10 days'),
  (2, 2, 'Live Tafseer: The Three Quls',                     '+2 days'),
  (3, 1, 'Live Q&A: Questions on Tawheed',                   '-8 days'),
  (3, 2, 'Live Session: Understanding Al-Qadr',              '+4 days'),
  (4, 1, 'Live Seerah Circle: The First Revelation',         '-6 days'),
  (4, 2, 'Midterm Revision Session',                         '+6 days'),
  (5, 1, 'Live Demonstration: Wudu & Tayammum',              '-5 days'),
  (5, 2, 'Live Q&A: Common Mistakes in Salah',               '+1 day');

-- Three sessions per new published course: two past (recorded) and one upcoming.
INSERT INTO seed_live
SELECT l.course, l.ord, 'Live Halaqah: ' || l.title,
       (ARRAY['-20 days', '-6 days', '+3 days']::interval[])[l.ord] + ((abs(hashtext('lv' || l.course)) % 48) || ' hours')::interval
FROM seed_lec l WHERE l.course BETWEEN 10 AND 17 AND l.ord <= 3;

INSERT INTO live_sessions (id, course_id, instructor_id, title, description, start_at, end_at, provider, provider_meeting_id, join_url, created_at)
SELECT md5('seed-live-' || l.course || '-' || l.s)::uuid, c.id, c.professor_id, l.title,
       'Weekly live class for ' || c.title || '. Bring your questions.',
       date_trunc('minute', now() + l.start_offset), date_trunc('minute', now() + l.start_offset) + interval '1 hour',
       'free', 'lms-session-' || md5('seed-live-' || l.course || '-' || l.s)::uuid,
       'https://meet.jit.si/lms-session-' || md5('seed-live-' || l.course || '-' || l.s)::uuid,
       now() + l.start_offset - interval '7 days'
FROM seed_live l
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-0000000000' || lpad(l.course::text, 2, '0'))::uuid
ON CONFLICT DO NOTHING;

INSERT INTO live_attendance (id, session_id, user_id, joined_at, left_at, duration_seconds, created_at)
SELECT md5('seed-live-att-' || ls.id || e.student_id)::uuid, ls.id, e.student_id,
       ls.start_at + ((x.h % 10) || ' minutes')::interval,
       ls.end_at - ((x.h % 15) || ' minutes')::interval,
       3600 - (x.h % 10) * 60 - (x.h % 15) * 60,
       ls.start_at
FROM live_sessions ls
JOIN enrollments e ON e.course_id = ls.course_id AND e.status = 'active'
CROSS JOIN LATERAL (SELECT abs(hashtext('live' || ls.id::text || e.student_id::text)) % 100 AS h) x
WHERE ls.id IN (SELECT md5('seed-live-' || course || '-' || s)::uuid FROM seed_live)
  AND ls.end_at < now()
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND x.h >= 25
ON CONFLICT DO NOTHING;

INSERT INTO live_session_recordings (id, session_id, recording_url, duration_seconds, created_at)
SELECT md5('seed-rec-' || ls.id)::uuid, ls.id,
       'https://example.com/seed/recordings/' || ls.id || '.mp4', 3420, ls.end_at + interval '30 minutes'
FROM live_sessions ls
WHERE ls.id IN (SELECT md5('seed-live-' || course || '-' || s)::uuid FROM seed_live)
  AND ls.end_at < now()
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 10. FEES
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO fee_structures (id, title, description, amount, currency, fee_type, frequency, course_id, status) VALUES
  ('e9000000-0000-4000-8000-000000000001', 'Registration Fee', 'One-time admission and registration fee.', 25, 'USD', 'registration', 'one-time', NULL, 'active'),
  ('e9000000-0000-4000-8000-000000000002', 'Monthly Tuition', 'Monthly tuition covering all enrolled courses.', 40, 'USD', 'tuition', 'monthly', NULL, 'active'),
  ('e9000000-0000-4000-8000-000000000003', 'Exam Fee — Seerah Midterm', 'Invigilation and certificate processing for the Seerah midterm.', 10, 'USD', 'exam', 'one-time', 'e1000000-0000-4000-8000-000000000004', 'active'),
  ('e9000000-0000-4000-8000-000000000004', 'Library Access', 'Annual access to the digital library.', 15, 'USD', 'library', 'annual', NULL, 'active'),
  ('e9000000-0000-4000-8000-000000000005', 'Late Payment Fee', 'Applied to tuition paid more than 7 days after the due date.', 5, 'USD', 'late_fee', 'one-time', NULL, 'active'),
  ('e9000000-0000-4000-8000-000000000006', 'Tajweed Course Fee', 'Semester fee for one-on-one recitation review.', 60, 'USD', 'tuition', 'semester', 'e1000000-0000-4000-8000-000000000001', 'active'),
  ('e9000000-0000-4000-8000-000000000007', 'Legacy Admission Fee (2025)', 'Replaced by the Registration Fee.', 30, 'USD', 'registration', 'one-time', NULL, 'inactive')
ON CONFLICT (id) DO NOTHING;

INSERT INTO fee_discounts (id, title, discount_type, value, active) VALUES
  ('e9100000-0000-4000-8000-000000000001', 'Sibling Discount', 'percentage', 10, true),
  ('e9100000-0000-4000-8000-000000000002', 'Merit Scholarship', 'percentage', 25, true),
  ('e9100000-0000-4000-8000-000000000003', 'Hardship Waiver', 'fixed', 20, true),
  ('e9100000-0000-4000-8000-000000000004', 'Ramadan Early-Bird 2025', 'percentage', 15, false)
ON CONFLICT (id) DO NOTHING;

-- One row per assessment: (student, fee, tag, assessed, paid, status, due offset, discount #, discount amount)
CREATE TEMP TABLE seed_fa (student int, fee int, tag text, assessed numeric, paid numeric, status text, due interval, disc int, deducted numeric) ON COMMIT DROP;

-- Registration: everyone except accounts still pending activation
INSERT INTO seed_fa
SELECT n, 1, 'reg', 25, 25, 'paid', (-((n * 3) % 150 + 10) || ' days')::interval, NULL, 0
FROM seed_users WHERE role = 'student' AND status <> 'pending_activation';

-- Tuition (last month + this month) with sibling / merit / hardship discounts
CREATE TEMP TABLE seed_tuition ON COMMIT DROP AS
SELECT n, status, d.disc, CASE d.disc WHEN 1 THEN 4 WHEN 2 THEN 10 WHEN 3 THEN 20 ELSE 0 END::numeric AS deducted
FROM seed_users
CROSS JOIN LATERAL (SELECT CASE WHEN n % 10 = 2 THEN 1 WHEN n % 10 = 5 THEN 2 WHEN n % 13 = 0 THEN 3 END AS disc) d
WHERE role = 'student' AND status IN ('active', 'suspended', 'inactive');

INSERT INTO seed_fa
SELECT n, 2, 'tuition-prev', 40 - deducted, 40 - deducted, 'paid', '-40 days', disc, deducted FROM seed_tuition;

INSERT INTO seed_fa
SELECT n, 2, 'tuition', 40 - deducted,
       CASE WHEN status = 'inactive' THEN 0 ELSE CASE n % 4 WHEN 0 THEN 40 - deducted WHEN 1 THEN (40 - deducted) / 2 ELSE 0 END END,
       CASE WHEN status = 'inactive' THEN 'overdue' ELSE CASE n % 4 WHEN 0 THEN 'paid' WHEN 1 THEN 'partial' WHEN 2 THEN 'unpaid' ELSE 'overdue' END END,
       CASE WHEN status <> 'inactive' AND n % 4 = 2 THEN '10 days'::interval ELSE '-10 days'::interval END,
       disc, deducted
FROM seed_tuition;

-- Late fee on every overdue tuition bill
INSERT INTO seed_fa SELECT student, 5, 'late', 5, 0, 'unpaid', '5 days', NULL, 0 FROM seed_fa WHERE tag = 'tuition' AND status = 'overdue';

-- Withdrawn students: this month's tuition cancelled
INSERT INTO seed_fa SELECT n, 2, 'tuition', 40, 0, 'cancelled', '-10 days', NULL, 0 FROM seed_users WHERE role = 'student' AND status = 'withdrawn';

-- Library (every third active student)
INSERT INTO seed_fa SELECT n, 4, 'library', 15, 15, 'paid', '-60 days', NULL, 0 FROM seed_users WHERE role = 'student' AND status = 'active' AND n % 3 = 0;

-- Seerah midterm exam fee and Tajweed course fee for active enrollees
INSERT INTO seed_fa SELECT student, 3, 'exam', 10, 0, 'unpaid', '14 days', NULL, 0 FROM seed_enroll WHERE course = 4 AND status = 'active';
INSERT INTO seed_fa
SELECT student, 6, 'tajweed', 60, CASE WHEN student % 6 = 0 THEN 0 ELSE 60 END,
       CASE WHEN student % 6 = 0 THEN 'unpaid' ELSE 'paid' END,
       CASE WHEN student % 6 = 0 THEN '20 days'::interval ELSE '-40 days'::interval END, NULL, 0
FROM seed_enroll WHERE course = 1 AND status = 'active';

INSERT INTO fee_assessments (id, student_id, fee_structure_id, amount_assessed, amount_paid, due_date, status, created_at)
SELECT md5('seed-fa-' || f.student || '-' || f.tag)::uuid,
       ('e0000000-0000-4000-8000-0000000000' || f.student)::uuid,
       ('e9000000-0000-4000-8000-00000000000' || f.fee)::uuid,
       f.assessed, f.paid, date_trunc('day', now() + f.due), f.status, now() + f.due - interval '20 days'
FROM seed_fa f
ON CONFLICT DO NOTHING;

INSERT INTO fee_assessments_discounts (id, assessment_id, discount_id, amount_deducted)
SELECT md5('seed-fad-' || f.student || '-' || f.tag)::uuid, md5('seed-fa-' || f.student || '-' || f.tag)::uuid,
       ('e9100000-0000-4000-8000-00000000000' || f.disc)::uuid, f.deducted
FROM seed_fa f WHERE f.disc IS NOT NULL AND f.status <> 'cancelled'
ON CONFLICT DO NOTHING;

-- Partial tuition → two installments (first paid, second pending)
INSERT INTO fee_installments (id, assessment_id, amount, due_date, status)
SELECT md5('seed-fi-' || f.student || '-' || i)::uuid, md5('seed-fa-' || f.student || '-tuition')::uuid,
       f.assessed / 2, date_trunc('day', now() + f.due + ((i - 1) * 15 || ' days')::interval),
       CASE WHEN i = 1 THEN 'paid' ELSE 'pending' END
FROM seed_fa f CROSS JOIN generate_series(1, 2) i
WHERE f.tag = 'tuition' AND f.status = 'partial'
ON CONFLICT DO NOTHING;

INSERT INTO fee_payments (id, student_id, assessment_id, amount, payment_method, status, reference_number, created_at)
SELECT md5('seed-fp-' || f.student || '-' || f.tag)::uuid,
       ('e0000000-0000-4000-8000-0000000000' || f.student)::uuid,
       md5('seed-fa-' || f.student || '-' || f.tag)::uuid,
       f.paid,
       (ARRAY['bank_transfer', 'cash', 'credit_card', 'online_gateway'])[1 + f.student % 4],
       'completed', 'SEED-' || upper(left(md5('seed-fp-' || f.student || '-' || f.tag), 10)),
       now() + f.due - interval '2 days'
FROM seed_fa f WHERE f.paid > 0
ON CONFLICT DO NOTHING;

-- Failed payment attempts on overdue tuition
INSERT INTO fee_payments (id, student_id, assessment_id, amount, payment_method, status, reference_number, created_at)
SELECT md5('seed-fp-failed-' || f.student)::uuid,
       ('e0000000-0000-4000-8000-0000000000' || f.student)::uuid,
       md5('seed-fa-' || f.student || '-tuition')::uuid,
       f.assessed, 'credit_card', 'failed', 'SEED-F' || upper(left(md5('seed-fp-failed-' || f.student), 9)),
       now() - interval '8 days'
FROM seed_fa f WHERE f.tag = 'tuition' AND f.status = 'overdue'
ON CONFLICT DO NOTHING;

INSERT INTO fee_refunds (id, payment_id, amount, reason, status, created_at) VALUES
  (md5('seed-fr-31')::uuid, md5('seed-fp-31-tajweed')::uuid, 30, 'Account suspended mid-semester — partial refund of course fee requested.', 'requested', now() - interval '4 days'),
  (md5('seed-fr-26')::uuid, md5('seed-fp-26-tajweed')::uuid, 10, 'Overcharged by the payment gateway — difference refunded.', 'processed', now() - interval '30 days'),
  (md5('seed-fr-24')::uuid, md5('seed-fp-24-reg')::uuid, 25, 'Requested refund of registration fee after the 14-day window.', 'rejected', now() - interval '50 days')
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 11. KPI CONFIGS & SNAPSHOTS
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO kpi_configs (id, role, name, metric_key, target_value, comparison, period, unit, description, active, created_by)
SELECT k.id::uuid, k.role, k.name, k.metric_key, k.target, k.cmp, k.period, k.unit, k.descr, true, 'e0000000-0000-4000-8000-000000000001'
FROM (VALUES
  ('ea000000-0000-4000-8000-000000000001', 'professor', 'Professor Lecture Target',   'lectures_created',        20, 'gte', 'monthly', ' lectures', 'Target: 20 lectures/month'),
  ('ea000000-0000-4000-8000-000000000002', 'professor', 'Courses Created',            'courses_created',          1, 'gte', 'monthly', ' courses',  'At least one new course per month'),
  ('ea000000-0000-4000-8000-000000000003', 'professor', 'Lecture Completion Rate',    'lecture_completion_rate', 70, 'gte', 'monthly', '%',         'Students complete at least 70% of lectures'),
  ('ea000000-0000-4000-8000-000000000004', 'professor', 'Student Engagement',         'student_engagement',      60, 'gte', 'weekly',  '%',         'Share of enrolled students active each week'),
  ('ea000000-0000-4000-8000-000000000005', 'professor', 'Quiz Creation',              'quiz_creation',            2, 'gte', 'monthly', ' quizzes',  'Publish at least 2 quizzes per month'),
  ('ea000000-0000-4000-8000-000000000006', 'professor', 'Assignment Uploads',         'assignment_upload',        2, 'gte', 'monthly', ' assignments', 'Publish at least 2 assignments per month'),
  ('ea000000-0000-4000-8000-000000000007', 'professor', 'Course Updates',             'course_updates',           4, 'gte', 'monthly', ' updates',  'Keep course content fresh'),
  ('ea000000-0000-4000-8000-000000000008', 'student',   'Student Course Completion',  'course_completion_days',  30, 'lte', 'monthly', ' days',     'Target: Complete course in 30 days'),
  ('ea000000-0000-4000-8000-000000000009', 'student',   'Engagement KPI',             'watch_time_pct',          80, 'gte', 'monthly', '%',         'Minimum watch time: 80%'),
  ('ea000000-0000-4000-8000-000000000010', 'admin',     'Courses Approved',           'courses_approved',         3, 'gte', 'monthly', ' courses',  'Review and approve pending courses promptly'),
  ('ea000000-0000-4000-8000-000000000011', 'admin',     'Certificates Issued',        'certificates_issued',      5, 'gte', 'monthly', ' certificates', 'Issue certificates to eligible students'),
  ('ea000000-0000-4000-8000-000000000012', 'admin',     'New Users Onboarded',        'new_users_onboarded',     10, 'gte', 'monthly', ' users',    'Grow the learner community')
) AS k(id, role, name, metric_key, target, cmp, period, unit, descr)
WHERE NOT EXISTS (SELECT 1 FROM kpi_configs c WHERE c.role = k.role AND c.metric_key = k.metric_key)
ON CONFLICT (id) DO NOTHING;

-- Snapshots for the last 3 months, per user × config for their role
INSERT INTO kpi_snapshots (id, user_id, kpi_config_id, period_start, period_end, actual_value, target_value, status, computed_at)
SELECT md5('seed-kpi-' || u.id || cfg.id || m)::uuid, u.id, cfg.id,
       date_trunc('month', now()) - (m || ' months')::interval,
       date_trunc('month', now()) - ((m - 1) || ' months')::interval - interval '1 second',
       v.actual, cfg.target_value,
       CASE WHEN (cfg.comparison = 'gte' AND v.actual >= cfg.target_value) OR (cfg.comparison = 'lte' AND v.actual <= cfg.target_value) THEN 'on_track'
            WHEN (cfg.comparison = 'gte' AND v.actual >= cfg.target_value * 0.7) OR (cfg.comparison = 'lte' AND v.actual <= cfg.target_value * 1.3) THEN 'below_target'
            ELSE 'critical' END,
       date_trunc('month', now()) - ((m - 1) || ' months')::interval
FROM seed_users u
JOIN LATERAL (
  SELECT DISTINCT ON (c.metric_key) c.* FROM kpi_configs c
  WHERE c.role = u.role AND c.active ORDER BY c.metric_key, c.created_at
) cfg ON true
CROSS JOIN generate_series(1, 3) m
CROSS JOIN LATERAL (SELECT abs(hashtext(u.id::text || cfg.metric_key || m)) % 100 AS h) x
CROSS JOIN LATERAL (SELECT round(cfg.target_value * (0.5 + x.h / 100.0 * 0.8), 2) AS actual) v
WHERE u.status = 'active'
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 12. CERTIFICATES
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO certificates (id, student_id, course_id, cert_number, grade, professor_cleared, professor_cleared_by, professor_cleared_at,
                          finance_cleared_at, status, issued_by, issued_at) VALUES
  ('eb000000-0000-4000-8000-000000000001', 'e0000000-0000-4000-8000-000000000021', 'e1000000-0000-4000-8000-000000000009', 'CERT-IKS-2025-0001', 88.50, true,
   'e0000000-0000-4000-8000-000000000014', now() - interval '138 days', now() - interval '137 days', 'issued', 'e0000000-0000-4000-8000-000000000001', now() - interval '136 days'),
  ('eb000000-0000-4000-8000-000000000002', 'e0000000-0000-4000-8000-000000000032', 'e1000000-0000-4000-8000-000000000009', 'CERT-IKS-2025-0002', 92.00, true,
   'e0000000-0000-4000-8000-000000000014', now() - interval '138 days', now() - interval '137 days', 'issued', 'e0000000-0000-4000-8000-000000000001', now() - interval '136 days'),
  ('eb000000-0000-4000-8000-000000000003', 'e0000000-0000-4000-8000-000000000021', 'e1000000-0000-4000-8000-000000000001', NULL, 84.00, true,
   'e0000000-0000-4000-8000-000000000011', now() - interval '2 days', NULL, 'pending', NULL, NULL),
  ('eb000000-0000-4000-8000-000000000004', 'e0000000-0000-4000-8000-000000000023', 'e1000000-0000-4000-8000-000000000003', NULL, 76.50, false,
   NULL, NULL, NULL, 'pending', NULL, NULL),
  ('eb000000-0000-4000-8000-000000000005', 'e0000000-0000-4000-8000-000000000033', 'e1000000-0000-4000-8000-000000000003', 'CERT-IKS-2026-0007', 70.00, true,
   'e0000000-0000-4000-8000-000000000013', now() - interval '60 days', now() - interval '60 days', 'revoked', 'e0000000-0000-4000-8000-000000000001', now() - interval '59 days')
ON CONFLICT DO NOTHING;

-- Completed enrollments → issued certificates; near-complete active enrollments → pending (professor cleared).
INSERT INTO certificates (id, student_id, course_id, cert_number, grade, professor_cleared, professor_cleared_by, professor_cleared_at,
                          finance_cleared_at, status, issued_by, issued_at)
SELECT md5('seed-cert-' || e.id)::uuid, e.student_id, e.course_id,
       CASE WHEN e.status = 'completed' THEN 'CERT-IKS-' || upper(left(md5('seed-cert-' || e.id), 8)) END,
       75 + abs(hashtext('g' || e.id::text)) % 25,
       true, c.professor_id, coalesce(e.completed_at, now() - interval '3 days'),
       CASE WHEN e.status = 'completed' THEN e.completed_at + interval '1 day' END,
       CASE WHEN e.status = 'completed' THEN 'issued' ELSE 'pending' END,
       CASE WHEN e.status = 'completed' THEN 'e0000000-0000-4000-8000-000000000001'::uuid END,
       CASE WHEN e.status = 'completed' THEN least(now(), e.completed_at + interval '2 days') END
FROM enrollments e
JOIN courses c ON c.id = e.course_id
WHERE e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
  AND (e.status = 'completed' OR (e.status = 'active' AND e.progress_pct >= 95))
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 13. ALERTS, AUDIT LOGS, LOGIN EVENTS
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO alerts (id, user_id, type, severity, title, message, read_at, created_at) VALUES
  ('ec000000-0000-4000-8000-000000000001', 'e0000000-0000-4000-8000-000000000001', 'course_pending', 'warning', 'Course Pending Approval', 'A new course "Daily Adhkar & Masnoon Duas" requires review and approval.', NULL, now() - interval '6 days'),
  ('ec000000-0000-4000-8000-000000000002', 'e0000000-0000-4000-8000-000000000001', 'user_pending', 'info', 'Accounts Awaiting Activation', 'Ustad Imran Malik and Aisha Kareem are waiting for account activation.', NULL, now() - interval '1 day'),
  ('ec000000-0000-4000-8000-000000000003', 'e0000000-0000-4000-8000-000000000002', 'fee_overdue', 'warning', 'Overdue Tuition Payments', 'Several students have overdue tuition for this month. Review the Finance hub.', NULL, now() - interval '2 days'),
  ('ec000000-0000-4000-8000-000000000004', 'e0000000-0000-4000-8000-000000000002', 'refund_requested', 'info', 'Refund Requested', 'Ibrahim Mirza requested a partial refund of the Tajweed course fee.', NULL, now() - interval '4 days'),
  ('ec000000-0000-4000-8000-000000000005', 'e0000000-0000-4000-8000-000000000011', 'assignment_submitted', 'info', 'New Submissions', 'New submissions received for "Recite & Record: Noon Saakin Rules".', NULL, now() - interval '1 day'),
  ('ec000000-0000-4000-8000-000000000006', 'e0000000-0000-4000-8000-000000000011', 'grading_pending', 'warning', 'Essays Awaiting Grading', 'Juz Amma Midterm has essay answers waiting for your review.', NULL, now() - interval '3 days'),
  ('ec000000-0000-4000-8000-000000000007', 'e0000000-0000-4000-8000-000000000014', 'kpi_below_target', 'critical', 'KPI Below Target', 'Your "Lectures Created" KPI is below 70% of the monthly target.', NULL, now() - interval '1 day'),
  ('ec000000-0000-4000-8000-000000000008', 'e0000000-0000-4000-8000-000000000013', 'course_approved', 'info', 'Course Approved', 'Your course "Fiqh of Taharah & Salah" has been approved and published.', now() - interval '85 days', now() - interval '88 days'),
  ('ec000000-0000-4000-8000-000000000009', 'e0000000-0000-4000-8000-000000000021', 'exam_published', 'info', 'Exam Published', 'A new exam "Seerah Midterm: The Makkan Period" has been scheduled.', NULL, now() - interval '1 day'),
  ('ec000000-0000-4000-8000-000000000010', 'e0000000-0000-4000-8000-000000000021', 'certificate_issued', 'info', 'Certificate Issued', 'Your certificate for "Seerah: The Madinan Period" is ready to download.', now() - interval '130 days', now() - interval '136 days'),
  ('ec000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000022', 'fee_due', 'warning', 'Exam Fee Due', 'The Seerah Midterm exam fee ($10) is due in 14 days.', NULL, now() - interval '2 days'),
  ('ec000000-0000-4000-8000-000000000012', 'e0000000-0000-4000-8000-000000000023', 'low_attendance', 'critical', 'Low Attendance', 'Your attendance in "Foundations of Aqeedah" has dropped below 60%.', NULL, now() - interval '3 days'),
  ('ec000000-0000-4000-8000-000000000013', 'e0000000-0000-4000-8000-000000000024', 'assignment_due', 'warning', 'Assignment Due Soon', '"Wudu Step-by-Step Checklist" is due in 3 days.', NULL, now() - interval '4 hours'),
  ('ec000000-0000-4000-8000-000000000014', 'e0000000-0000-4000-8000-000000000027', 'fee_overdue', 'critical', 'Tuition Overdue', 'Your monthly tuition is overdue. Please pay to avoid a late fee.', NULL, now() - interval '1 day'),
  ('ec000000-0000-4000-8000-000000000015', 'e0000000-0000-4000-8000-000000000026', 'live_reminder', 'info', 'Live Class Today', '"Live Recitation Clinic" is starting now.', NULL, now() - interval '15 minutes')
ON CONFLICT DO NOTHING;

INSERT INTO audit_logs (id, actor_id, action, entity_type, entity_id, details, created_at) VALUES
  ('ed000000-0000-4000-8000-000000000001', 'e0000000-0000-4000-8000-000000000001', 'activate_user',      'profile',     'e0000000-0000-4000-8000-000000000021', '{}', now() - interval '129 days'),
  ('ed000000-0000-4000-8000-000000000002', 'e0000000-0000-4000-8000-000000000001', 'approve_course',     'course',      'e1000000-0000-4000-8000-000000000001', '{"from":"pending","to":"published"}', now() - interval '118 days'),
  ('ed000000-0000-4000-8000-000000000003', 'e0000000-0000-4000-8000-000000000001', 'approve_course',     'course',      'e1000000-0000-4000-8000-000000000005', '{"from":"pending","to":"published"}', now() - interval '88 days'),
  ('ed000000-0000-4000-8000-000000000004', 'e0000000-0000-4000-8000-000000000002', 'create_fee_structure','fee_structure','e9000000-0000-4000-8000-000000000002', '{"amount":40,"frequency":"monthly"}', now() - interval '100 days'),
  ('ed000000-0000-4000-8000-000000000005', 'e0000000-0000-4000-8000-000000000001', 'issue_certificate',  'certificate', 'eb000000-0000-4000-8000-000000000001', '{"cert_number":"CERT-IKS-2025-0001"}', now() - interval '136 days'),
  ('ed000000-0000-4000-8000-000000000006', 'e0000000-0000-4000-8000-000000000001', 'update_user',        'profile',     'e0000000-0000-4000-8000-000000000031', '{"status":{"from":"active","to":"suspended"}}', now() - interval '5 days'),
  ('ed000000-0000-4000-8000-000000000007', 'e0000000-0000-4000-8000-000000000001', 'update_user',        'profile',     'e0000000-0000-4000-8000-000000000032', '{"status":{"from":"active","to":"graduated"}}', now() - interval '135 days'),
  ('ed000000-0000-4000-8000-000000000008', 'e0000000-0000-4000-8000-000000000001', 'update_user',        'profile',     'e0000000-0000-4000-8000-000000000033', '{"status":{"from":"active","to":"withdrawn"}}', now() - interval '60 days'),
  ('ed000000-0000-4000-8000-000000000009', 'e0000000-0000-4000-8000-000000000014', 'publish_exam',       'exam',        'e6000000-0000-4000-8000-000000000004', '{"status":"published"}', now() - interval '1 day'),
  ('ed000000-0000-4000-8000-000000000010', 'e0000000-0000-4000-8000-000000000001', 'approve_course',     'course',      'e1000000-0000-4000-8000-000000000006', '{"from":"pending","to":"approved"}', now() - interval '25 days'),
  ('ed000000-0000-4000-8000-000000000011', 'e0000000-0000-4000-8000-000000000001', 'revoke_certificate', 'certificate', 'eb000000-0000-4000-8000-000000000005', '{"reason":"Student withdrew before completion was verified"}', now() - interval '58 days'),
  ('ed000000-0000-4000-8000-000000000012', 'e0000000-0000-4000-8000-000000000002', 'record_payment',     'fee_payment', md5('seed-fp-21-reg')::uuid, '{"amount":25,"method":"cash"}', now() - interval '65 days')
ON CONFLICT DO NOTHING;

-- Generated alerts
INSERT INTO alerts (id, user_id, type, severity, title, message, read_at, created_at)
SELECT md5('seed-alert-fee-' || fa.id)::uuid, fa.student_id, 'fee_overdue', 'critical', 'Payment Overdue',
       fs.title || ' of $' || fa.amount_assessed || ' is overdue. Please pay to avoid a late fee.', NULL, fa.due_date + interval '1 day'
FROM fee_assessments fa JOIN fee_structures fs ON fs.id = fa.fee_structure_id
WHERE fa.id IN (SELECT md5('seed-fa-' || student || '-' || tag)::uuid FROM seed_fa) AND fa.status = 'overdue'
ON CONFLICT DO NOTHING;

INSERT INTO alerts (id, user_id, type, severity, title, message, read_at, created_at)
SELECT md5('seed-alert-graded-' || s.id)::uuid, s.student_id, 'assignment_graded', 'info', 'Assignment Graded',
       'Your submission for "' || a.title || '" was graded: ' || s.score || '/' || a.max_score || '.',
       CASE WHEN abs(hashtext(s.id::text)) % 2 = 0 THEN s.graded_at + interval '1 day' END, s.graded_at
FROM assignment_submissions s JOIN assignments a ON a.id = s.assignment_id
WHERE s.status = 'graded' AND a.course_id::text LIKE 'e1000000-%' AND s.graded_at <= now()
ON CONFLICT DO NOTHING;

INSERT INTO alerts (id, user_id, type, severity, title, message, read_at, created_at)
SELECT md5('seed-alert-exam-' || r.id)::uuid, r.student_id, 'exam_published', 'info', 'Exam Scheduled',
       '"' || ex.title || '" is scheduled for ' || to_char(ex.scheduled_start, 'DD Mon YYYY HH24:MI') || '. You are registered.',
       NULL, r.registered_at
FROM exam_registrations r JOIN exams ex ON ex.id = r.exam_id
WHERE ex.scheduled_start > now() AND r.id = md5('seed-reg-' || r.exam_id || r.student_id)::uuid
ON CONFLICT DO NOTHING;

INSERT INTO alerts (id, user_id, type, severity, title, message, read_at, created_at)
SELECT md5('seed-alert-att-' || la.student_id || la.course_id)::uuid, la.student_id, 'low_attendance', 'warning', 'Low Attendance',
       'You have missed ' || count(*) || ' lectures in "' || c.title || '". Catch up on the recordings.', NULL, now() - interval '2 days'
FROM lecture_attendance la JOIN courses c ON c.id = la.course_id
WHERE la.status = 'absent' AND la.id = md5('seed-att-' || la.student_id || la.lecture_id)::uuid
GROUP BY la.student_id, la.course_id, c.title
HAVING count(*) >= 2
ON CONFLICT DO NOTHING;

-- Generated audit trail
INSERT INTO audit_logs (id, actor_id, action, entity_type, entity_id, details, created_at)
SELECT md5('seed-audit-approve-' || c.id)::uuid, 'e0000000-0000-4000-8000-000000000001', 'approve_course', 'course', c.id,
       jsonb_build_object('title', c.title, 'to', c.status), c.created_at + interval '2 days'
FROM courses c WHERE c.id::text LIKE 'e1000000-%' AND c.status IN ('published', 'approved', 'archived')
ON CONFLICT DO NOTHING;

INSERT INTO audit_logs (id, actor_id, action, entity_type, entity_id, details, created_at)
SELECT md5('seed-audit-activate-' || u.id)::uuid, ('e0000000-0000-4000-8000-00000000000' || (1 + u.n % 2))::uuid,
       'activate_user', 'profile', u.id, jsonb_build_object('email', u.email, 'role', u.role), now() - u.joined + interval '1 day'
FROM seed_users u WHERE u.role <> 'admin' AND u.status <> 'pending_activation'
ON CONFLICT DO NOTHING;

INSERT INTO audit_logs (id, actor_id, action, entity_type, entity_id, details, created_at)
SELECT md5('seed-audit-pay-' || fp.id)::uuid, 'e0000000-0000-4000-8000-000000000002', 'record_payment', 'fee_payment', fp.id,
       jsonb_build_object('amount', fp.amount, 'method', fp.payment_method, 'reference', fp.reference_number), fp.created_at
FROM fee_payments fp WHERE fp.reference_number LIKE 'SEED-%' AND fp.status = 'completed'
ON CONFLICT DO NOTHING;

INSERT INTO audit_logs (id, actor_id, action, entity_type, entity_id, details, created_at)
SELECT md5('seed-audit-cert-' || ce.id)::uuid, ce.issued_by, 'issue_certificate', 'certificate', ce.id,
       jsonb_build_object('cert_number', ce.cert_number), ce.issued_at
FROM certificates ce WHERE ce.id::text NOT LIKE 'eb000000-%' AND ce.status = 'issued'
  AND ce.id IN (SELECT md5('seed-cert-' || md5('seed-enr-' || course || '-' || student)::uuid)::uuid FROM seed_enroll)
ON CONFLICT DO NOTHING;

INSERT INTO login_events (id, user_id, ip_address, login_at)
SELECT md5('seed-login-' || u.id || d)::uuid, u.id,
       '203.0.113.' || (u.n * 7 % 250 + 1),
       date_trunc('day', now()) - (d || ' days')::interval + ((7 + x.h % 14) || ' hours')::interval + ((x.h % 60) || ' minutes')::interval
FROM seed_users u
CROSS JOIN generate_series(0, 29) d
CROSS JOIN LATERAL (SELECT abs(hashtext(u.id::text || d)) % 100 AS h) x
WHERE u.status = 'active'
  AND x.h < CASE u.role WHEN 'student' THEN 55 ELSE 75 END
  AND date_trunc('day', now()) - (d || ' days')::interval + ((7 + x.h % 14) || ' hours')::interval <= now()
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- 14. STUDENT ANALYTICS (computed from the data above)
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO student_analytics (id, student_id, course_id, attendance_count, total_lectures, lecture_completion_pct, total_watch_seconds,
                               quiz_attempts, avg_quiz_score, exam_score, assignment_completion_pct, login_count_daily, login_count_weekly, last_active, updated_at)
SELECT md5('seed-sa-' || e.student_id || e.course_id)::uuid, e.student_id, e.course_id,
       (SELECT count(*) FROM lecture_attendance la JOIN lectures l ON l.id = la.lecture_id
         WHERE la.student_id = e.student_id AND l.course_id = e.course_id AND la.status = 'present'),
       (SELECT count(*) FROM lectures l WHERE l.course_id = e.course_id AND l.publish_date <= now()),
       e.progress_pct,
       (SELECT coalesce(sum(lp.total_watch_seconds), 0) FROM lecture_progress lp JOIN lectures l ON l.id = lp.lecture_id
         WHERE lp.student_id = e.student_id AND l.course_id = e.course_id),
       (SELECT count(*) FROM exam_attempts a JOIN exams x ON x.id = a.exam_id
         WHERE a.student_id = e.student_id AND x.course_id = e.course_id AND x.type = 'quiz'),
       (SELECT coalesce(round(avg(a.score / nullif(a.total_marks, 0) * 100), 2), 0) FROM exam_attempts a JOIN exams x ON x.id = a.exam_id
         WHERE a.student_id = e.student_id AND x.course_id = e.course_id AND x.type = 'quiz' AND a.status <> 'in_progress'),
       (SELECT coalesce(round(avg(a.score / nullif(a.total_marks, 0) * 100), 2), 0) FROM exam_attempts a JOIN exams x ON x.id = a.exam_id
         WHERE a.student_id = e.student_id AND x.course_id = e.course_id AND x.type = 'exam' AND a.status <> 'in_progress'),
       coalesce((SELECT round(count(s.id) * 100.0 / nullif(count(asg.id), 0), 2)
                 FROM assignments asg
                 LEFT JOIN assignment_submissions s ON s.assignment_id = asg.id AND s.student_id = e.student_id
                 WHERE asg.course_id = e.course_id AND asg.status IN ('published', 'closed')), 0),
       (SELECT count(*) FROM login_events le WHERE le.user_id = e.student_id AND le.login_at >= now() - interval '1 day'),
       (SELECT count(*) FROM login_events le WHERE le.user_id = e.student_id AND le.login_at >= now() - interval '7 days'),
       (SELECT max(le.login_at) FROM login_events le WHERE le.user_id = e.student_id),
       now()
FROM enrollments e
WHERE e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
ON CONFLICT DO NOTHING;

COMMIT;
