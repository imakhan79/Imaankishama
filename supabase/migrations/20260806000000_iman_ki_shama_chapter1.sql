/*
# Iman Ki Shama — Chapter 1 Content Seed

Seeds the real "Iman Ki Shama" course content (Surah An-Nisa, Ayah 136) supplied
in the project's source files (see docs/content-inventory.md and
docs/content-mapping.md). Follows the same fixed-UUID / ON CONFLICT DO NOTHING
pattern as 20260803010000_demo_recorded_lectures.sql so this migration is safely
re-runnable. Reuses the existing Islamic Studies demo professor
(b9407e90-9672-4a66-a399-48a907066adb) as course owner.

Scholar/video attributions come from the project's own
`Contant Vedio lactures.pdf` (source of truth, per project decision) — NOT from
any generic template text, since the two disagree on all six scholar/URL pairs.

Quiz correct answers are not present in the source quiz-card images; both were
derived directly from the ayah text and its stated "comprehensive message"
already quoted in the Chapter 1 source document (see docs/content-mapping.md),
not invented.
*/

-- Course
INSERT INTO courses (id, title, description, category, professor_id, status, thumbnail_url)
VALUES (
  'd2000000-0000-4000-8000-000000000001',
  'Iman Ki Shama — ایمان کی شمع',
  'From Quranic Knowledge to Practical Life. A Quran-based character-building program: understand an ayah, reflect on it, discuss it, and put it into practice.',
  'Islamic Studies',
  'b9407e90-9672-4a66-a399-48a907066adb',
  'published',
  ''
)
ON CONFLICT (id) DO NOTHING;

-- Lecture (Chapter 1)
INSERT INTO lectures (id, course_id, title, description, duration_seconds, learning_objectives, publish_date, order_index)
VALUES (
  'd2000000-0000-4000-8000-000000000101',
  'd2000000-0000-4000-8000-000000000001',
  'Chapter 1 — Surah An-Nisa, Ayah 136',
  E'يَا أَيُّهَا الَّذِينَ آمَنُوا آمِنُوا بِاللَّهِ وَرَسُولِهِ وَالْكِتَابِ الَّذِي نَزَّلَ عَلَى رَسُولِهِ وَالْكِتَابِ الَّذِي أَنزَلَ مِن قَبْلُ ۚ وَمَن يَكْفُرْ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ فَقَدْ ضَلَّ ضَلَالًا بَعِيدًا (سورۃ النساء، آیت 136)\n\nO you who believe! Believe in Allah, His Messenger, the Book He revealed to His Messenger, and the Books He revealed before. Whoever disbelieves in Allah, His angels, His Books, His Messengers, and the Last Day has strayed far into error.\n\nComprehensive message: this ayah teaches that Iman is not a verbal claim alone, but a complete way of life rooted in deep conviction of the heart, correct belief, and a life of practice — and that Iman is a matter of continuous learning, understanding, and strengthening, not a one-time declaration.\n\nIncludes: self-reflection questions, a 7-Day Iman Challenge, a Daily Iman Routine chart, and Weekly Iman Goals with a self-check list (see assignment and course material for full text).',
  0,
  'Understand the meaning and scope of Iman in Surah An-Nisa 4:136; reflect on personal practice; build a daily/weekly habit of strengthening Iman.',
  now(),
  1
)
ON CONFLICT (id) DO NOTHING;

