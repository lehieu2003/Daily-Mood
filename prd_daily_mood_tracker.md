# Product Requirements Document (PRD)

## "Daily Mood: Tracker & Diary"

**Version:** 1.1 (Updated — see changelog at bottom)
**Status:** Draft — MVP
**Product Type:** Mobile app (iOS + Android), Offline-First

---

## 1. Product Vision

A private mood-journaling app, requiring no account and no server, that helps users record their daily emotions in **under 10 seconds** and see their emotional trends over time — without having to sacrifice privacy.

**Core differentiator:** Zero-Knowledge, 100% offline, no ads, no behavioral tracking.

---

## 2. Problem Statement

- Many current mood tracker apps require account creation, send data to their cloud, or contain ads/behavioral tracking — which raises concerns since mood and journal data is highly sensitive information.
- Traditional emotional journaling (handwriting, note apps) lacks the structure needed to reveal trends or relationships between activities and emotions.
- High friction (having to open the app, log in, write lengthy entries) causes users to give up after a few days.

---

## 3. Target Users

| Persona                              | Description                                                                 | Main Need                                                        |
| ------------------------------------ | --------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **The mental wellness self-tracker** | Age 20-40, interested in wellness, may be in therapy or self-observing      | Needs data to discuss with a therapist or self-identify patterns |
| **The busy quick-logger**            | No time to write long journal entries, wants a single quick action each day | Needs speed, minimal steps                                       |
| **The privacy-conscious user**       | Does not want personal data leaving the device in any form                  | Needs a clear commitment to zero-knowledge, no account required  |

---

## 4. Goals & Success Metrics

| Goal                | Metric                                                   | Expected Threshold (3 months post-launch)  |
| ------------------- | -------------------------------------------------------- | ------------------------------------------ |
| User retention      | D7 Retention                                             | ≥ 25%                                      |
| User retention      | D30 Retention                                            | ≥ 10%                                      |
| Regular usage level | Average entries/user/week                                | ≥ 4 entries                                |
| Logging speed       | Average time to complete 1 entry                         | ≤ 10 seconds (excluding note-writing time) |
| Stable experience   | Crash-free session rate\*                                | ≥ 99.5%                                    |
| Data reliability    | Number of data-loss incidents from backup/restore errors | 0                                          |

> \* **Measurement note (added in this revision):** the MVP has no in-app crash reporting SDK (per Privacy Policy §4 and §8 below — any crash SDK is opt-in and only planned for a later version). Until that opt-in layer exists, this metric should be tracked via **store-provided data only** — Google Play Console's crash/ANR stats and Xcode Organizer's crash reports — both of which are provided by the OS/store and require no in-app SDK or additional user data collection. Once opt-in crash reporting ships, this can be supplemented with in-app data, but only from users who've opted in, so treat any such sample as directional, not comprehensive.

> Note: since the app has no server, the other metrics above can only be measured if there is an opt-in local analytics layer (see section 8), following privacy-first principles (opt-in, anonymous).

---

## 5. MVP Scope (In Scope)

- Log mood on a 5-level scale, along with activity tags (default + custom).
- Free-form text notes (optional), attached photos (optional), and voice journal recordings (Voice Note - optional).
- Dashboard to view history, weekly trend chart, monthly calendar heatmap.
- App lock via PIN or biometrics.
- Local data encryption (SQLCipher).
- Manual data export/import (JSON/CSV) via the system share sheet.
- Automatic Dark mode / Light mode based on system settings.

## 6. Out of Scope for MVP (For Later Versions)

- Automatic cloud sync (Google Drive / iCloud).
- Smart reminders (based on app usage patterns).
- Sharing data with a therapist/third party.
- Home screen widget.
- Multiple languages (MVP is Vietnamese + English only).
- Login / account of any kind.

---

## 7. Key User Stories

1. **As a new user**, I want to open the app and log my mood right away without creating an account, so I can start using it without friction.
2. **As a daily user**, I want to log my mood in under 10 seconds, so that journaling doesn't become a burden.
3. **As a privacy-conscious user**, I want to set a PIN/biometric lock, so that others can't read my journal if they pick up my phone.
4. **As a long-term user**, I want to view weekly/monthly mood trend charts, so I can recognize my own emotional patterns.
5. **As a long-term user**, I want to see which activities correlate with good/bad moods, so I can adjust my habits.
6. **As a user who wants backups**, I want to export all my data to a file, so I can store it however I choose (Drive, iCloud, computer, etc.).
7. **As a user switching phones**, I want to import a backup file, so I don't lose my old journal history.
8. **As a user who wants to delete data**, I want a clear "delete all data" button in Settings, so I have full control over my information.
9. **As a user who doesn't want to type**, I want to quickly record my thoughts as a Voice Note, so I can capture my emotions vividly with the least effort.

---

## 8. Privacy & Analytics Considerations

- No personal data collection, no backend server.
- If analytics (measuring retention, crash reports) is included, it must be **clearly opt-in**, fully anonymous, and not linked to journal content. Recommend using a crash-only tool (e.g., Sentry in no-PII-collection mode) rather than a full analytics SDK.
- Full details are located in the separate **Privacy Policy** document.

---

## 9. Risks & Assumptions

| Risk                                                                | Level      | Mitigation                                                                                         |
| ------------------------------------------------------------------- | ---------- | -------------------------------------------------------------------------------------------------- |
| Data loss from incorrect restore                                    | High       | Auto-backup before import, timestamp-based conflict strategy (see Data Model doc)                  |
| App rejected from the store due to sensitive mental health category | Medium     | Clear Privacy Policy, no medical claims, disclaimer that it "does not replace professional advice" |
| Users abandon the app after a few days due to forgetting to log     | High       | Consider a gentle local reminder notification (not MVP but should be noted early)                  |
| Poor performance with large data volumes (many years of use)        | Low-Medium | Properly index SQLite columns, paginate when loading history                                       |

---

## 10. Open Questions (to decide before coding)

- Is a local notification to remind users to log their mood daily needed? (Affects the permission requested during onboarding)
- What is the attachment photo size limit before warning the user?
- What is the default language when the app cannot detect the system locale?

---

## Changelog (v1.0 → v1.1)

| Change                                                                | Reason                                                                                                  |
| --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Added measurement footnote to the Crash-free session rate metric (§4) | Metric target existed with no way to measure it in the MVP, since no crash SDK is integrated pre-launch |
