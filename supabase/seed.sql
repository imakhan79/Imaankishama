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

All seed accounts use the password:  Seed@12345
  admin:      ayesha.siddiqui@imaankishama.test   (also bilal.ahmed@…)
  professor:  abdullah.rahman@imaankishama.test   (and 3 others)
  student:    ahmed.raza@imaankishama.test        (and 13 others)

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
  ('e1000000-0000-4000-8000-000000000009', 'Seerah: The Madinan Period (2025 Cohort)', 'From the Hijrah to the Farewell Pilgrimage. Archived after the 2025 cohort completed.', 'Seerah', 'e0000000-0000-4000-8000-000000000014', 'archived', '', now() - interval '170 days')
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

-- ════════════════════════════════════════════════════════════════════════════
-- 3. COURSE MATERIALS, LIBRARY BOOKS & LECTURE ATTACHMENTS
--    (inserted before enrollments so the new-material trigger doesn't flood alerts)
-- ════════════════════════════════════════════════════════════════════════════
-- Lecture notes (PDF) for every seeded lecture
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at)
SELECT ('e3000000-0000-4000-8000-0000000000' || right(l.id::text, 2))::uuid, l.course_id, l.id, 'pdf',
       'Lecture Notes — ' || l.title,
       'https://example.com/seed/notes/lecture-' || right(l.id::text, 2) || '.pdf',
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
  ('e3200000-0000-4000-8000-000000000007', 'e1000000-0000-4000-8000-000000000007', NULL, 'book', 'Hisnul Muslim (Fortress of the Muslim) — Sa''id al-Qahtani', 'https://example.com/seed/library/hisnul-muslim.pdf', 3100000, 0, now() - interval '5 days')
ON CONFLICT (id) DO NOTHING;

-- Syllabus notes + worksheets
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at)
SELECT ('e3300000-0000-4000-8000-00000000000' || right(c.id::text, 1))::uuid, c.id, NULL, 'note',
       'Course Syllabus — ' || c.title, 'https://example.com/seed/syllabus/course-' || right(c.id::text, 1) || '.pdf',
       180000, 0, c.created_at
FROM courses c WHERE c.id::text LIKE 'e1000000-%'
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds, created_at) VALUES
  ('e3400000-0000-4000-8000-000000000012', 'e1000000-0000-4000-8000-000000000001', 'e2000000-0000-4000-8000-000000000012', 'worksheet', 'Worksheet: Match Each Letter to Its Makhraj', 'https://example.com/seed/worksheets/makharij.pdf', 220000, 0, now() - interval '45 days'),
  ('e3400000-0000-4000-8000-000000000022', 'e1000000-0000-4000-8000-000000000002', 'e2000000-0000-4000-8000-000000000022', 'worksheet', 'Worksheet: Surah Al-Asr Reflection Questions', 'https://example.com/seed/worksheets/al-asr.pdf', 190000, 0, now() - interval '40 days'),
  ('e3400000-0000-4000-8000-000000000032', 'e1000000-0000-4000-8000-000000000003', 'e2000000-0000-4000-8000-000000000032', 'worksheet', 'Worksheet: The Six Pillars of Iman', 'https://example.com/seed/worksheets/pillars-of-iman.pdf', 210000, 0, now() - interval '35 days'),
  ('e3400000-0000-4000-8000-000000000052', 'e1000000-0000-4000-8000-000000000005', 'e2000000-0000-4000-8000-000000000052', 'worksheet', 'Worksheet: Conditions vs Pillars of Salah', 'https://example.com/seed/worksheets/salah.pdf', 200000, 0, now() - interval '25 days')
ON CONFLICT (id) DO NOTHING;

INSERT INTO lecture_attachments (id, lecture_id, type, url, title, size_bytes, duration_seconds) VALUES
  ('e3500000-0000-4000-8000-000000000001', 'e2000000-0000-4000-8000-000000000022', 'reference', 'https://www.youtube.com/playlist?list=PLLSbPBshw4tBeAXprgSWX8g-7PWmG28n4', 'Dr. Israr Ahmed — Bayan-ul-Quran (playlist)', 0, 0),
  ('e3500000-0000-4000-8000-000000000002', 'e2000000-0000-4000-8000-000000000032', 'pdf', 'https://example.com/seed/handouts/an-nisa-4-136.pdf', 'Handout: Surah An-Nisa 4:136 — Text & Translation', 140000, 0),
  ('e3500000-0000-4000-8000-000000000003', 'e2000000-0000-4000-8000-000000000041', 'book', 'https://example.com/seed/library/the-sealed-nectar.pdf', 'The Sealed Nectar — Chapter 1', 15800000, 0),
  ('e3500000-0000-4000-8000-000000000004', 'e2000000-0000-4000-8000-000000000052', 'worksheet', 'https://example.com/seed/worksheets/salah.pdf', 'Practice Sheet: Pillars of Salah', 200000, 0),
  ('e3500000-0000-4000-8000-000000000005', 'e2000000-0000-4000-8000-000000000013', 'video', 'https://example.com/seed/videos/noon-saakin-examples.mp4', 'Worked Examples: Noon Saakin in Juz Amma', 54000000, 840)
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

