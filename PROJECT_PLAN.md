# Daily Mood Project Plan

This is the live implementation tracker for Daily Mood: Tracker & Diary. Update it whenever a task starts, is blocked, enters review, or is completed.

## Status Legend

| Status | Meaning |
| --- | --- |
| Not Started | No implementation work has begun. |
| In Progress | Work has started but is not ready for verification. |
| Review | Implementation is ready, but tests/manual checks are still needed. |
| Blocked | Work cannot continue without a product, design, legal, or technical decision. |
| Done | Implementation is complete and verified. |
| Deferred | Intentionally postponed beyond the MVP. |

## Current Snapshot

| Field | Value |
| --- | --- |
| Overall MVP status | JSON/CSV export complete |
| Current active phase | Phase 6 - Backup, Export, Import |
| Last updated | 2026-07-13 |
| Latest verification | P6.1 user-reported format, targeted export/settings tests, and `flutter analyze` passed |
| Main next task | P6.2 - Import parser |
| Known blockers | Real privacy-policy effective date/contact; final chart green; Gradient 1 confirmation; WCAG contrast pass |

## Update Rules

- Set a task to `In Progress` before starting meaningful implementation.
- Set a task to `Review` when implementation is complete but not verified.
- Set a task to `Done` only after the acceptance check passes.
- For this project, after implementation reaches `Review`, the user manually runs the relevant Flutter verification commands, including `flutter test` and `flutter analyze`, then reports the results. Record those user-reported results in the Verification Log before moving the task to `Done`.
- When formatting is needed, provide the exact Flutter/Dart format command for the user to run manually instead of running it directly.
- Do not put all logic and UI in one large file. Split feature code into maintainable files by responsibility, such as screen, state, models/data definitions, reusable widgets, and persistence logic.
- Add blockers in the task notes and in the Current Snapshot if they affect the next task.
- Every completed implementation task must update this file in the same change.
- Keep this tracker aligned with the PRD, data model, UI/UX spec, style guide, and privacy policy.

## Phase 0 - Documentation & Planning

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P0.1 | Review project Markdown docs | Done | Product/design docs | Main docs reviewed for consistency | Completed before tracker creation. |
| P0.2 | Replace generated Flutter README | Done | App README | README explains app purpose, setup, docs map, and current status | Typo cleanup tracked separately. |
| P0.3 | Create live project tracker | Done | Project plan | Tracker has phases, statuses, update rules, and verification log | This file is the source for implementation progress. |
| P0.4 | Fill privacy publication details | Blocked | Privacy policy | Effective date and support contact are real, not placeholders | Requires owner/legal/product input. |
| P0.5 | Confirm unresolved design tokens | Blocked | Style guide, theme tokens | Chart green, Gradient 1, and contrast checks are confirmed | Requires design confirmation. |

## Phase 1 - Local Foundation, Encryption, Database

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P1.1 | Flutter app shell and routing | Done | App shell, routes | App boots through configured router | Home and quick-log are still placeholders. |
| P1.2 | Theme and design tokens | Done | Theme layer | Tokens align with style guide v1.1 and analyzer has no opacity deprecations | Final design confirmations still blocked in P0.5. |
| P1.3 | Drift database setup | Done | Database layer | App database opens and generated Drift code matches tables | Verified by database tests after schema generation. |
| P1.4 | SQLCipher encrypted connection | In Progress | Database/security layer | Encrypted DB opens using secure key storage on target platforms | Needs device/platform verification. |
| P1.5 | Default activity seed data | Done | Database seed logic | Seven default activities are seeded on first create | Existing test covers count. |
| P1.6 | Complete target schema | Done | Database tables | Schema includes voice note path, sub-emotions, and entry-sub-emotion junction | Added schema version 2 with `voiceNotePath`, `SubEmotions`, and `MoodEntrySubEmotions`; tests/analyze pass. |
| P1.7 | Migration strategy and tests | Done | Database migrations/tests | Migration tests preserve sample data across schema versions | Schema version 1 to 2 upgrade coverage passes. |

## Phase 2 - Mood Logging Flow

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P2.1 | Mood form state model | Done | Mood tracker feature | Form can hold mood score, sub-emotions, tags, note, photo path, and voice path | Added `MoodFormState`, `MoodFormCubit`, and focused cubit tests. |
| P2.2 | Quick-log screen UI | Done | Mood tracker feature | User can enter the quick-log flow from app routes | Redesigned as a 4-step flow matching the provided mockup, uses bundled `assets/emojis`, split files, and idempotent default reason seeding. |
| P2.3 | Mood entry persistence | Done | Mood DAO/form logic | Saving creates a mood entry and selected tag links | Quick-log Save persists mood score, note, selected reasons, selected sub-emotions, and voice path through `MoodEntryDao`; user-reported format, targeted tests, and analyze passed. |
| P2.4 | Custom activity tag flow | Done | Mood tracker/database | User can add a valid custom tag with 20-character max and category | Reasons step can create custom `Other` reasons through `ActivityDao`, selects the new reason after creation, and DAO tests cover validation plus the 30 custom tag limit. |
| P2.5 | Photo and voice attachment flow | Done | Mood tracker/media storage | Relative photo paths are stored and voice input can generate note text | Photos are copied into app document storage; Add voice uses speech-to-text and appends recognized text into the note instead of storing an audio file; user-reported format, targeted tests, and analyze passed. |

