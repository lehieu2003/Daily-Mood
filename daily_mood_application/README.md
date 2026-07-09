# Daily Mood: Tracker & Diary

Daily Mood is an offline-first Flutter app for private mood tracking and journaling. The MVP is designed around fast daily logging, local-only encrypted storage, and clear user control over export, import, and deletion.

The app has no account system and no backend server in the MVP. Mood entries, notes, photos, voice notes, activity tags, and lock settings are intended to stay on the user's device unless the user explicitly exports a backup file.

## Current Status

This repository contains the Flutter application plus product/design documents at the repository root.

Implemented foundation:

- Flutter app shell with routing.
- Local Drift database setup.
- SQLCipher-backed encrypted SQLite connection.
- Default activity seeding.
- PIN/biometric app-lock foundation.
- Design token files for colors and typography.

Still in progress:

- Real home dashboard and quick-log screens.
- Mood entry form state and persistence UI.
- Sub-emotions and voice-note schema integration.
- Charts, calendar heatmap, backup/export/import flows.
- Store-ready privacy/contact details.

## Product Scope

The MVP includes:

- Mood logging on a 5-level scale.
- Default and custom activity tags.
- Optional journal notes, photo attachment, and voice journal recording.
- Dashboard history, weekly trend chart, and monthly calendar heatmap.
- PIN or biometric app lock.
- Local database encryption.
- Manual JSON/CSV export and import through the system share sheet.
- Light and dark mode support.

Out of scope for MVP:

- Account login.
- Automatic cloud sync.
- Ads or behavioral tracking.
- Sharing data with a therapist or third party.
- Home screen widget.
- Languages beyond the initial Vietnamese and English target.

## Tech Stack

- Flutter and Dart.
- Drift over SQLite for local persistence.
- SQLCipher for encrypted local storage.
- flutter_secure_storage for protected key/PIN material.
- flutter_bloc for state management.
- go_router for app navigation and route guards.
- local_auth for biometric authentication.
- fl_chart and table_calendar for planned analytics UI.

## Run Locally

Install dependencies:

```bash
flutter pub get
```

Run code generation after changing Drift tables or DAOs:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run tests:

```bash
flutter test
```

Run the app:

```bash
flutter run
```

## Documentation Map

Read these root-level documents before changing scope or data behavior:

- `prd_daily_mood_tracker.md` - product goals, MVP scope, user stories, and open questions.
- `daily_mood_tracker_offline_first_plan.md` - architecture and phased implementation plan.
- `data_model.md` - target local schema, ERD, migration strategy, and import/restore conflict strategy.
- `Daily_mood_tracker_uiux_spec.md` - screen flows, interaction rules, and mood-level visual system.
- `style_guide.md` - color and typography tokens.
- `privacy_policy.md` - draft privacy policy for the local-only MVP.

## Important Development Notes

- Treat the data model as privacy-sensitive. Do not add networking, analytics, crash reporting, or cloud storage without updating the PRD and privacy policy first.
- Do not use destructive database migrations after release. Every schema change needs an explicit Drift migration and a migration test.
- Store media file paths as relative paths inside app storage, not absolute OS paths.
- Use `uuid` as the stable logical key for import/restore matching; do not rely on local auto-increment IDs across devices.
- Keep design tokens synchronized with `style_guide.md` and `Daily_mood_tracker_uiux_spec.md`.
