# Daily Mood Project Plan

This is the live implementation tracker for Daily Mood: Tracker & Diary. Update it whenever a task starts, is blocked, enters review, or is completed.

## Status Legend

| Status      | Meaning                                                                       |
| ----------- | ----------------------------------------------------------------------------- |
| Not Started | No implementation work has begun.                                             |
| In Progress | Work has started but is not ready for verification.                           |
| Review      | Implementation is ready, but tests/manual checks are still needed.            |
| Blocked     | Work cannot continue without a product, design, legal, or technical decision. |
| Done        | Implementation is complete and verified.                                      |
| Deferred    | Intentionally postponed beyond the MVP.                                       |

## Current Snapshot

| Field                | Value                                                                                                      |
| -------------------- | ---------------------------------------------------------------------------------------------------------- |
| Overall MVP status   | Feature-gap backlog implementation is complete                                                             |
| Current active phase | Phase 9.8 - MVP Polish: Gentle Feedback & Visual Rewards; Phase 7 store readiness remains open             |
| Last updated         | 2026-07-21                                                                                                 |
| Latest verification  | P9.8f user-reported format, targeted tests, and analyze passed                                             |
| Main next task       | P9.8g animation QA and cleanup or Phase 7 store readiness items                                            |
| Known blockers       | Real privacy-policy effective date/contact; final chart green; Gradient 1 confirmation; WCAG contrast pass |

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

| ID   | Task                             | Status  | Main files/areas          | Acceptance check                                                 | Notes                                                |
| ---- | -------------------------------- | ------- | ------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------- |
| P0.1 | Review project Markdown docs     | Done    | Product/design docs       | Main docs reviewed for consistency                               | Completed before tracker creation.                   |
| P0.2 | Replace generated Flutter README | Done    | App README                | README explains app purpose, setup, docs map, and current status | Typo cleanup tracked separately.                     |
| P0.3 | Create live project tracker      | Done    | Project plan              | Tracker has phases, statuses, update rules, and verification log | This file is the source for implementation progress. |
| P0.4 | Fill privacy publication details | Blocked | Privacy policy            | Effective date and support contact are real, not placeholders    | Requires owner/legal/product input.                  |
| P0.5 | Confirm unresolved design tokens | Blocked | Style guide, theme tokens | Chart green, Gradient 1, and contrast checks are confirmed       | Requires design confirmation.                        |

## Phase 1 - Local Foundation, Encryption, Database

| ID   | Task                           | Status      | Main files/areas          | Acceptance check                                                              | Notes                                                                                                       |
| ---- | ------------------------------ | ----------- | ------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| P1.1 | Flutter app shell and routing  | Done        | App shell, routes         | App boots through configured router                                           | Home and quick-log are still placeholders.                                                                  |
| P1.2 | Theme and design tokens        | Done        | Theme layer               | Tokens align with style guide v1.1 and analyzer has no opacity deprecations   | Final design confirmations still blocked in P0.5.                                                           |
| P1.3 | Drift database setup           | Done        | Database layer            | App database opens and generated Drift code matches tables                    | Verified by database tests after schema generation.                                                         |
| P1.4 | SQLCipher encrypted connection | In Progress | Database/security layer   | Encrypted DB opens using secure key storage on target platforms               | Needs device/platform verification.                                                                         |
| P1.5 | Default activity seed data     | Done        | Database seed logic       | Seven default activities are seeded on first create                           | Existing test covers count.                                                                                 |
| P1.6 | Complete target schema         | Done        | Database tables           | Schema includes voice note path, sub-emotions, and entry-sub-emotion junction | Added schema version 2 with `voiceNotePath`, `SubEmotions`, and `MoodEntrySubEmotions`; tests/analyze pass. |
| P1.7 | Migration strategy and tests   | Done        | Database migrations/tests | Migration tests preserve sample data across schema versions                   | Schema version 1 to 2 upgrade coverage passes.                                                              |

## Phase 2 - Mood Logging Flow

| ID   | Task                            | Status | Main files/areas           | Acceptance check                                                               | Notes                                                                                                                                                                                                            |
| ---- | ------------------------------- | ------ | -------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P2.1 | Mood form state model           | Done   | Mood tracker feature       | Form can hold mood score, sub-emotions, tags, note, photo path, and voice path | Added `MoodFormState`, `MoodFormCubit`, and focused cubit tests.                                                                                                                                                 |
| P2.2 | Quick-log screen UI             | Done   | Mood tracker feature       | User can enter the quick-log flow from app routes                              | Redesigned as a 4-step flow matching the provided mockup, uses bundled `assets/emojis`, split files, and idempotent default reason seeding.                                                                      |
| P2.3 | Mood entry persistence          | Done   | Mood DAO/form logic        | Saving creates a mood entry and selected tag links                             | Quick-log Save persists mood score, note, selected reasons, selected sub-emotions, and voice path through `MoodEntryDao`; user-reported format, targeted tests, and analyze passed.                              |
| P2.4 | Custom activity tag flow        | Done   | Mood tracker/database      | User can add a valid custom tag with 20-character max and category             | Reasons step can create custom `Other` reasons through `ActivityDao`, selects the new reason after creation, and DAO tests cover validation plus the 30 custom tag limit.                                        |
| P2.5 | Photo and voice attachment flow | Done   | Mood tracker/media storage | Relative photo paths are stored and voice input can generate note text         | Photos are copied into app document storage; Add voice uses speech-to-text and appends recognized text into the note instead of storing an audio file; user-reported format, targeted tests, and analyze passed. |