## Phase 3 - Dashboard & History

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P3.1 | Replace home placeholder | Done | Dashboard feature | Home shows real dashboard instead of lock-only placeholder | Added `DashboardScreen`, wired Home tab to recent mood entries, split dashboard UI/helpers into focused files, and restyled the dashboard toward the supplied reference UI. User-reported verification passed. |
| P3.2 | History stream | Done | Dashboard/database | Entries render from a Drift stream and update after save/delete | Added `HistoryScreen` backed by the existing non-deleted mood entry stream, grouped entries by day, and replaced the History tab placeholder. User-reported verification passed. |
| P3.3 | Weekly trend entry point | Done | Dashboard/analytics | Trend section hides until at least 3 entries exist | Added a dashboard weekly-trend entry card that appears only after 3 entries and opens the Stats tab. Chart implementation remains Phase 4. User-reported verification passed. |
| P3.4 | Entry detail/edit/delete | Done | Dashboard/mood tracker | User can view, edit, soft-delete, and restore if supported | Added shared entry detail sheet for dashboard/history, repository update/delete actions, and widget tests. Restore is deferred because deleted entries are not exposed in the current app surface; hard-delete cleanup policy still open. User-reported verification passed. |

## Phase 4 - Offline Insights & Analytics

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P4.1 | Weekly mood trend query | Done | Analytics/database | Query handles days with no entries and produces expected averages | Added analytics model, local service, repository provider, and focused test for sparse weekly averages. User-reported verification passed. |
| P4.2 | Weekly trend chart | Done | Analytics UI | Chart renders non-empty data correctly and hides invalid states | Replaced Stats placeholder with analytics screen, added weekly trend chart using mood-level colors, hides chart until at least 3 weekly entries exist, pinned compatible `fl_chart`, and added widget tests. User-reported verification passed. |
| P4.3 | Monthly calendar heatmap | Done | Analytics UI | Calendar displays month mood intensity with correct colors | Added monthly heatmap data points, calendar UI using mood-level colors plus numeric mood values, empty state, and focused tests. User-reported verification passed. |
| P4.4 | Activity correlation chart | Done | Analytics/database/UI | Activity-mood relationship is calculated locally and rendered | Added local activity-mood aggregation, generic-palette horizontal bar chart with labels/values, empty state, and focused tests. User-reported verification passed. |
| P4.5 | Analytics edge-case tests | Done | Tests | Covers empty data, sparse days, ties, and large local histories | Added focused analytics repository coverage for empty data, sparse datasets, tied activity ordering, activity limit handling, and large local histories. User-reported verification passed. |

## Phase 5 - App Lock, Settings, Data Control

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P5.1 | PIN setup flow | In Progress | Settings/security | User can set and verify a PIN | Foundation exists; needs full manual/device checks. |
| P5.2 | Lock screen flow | In Progress | Settings/security/routes | Locked routes redirect correctly and unlock returns to app | Foundation exists. |
| P5.3 | Biometric lifecycle behavior | In Progress | Security/app lifecycle | Biometric prompt respects foreground cooldown and avoids prompt spam | Needs platform testing. |
| P5.4 | Settings screen | Done | Settings feature | User can access lock, export/import, delete data, and haptics settings | Added real settings dashboard, haptics preference persistence, lock-now action, visible export/import/delete entry points, and widget tests. User-reported verification passed. |
| P5.5 | Delete all data | Done | Settings/security/database | User can permanently remove local data and reset encryption material intentionally | Added explicit DELETE confirmation, local database reset with default reseed, mood media cleanup, SQLCipher key rotation, and focused tests. User-reported verification passed. |

## Phase 6 - Backup, Export, Import

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P6.1 | JSON/CSV export | Done | Backup/restore utilities | User can export readable data through system share sheet | Added JSON/CSV export builder, settings format picker, share-sheet integration, and focused tests. Media files are exported as relative path references until the packaging decision is resolved. User-reported format, targeted tests, and analyze passed. |
| P6.2 | Import parser | Not Started | Backup/restore utilities | Valid backup imports without data loss | Must reject corrupted files safely. |
| P6.3 | UUID/timestamp conflict strategy | Not Started | Backup/restore/database | Newer imported records overwrite, older records are skipped and reported | Matches data model. |
| P6.4 | Automatic pre-import backup | Not Started | Backup/restore utilities | Import creates rollback snapshot before changing data | Keep latest 3 snapshots. |
| P6.5 | Backup/restore tests | Not Started | Tests | Covers duplicates, old files, corrupted files, media references, and rollback | Critical for release. |