INSERT INTO enrollments (id, course_id, student_id, status, progress_pct, enrolled_at, completed_at)
SELECT md5('seed-enr-' || s.course || '-' || s.student)::uuid,
       ('e1000000-0000-4000-8000-00000000000' || s.course)::uuid,
       ('e0000000-0000-4000-8000-0000000000' || s.student)::uuid,
       s.status, 0,
       c.created_at + ((s.student - 20) || ' days')::interval,
       CASE WHEN s.status = 'completed' THEN now() - interval '140 days' END
FROM seed_enroll s
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-00000000000' || s.course)::uuid
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

-- Register every active student of the exam's course (exams 1–4)
INSERT INTO exam_registrations (id, exam_id, student_id, registered_at, registered_by)
SELECT md5('seed-reg-' || ex.id || e.student_id)::uuid, ex.id, e.student_id, ex.created_at + interval '1 day',
       'e0000000-0000-4000-8000-000000000001'
FROM exams ex
JOIN enrollments e ON e.course_id = ex.course_id AND e.status = 'active'
WHERE ex.id IN ('e6000000-0000-4000-8000-000000000001', 'e6000000-0000-4000-8000-000000000002',
                'e6000000-0000-4000-8000-000000000003', 'e6000000-0000-4000-8000-000000000004')
  AND e.id IN (SELECT md5('seed-enr-' || course || '-' || student)::uuid FROM seed_enroll)
ON CONFLICT DO NOTHING;

-- Attempts for exams that have opened (1–3). Most registrants attempt; a few skip.
CREATE TEMP TABLE seed_attempts ON COMMIT DROP AS
SELECT md5('seed-attempt-' || r.exam_id || r.student_id)::uuid AS id, r.exam_id, r.student_id, ex.duration_minutes,
       ex.scheduled_start, x.h,
       CASE WHEN ex.id = 'e6000000-0000-4000-8000-000000000001' AND x.h >= 85 THEN 'in_progress'
            WHEN ex.id = 'e6000000-0000-4000-8000-000000000002' AND x.h % 2 = 0 THEN 'submitted'  -- essay awaiting grading
            ELSE 'graded' END AS status
FROM exam_registrations r
JOIN exams ex ON ex.id = r.exam_id
CROSS JOIN LATERAL (SELECT abs(hashtext('att' || r.exam_id::text || r.student_id::text)) % 100 AS h) x
WHERE r.exam_id IN ('e6000000-0000-4000-8000-000000000001', 'e6000000-0000-4000-8000-000000000002', 'e6000000-0000-4000-8000-000000000003')
  AND r.id = md5('seed-reg-' || r.exam_id || r.student_id)::uuid
  AND x.h >= 10;

INSERT INTO exam_attempts (id, exam_id, student_id, started_at, submitted_at, status, score, total_marks, time_spent_seconds, auto_evaluated)
SELECT a.id, a.exam_id, a.student_id,
       a.scheduled_start + ((a.h % 6) || ' days')::interval,
       CASE WHEN a.status <> 'in_progress' THEN a.scheduled_start + ((a.h % 6) || ' days')::interval + ((a.duration_minutes * (40 + a.h % 55) / 100) || ' minutes')::interval END,
       a.status, 0, 0,
       CASE WHEN a.status <> 'in_progress' THEN a.duration_minutes * 60 * (40 + a.h % 55) / 100 ELSE 120 END,
       a.status <> 'in_progress'
FROM seed_attempts a
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
       CASE WHEN qb.type = 'essay' AND a.status = 'graded' THEN a.scheduled_start + interval '7 days' END
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

