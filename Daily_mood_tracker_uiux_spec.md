# UI/UX Design Specification (Revised): "Daily Mood: Tracker & Diary"

This document outlines the user interface layout, design tokens, and user experience strategy for building a high-retention, offline-first mobile application. The guiding principle is **frictionless input**: a user must be able to completely log their mood and primary context factors in under **10 seconds**.

---

## 1. Design Tokens & Visual Hierarchy

To foster emotional reflection, the visual layout utilizes soft, low-contrast pastel tones, generous white space, and smooth, playful micro-interactions — **balanced against the requirement for sufficient readability contrast**.

### Color Palettes (Light & Dark Adaptive)

Semantic colors map directly to the **5 mood levels**. The background colors (chip/card background) keep a pastel tone, but **text/icons placed on colored backgrounds must use a darker color** to achieve at least WCAG AA (contrast ratio ≥ 4.5:1 for normal text, ≥ 3:1 for large text/icons).

| Mood Level    | Score | Emotional Mapping          | Light Mode BG           | Dark Mode BG | Text/Icon on background (Light) |
| ------------- | ----- | -------------------------- | ----------------------- | ------------ | ------------------------------- |
| **Excellent** | 5     | Radiant, joyful, energized | `#A7F3D0` (Mint)        | `#065F46`    | `#065F46` (Emerald 800)         |
| **Good**      | 4     | Calm, satisfied, stable    | `#BAE6FD` (Sky Pastel)  | `#075985`    | `#075985` (Sky 800)             |
| **Okay**      | 3     | Neutral, passive, routine  | `#FEF08A` (Soft Yellow) | `#854D0E`    | `#854D0E` (Amber 800)           |
| **Bad**       | 2     | Anxious, tired, down       | `#FED7AA` (Soft Orange) | `#9A3412`    | `#9A3412` (Orange 800)          |
| **Awful**     | 1     | Overwhelmed, angry, sad    | `#FCA5A5` (Blush Red)   | `#991B1B`    | `#991B1B` (Red 800)             |

- **Backgrounds:** Light Mode `#F8FAFC` (Slate 50). Dark Mode `#0F172A` (Slate 900).
- **Typography:** `Inter` or `Plus Jakarta Sans`.
- **QA rule:** Run contrast checks (e.g., using Stark or the WebAIM Contrast Checker) on every text-on-background color pair before merging UI, rather than relying solely on visual judgment.

---

## 2. Key Screen Mockup Layouts

### Screen A: The Passcode / Biometric Guard (Launch View)

```text
+------------------------------------------+
|                                          |
|                 [ Logo ]                 |
|                Daily Mood                |
|                                          |
|            Enter Passcode PIN            |
|                                          |
|                 O  O  O  O               |
|                                          |
|               1     2     3              |
|               4     5     6              |
|               7     8     9              |
|            [Bio]    0    [Del]           |
|                                          |
+------------------------------------------+
```

- **UX Rule:** Automatically trigger `local_auth` (FaceID/Fingerprint) when this screen is displayed for the **first time after the app comes to the foreground from the background**, not every time the widget rebuilds.
- **Prevent prompt spam:** Add a cooldown — if biometric auth fails or is cancelled, do not automatically retrigger it; wait for the user to actively tap the `[Bio]` button. Android limits the number of consecutive `BiometricPrompt` calls, so avoid repeated automatic triggers.
- **App lifecycle:** Only require re-authentication if the app has been in the background longer than a configurable time period (e.g., default 1 minute), not every time the user switches tabs/apps.

---

### Screen B: The Home Dashboard (Main Feed)

**State with data:**

```text
+------------------------------------------+
| [Settings]     JULY 2026       [Calendar]|
|                                          |
|  Weekly Trend                            |
|  (Line Chart: Mon -> Sun)                |
|   /\_/\                                  |
|  /     \__/\                             |
|                                          |
|  Today's Entry                           |
|  +-------------------------------------+ |
|  | [Excellent] 09:30 AM                | |
|  | "Had a fantastic coding run!"       | |
|  | Chips: [Work] [Exercise]            | |
|  +-------------------------------------+ |
|                                          |
|  Yesterday's Entry                       |
|  +-------------------------------------+ |
|  | [Okay] July 5                       | |
|  | Chips: [Social] [Sleep]             | |
|  +-------------------------------------+ |
|                                          |
|                 (( + ))                  |  <-- Floating Quick-Add Button
+------------------------------------------+
```

**Empty state (no entries yet — important for the first day of app use):**

```text
+------------------------------------------+
| [Settings]     JULY 2026       [Calendar]|
|                                          |
|                                          |
|            (gentle illustration)         |
|         "No mood entries yet"            |
|      "Start by tapping the + button"     |
|                                          |
|                    ↓                     |
|                 (( + ))                  |  <-- Emphasized with a subtle pulse animation
+------------------------------------------+
```