## Phase 7 - Polish, QA, Store Readiness

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P7.1 | Static analysis | Done | Flutter app | `flutter analyze` passes | User reported no issues after opacity cleanup. |
| P7.2 | Automated tests | Done | Tests | `flutter test` passes after latest edits | Passed on 2026-07-09. |
| P7.3 | Accessibility and contrast pass | Not Started | UI/theme | Text/background pairs meet WCAG target from UI spec | Especially text tertiary and mood chips. |
| P7.4 | App icon and launch screen branding | Not Started | Platform assets | App has production icon and launch screen assets | Current iOS launch README is default boilerplate. |
| P7.5 | Store privacy readiness | Blocked | Privacy/store metadata | Privacy policy, App Store labels, and Google Play Data Safety are complete | Requires owner/legal/product input. |

## Phase 8 - Post-MVP Expansion

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P8.1 | Automatic cloud sync | Deferred | Sync/storage | User can opt in to platform-backed sync without violating privacy policy | Not MVP. |
| P8.2 | Home screen widget | Deferred | Platform widgets | Widget shows useful local-only mood entry affordance | Not MVP. |
| P8.3 | Additional languages | Deferred | Localization | Languages beyond Vietnamese and English are supported | Not MVP. |
| P8.4 | Smart reminders | Deferred | Notifications | Local reminders work without behavioral tracking | Not MVP. |

## Verification Log