INSERT INTO assignment_submissions (id, assignment_id, student_id, file_url, file_name, file_size_bytes, submitted_at, status, score, feedback, graded_by, graded_at)
SELECT md5('seed-sub-' || asg.id || e.student_id)::uuid, asg.id, e.student_id,
       'https://example.com/seed/submissions/' || md5('seed-sub-' || asg.id || e.student_id) || '.pdf',
       lower(replace(split_part(p.full_name, ' ', 1), '.', '')) || '_' || right(asg.id::text, 1) || '.pdf',
       150000 + x.h * 9000,
       CASE WHEN past AND x.h % 5 = 0 THEN asg.due_date + interval '2 days'
            ELSE least(now(), coalesce(asg.due_date, now()) - ((x.h % 6 + 1) || ' days')::interval) END,
       CASE WHEN past AND x.h % 5 = 0 AND x.h % 2 = 1 THEN 'late'
            WHEN past THEN 'graded' ELSE 'submitted' END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN round(asg.max_score * (60 + x.h % 39) / 100) END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1)
            THEN (ARRAY['Excellent reflection — JazakAllahu khayran.', 'Good work. Add more evidence next time.', 'Well structured and thoughtful.', 'Solid effort; revise the second section.'])[1 + x.h % 4] END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN asg.professor_id END,
       CASE WHEN past AND NOT (x.h % 5 = 0 AND x.h % 2 = 1) THEN asg.due_date + interval '4 days' END
FROM assignments asg
JOIN enrollments e ON e.course_id = asg.course_id AND e.status = 'active'
JOIN profiles p ON p.id = e.student_id
CROSS JOIN LATERAL (SELECT abs(hashtext('sub' || asg.id::text || e.student_id::text)) % 100 AS h) x
CROSS JOIN LATERAL (SELECT asg.due_date < now() AS past) y
WHERE asg.id::text LIKE 'e7000000-%' AND asg.status IN ('published', 'closed')
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

INSERT INTO live_sessions (id, course_id, instructor_id, title, description, start_at, end_at, provider, provider_meeting_id, join_url, created_at)
SELECT md5('seed-live-' || l.course || '-' || l.s)::uuid, c.id, c.professor_id, l.title,
       'Weekly live class for ' || c.title || '. Bring your questions.',
       date_trunc('minute', now() + l.start_offset), date_trunc('minute', now() + l.start_offset) + interval '1 hour',
       'free', 'lms-session-' || md5('seed-live-' || l.course || '-' || l.s)::uuid,
       'https://meet.jit.si/lms-session-' || md5('seed-live-' || l.course || '-' || l.s)::uuid,
       now() + l.start_offset - interval '7 days'
FROM seed_live l
JOIN courses c ON c.id = ('e1000000-0000-4000-8000-00000000000' || l.course)::uuid
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

-- One row per assessment: (student, fee, assessed, paid, status, due offset)
CREATE TEMP TABLE seed_fa (student int, fee int, tag text, assessed numeric, paid numeric, status text, due interval) ON COMMIT DROP;
INSERT INTO seed_fa
SELECT n, 1, 'reg', 25, 25, 'paid', (-(n * 3) || ' days')::interval FROM generate_series(21, 33) n;
INSERT INTO seed_fa
SELECT n, 2, 'tuition',
       CASE n WHEN 22 THEN 36 WHEN 25 THEN 30 ELSE 40 END,
       CASE n % 4 WHEN 0 THEN CASE n WHEN 22 THEN 36 WHEN 25 THEN 30 ELSE 40 END WHEN 1 THEN 20 ELSE 0 END,
       CASE n % 4 WHEN 0 THEN 'paid' WHEN 1 THEN 'partial' WHEN 2 THEN 'unpaid' ELSE 'overdue' END,
       CASE n % 4 WHEN 2 THEN '10 days'::interval ELSE '-10 days'::interval END
FROM generate_series(21, 31) n;
INSERT INTO seed_fa SELECT n, 3, 'exam', 10, 0, 'unpaid', '14 days' FROM unnest(ARRAY[22, 23, 25, 28, 29, 30]) n;
INSERT INTO seed_fa SELECT n, 6, 'tajweed', 60, 60, 'paid', '-40 days' FROM unnest(ARRAY[21, 22, 23, 24, 25, 26, 31]) n;
INSERT INTO seed_fa VALUES (33, 2, 'tuition', 40, 0, 'cancelled', '-10 days');  -- withdrawn student

INSERT INTO fee_assessments (id, student_id, fee_structure_id, amount_assessed, amount_paid, due_date, status, created_at)
SELECT md5('seed-fa-' || f.student || '-' || f.tag)::uuid,
       ('e0000000-0000-4000-8000-0000000000' || f.student)::uuid,
       ('e9000000-0000-4000-8000-00000000000' || f.fee)::uuid,
       f.assessed, f.paid, date_trunc('day', now() + f.due), f.status, now() + f.due - interval '20 days'
FROM seed_fa f
ON CONFLICT DO NOTHING;

INSERT INTO fee_assessments_discounts (id, assessment_id, discount_id, amount_deducted) VALUES
  (md5('seed-fad-22')::uuid, md5('seed-fa-22-tuition')::uuid, 'e9100000-0000-4000-8000-000000000001', 4),
  (md5('seed-fad-25')::uuid, md5('seed-fa-25-tuition')::uuid, 'e9100000-0000-4000-8000-000000000002', 10)
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
