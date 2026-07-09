# Privacy Policy

## "Daily Mood: Tracker & Diary"

**Version:** 1.1 (Updated — see changelog at bottom)
**Effective Date:** TODO — fill before publication

---

## 1. Summary (Short, Easy to Understand)

**Daily Mood: Tracker & Diary** does not collect, store, or transmit any of your personal data to our servers — simply because **we have no servers storing user data**. All of your journal entries, moods, photos, and notes exist only on your own device, encrypted locally.

---

## 2. What Data Is Created and Where It's Stored

| Data type                                          | Storage location                                                                                                                                                          | Does it leave the device?                                                               |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| Mood score, journal notes                          | Local database (SQLite, encrypted with SQLCipher) on the device                                                                                                           | No                                                                                      |
| Activity tags (default + custom)                   | Local database on the device                                                                                                                                              | No                                                                                      |
| Attached photos                                    | App's private sandbox file folder on the device                                                                                                                           | No                                                                                      |
| Voice recording file (Voice Note)                  | Separate file folder within the app's sandbox on the device                                                                                                               | No — the app only records audio when you actively tap the Mic button in the interface   |
| PIN / biometric data                               | PIN is hashed and stored in Keystore (Android) / Keychain (iOS); biometrics are processed entirely by the OS — the app never receives or stores raw fingerprint/face data | No — the app has no access to raw biometric data                                        |
| Backup file (JSON/CSV) when you actively export it | You choose where to save it (Google Drive, iCloud, device storage, sending via another app, etc.)                                                                         | Only when and where **you choose** to save it — outside the app's control once exported |

> **Formatting fix (this revision):** the Voice Note row was previously broken out into a stray heading fragment below the table instead of being a proper row inside it, which meant it likely wasn't rendering as part of the table. It's now merged in correctly above.

---

## 3. What We Do NOT Do

- We do not require account creation, and do not collect email, phone number, or any identifying information.
- There is no backend server that receives or stores user data.
- We do not share, sell, or give third parties access to your journal/mood data.
- We do not insert ads, and we do not use ad SDKs or third-party tracking (Facebook SDK, Google Ads SDK, etc.).
- We do not automatically sync data to any cloud without an explicit export action from you.

---

## 4. Analytics & Crash Reporting (If Applicable, Must Be Opt-in)

If the app integrates stability-measurement tools (e.g., crash reporting) or anonymous usage statistics in later versions:

- Default is **off (opt-out by default)** — users must actively enable it in Settings if they want it.
- Any data collected (if enabled) will **never** include: journal content, photos, specific daily mood scores, or any personal content.
- Anonymous data may include: number of app crashes, OS version, device type (for technical debugging) — none of it tied to user identity.

> **Current MVP status:** No analytics/crash reporting has been integrated yet. This section applies if added in a later version, and the policy will be updated with clear in-app notice before activation. (See PRD §4 for how the crash-free-rate goal is measured in the meantime, via store-provided crash data rather than an in-app SDK.)

---

## 5. Your Rights Over Your Data

Since all data resides on your device, you have full rights to:

- **View** all your data directly in the app, without restriction.
- **Export** any data at any time in JSON/CSV format, readable outside the app.
- **Delete** all data permanently via the "Delete All Data" function in Settings — this action cannot be undone since there is no server-side copy to restore from.
- **Uninstall** the app to completely remove data from the device (unless you have enabled OS-level system backup such as iCloud Backup or Android Auto Backup — see section 6).

---

## 6. Note on OS-Level Backup (iOS/Android)

- If you enable **iCloud Backup** or **Google Backup** at the OS level (not an app-specific feature), the app's data **may** be included in that system backup, depending on your configuration.
- That backup is performed and secured by Apple/Google under their own respective policies, outside the control of "Daily Mood: Tracker & Diary."
- You can disable this feature specifically for the app in System Settings if you want your data to absolutely never leave the physical device.

---

## 7. Data Security

- The entire database is encrypted locally using SQLCipher (AES-256).
- The encryption key is stored in Android Keystore / iOS Keychain — never stored as plaintext, never hardcoded in source code.
- The app can be locked with a PIN or biometrics (FaceID/TouchID/Fingerprint) — an additional protection layer at the application level.
- Despite these measures, no system is 100% absolutely secure; users should protect their own device (screen lock, regular OS updates).
- Regarding Microphone permission: The app will request access to the device's microphone. This permission is only activated and used when you actively tap the "Voice Journal Recording" feature. Audio files are recorded and stored entirely locally on your device, and are never sent to any server.

---

## 8. Intended Users & Limitations on Health Content

- The app is intended for **personal self-tracking purposes**, and is not a diagnostic or medical/psychological treatment tool.
- The app **does not replace** consultation from medical professionals, psychologists, or psychiatrists.
- If you are experiencing a mental health crisis or having thoughts of self-harm, please contact emergency support hotlines in your area or a qualified professional immediately.
- The app is recommended not to be used independently by children under 13 (or the minimum age per local law) without parental supervision, due to the personal/journaling nature of its content.

---

## 9. Policy Changes

If this policy changes (e.g., when adding cloud sync features in a later version), we will:

- Clearly notify users in-app before the new feature takes effect.
- Require opt-in consent if the change involves data starting to leave the device (e.g., enabling cloud sync).
- Update the effective date at the top of this document.

---

## 10. Contact

If you have questions about this privacy policy, please contact: TODO — fill in the official support email or support channel before publication.

---

## Checklist Before Official Publication (for the dev/product team)

- [ ] Have a lawyer/compliance expert review this draft.
- [ ] Fill in the [effective date] and [contact information].
- [ ] Check the specific requirements of the App Store (Apple Privacy Nutrition Label) and Google Play (Data Safety section) — both require detailed disclosure of data types processed, even when only stored locally.
- [ ] Confirm the app does not use any third-party SDK that silently collects data (carefully check packages such as crash reporting, ad SDKs if added later).
- [ ] If targeting the Vietnamese market: cross-check against Decree 13/2023/NĐ-CP on personal data protection.
- [ ] If targeting the EU market: cross-check against GDPR (especially the "right to erasure" — the app already satisfies this via the local data deletion function).

---

## Changelog (this revision)

| Change                                                        | Reason                                                                                                             |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Merged the Voice Note row into the main data table (§2)       | Was previously a broken standalone line (`## \| ... \|`) sitting outside the table, likely not rendering correctly |
| Added cross-reference to PRD §4 in the analytics section (§4) | Connects the "no crash SDK in MVP" statement here to how that metric gets measured in practice                     |
