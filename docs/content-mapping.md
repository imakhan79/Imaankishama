# Content Mapping — Iman Ki Shama Chapter 1

Maps each supplied file to where it lives in the existing LMS schema (`courses` →
`lectures` → `course_materials` / `assignments` / `question_bank` + `question_options`).
No new tables were added — the existing schema already covers every content type here.

```
Course: "Iman Ki Shama" (category: Islamic Studies)
  └─ Lecture: "Chapter 1 — Surah An-Nisa, Ayah 136"      [from F04 Chapter 1.pdf]
       ├─ course_materials (type=video, 5 rows)           [from F08, scholar = source of truth]
       │    Mufti Shafi Usmani   → youtube.com/watch?v=j9dtY0_Yk7E&list=PLtbtLwUBNoYAAY0x6HD3zSi-jC8SQcF7W
       │    Mufti Taqi Usmani    → youtube.com/watch?v=2IRBcw71eIk&list=PLJv3Hki8p7HidHKYk-sKuQZoukg-N09WH
       │    Dr. Israr Ahmed      → youtube.com/playlist?list=PLLSbPBshw4tBeAXprgSWX8g-7PWmG28n4
       │    Maulana Maududi      → youtube.com/watch?v=x-nFMtF-_Ks&list=PL0LdCX57zS5NjSkQKXjv1zrntzvtjl2gW
       │    Shujauddin Shaikh    → youtube.com/watch?v=Mq6iAug6syQ&list=PLVr-v5WxhOGfdMjuQhMHQv-zCjFCpijfg
       ├─ course_materials (type=note, 1 row)
       │    Maulana Aasif Qasmi  → Baseerat-ul-Quran Android app (Play Store) — not a video
       ├─ assignments (1 row)                             [from F05 Assigment.pdf — 5 questions verbatim]
       └─ question_bank + question_options (2 rows)        [from F06 + F07 quiz cards]
Orientation reference: F02 (Introduction presentation), F03 (editorial credits) → docs only, not app content
Marketing asset: F01 (hero mockup) → not imported as course content
```

## Design decisions

- **One lecture per chapter.** The schema has no separate "module" table; `courses → lectures` is the
  existing hierarchy, so each future chapter becomes one more `lectures` row under the `Iman Ki Shama` course,
  in `order_index` sequence. This mirrors how the existing demo content (`20260803010000_demo_recorded_lectures.sql`)
  is structured — no schema change needed.
- **Scholar attribution uses F08, not the master prompt.** Per your decision, all 6 scholar↔link pairs come
  from `Contant Vedio lactures.pdf`, which contradicts the master prompt's sections 12–17 in every case.
- **Quiz answer keys were not given in the source images** — F06/F07 show 4 options each with no marked
  correct answer. The correct option for both was derived directly from the ayah text and its stated
  "comprehensive message" (جامع پیغام) already quoted in F04 `Chapter 1.pdf`, not invented:
  - Q1 → **B** ("Strengthen and mature Iman") — matches F04's own gloss: "ایمان مسلسل سیکھنے، سمجھنے اور
    مضبوط کرنے کا نام ہے".
  - Q2 → **C** ("Allah, the Messenger, the Book, the angels, the heavenly Books, and the Last Day") — matches
    the ayah's text as quoted verbatim in F04.
- **Assignment has no due date, marks, or rubric in the source** — per the master prompt's own anti-fabrication
  rule (section 88), these were left at the schema's structural defaults (`due_date = NULL`, `max_score = 100`
  system default) rather than invented as if extracted from the document. This should be set by whoever
  schedules the course in a real term.
- **F01 (hero mockup) and F02/F03 (intro + credits PDFs)** are program-identity/documentation assets, not
  student-facing course content — they went into `docs/` context only, not into the database.