- **UX Rule:** Do not display an empty chart/trend line, as it creates a sense of something being broken. Instead, show an illustration + short copy encouraging the first action.
- Only start showing the Weekly Trend chart once the user has ≥ 3 entries. With fewer than 3 data points, a chart carries no statistical meaning.

---

### Screen C: The 10-Second Quick-Log Screen (Form View)

```text
+------------------------------------------+
| [Cancel]       New Entry          [Done] |
|                                          |
| 1. How are you feeling?                  |
|    ( (Awful) (Bad) (Okay) (Good) (Excel) )  <-- Interactive Carousel
|                                          |
| 1b. More details about this mood?        |
|    ( [Excited] ) [Confused] [Guilty]     |  <-- Sub-Emotions Grid
|    [Anxious] ( [Proud] ) [Disappointed]  |  <-- (Active choices are filled)
|                                          |
| 2. What have you been up to?             |
|    [+ Add Custom Tag]                    |
|    ( [Exercise] ) [Sleep] [Work] [Family]|  <-- Multi-Select Filter Chips
|                                          |
| 3. Write about your day (Optional)       |
|    [ Type your private journal notes... ]|
|                                          |
| 4. Attach Media (Optional)               |
|    [ + Photo Image ]  [ 🎤 Record Voice ]|  <-- Added Voice Recording button
+------------------------------------------+
```

**Detailed flow for "Add Custom Tag":**

- When `[+ Add Custom Tag]` is tapped, a small bottom sheet appears with: a text input for the tag name (limited to **20 characters**, no emoji allowed to avoid breaking chip-wrap layout) + a dropdown to select an existing category (`Health`, `Life`, or `Other`).
- The new tag is saved to the `Activities` table with the `isCustom = true` flag, to distinguish it from default tags when later displayed in statistics.
- Maximum limit of **30 custom tags** to prevent an overly long chip list from cluttering the UI; when the limit is reached, hide the add button and show a suggestion: "Remove some rarely-used tags in Settings."

**Note on attached photos (item 4):**

- Photos are **not stored as a blob in SQLite** — the actual file is saved to a local folder via `path_provider` (e.g., `/app_documents/mood_photos/{entryId}.jpg`), with the DB only storing the **relative path**, not the absolute path (to avoid broken references when the app updates or the container ID changes).
- When exporting/backing up to JSON, photos are packaged separately (zipped alongside the JSON) or converted to base64 if the file is small — this needs to be clearly decided in Phase 4 (Backup/Restore) to avoid a bloated JSON or lost photos during restore.
- Compress photos before saving (e.g., resize to max 1080px on the long edge, ~80% quality) to avoid the app's storage footprint growing over time.

**Note on attached media files (Photos & Voice Recordings):**

- Photos and voice recording files are **not stored as blobs in SQLite**.
- All actual files are stored in the app's local sandbox storage via `path_provider`:
  - Photos: `/app_documents/mood_photos/{uuid}.jpg`
  - Voice recordings: `/app_documents/mood_voices/{uuid}.m4a` or `.mp3`
- The database only stores the **relative path** (e.g., `mood_photos/{uuid}.jpg`, `mood_voices/{uuid}.m4a`) to ensure links don't break when the OS changes the app's container folder ID.
- When recording, the app allows a maximum of **3 minutes** per recording to optimize local storage usage.

---

## 3. Micro-Interactions & Animation Guide

- **Mood Selection Scale:** Swiping/sliding through mood levels scales up the selected icon while dimming the other options. The background color morphs smoothly to the accent color of the selected mood.
- **Tactile Feedback (`HapticFeedback`) — adjusted to avoid annoyance:**
  - Only vibrate lightly (`HapticFeedback.selectionClick`) when the selector **stops** on a mood score, not continuously while swiping through each level — to avoid a jarring rapid-fire vibration feeling when swiping quickly.
  - Tag chip: only a single short pulse when **activated** (selected), no vibration when deselected, to avoid a "noisy" feeling when the user taps multiple chips in a row.
  - Add a **"Turn off haptic feedback"** toggle in Settings for users who don't like haptics.
- **Feed Interpolation:** Use `ScaleTransition` or a sliding translation when adding/removing journal items to avoid screen jank.

---

## 4. UX Anti-Patterns to Avoid

- **No Mandatory Onboarding:** Do not force profile creation, email entry, or a tutorial when the app is first opened. Go straight to the dashboard (in the empty state described in section 2).
- **Avoid Text Entry Blocks:** Do not make an empty textbox the primary interaction. Text is only a secondary, optional part.
- **No Hidden Data Options:** Always have a clearly visible area in Settings for the user to delete all local data or export a file — it should never be buried deep in a submenu.
- **(New) Avoid Confirmation Fatigue:** Do not show too many consecutive confirmation dialogs (e.g., confirm delete → confirm again → toast notification) — maximum of 1 confirmation layer for destructive actions.

---