-- Scholar video resources (source: Contant Vedio lactures.pdf)
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds)
VALUES
  ('d2000000-0000-4000-8000-000000000201', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'video', 'Mufti Muhammad Shafi Usmani (رحمۃ اللہ علیہ) — Lecture', 'https://www.youtube.com/watch?v=j9dtY0_Yk7E&list=PLtbtLwUBNoYAAY0x6HD3zSi-jC8SQcF7W', 0, 0),
  ('d2000000-0000-4000-8000-000000000202', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'video', 'Mufti Taqi Usmani (حفظہ اللہ) — Lecture', 'https://www.youtube.com/watch?v=2IRBcw71eIk&list=PLJv3Hki8p7HidHKYk-sKuQZoukg-N09WH&index=2', 0, 0),
  ('d2000000-0000-4000-8000-000000000203', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'video', 'Dr. Israr Ahmed (رحمۃ اللہ علیہ) — Bayan-ul-Quran Playlist', 'https://www.youtube.com/playlist?list=PLLSbPBshw4tBeAXprgSWX8g-7PWmG28n4', 0, 0),
  ('d2000000-0000-4000-8000-000000000204', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'video', 'Maulana Abul Ala Maududi (رحمۃ اللہ علیہ) — Tafheem-ul-Quran', 'https://www.youtube.com/watch?v=x-nFMtF-_Ks&list=PL0LdCX57zS5NjSkQKXjv1zrntzvtjl2gW', 0, 0),
  ('d2000000-0000-4000-8000-000000000205', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'video', 'Ustad Shujauddin Shaikh (حفظہ اللہ) — Qurani Dars', 'https://www.youtube.com/watch?v=Mq6iAug6syQ&list=PLVr-v5WxhOGfdMjuQhMHQv-zCjFCpijfg', 0, 0),
  ('d2000000-0000-4000-8000-000000000206', 'd2000000-0000-4000-8000-000000000001', 'd2000000-0000-4000-8000-000000000101', 'note', 'Maulana Muhammad Aasif Qasmi Nanotwi — Baseerat-ul-Quran (Android app, Tafseer + Translation)', 'https://play.google.com/store/apps/details?id=com.atq.quranemajeedapp.org.bsq', 0, 0)
ON CONFLICT (id) DO NOTHING;

-- Assignment (verbatim from Assigment.pdf — 5 questions)
INSERT INTO assignments (id, course_id, professor_id, title, description, instructions, due_date, max_score, rubric, status)
VALUES (
  'd2000000-0000-4000-8000-000000000301',
  'd2000000-0000-4000-8000-000000000001',
  'b9407e90-9672-4a66-a399-48a907066adb',
  'Chapter 1 — Assignment',
  'Reflection and practice assignment for Surah An-Nisa, Ayah 136. The goal is not just to answer, but to understand Iman, reflect on it, and connect it to your practical life.',
  E'1. میرا آج کا سبق — ہم نے کیا سیکھا؟ اس Chapter سے آپ نے جو 3 اہم باتیں سیکھی ہیں، اپنے الفاظ میں لکھیں۔\n\n2. گھر پر عملی سرگرمی — عمل کرکے دکھائیں: Chapter میں دی گئی عملی مشقوں میں سے کسی ایک عمل کو گھر میں کریں اور مختصر لکھیں کہ آپ نے کیا کیا۔\n\n3. پہلے سوچیں، پھر سمجھیں، پھر جواب دیں۔ دی گئی آیت پر غور کریں اور سوچیں کہ ایک صاحبِ ایمان طالب علم کو اپنی روزمرہ زندگی کے کن مواقع اور مصروفیات میں اپنے ایمان کو تازہ کرنے اور اللہ سے اپنا تعلق مضبوط کرنے کی ضرورت پیش آتی ہے؟ اپنی زندگی سے کم از کم 3 مواقع منتخب کریں اور بتائیں کہ ان مواقع پر آپ اپنے ایمان کو کیسے تازہ کر سکتے ہیں؟\n\n4. کیا آپ جانتے ہیں؟ — اس Chapter سے متعلق ایک ایسی نئی بات لکھیں جو آپ نے پہلے نہیں جانی تھی۔\n\n5. اہلِ علم سے سیکھیں — سنیں، پڑھیں اور سمجھیں۔ اس Chapter سے متعلق فراہم کردہ علماءِ کرام کی ویڈیوز میں سے کم از کم ایک ویڈیو سنیں اور اس سے حاصل ہونے والی ایک اہم بات اپنے الفاظ میں لکھیں۔ اگر کسی عالمِ دین کی متعلقہ ویڈیو دستیاب نہ ہو تو ان کی متعلقہ تفسیر یا ترجمہ سے اسی آیت کے بارے میں مختصر مطالعہ کریں اور ایک اہم نکتہ لکھیں۔',
  NULL,
  100,
  '[]'::jsonb,
  'published'
)
ON CONFLICT (id) DO NOTHING;