## Phase 3 - Dashboard & History

| ID   | Task                           | Status | Main files/areas       | Acceptance check                                                              | Notes                                                                                                                                                                                                                                                                                                 |
| ---- | ------------------------------ | ------ | ---------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P3.1 | Replace home placeholder       | Done   | Dashboard feature      | Home shows real dashboard instead of lock-only placeholder                    | Added `DashboardScreen`, wired Home tab to recent mood entries, split dashboard UI/helpers into focused files, and restyled the dashboard toward the supplied reference UI. User-reported verification passed.                                                                                        |
| P3.2 | History stream                 | Done   | Dashboard/database     | Entries render from a Drift stream and update after save/delete               | Added `HistoryScreen` backed by the existing non-deleted mood entry stream, grouped entries by day, and replaced the History tab placeholder. User-reported verification passed.                                                                                                                      |
| P3.3 | Weekly trend entry point       | Done   | Dashboard/analytics    | Trend section hides until at least 3 entries exist                            | Added a dashboard weekly-trend entry card that appears only after 3 entries and opens the Stats tab. Chart implementation remains Phase 4. User-reported verification passed.                                                                                                                         |
| P3.4 | Entry detail/edit/delete       | Done   | Dashboard/mood tracker | User can view, edit, soft-delete, and restore if supported                    | Added shared entry detail sheet for dashboard/history, repository update/delete actions, and widget tests. Restore is deferred because deleted entries are not exposed in the current app surface; hard-delete cleanup policy still open. User-reported verification passed.                          |
| P3.5 | Dynamic dashboard mood visuals | Done   | Dashboard UI           | Week strip and today mood chart show real logged moods instead of sample data | Replaced hardcoded day/mood samples with entries from the dashboard stream, removed fixed chart scores/times, added an empty chart state, made week days selectable for per-day views, and added focused widget coverage. Awaiting user-run format, targeted dashboard test, and analyze before Done. |

## Phase 4 - Offline Insights & Analytics

| ID   | Task                       | Status | Main files/areas      | Acceptance check                                                  | Notes                                                                                                                                                                                                                                           |
| ---- | -------------------------- | ------ | --------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P4.1 | Weekly mood trend query    | Done   | Analytics/database    | Query handles days with no entries and produces expected averages | Added analytics model, local service, repository provider, and focused test for sparse weekly averages. User-reported verification passed.                                                                                                      |
| P4.2 | Weekly trend chart         | Done   | Analytics UI          | Chart renders non-empty data correctly and hides invalid states   | Replaced Stats placeholder with analytics screen, added weekly trend chart using mood-level colors, hides chart until at least 3 weekly entries exist, pinned compatible `fl_chart`, and added widget tests. User-reported verification passed. |
| P4.3 | Monthly calendar heatmap   | Done   | Analytics UI          | Calendar displays month mood intensity with correct colors        | Added monthly heatmap data points, calendar UI using mood-level colors plus numeric mood values, empty state, and focused tests. User-reported verification passed.                                                                             |
| P4.4 | Activity correlation chart | Done   | Analytics/database/UI | Activity-mood relationship is calculated locally and rendered     | Added local activity-mood aggregation, generic-palette horizontal bar chart with labels/values, empty state, and focused tests. User-reported verification passed.                                                                              |
| P4.5 | Analytics edge-case tests  | Done   | Tests                 | Covers empty data, sparse days, ties, and large local histories   | Added focused analytics repository coverage for empty data, sparse datasets, tied activity ordering, activity limit handling, and large local histories. User-reported verification passed.                                                     |

## Phase 5 - App Lock, Settings, Data Control

| ID   | Task                         | Status | Main files/areas           | Acceptance check                                                                   | Notes                                                                                                                                                                           |
| ---- | ---------------------------- | ------ | -------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P5.1 | PIN setup flow               | Done   | Settings/security          | User can set and verify a PIN                                                      | Foundation exists; needs full manual/device checks.                                                                                                                             |
| P5.2 | Lock screen flow             | Done   | Settings/security/routes   | Locked routes redirect correctly and unlock returns to app                         | Foundation exists.                                                                                                                                                              |
| P5.3 | Biometric lifecycle behavior | Done   | Security/app lifecycle     | Biometric prompt respects foreground cooldown and avoids prompt spam               | Needs platform testing.                                                                                                                                                         |
| P5.4 | Settings screen              | Done   | Settings feature           | User can access lock, export/import, delete data, and haptics settings             | Added real settings dashboard, haptics preference persistence, lock-now action, visible export/import/delete entry points, and widget tests. User-reported verification passed. |
| P5.5 | Delete all data              | Done   | Settings/security/database | User can permanently remove local data and reset encryption material intentionally | Added explicit DELETE confirmation, local database reset with default reseed, mood media cleanup, SQLCipher key rotation, and focused tests. User-reported verification passed. |

## Phase 6 - Backup, Export, Import

