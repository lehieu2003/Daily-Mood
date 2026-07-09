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
| Overall MVP status | Foundation in progress |
| Current active phase | Phase 1 - Local Foundation, Encryption, Database |
| Last updated | 2026-07-09 |
| Latest verification | `dart format lib test`, `flutter test`, and `flutter analyze` passed after P1.7 |
| Main next task | Continue P1.4 SQLCipher encrypted connection device/platform verification |
| Known blockers | Real privacy-policy effective date/contact; final chart green; Gradient 1 confirmation; WCAG contrast pass |

## Update Rules

- Set a task to `In Progress` before starting meaningful implementation.
- Set a task to `Review` when implementation is complete but not verified.
- Set a task to `Done` only after the acceptance check passes.
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
| P2.1 | Mood form state model | Not Started | Mood tracker feature | Form can hold mood score, sub-emotions, tags, note, photo path, and voice path | Existing mood form files are empty. |
| P2.2 | Quick-log screen UI | Not Started | Mood tracker feature | User can enter the quick-log flow from app routes | Current route is a placeholder. |
| P2.3 | Mood entry persistence | Not Started | Mood DAO/form logic | Saving creates a mood entry and selected tag links | Must use UUID and updatedAt consistently. |
| P2.4 | Custom activity tag flow | Not Started | Mood tracker/database | User can add a valid custom tag with 20-character max and category | Enforce 30 custom tag limit. |
| P2.5 | Photo and voice attachment flow | Not Started | Mood tracker/media storage | Relative media paths are stored and files stay in app sandbox | Voice duration max is 3 minutes per UI spec. |

## Phase 3 - Dashboard & History

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P3.1 | Replace home placeholder | Not Started | Dashboard feature | Home shows real dashboard instead of lock-only placeholder | Should include empty state. |
| P3.2 | History stream | Not Started | Dashboard/database | Entries render from a Drift stream and update after save/delete | Filter soft-deleted entries. |
| P3.3 | Weekly trend entry point | Not Started | Dashboard/analytics | Trend section hides until at least 3 entries exist | Chart implementation is Phase 4. |
| P3.4 | Entry detail/edit/delete | Not Started | Dashboard/mood tracker | User can view, edit, soft-delete, and restore if supported | Hard-delete cleanup policy still open. |

## Phase 4 - Offline Insights & Analytics

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P4.1 | Weekly mood trend query | Not Started | Analytics/database | Query handles days with no entries and produces expected averages | Use mood-level palette, not generic chart palette. |
| P4.2 | Weekly trend chart | Not Started | Analytics UI | Chart renders non-empty data correctly and hides invalid states | Needs visual QA. |
| P4.3 | Monthly calendar heatmap | Not Started | Analytics UI | Calendar displays month mood intensity with correct colors | Uses local database only. |
| P4.4 | Activity correlation chart | Not Started | Analytics/database/UI | Activity-mood relationship is calculated locally and rendered | Generic chart palette applies here. |
| P4.5 | Analytics edge-case tests | Not Started | Tests | Covers empty data, sparse days, ties, and large local histories | Required before analytics is Done. |

## Phase 5 - App Lock, Settings, Data Control

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P5.1 | PIN setup flow | In Progress | Settings/security | User can set and verify a PIN | Foundation exists; needs full manual/device checks. |
| P5.2 | Lock screen flow | In Progress | Settings/security/routes | Locked routes redirect correctly and unlock returns to app | Foundation exists. |
| P5.3 | Biometric lifecycle behavior | In Progress | Security/app lifecycle | Biometric prompt respects foreground cooldown and avoids prompt spam | Needs platform testing. |
| P5.4 | Settings screen | Not Started | Settings feature | User can access lock, export/import, delete data, and haptics settings | No real settings dashboard yet. |
| P5.5 | Delete all data | Not Started | Settings/security/database | User can permanently remove local data and reset encryption material intentionally | Must be destructive only after confirmation. |

## Phase 6 - Backup, Export, Import

| ID | Task | Status | Main files/areas | Acceptance check | Notes |
| --- | --- | --- | --- | --- | --- |
| P6.1 | JSON/CSV export | Not Started | Backup/restore utilities | User can export readable data through system share sheet | Media packaging decision still needed. |
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

## Reference Docs

- `prd_daily_mood_tracker.md` - product goals, MVP scope, and open product questions.
- `daily_mood_tracker_offline_first_plan.md` - original phased implementation roadmap.
- `data_model.md` - target local schema and import/restore rules.
- `Daily_mood_tracker_uiux_spec.md` - screen behavior and UX constraints.
- `style_guide.md` - design tokens and unresolved design confirmations.
- `privacy_policy.md` - local-only privacy policy draft.