| Date | Check | Result | Notes |
| --- | --- | --- | --- |
| 2026-07-09 | `flutter analyze` | Passed | Reported by user after deprecation cleanup. |
| 2026-07-09 | `rg -n "withOpacity" lib` | Passed | No remaining matches under app `lib`. |
| 2026-07-09 | `dart format lib test` | Passed | Reported by user, 0 files changed. |
| 2026-07-09 | `flutter test` | Passed | Reported by user, all tests passed. |
| 2026-07-09 | `flutter analyze` | Passed | Reported by user, no issues found. |
| 2026-07-09 | `dart format lib test` | Passed | Reported by user after P1.7; formatted 3 files. |
| 2026-07-09 | `flutter test` | Passed | Reported by user after P1.7; 3 tests passed. |
| 2026-07-09 | `flutter analyze` | Passed | Reported by user after P1.7; no issues found. |
| 2026-07-09 | Main shell color-token cleanup | Passed | Reported by user after stale `_HomePlaceholder` removal; `flutter analyze` found no issues. |
| 2026-07-09 | `flutter test test/features/mood_tracker/cubit/mood_form_cubit_test.dart` | Passed | Reported by user after P2.1; 12 tests passed. |
| 2026-07-10 | `flutter test` | Passed | Reported by user after P2.2; all tests passed. |
| 2026-07-10 | `flutter analyze` | Passed | Reported by user after P2.2; no issues found. |
| 2026-07-10 | `dart format lib test` | Passed | Reported by user after P2.3; all relevant files formatted. |
| 2026-07-10 | `flutter test test/core/database/app_database_test.dart test/core/database/daos/mood_entry_dao_test.dart test/features/mood_tracker/quick_log/quick_log_screen_test.dart` | Passed | Reported by user after P2.3 persistence and sub-emotion seeding fixes. |
| 2026-07-10 | `flutter analyze` | Passed | Reported by user after P2.3; no issues found. |
| 2026-07-10 | `flutter pub get` | Passed | Reported by user after adding speech-to-text support for P2.5. |
| 2026-07-10 | `dart format lib test` | Passed | Reported by user after P2.5 photo and speech-to-text note flow. |
| 2026-07-10 | `flutter test test/features/mood_tracker/quick_log/quick_log_screen_test.dart test/core/database/daos/mood_entry_dao_test.dart test/features/mood_tracker/cubit/mood_form_cubit_test.dart` | Passed | Reported by user after P2.5. |
| 2026-07-10 | `flutter analyze` | Passed | Reported by user after P2.5 deprecation cleanup; no issues found. |
| 2026-07-10 | `dart format lib\features\dashboard test\features\dashboard\dashboard_screen_test.dart` | Passed | Reported by user after P3.1 dashboard restyle. |
| 2026-07-10 | `flutter test test\features\dashboard\dashboard_screen_test.dart` | Passed | Reported by user after P3.1 dashboard overflow fixes. |
| 2026-07-10 | `flutter test` | Passed | Reported by user after P3.1. |
| 2026-07-10 | `flutter analyze` | Passed | Reported by user after P3.1. |
| 2026-07-11 | `dart format lib\features\dashboard lib\features\shell\main_shell.dart test\features\dashboard` | Passed | Reported by user after P3.2 history stream. |
| 2026-07-11 | `flutter test test\features\dashboard\history_screen_test.dart test\features\dashboard\dashboard_screen_test.dart` | Passed | Reported by user after P3.2. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P3.2. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P3.2. |
| 2026-07-11 | `dart format lib\features\dashboard lib\features\shell\main_shell.dart test\features\dashboard` | Passed | Reported by user after P3.3 weekly trend entry point. |
| 2026-07-11 | `flutter test test\features\dashboard\dashboard_screen_test.dart` | Passed | Reported by user after P3.3. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P3.3. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P3.3. |
| 2026-07-11 | `dart format lib\features\dashboard lib\data test\features\dashboard` | Passed | Reported by user after P3.4 entry detail/edit/delete. |
| 2026-07-11 | `flutter test test\features\dashboard\dashboard_screen_test.dart test\features\dashboard\history_screen_test.dart` | Passed | Reported by user after P3.4. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P3.4. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P3.4. |
| 2026-07-11 | `dart format lib\app.dart lib\data lib\domain test\data` | Passed | Reported by user after P4.1 weekly mood trend query. |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart` | Passed | Reported by user after P4.1 import conflict fix. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P4.1. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P4.1. |
| 2026-07-11 | `flutter pub get` | Passed | Reported by user after pinning compatible `fl_chart` for P4.2. |
| 2026-07-11 | `dart format lib\features\analytics lib\features\shell\main_shell.dart test\features\analytics` | Passed | Reported by user after P4.2 weekly trend chart. |
| 2026-07-11 | `flutter test test\features\analytics\stats_screen_test.dart` | Passed | Reported by user after P4.2. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P4.2. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P4.2. |
| 2026-07-11 | `dart format lib\data lib\domain lib\features\analytics test\data test\features\analytics` | Passed | Reported by user after P4.3 monthly calendar heatmap. |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart test\features\analytics\stats_screen_test.dart` | Passed | Reported by user after P4.3. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P4.3. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P4.3. |
| 2026-07-11 | `dart format lib\core\database\daos lib\data lib\domain lib\features\analytics test\data test\features\analytics` | Passed | Reported by user after P4.4 activity correlation chart. |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart test\features\analytics\stats_screen_test.dart` | Passed | Reported by user after P4.4. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P4.4. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P4.4. |
| 2026-07-11 | `dart format test\data\repositories\mood_analytics_repository_test.dart` | Passed | Reported by user after P4.5 analytics edge-case tests. |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart` | Passed | Reported by user after P4.5. |
| 2026-07-11 | `flutter test` | Passed | Reported by user after P4.5. |
| 2026-07-11 | `flutter analyze` | Passed | Reported by user after P4.5. |
| 2026-07-12 | `dart format lib\features\settings lib\features\shell\main_shell.dart test\features\settings` | Passed | Reported by user after P5.4 settings screen. |
| 2026-07-12 | `flutter test test\features\settings\settings_screen_test.dart` | Passed | Reported by user after P5.4. |
| 2026-07-12 | `flutter test` | Passed | Reported by user after P5.4. |
| 2026-07-12 | `flutter analyze` | Passed | Reported by user after P5.4. |
| 2026-07-12 | `dart format lib\core\database\app_database.dart lib\core\security\db_key_manager.dart lib\features\settings test\features\settings` | Passed | Reported by user after P5.5 delete all data. |
| 2026-07-12 | `flutter test test\features\settings\settings_screen_test.dart test\features\settings\local_data_reset_service_test.dart` | Passed | Reported by user after P5.5. |
| 2026-07-12 | `flutter test` | Passed | Reported by user after P5.5. |
| 2026-07-12 | `flutter analyze` | Passed | Reported by user after P5.5. |
| 2026-07-13 | `dart format lib\features\settings test\features\settings` | Passed | Reported by user after P6.1 JSON/CSV export. |
| 2026-07-13 | `flutter test test\features\settings\backup_export_service_test.dart test\features\settings\settings_screen_test.dart` | Passed | Reported by user after P6.1. |
| 2026-07-13 | `flutter analyze` | Passed | Reported by user after P6.1. |

## Reference Docs

- `prd_daily_mood_tracker.md` - product goals, MVP scope, and open product questions.
- `daily_mood_tracker_offline_first_plan.md` - original phased implementation roadmap.
- `data_model.md` - target local schema and import/restore rules.
- `Daily_mood_tracker_uiux_spec.md` - screen behavior and UX constraints.
- `style_guide.md` - design tokens and unresolved design confirmations.
- `privacy_policy.md` - local-only privacy policy draft.