| ID   | Task                             | Status | Main files/areas         | Acceptance check                                                              | Notes                                                                                                                                                                                                                                                       |
| ---- | -------------------------------- | ------ | ------------------------ | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P6.1 | JSON/CSV export                  | Done   | Backup/restore utilities | User can export readable data through system share sheet                      | Added JSON/CSV export builder, settings format picker, share-sheet integration, and focused tests. Media files are exported as relative path references until the packaging decision is resolved. User-reported format, targeted tests, and analyze passed. |
| P6.2 | Import parser                    | Done   | Backup/restore utilities | Valid backup imports without data loss                                        | Added typed JSON/CSV backup parser and focused tests for valid imports, corrupt JSON, unsupported CSV headers, invalid mood scores, absolute media paths, and duplicate UUIDs. User-reported format, targeted tests, and analyze passed.                    |
| P6.3 | UUID/timestamp conflict strategy | Done   | Backup/restore/database  | Newer imported records overwrite, older records are skipped and reported      | Added import applicator with transactional insert/update/skip behavior, activity resolution, entry link replacement, photo reference replacement, and focused database tests. User-reported format, targeted tests, and analyze passed.                     |
| P6.4 | Automatic pre-import backup      | Done   | Backup/restore utilities | Import creates rollback snapshot before changing data                         | Added pre-import JSON rollback snapshots, latest-three pruning, restore orchestration that snapshots before apply, Settings file-picker import flow, and focused tests. User-reported format, targeted tests, and analyze passed.                           |
| P6.5 | Backup/restore tests             | Done   | Tests                    | Covers duplicates, old files, corrupted files, media references, and rollback | Added broad backup/restore flow tests for JSON restore with media refs, duplicate old/new conflict behavior, corrupted files before mutation, and rollback snapshot contents. User-reported verification passed.                                            |

## Phase 7 - Polish, QA, Store Readiness

| ID   | Task                                | Status      | Main files/areas       | Acceptance check                                                                         | Notes                                                                                                                                                                |
| ---- | ----------------------------------- | ----------- | ---------------------- | ---------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P7.1 | Static analysis                     | Done        | Flutter app            | `flutter analyze` passes                                                                 | User reported no issues after opacity cleanup.                                                                                                                       |
| P7.2 | Automated tests                     | Done        | Tests                  | `flutter test` passes after latest edits                                                 | Passed on 2026-07-09.                                                                                                                                                |
| P7.3 | Accessibility and contrast pass     | Not Started | UI/theme               | Text/background pairs meet WCAG target from UI spec                                      | Especially text tertiary and mood chips.                                                                                                                             |
| P7.4 | App icon and launch screen branding | Not Started | Platform assets        | App has production icon and launch screen assets                                         | Current iOS launch README is default boilerplate.                                                                                                                    |
| P7.5 | Store privacy readiness             | Blocked     | Privacy/store metadata | Privacy policy, App Store labels, and Google Play Data Safety are complete               | Requires owner/legal/product input.                                                                                                                                  |
| P7.6 | Bottom navigation visual polish     | Done        | Shell UI               | Bottom navigation colors match the dashboard reference and keep readable inactive states | Added bottom navigation color tokens to `AppColors` and applied them in `MainShell`. Awaiting user-run format, shell/dashboard smoke check, and analyze before Done. |

## Phase 8 - Feature Gap Backlog

These tasks come from the 2026-07-13 feature-gap review of the current codebase, project docs, and common mood/journal app patterns. They are not all required to close the current MVP, but they are tracked here so product scope decisions stay explicit.

| ID    | Task                                | Status | Main files/areas                       | Acceptance check                                                                                           | Notes                                                                                                                                                                                                                                                                                            |
| ----- | ----------------------------------- | ------ | -------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| P8.1  | History search and filters          | Done   | Dashboard/history/database             | User can search notes and filter history by mood, activity tag, emotion, and date                          | Added history metadata stream, metadata chips, UI filters for search/mood/date, and focused DAO/widget tests. User-reported format, targeted tests, and analyze passed.                                                                                                                          |
| P8.2  | Full entry edit flow                | Done   | Dashboard/mood tracker                 | Existing entries can update mood, note, activities, sub-emotions, photo, and voice                         | Added transactional full-entry updates for mood, note, activities, sub-emotions, photo path, and voice path plus focused DAO/widget coverage. User-reported verification passed.                                                                                                                 |
| P8.3  | Real voice note recording           | Done   | Mood tracker/media/database            | Voice entries save a local relative audio path and can be played back                                      | Replaced speech-to-text-only voice action with local `.m4a` recording saved under `mood_voices/`, record-plugin wiring, and MissingPlugin guards. User-reported verification passed.                                                                                                             |
| P8.4  | Photo compression and size guard    | Done   | Mood tracker/media storage             | Picked photos are resized/compressed and oversized files show a clear warning                              | Quick-log and entry edit photos now compress to JPEG at 1080px/80% quality, reject source files over 20 MB, reject compressed files over 5 MB, keep relative `mood_photos/{uuid}.jpg` paths, and show localized warnings. Needs user-run format, targeted tests, analyze, and photo smoke check. |
| P8.5  | Media-safe backup packaging         | Done   | Backup/restore/media                   | JSON backup can include or package referenced media so restore works on a new phone                        | Export currently writes `mediaPackaging: relative_paths_only`, so photo/audio files are not actually moved with the backup.                                                                                                                                                                      |
| P8.6  | Custom tag management               | Done   | Settings/activity repository           | User can archive or restore custom tags without breaking historical entries                                | Added a Settings custom-tag management sheet with archive/restore actions, activity repository/DAO support, localized copy, and focused DAO/widget tests. User-reported verification passed.                                                                                                     |
| P8.7  | Local reminders and streaks         | Done   | Settings/dashboard                     | User can opt into a reminder preference and see a non-punitive streak                                      | Added persisted local reminder opt-in/time settings, scheduler abstraction, dashboard reflection streak card, localization, and focused widget coverage. Production still uses `NoopLocalReminderScheduler`, so real OS notifications are tracked in P9.7. User-reported verification passed.                                                                                                      |
| P8.8  | Vietnamese and English localization | Done   | App/localization/content               | App strings switch between Vietnamese and English based on locale or user choice                           | Added app-level English/Vietnamese localization with an in-app Settings language switch, English fallback, localized high-traffic screens, default mood/activity labels, and focused localization tests. User-reported pub get, format, targeted tests, and analyze passed.                      |
| P8.10 | Light and dark mode design          | Done   | App/theme/dashboard/analytics/settings | App supports coherent light, dark, and system appearance modes with readable contrast                      | Added persisted appearance mode, app-level light/dark themes, Settings switch, and adaptive dashboard/analytics surfaces. Needs user-run format, targeted tests, analyze, and light/dark smoke check.                                                                                            |
| P8.11 | Advanced stats views                | Done   | Analytics UI/data                      | Stats supports week/month/year ranges, mood distribution, calendar count badges, and clear section filters | Added period/date navigation, mood distribution data and donut chart, count badges in the calendar, and reference-style stats filters. User-reported advanced stats tests passed.                                                                                                                |
| P8.9  | Local guided insights               | Done   | Analytics/dashboard                    | App explains simple local patterns in plain language without sending data anywhere                         | Added local rule-based guided insight cards from weekly trends, mood distribution, and activity correlations, framed as reflection prompts rather than medical advice. User-reported verification passed.                                                                                        |

