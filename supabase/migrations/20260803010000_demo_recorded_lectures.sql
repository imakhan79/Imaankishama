/*
# Demo Recorded Lectures — Learning Hub

1. Overview
Adds a `thumbnail_url` column to `lectures` (previously missing) and seeds
7 demo published courses/lectures/video materials — one per subject
(Mathematics, English, Urdu, Arabic, Science, Computer Science, Islamic
Studies) — so the Learning Hub → Recorded Lectures tab has realistic
demo content with real embeddable YouTube videos.

2. Changes
- `lectures.thumbnail_url` text column added (default '').
- 4 new published courses created for subjects with no existing course
  (English, Urdu, Arabic, Islamic Studies). Existing Mathematics,
  Science and Computer Science courses are reused.
- 7 lectures inserted (one per subject) with realistic titles,
  descriptions, durations (15-45 min) and thumbnails.
- 7 `course_materials` rows (type='video') linking each lecture to a
  public, embeddable YouTube video URL.

3. Notes
- All ids are fixed literals so this migration is safely re-runnable
  (ON CONFLICT DO NOTHING).
*/

ALTER TABLE lectures ADD COLUMN IF NOT EXISTS thumbnail_url text NOT NULL DEFAULT '';

-- New demo courses for subjects without an existing course
INSERT INTO courses (id, title, description, category, professor_id, status, thumbnail_url)
VALUES
  ('a1000000-0000-4000-8000-000000000001', 'English Language & Literature', 'Grammar, composition and literary analysis for confident written and spoken English.', 'English', '12c6f4d6-b1fd-48e7-9833-f090fbde0883', 'published', ''),
  ('a1000000-0000-4000-8000-000000000002', 'Urdu Language Fundamentals', 'Reading, writing and conversational fundamentals of the Urdu language.', 'Urdu', '260d07d3-7ea6-43b0-9eeb-2efbb6582ff1', 'published', ''),
  ('a1000000-0000-4000-8000-000000000003', 'Arabic Language Fundamentals', 'Arabic alphabet, pronunciation and foundational grammar for new learners.', 'Arabic', '74c0ff61-4e64-40fb-b93f-e7de9aefc622', 'published', ''),
  ('a1000000-0000-4000-8000-000000000004', 'Islamic Studies Foundations', 'Core Islamic beliefs, Seerah and character-building teachings.', 'Islamic Studies', '7b99c116-906b-4773-ad68-f3e311cad3de', 'published', '')
ON CONFLICT (id) DO NOTHING;