-- Quiz question 1 (source: WhatsApp Image ...22.06.01.jpeg)
INSERT INTO question_bank (id, subject, course_id, difficulty, topic, marks, time_seconds, type, question_text, options, correct_answer, explanation, category, status, created_by)
VALUES (
  'd2000000-0000-4000-8000-000000000401',
  'Islamic Studies',
  'd2000000-0000-4000-8000-000000000001',
  'easy',
  'Surah An-Nisa 4:136',
  1,
  60,
  'mcq',
  'سورۃ النساء کی آیت 136 میں اہلِ ایمان کو کس بنیادی بات کی تاکید کی گئی ہے؟',
  '["صرف عبادات میں اضافہ کریں", "ایمان کو مضبوط اور پختہ کریں", "زیادہ مال حاصل کریں", "دنیاوی کامیابی حاصل کریں"]'::jsonb,
  '"ایمان کو مضبوط اور پختہ کریں"'::jsonb,
  'ماخذ: Chapter 1 دستاویز کا اپنا خلاصہ — "یہ آیت اس بات کی دعوت دیتی ہے کہ ایمان مسلسل سیکھنے، سمجھنے اور مضبوط کرنے کا نام ہے۔"',
  'Islamic Studies',
  'active',
  'b9407e90-9672-4a66-a399-48a907066adb'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO question_options (id, question_id, option_text, is_correct)
VALUES
  ('d2000000-0000-4000-8000-000000000411', 'd2000000-0000-4000-8000-000000000401', 'صرف عبادات میں اضافہ کریں', false),
  ('d2000000-0000-4000-8000-000000000412', 'd2000000-0000-4000-8000-000000000401', 'ایمان کو مضبوط اور پختہ کریں', true),
  ('d2000000-0000-4000-8000-000000000413', 'd2000000-0000-4000-8000-000000000401', 'زیادہ مال حاصل کریں', false),
  ('d2000000-0000-4000-8000-000000000414', 'd2000000-0000-4000-8000-000000000401', 'دنیاوی کامیابی حاصل کریں', false)
ON CONFLICT (id) DO NOTHING;

-- Quiz question 2 (source: WhatsApp Image ...22.06.01 (1).jpeg)
INSERT INTO question_bank (id, subject, course_id, difficulty, topic, marks, time_seconds, type, question_text, options, correct_answer, explanation, category, status, created_by)
VALUES (
  'd2000000-0000-4000-8000-000000000402',
  'Islamic Studies',
  'd2000000-0000-4000-8000-000000000001',
  'easy',
  'Surah An-Nisa 4:136',
  1,
  60,
  'mcq',
  'سورۃ النساء کی آیت 136 کے مطابق کن چیزوں پر ایمان لانا ضروری ہے؟',
  '["صرف اللہ اور رسول ﷺ پر", "صرف قرآن پر", "اللہ، رسول ﷺ، کتاب، فرشتوں، آسمانی کتابوں اور آخرت پر", "صرف آخرت پر"]'::jsonb,
  '"اللہ، رسول ﷺ، کتاب، فرشتوں، آسمانی کتابوں اور آخرت پر"'::jsonb,
  'ماخذ: آیت 136 کا متن بعینہٖ (Chapter 1 دستاویز میں نقل شدہ): اللہ، اُس کے رسول ﷺ، اُس کتاب پر جو اُس نے اپنے رسول ﷺ پر نازل فرمائی، اور اُن کتابوں پر جو اُس نے اس سے پہلے نازل فرمائیں، اور جو اللہ، اُس کے فرشتوں، اُس کی کتابوں، اُس کے رسولوں اور آخرت کے دن کا انکار کرے وہ گمراہی میں بہت دور جا پڑا۔',
  'Islamic Studies',
  'active',
  'b9407e90-9672-4a66-a399-48a907066adb'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO question_options (id, question_id, option_text, is_correct)
VALUES
  ('d2000000-0000-4000-8000-000000000421', 'd2000000-0000-4000-8000-000000000402', 'صرف اللہ اور رسول ﷺ پر', false),
  ('d2000000-0000-4000-8000-000000000422', 'd2000000-0000-4000-8000-000000000402', 'صرف قرآن پر', false),
  ('d2000000-0000-4000-8000-000000000423', 'd2000000-0000-4000-8000-000000000402', 'اللہ، رسول ﷺ، کتاب، فرشتوں، آسمانی کتابوں اور آخرت پر', true),
  ('d2000000-0000-4000-8000-000000000424', 'd2000000-0000-4000-8000-000000000402', 'صرف آخرت پر', false)
ON CONFLICT (id) DO NOTHING;