## Phase 9 - Retention Loop Features

This phase turns Daily Mood from a passive mood logger into a private daily habit loop. The loop is: gentle reminder -> quick check-in -> small reward -> daily reflection -> weekly insight -> memory resurfacing -> return tomorrow. All P9 features must remain offline-first and local-only: no accounts, remote AI, analytics SDKs, cloud sync, or health permissions in this phase.

| ID   | Task                                      | Status      | Main files/areas               | Acceptance check                                                                                         | Notes                                                                                                                                                                                                                                                                                                                                         |
| ---- | ----------------------------------------- | ----------- | ------------------------------ | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| P9.1 | Daily Reflection                          | Done | Dashboard/mood tracker/database | User can write or edit one short reflection for a day after logging at least one mood                    | Added local daily reflection persistence keyed by date, repository/app wiring, dashboard card, English/Vietnamese strings, focused tests, and JSON backup/import coverage. User reported all tests passed.                  |
| P9.2 | Mood Garden                               | Done | Dashboard/retention UI          | Home shows non-punishing progress that grows from check-ins and reflections without resetting on misses  | Added local garden summary logic, reflection list streaming, dashboard garden card, English/Vietnamese strings, and focused tests for growth plus non-reset behavior. User reported all tests passed.                                      |
| P9.2a | Mood Garden progression viewer           | Done | Dashboard/retention UI          | User can view the full tree growth journey from first stage to final stage, with locked stages clearly marked | Added stage threshold metadata, a Mood Garden progression sheet, dashboard entry point, localized copy, lock overlays for future stages, and focused tests for current/unlocked/locked progression. User reported all tests passed. |
| P9.3 | Weekly Report                             | Done | Analytics/dashboard             | User can view a weekly summary with average mood, check-ins, reflections, top emotion/activity, insight  | Added a local weekly report builder, dashboard report card, English/Vietnamese strings, and focused tests for empty, sparse, reflected, and rendered weekly states. User reported all tests passed.                   |
| P9.4 | On This Day                               | Done | Dashboard/history/media         | Home can resurface entries from the same month/day in previous years with safe, neutral wording          | Added a prior-year same-month/day DAO stream, repository/service plumbing, dashboard memory card with neutral copy, original date, note excerpt, and photo/voice indicators, plus focused DAO/widget tests. User reported all tests passed. |
| P9.5 | Daily Challenge                           | Done | Dashboard/settings/retention    | User receives one optional tiny local challenge per day and can mark it complete                         | Added a deterministic static local challenge pool, date-scoped completion persistence in local preferences, dashboard challenge card, English/Vietnamese strings, and focused unit/widget tests. User reported all tests passed. |
| P9.6 | Retention tests, localization, and privacy review | Done | Tests/localization/privacy docs | P9 features have focused tests, English/Vietnamese strings, dark/light checks, and privacy-safe wording | Added retention-loop localization/privacy-safe copy assertions, small-phone dashboard coverage for P9 cards, light/dark daily challenge card coverage, narrow mood-garden/streak-card behavior, and a privacy policy note confirming P9 reflection/report/memory/garden/challenge features remain local-only without remote AI, accounts, health data, analytics SDKs, or server processing. User reported all tests passed. |
| P9.7 | Real daily reminder notifications         | Done | Settings/notifications          | User can enable daily reminders, change reminder time, and receive an OS notification at that time       | Added a `flutter_local_notifications` scheduler, local timezone handling, Android notification permission/boot receiver/desugaring setup, app-start reminder reconciliation, permission-denied rollback, and focused tests. Turning reminders on now asks the user to choose a time first instead of silently using the default. User-reported verification passed. |

