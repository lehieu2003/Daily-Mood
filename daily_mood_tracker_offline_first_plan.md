# 📋 Plan: "Daily Mood: Tracker & Diary" (Offline-First, MVP-Focused)

**Version:** 1.1 (Updated — see changelog at bottom)

---

## 1. Core Architecture Strategy

- **Privacy Model:** Zero-Knowledge local storage — data is **encrypted at rest**, not just protected by a PIN/biometric screen lock.
- **Data Layer:** Reactive local streaming using **Drift (SQLite)**, encrypted via **SQLCipher** (the `sqlcipher_flutter_libs` + `drift_sqlcipher` packages or equivalent).
- **Cloud Synchronization:** Not included in the MVP. The initial phase only supports manual file export/import (JSON/CSV), which users save themselves to Drive/iCloud via the system share sheet. Automatic cloud sync will be **Phase 5 (expansion)**.

---

## 2. Project Architecture (Feature-First)

```text
lib/
├── app/
│   ├── theme/          # Soft palettes (Pastels), system dark-mode adaptations
│   └── routes/         # GoRouter configurations (Includes Guard for LockScreen)
├── core/
│   ├── database/       # AppDatabase (Drift + SQLCipher), migrations, seed data
│   ├── security/       # Biometrics auth, encryption key management (Keystore/Keychain)
│   └── utils/          # Backup/Restore file handlers, conflict resolution, date extensions
└── features/
    ├── mood_tracker/   # Entry creation, activity tags management, calendar roll
    ├── analytics/      # Local SQL execution calculations for mood charts
    └── settings/       # PIN Setup, export/import JSON, backup history
```

---

## 3. Phased Implementation Roadmap (6 Weeks)

### 🏗️ Phase 1: Local Foundation, Encryption & Reactive DB Setup (Week 1–2)

- **Database Engineering:** Initialize `AppDatabase` using Drift, integrating **SQLCipher** to encrypt the entire `.db` file from the very start (not added later).
- **Key Management:** Store the encryption key in Android Keystore / iOS Keychain — never hardcoded, never stored as plaintext.
- **Schema:** Write an explicit schema covering all 5 tables defined in the Data Model doc: `MoodEntries`, `Activities`, the `MoodEntryActivities` junction table, `MoodPhotos`, and `SubEmotions` / `MoodEntrySubEmotions`. _(Updated in this revision — previously this bullet only listed 3 of the 5 tables.)_
- **UUID Support:** Add a `uuid TEXT UNIQUE` column to both `MoodEntries` and `Activities` from the start, per Data Model §2.1/§2.2 — this is required for import/restore conflict resolution in Phase 4 and is far more costly to retrofit once real user data exists. _(New task in this revision.)_
- **Data Seeding:** Automatically add the default activity tags — `Work`, `Exercise`, `Social`, `Sleep`, `Nutrition`, `Family`, `Hobbies` — in the `beforeOpen` lifecycle hook. _(Updated in this revision — previously only listed 4 of the 7 tags defined in the Data Model doc.)_
- **Theme & Design Tokens:** A soft, easy-on-the-eyes pastel color palette, mapping 5 accent colors to the 5 mood levels, with light/dark mode support.
- **QA checkpoint:** Test the encrypted DB on both platforms, ensuring the migration path works correctly when the schema changes.

### 📝 Phase 2: Frictionless Logging & State Logic (Week 3)

- **Local State Isolation:** `MoodFormCubit` handles temporary state (mood score, selected tags, journal content) before writing to the DB.
- **10-Second Log Screen:** A carousel/slider for quickly selecting one of the 5 mood levels, a multi-select grid for activity tags, and a separate text block for private journal notes.
- **Main Dashboard:** History list driven by a Drift stream, updating the UI immediately when a new log is created.
- **QA checkpoint:** Test the entry-logging flow on a real device, checking performance when the database contains a large number of records (e.g., 1000+ entries).

### 📊 Phase 3: Offline Insights & Analytics (Week 4)

- **Local Metric Calculations:** Optimized SQL queries in the DAO to calculate weekly mood averages and correlations between activity tags and mood.
- **Visualization Layer:** Use `fl_chart` for the mood trend line chart (using the mood-level color palette — see UI/UX Spec §1) and a pie chart for habit distribution (using the generic Chart Colors from the Style Guide §1.2).
- **Calendar Heatmap:** Integrate `table_calendar` to display a color-coded monthly grid.
- **QA checkpoint:** Verify the accuracy of statistical calculations with edge-case data (days with no log, ties in mood scores).

### 🔒 Phase 4: Biometric Lock & Manual Backup/Restore (Week 5)

- **Hardware Security Guard:** Lock the app using `local_auth` (FaceID/Fingerprint) or an internal PIN.
- **JSON/CSV Export Engine:** Use `path_provider` + the system share sheet so users can export a file themselves and save it to Drive/iCloud/local storage as they choose.
- **Import & Conflict Resolution:** During restore, compare the `updatedAt` timestamp of each entry using the `uuid` column added in Phase 1:
  - If the entry doesn't exist yet → add it as new.
  - If the entry already exists and the imported file's version is newer → overwrite.
  - If the imported file's version is older → keep the current record, and log the skipped entries for the user to review.
  - Always create an automatic backup before performing an import, so it can be rolled back if the restore goes wrong.
- **QA checkpoint:** Thoroughly test conflict scenarios (importing an old file, importing duplicates, importing a corrupted file).

### ☁️ Phase 5 (Expansion — post-MVP): Automatic Cloud Sync

- **Android:** Integrate `googleapis` to sync to `drive.appdata`.
- **iOS:** Map the local folder to iCloud Documents so the OS handles backup automatically.
- Only implement this after the MVP has been tried by real users and feedback has stabilized.

---

## 4. Immediate Tasks to Get Started

1. **Drift + SQLCipher Database Implementation:** Write the encrypted database structure (all 5 tables, including `uuid` columns), entity models, and default seed data (7 tags).
2. **Home Dashboard & Slider UI Setup:** Write the UI structure for the log-entry slider screen and the main interactive components.

---

## Summary of Changes from the Original Version

| Issue                   | Original Version          | Revised Version                                      |
| ----------------------- | ------------------------- | ---------------------------------------------------- |
| Data encryption         | None, only a screen lock  | Added SQLCipher, making it truly zero-knowledge      |
| Timeline                | 4 weeks                   | 6 weeks, with QA buffer                              |
| Conflict during restore | Not addressed             | Timestamp-based strategy + auto-backup before import |
| Cloud sync              | Included in MVP (Phase 4) | Pushed to Phase 5; MVP only has manual export/import |
| Testing                 | None                      | Added a QA checkpoint at the end of each phase       |

## Changelog (this revision, v1.1)

| Change                                                               | Reason                                                                                                 |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Phase 1 schema task expanded to all 5 tables                         | Was only listing 3 of the 5 tables defined in the Data Model doc (missing `MoodPhotos`, `SubEmotions`) |
| Added explicit `uuid` column task to Phase 1                         | Data Model doc recommended this "from Phase 1" but the Plan never had a matching task                  |
| Seed tag list expanded from 4 to 7 tags                              | Didn't match the 7 default tags actually defined in the Data Model doc                                 |
| Phase 3 visualization bullet clarified which palette each chart uses | Previously ambiguous whether trend chart and pie chart shared the same color source                    |