-- Demo lectures (one per subject)
INSERT INTO lectures (id, course_id, title, description, duration_seconds, learning_objectives, publish_date, order_index, thumbnail_url)
VALUES
  ('b1000000-0000-4000-8000-000000000001', 'dac2189a-b2e7-4917-8696-60dcfa33b0fa', 'The Beauty of Algebra', 'An engaging walkthrough of core algebraic concepts, from variables to equations, with worked examples.', 1920, 'Understand variables, expressions and the structure of algebraic equations.', now() - interval '6 days', 1, 'https://img.youtube.com/vi/kpCJyQ2usJ4/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000002', 'a1000000-0000-4000-8000-000000000001', 'Comma Story: Mastering Punctuation', 'A concise lesson on comma usage in complex sentences, part of the English writing fundamentals series.', 1080, 'Correctly use commas to join clauses and separate items in a list.', now() - interval '5 days', 1, 'https://img.youtube.com/vi/GHnl1O3NGJk/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000003', 'a1000000-0000-4000-8000-000000000002', 'Urdu for Beginners: Alphabet & Basics', 'Introduction to Urdu script, pronunciation and everyday vocabulary for new learners.', 1500, 'Recognize Urdu letters and form basic words and greetings.', now() - interval '4 days', 1, 'https://img.youtube.com/vi/7za6l8ycsBo/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000004', 'a1000000-0000-4000-8000-000000000003', 'Arabic Alphabet: Listen, Repeat & Write', 'A guided introduction to the Arabic alphabet covering pronunciation and letter forms.', 1320, 'Read and write the Arabic alphabet with correct pronunciation.', now() - interval '3 days', 1, 'https://img.youtube.com/vi/bJ1MAanBZJE/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000005', '37560e9e-a50d-468c-8075-b2cfd12ae8cf', 'Introduction to the Cell', 'An overview of cell structure and function, the basic unit of life, for high school biology.', 2400, 'Describe the main components of a cell and their functions.', now() - interval '2 days', 1, 'https://img.youtube.com/vi/5KfHxF6Vhps/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000006', '0be5d299-59b5-4eaa-8c8f-7bd854dc7d80', 'Programming Fundamentals: Getting Started', 'A beginner-friendly introduction to programming logic, variables and control flow.', 2700, 'Write and reason about simple programs using variables, conditionals and loops.', now() - interval '1 day', 1, 'https://img.youtube.com/vi/rfscVS0vtbw/hqdefault.jpg'),
  ('b1000000-0000-4000-8000-000000000007', 'a1000000-0000-4000-8000-000000000004', 'Introduction to the Seerah of Prophet Muhammad (PBUH)', 'A foundational lecture on the life and character of the Prophet Muhammad (PBUH).', 2100, 'Outline the key events and lessons from the early Seerah.', now(), 1, 'https://img.youtube.com/vi/leWJExocCsQ/hqdefault.jpg')
ON CONFLICT (id) DO NOTHING;

-- Demo video materials (Recording Available)
INSERT INTO course_materials (id, course_id, lecture_id, type, title, url, size_bytes, duration_seconds)
VALUES
  ('c1000000-0000-4000-8000-000000000001', 'dac2189a-b2e7-4917-8696-60dcfa33b0fa', 'b1000000-0000-4000-8000-000000000001', 'video', 'The Beauty of Algebra — Recording', 'https://www.youtube.com/watch?v=kpCJyQ2usJ4', 0, 1920),
  ('c1000000-0000-4000-8000-000000000002', 'a1000000-0000-4000-8000-000000000001', 'b1000000-0000-4000-8000-000000000002', 'video', 'Comma Story — Recording', 'https://www.youtube.com/watch?v=GHnl1O3NGJk', 0, 1080),
  ('c1000000-0000-4000-8000-000000000003', 'a1000000-0000-4000-8000-000000000002', 'b1000000-0000-4000-8000-000000000003', 'video', 'Urdu for Beginners — Recording', 'https://www.youtube.com/watch?v=7za6l8ycsBo', 0, 1500),
  ('c1000000-0000-4000-8000-000000000004', 'a1000000-0000-4000-8000-000000000003', 'b1000000-0000-4000-8000-000000000004', 'video', 'Arabic Alphabet — Recording', 'https://www.youtube.com/watch?v=bJ1MAanBZJE', 0, 1320),
  ('c1000000-0000-4000-8000-000000000005', '37560e9e-a50d-468c-8075-b2cfd12ae8cf', 'b1000000-0000-4000-8000-000000000005', 'video', 'Introduction to the Cell — Recording', 'https://www.youtube.com/watch?v=5KfHxF6Vhps', 0, 2400),
  ('c1000000-0000-4000-8000-000000000006', '0be5d299-59b5-4eaa-8c8f-7bd854dc7d80', 'b1000000-0000-4000-8000-000000000006', 'video', 'Programming Fundamentals — Recording', 'https://www.youtube.com/watch?v=rfscVS0vtbw', 0, 2700),
  ('c1000000-0000-4000-8000-000000000007', 'a1000000-0000-4000-8000-000000000004', 'b1000000-0000-4000-8000-000000000007', 'video', 'Introduction to the Seerah — Recording', 'https://www.youtube.com/watch?v=leWJExocCsQ', 0, 2100)
ON CONFLICT (id) DO NOTHING;