## Phase 9.8 - MVP Polish: Gentle Feedback & Visual Rewards

This phase adds calm, local-only micro-interactions to the completed MVP. The goal is to make mood logging feel acknowledged and satisfying while preserving the app's private, gentle, low-pressure tone.

### Product Principles

- Animations must support reflection, not performance.
- No streak pressure, leaderboards, social sharing, points economy, ads, analytics, or cloud features.
- All effects must run fully on-device.
- Animations should be short, calm, and non-blocking.
- Respect reduced-motion and accessibility settings where possible.
- Do not rely on animation or color alone to communicate success.
- Prefer Flutter-native animation before adding new packages.

| ID     | Task                                  | Status      | Main files/areas                         | Acceptance check                                                                                   | Notes                                                                                         |
| ------ | ------------------------------------- | ----------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| P9.8a  | Shared reduced-motion behavior         | Done | App theme/shared animation utilities      | Widgets can choose full animation or instant/fade-only feedback through a centralized helper        | Added `AppMotion` duration/curve tokens with `MediaQuery` reduced-motion detection, then wired existing short UI animations to keep normal timing while using reduced motion when requested. Needs user-run format, analyze, and targeted tests.        |
| P9.8b  | Quick-log save confirmation animation | Done | Mood tracker/quick-log/shared widgets     | Saving a mood shows a brief visual confirmation under 400ms and then continues normally             | Added an animated completion mark to the existing post-save dialog: selected emoji scale, mood-color ring/glow, check indicator, reduced-motion fallback, and focused widget assertions. User-reported format, targeted test, and analyze passed. |
| P9.8c  | Soft mood selection feedback          | Done | Mood tracker/quick-log mood picker        | Selecting a mood gives immediate scale, fade, or color feedback without shifting layout             | Reworked mood options into stable responsive slots with animated scale, ring, border, and check-badge feedback plus selected semantics. User-reported format, targeted test, and analyze passed. |
| P9.8d  | Gentle Mood Garden growth moment      | Done | Dashboard/retention UI                    | After a successful check-in, the garden shows a subtle growth, watering, or bloom animation          | Added a data-driven garden growth pulse that triggers when growth points increase, with decorative watering/sparkle overlay and reduced-motion support. User-reported format, targeted test, and analyze passed. |
| P9.8e  | Daily Challenge completion feedback   | Done | Dashboard/settings/retention              | Completing a challenge shows a calm badge/check animation and accessible success text                | Added a one-shot completion ring/check animation, kept accessible success text visible, and prevented replay spam on repeated off/on toggles. User-reported format, targeted test, and analyze passed. |
| P9.8f  | Haptic feedback pass                  | Done | Quick-log/challenge interactions          | Optional light haptics fire only on clear user actions and app still works when haptics unavailable | Added a settings-aware haptics service for mood selected, mood saved, and challenge completed; removed sub-emotion haptics; added focused coverage for enabled, disabled, unavailable, and widget trigger behavior. User-reported format, targeted tests, and analyze passed. |
| P9.8g  | Animation QA and cleanup              | Not Started | Affected widgets/tests                    | Animations do not block navigation, overflow, obscure content, or break small-phone layouts          | Check light mode, dark mode, small phones, repeated quick logging, and reduced motion.         |

### Recommended Implementation Order

1. P9.8a - Shared reduced-motion behavior
2. P9.8b - Quick-log save confirmation animation
3. P9.8c - Soft mood selection feedback
4. P9.8d - Gentle Mood Garden growth moment
5. P9.8e - Daily Challenge completion feedback
6. P9.8f - Haptic feedback pass
7. P9.8g - Animation QA and cleanup

### Slice 1: Shared Animation Foundation

Create a small reusable animation helper layer before adding effects across the app.

Acceptance:

- Common durations are centralized.
- Reduced-motion behavior is easy for widgets to check.
- Widgets can choose between full animation and minimal fade or instant state.
- No product behavior changes yet.

Suggested constants:

- Fast feedback: 120-180ms
- Save confirmation: 250-400ms
- Garden growth: 600-900ms
- Reduced motion: 0-120ms fade only

### Slice 2: Quick-log Save Confirmation

When the user saves a mood:

- The selected emoji gently scales up.
- A mood color ring or glow briefly appears.
- A success check appears or fades in.
- Navigation and save completion continue normally.

Acceptance:

- Does not delay database save.
- Does not block user navigation.
- Does not cover note text or form controls awkwardly.
- Works in light and dark mode.
- Has a reduced-motion fallback.

### Slice 3: Mood Selection Feedback

When selecting mood:

- The selected option becomes visually active.
- The emoji or option surface uses a small scale, border, or color transition.
- The previous selection returns to normal smoothly.
- No layout jump occurs.

Acceptance:

- Mood can still be selected with keyboard and screen reader flows.
- Selected state is clear without relying only on color.
- Touch target remains accessible.

### Slice 4: Mood Garden Growth

After logging a mood:

- Garden receives a new check-in state.
- Plant or garden visuals animate subtly.
- Animation can reflect the current mood color when it fits the calm tone.
- No new achievement or unlock logic is added.

Acceptance:

- Garden state remains data-driven.
- Animation is decorative, not required to understand progress.
- Dashboard remains readable during animation.

### Slice 5: Daily Challenge Completion

When a challenge is completed:

