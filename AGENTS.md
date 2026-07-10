# Daily Mood Agent Guide

## Project Overview

Daily Mood is an offline-first Flutter app for private mood tracking and journaling. The MVP must keep user data local by default, encrypted at rest, and under explicit user control through manual export/import only.

The app currently lives in `daily_mood_application/`. Product, architecture, privacy, data model, UI/UX, and style documents live at the repository root.

## Repository Map

| Path | Purpose |
| --- | --- |
| `daily_mood_application/` | Flutter application source, platform folders, tests, and assets |
| `daily_mood_application/lib/app/` | App shell, routing, theme, design tokens |
| `daily_mood_application/lib/core/` | Database, security, and cross-feature infrastructure |
| `daily_mood_application/lib/features/` | Feature-first UI and state modules |
| `daily_mood_application/test/` | Widget, Cubit, DAO, and database tests |
| `prd_daily_mood_tracker.md` | Product scope and user stories |
| `daily_mood_tracker_offline_first_plan.md` | Offline-first architecture and implementation phases |
| `data_model.md` | Target schema, migrations, import/restore strategy |
| `Daily_mood_tracker_uiux_spec.md` | Screen flows, interaction rules, mood visuals |
| `style_guide.md` | Color and typography system |
| `privacy_policy.md` | Privacy commitments for the local-only MVP |
| `.agents/` | Agent commands, local rules, skills, and settings |

## Current Stack

- Flutter and Dart.
- Drift over SQLite for local persistence.
- SQLCipher-backed encrypted database via `sqlcipher_flutter_libs`.
- `flutter_secure_storage` for protected key/PIN material.
- `flutter_bloc` for feature state.
- `go_router` for navigation and lock routing.
- `local_auth` for biometrics.
- `fl_chart` and `table_calendar` for analytics UI.
- No backend, account system, analytics, ads, crash reporting, or automatic cloud sync in the MVP.

## Development Workflow

Use a small-slice workflow:

1. Read the relevant root document before changing product scope, data behavior, security, privacy, or UI patterns.
2. Plan the smallest vertical slice that leaves the app buildable.
3. Add or update tests before behavior changes when the expected behavior is clear.
4. Implement inside the existing feature-first structure.
5. Leave `dart format`, `flutter analyze`, and `flutter test` for the user to run unless the user explicitly asks the agent to run them.
6. Review for privacy, local data safety, migration safety, and UI consistency.

Commands in `.agents/commands/` are available, but this project is Flutter-first. If a generic rule mentions Next.js, Prisma, Redis, Postgres, REST APIs, or React, treat it as non-applicable unless that technology is actually introduced by an approved scope change.

## Essential Commands

Run these from `daily_mood_application/`:

```bash
flutter pub get
dart format lib test
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

Use code generation after changing Drift tables, DAOs, generated part files, or database-related annotations.

Agent execution rule: the user runs formatting, analysis, and tests. Do not run `dart format`, `flutter analyze`, or `flutter test` unless explicitly requested.

## Architecture Rules

- Keep a feature-first layout under `lib/features/`.
- Put app shell, theme, and route definitions under `lib/app/`.
- Put shared persistence, security, and infrastructure under `lib/core/`.
- Keep Cubits focused on screen or feature state; avoid mixing database implementation details into widgets.
- Keep Drift table, DAO, and migration changes together with tests.
- Prefer reactive Drift streams for dashboard/history data instead of manual refresh plumbing.
- Store media paths relative to app-controlled storage, not as absolute OS paths.
- Use `uuid` as the stable logical identifier for import/restore matching; do not rely on local auto-increment IDs across devices.

## Privacy And Security Rules

- Treat mood entries, notes, photos, voice notes, tags, and lock settings as sensitive data.
- Do not add networking, analytics, crash reporting, remote logging, account login, or cloud sync without updating the PRD and privacy policy first.
- Never hardcode encryption keys, PINs, salts, or test credentials into production code.
- Keep database encryption enabled from the start; do not introduce plaintext local storage for private user data.
- Do not log journal text, mood notes, encryption material, biometric state details, or database contents.
- Always create migration tests for schema changes that can affect existing user data.

## UI And UX Rules

- Follow `Daily_mood_tracker_uiux_spec.md` and `style_guide.md` for mood colors, typography, spacing, and interaction patterns.
- Keep logging fast and low-friction; the quick-log flow should stay focused on mood, emotion, reason, and optional note input.
- Support light and dark mode through centralized tokens in `lib/app/theme/`.
- Keep accessibility in mind for mood color usage; do not rely on color alone to communicate state.
- Validate responsive behavior for small phones before considering a UI slice complete.

## Testing Expectations

- Prefer focused tests near the changed behavior:
  - DAO/database tests for Drift queries, seeding, migrations, and conflict behavior.
  - Cubit tests for form and lock state transitions.
  - Widget tests for quick-log, dashboard, settings, and lock flows.
- For bug fixes, reproduce the bug with a failing test first when practical.
- For database changes, test empty database creation and migration from previous schemas.
- Before reporting completion, run at least the narrow relevant tests. Run the full suite when touching shared database, routing, security, or theme behavior.

## Git And Editing Rules

- Do not revert user changes unless explicitly asked.
- Keep edits scoped to the requested slice.
- Use conventional commit messages when asked to commit.
- Include verification evidence in commit bodies when committing.
- Avoid unrelated formatting churn outside files touched for the task.

## Agent Configuration Notes

- `.agents/settings.json` points tools to `.agents/rules`, `.agents/commands`, `.agents/skills`, and `.agents/agents`.
- `.agents/AGENTS.md` should stay aligned with this root `AGENTS.md`.
- The local `.agents/rules/` folder still contains some generic web/backend guidance. Apply only the parts that fit this Flutter offline-first app.