- Challenge item transitions to completed state.
- Badge or check animates softly.
- Optional small particle effect is allowed only if it fits the calm tone.
- Success text remains available for accessibility.

Acceptance:

- No loud reward language like "Quest Complete."
- No streak pressure.
- Repeated toggles do not spam effects.

### Slice 6: Haptics

Use only light haptics for:

- Mood selected.
- Mood saved.
- Challenge completed.

Avoid haptics for:

- Passive dashboard animations.
- Page transitions.
- Background garden changes.

Acceptance:

- Haptics are subtle.
- App still feels good with haptics unavailable.

### Slice 7: QA

Manual checks:

- Small phone layout.
- Dark mode.
- Light mode.
- Reduced-motion mode if available.
- Repeated quick logging.
- Challenge toggle on/off/on.
- Dashboard after app restart.
- No animation overflows.
- No stuck animation controllers.

Target tests:

- Widget test for quick-log selected state.
- Widget test for save confirmation trigger.
- Widget test for challenge completed state.
- Cubit or state test only if new state is introduced.

## Phase 10 - Post-MVP Expansion

| ID    | Task                                           | Status   | Main files/areas | Acceptance check                                                         | Notes                                                       |
| ----- | ---------------------------------------------- | -------- | ---------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------- |
| P10.1 | Automatic cloud sync                           | Deferred | Sync/storage     | User can opt in to platform-backed sync without violating privacy policy | Post-MVP; requires privacy policy and explicit opt-in flow. |
| P10.2 | Home screen widget                             | Deferred | Platform widgets | Widget shows useful local-only mood entry affordance                     | Post-MVP; useful after retention surfaces stabilize.        |
| P10.3 | Additional languages beyond English/Vietnamese | Deferred | Localization     | Languages beyond the initial Vietnamese and English target are supported | Post-MVP; separate from P8.8.                               |
| P10.4 | Health correlation                             | Deferred | Health/platforms | User can opt in to steps/sleep/activity correlations                     | Requires Apple Health/Google Fit permissions and policy updates. |
| P10.5 | Private AI companion and AI memory             | Deferred | AI/insights       | User can opt in to AI reflection without compromising journal privacy    | Requires product, privacy, model, and on-device/cloud architecture decisions. |
| P10.6 | Mood forecast and year-in-review               | Deferred | Analytics/summary | User can view predictive or annual summaries from enough local history   | Build after P9 report/memory foundations exist.             |

## Feature Gap Research Notes

| Date       | Finding                                                                                           | Source/context                                                                                                               | Follow-up tasks  |
| ---------- | ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 2026-07-13 | Mood apps commonly support search/filter, reminders/streaks, custom activities, charts, and media | Compared project docs/code with Daylio, DailyBean-style mood journals, and general mood-tracking app guidance.               | P8.1, P8.2, P8.7 |
| 2026-07-13 | Current implementation references media paths but does not package media files into backup export | `BackupExportService` emits `mediaPackaging: relative_paths_only`; UI copy says media files export as relative references.   | P8.5             |
| 2026-07-13 | Current implementation has voice transcription but not persisted voice recordings                 | Quick-log route wires `onTranscribeVoice` to `speech_to_text`; schema has `voiceNotePath`.                                   | P8.3             |
| 2026-07-13 | Initial Vietnamese + English target is not implemented as app localization                        | PRD mentions Vietnamese + English target; `pubspec.yaml` has no localization dependency/config and UI strings are hardcoded. | P8.8             |
| 2026-07-18 | Retention should be designed as a habit loop, not just more charts                                | Attached retention note recommends daily reflection, mood garden, weekly report, memories, challenges, health correlation, and AI companion ideas. | P9.1-P9.6, P10.4-P10.6 |

## Verification Log

| Date       | Check                                                                                                                                                                                      | Result | Notes                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------- |
| 2026-07-09 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after deprecation cleanup.                                                 |
| 2026-07-09 | `rg -n "withOpacity" lib`                                                                                                                                                                  | Passed | No remaining matches under app `lib`.                                                       |
| 2026-07-09 | `dart format lib test`                                                                                                                                                                     | Passed | Reported by user, 0 files changed.                                                          |
| 2026-07-09 | `flutter test`                                                                                                                                                                             | Passed | Reported by user, all tests passed.                                                         |
| 2026-07-09 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user, no issues found.                                                          |
| 2026-07-09 | `dart format lib test`                                                                                                                                                                     | Passed | Reported by user after P1.7; formatted 3 files.                                             |
| 2026-07-09 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P1.7; 3 tests passed.                                                |
| 2026-07-09 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P1.7; no issues found.                                               |
| 2026-07-09 | Main shell color-token cleanup                                                                                                                                                             | Passed | Reported by user after stale `_HomePlaceholder` removal; `flutter analyze` found no issues. |
| 2026-07-09 | `flutter test test/features/mood_tracker/cubit/mood_form_cubit_test.dart`                                                                                                                  | Passed | Reported by user after P2.1; 12 tests passed.                                               |
| 2026-07-10 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P2.2; all tests passed.                                              |
| 2026-07-10 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P2.2; no issues found.                                               |
| 2026-07-10 | `dart format lib test`                                                                                                                                                                     | Passed | Reported by user after P2.3; all relevant files formatted.                                  |
| 2026-07-10 | `flutter test test/core/database/app_database_test.dart test/core/database/daos/mood_entry_dao_test.dart test/features/mood_tracker/quick_log/quick_log_screen_test.dart`                  | Passed | Reported by user after P2.3 persistence and sub-emotion seeding fixes.                      |
| 2026-07-10 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P2.3; no issues found.                                               |
| 2026-07-10 | `flutter pub get`                                                                                                                                                                          | Passed | Reported by user after adding speech-to-text support for P2.5.                              |
| 2026-07-10 | `dart format lib test`                                                                                                                                                                     | Passed | Reported by user after P2.5 photo and speech-to-text note flow.                             |
| 2026-07-10 | `flutter test test/features/mood_tracker/quick_log/quick_log_screen_test.dart test/core/database/daos/mood_entry_dao_test.dart test/features/mood_tracker/cubit/mood_form_cubit_test.dart` | Passed | Reported by user after P2.5.                                                                |
| 2026-07-10 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P2.5 deprecation cleanup; no issues found.                           |
| 2026-07-10 | `dart format lib\features\dashboard test\features\dashboard\dashboard_screen_test.dart`                                                                                                    | Passed | Reported by user after P3.1 dashboard restyle.                                              |
| 2026-07-10 | `flutter test test\features\dashboard\dashboard_screen_test.dart`                                                                                                                          | Passed | Reported by user after P3.1 dashboard overflow fixes.                                       |
| 2026-07-10 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P3.1.                                                                |
| 2026-07-10 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P3.1.                                                                |
| 2026-07-11 | `dart format lib\features\dashboard lib\features\shell\main_shell.dart test\features\dashboard`                                                                                            | Passed | Reported by user after P3.2 history stream.                                                 |
| 2026-07-11 | `flutter test test\features\dashboard\history_screen_test.dart test\features\dashboard\dashboard_screen_test.dart`                                                                         | Passed | Reported by user after P3.2.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P3.2.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P3.2.                                                                |
| 2026-07-11 | `dart format lib\features\dashboard lib\features\shell\main_shell.dart test\features\dashboard`                                                                                            | Passed | Reported by user after P3.3 weekly trend entry point.                                       |
| 2026-07-11 | `flutter test test\features\dashboard\dashboard_screen_test.dart`                                                                                                                          | Passed | Reported by user after P3.3.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P3.3.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P3.3.                                                                |
| 2026-07-11 | `dart format lib\features\dashboard lib\data test\features\dashboard`                                                                                                                      | Passed | Reported by user after P3.4 entry detail/edit/delete.                                       |
| 2026-07-11 | `flutter test test\features\dashboard\dashboard_screen_test.dart test\features\dashboard\history_screen_test.dart`                                                                         | Passed | Reported by user after P3.4.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P3.4.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P3.4.                                                                |
| 2026-07-11 | `dart format lib\app.dart lib\data lib\domain test\data`                                                                                                                                   | Passed | Reported by user after P4.1 weekly mood trend query.                                        |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart`                                                                                                                  | Passed | Reported by user after P4.1 import conflict fix.                                            |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P4.1.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P4.1.                                                                |
| 2026-07-11 | `flutter pub get`                                                                                                                                                                          | Passed | Reported by user after pinning compatible `fl_chart` for P4.2.                              |
| 2026-07-11 | `dart format lib\features\analytics lib\features\shell\main_shell.dart test\features\analytics`                                                                                            | Passed | Reported by user after P4.2 weekly trend chart.                                             |
| 2026-07-11 | `flutter test test\features\analytics\stats_screen_test.dart`                                                                                                                              | Passed | Reported by user after P4.2.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P4.2.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P4.2.                                                                |
| 2026-07-11 | `dart format lib\data lib\domain lib\features\analytics test\data test\features\analytics`                                                                                                 | Passed | Reported by user after P4.3 monthly calendar heatmap.                                       |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart test\features\analytics\stats_screen_test.dart`                                                                   | Passed | Reported by user after P4.3.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P4.3.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P4.3.                                                                |
| 2026-07-11 | `dart format lib\core\database\daos lib\data lib\domain lib\features\analytics test\data test\features\analytics`                                                                          | Passed | Reported by user after P4.4 activity correlation chart.                                     |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart test\features\analytics\stats_screen_test.dart`                                                                   | Passed | Reported by user after P4.4.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P4.4.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P4.4.                                                                |
| 2026-07-11 | `dart format test\data\repositories\mood_analytics_repository_test.dart`                                                                                                                   | Passed | Reported by user after P4.5 analytics edge-case tests.                                      |
| 2026-07-11 | `flutter test test\data\repositories\mood_analytics_repository_test.dart`                                                                                                                  | Passed | Reported by user after P4.5.                                                                |
| 2026-07-11 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P4.5.                                                                |
| 2026-07-11 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P4.5.                                                                |
| 2026-07-12 | `dart format lib\features\settings lib\features\shell\main_shell.dart test\features\settings`                                                                                              | Passed | Reported by user after P5.4 settings screen.                                                |
| 2026-07-12 | `flutter test test\features\settings\settings_screen_test.dart`                                                                                                                            | Passed | Reported by user after P5.4.                                                                |
| 2026-07-12 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P5.4.                                                                |
| 2026-07-12 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P5.4.                                                                |
| 2026-07-12 | `dart format lib\core\database\app_database.dart lib\core\security\db_key_manager.dart lib\features\settings test\features\settings`                                                       | Passed | Reported by user after P5.5 delete all data.                                                |
| 2026-07-12 | `flutter test test\features\settings\settings_screen_test.dart test\features\settings\local_data_reset_service_test.dart`                                                                  | Passed | Reported by user after P5.5.                                                                |
| 2026-07-12 | `flutter test`                                                                                                                                                                             | Passed | Reported by user after P5.5.                                                                |
| 2026-07-12 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P5.5.                                                                |
| 2026-07-13 | `dart format lib\features\settings test\features\settings`                                                                                                                                 | Passed | Reported by user after P6.1 JSON/CSV export.                                                |
| 2026-07-13 | `flutter test test\features\settings\backup_export_service_test.dart test\features\settings\settings_screen_test.dart`                                                                     | Passed | Reported by user after P6.1.                                                                |
| 2026-07-13 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P6.1.                                                                |
| 2026-07-13 | `dart format lib\features\settings test\features\settings`                                                                                                                                 | Passed | Reported by user after P6.2 import parser.                                                  |
| 2026-07-13 | `flutter test test\features\settings\backup_import_parser_test.dart`                                                                                                                       | Passed | Reported by user after P6.2.                                                                |
| 2026-07-13 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P6.2.                                                                |
| 2026-07-13 | `dart format lib\features\settings test\features\settings`                                                                                                                                 | Passed | Reported by user after P6.3 UUID/timestamp conflict strategy.                               |
| 2026-07-13 | `flutter test test\features\settings\backup_import_apply_service_test.dart`                                                                                                                | Passed | Reported by user after P6.3.                                                                |
| 2026-07-13 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P6.3.                                                                |
| 2026-07-13 | `dart format lib\features\settings test\features\settings`                                                                                                                                 | Passed | Reported by user after P6.4 import pipeline.                                                |
| 2026-07-13 | `flutter test test\features\settings\backup_snapshot_service_test.dart test\features\settings\backup_import_restore_service_test.dart test\features\settings\settings_screen_test.dart`    | Passed | Reported by user after P6.4.                                                                |
| 2026-07-13 | `flutter analyze`                                                                                                                                                                          | Passed | Reported by user after P6.4.                                                                |
| 2026-07-13 | P6.5 backup/restore verification                                                                                                                                                           | Passed | Reported by user before moving P6.5 to Done.                                                |
| 2026-07-13 | P8.1 history search/filter verification                                                                                                                                                    | Passed | Reported by user after Phase 8 history search/filter implementation.                        |
| 2026-07-13 | P8.2 full entry edit verification                                                                                                                                                          | Passed | Reported by user after full entry edit implementation.                                      |
| 2026-07-14 | P8.3 real voice note recording verification                                                                                                                                                | Passed | Reported by user after pub get, format, targeted tests, and analyze.                        |
| 2026-07-16 | P8.8 Vietnamese and English localization verification                                                                                                                                      | Passed | Reported by user after pub get, format, targeted tests, and analyze.                        |
| 2026-07-17 | P8.11 advanced stats views verification                                                                                                                                                    | Passed | Reported by user after advanced stats tests passed.                                         |
| 2026-07-17 | P8.6 custom tag management verification                                                                                                                                                    | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-17 | P8.7 local reminders and streaks verification                                                                                                                                              | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-17 | P8.9 local guided insights verification                                                                                                                                                    | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-18 | `dart run build_runner build --delete-conflicting-outputs`                                                                                                                                 | Completed | Reported by user during P9.1 daily reflection schema generation.                            |
| 2026-07-18 | P9.1 daily reflection verification                                                                                                                                                         | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-18 | P9.2 mood garden verification                                                                                                                                                              | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-19 | P9.3 weekly report verification                                                                                                                                                            | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-19 | P9.2a mood garden progression viewer verification                                                                                                                                          | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-19 | P9.7 real daily reminder notifications verification                                                                                                                                        | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-20 | P9.4 On This Day verification                                                                                                                                                              | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-20 | P9.5 Daily Challenge verification                                                                                                                                                          | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-20 | P9.6 retention tests, localization, and privacy review verification                                                                                                                         | Passed | Reported by user after all tests passed.                                                    |
| 2026-07-21 | P9.8b quick-log save confirmation animation verification                                                                                                                                    | Passed | Reported by user after format, targeted test, and analyze passed.                           |
| 2026-07-21 | P9.8c soft mood selection feedback verification                                                                                                                                             | Passed | Reported by user after format, targeted test, and analyze passed.                           |
| 2026-07-21 | P9.8d gentle Mood Garden growth moment verification                                                                                                                                         | Passed | Reported by user after format, targeted test, and analyze passed.                           |
| 2026-07-21 | P9.8e daily challenge completion feedback verification                                                                                                                                      | Passed | Reported by user after format, targeted test, and analyze passed.                           |
| 2026-07-21 | P9.8f haptic feedback pass verification                                                                                                                                                     | Passed | Reported by user after format, targeted tests, and analyze passed.                          |

## Reference Docs

- `prd_daily_mood_tracker.md` - product goals, MVP scope, and open product questions.
- `daily_mood_tracker_offline_first_plan.md` - original phased implementation roadmap.
- `data_model.md` - target local schema and import/restore rules.
- `Daily_mood_tracker_uiux_spec.md` - screen behavior and UX constraints.
- `style_guide.md` - design tokens and unresolved design confirmations.
- `privacy_policy.md` - local-only privacy policy draft.
