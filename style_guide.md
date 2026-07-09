# Style Guide

**Version:** 1.1 (Updated — see changelog at bottom)
**Scope:** Design tokens for Colors & Typography

---

## 1. Colors

### 1.1 UI Colors

Primary colors used for interface elements (buttons, backgrounds, accents).

| Color          | Hex       | Opacity | Swatch |
| -------------- | --------- | ------- | ------ |
| Primary Purple | `#8B4CFC` | 100%    | 🟣     |
| Pink           | `#FAD9E6` | 100%    | 🌸     |
| Lavender       | `#DED7FA` | 100%    | 🔮     |

### 1.2 Chart Colors

A dedicated color set for **generic/analytics charts** (e.g., the activity-correlation chart), using 75% opacity to create a soft feel that doesn't compete with the main content.

> **Scope note:** This 4-color set is for general analytics visuals only. The **Weekly Trend mood chart** does NOT use this palette — it uses the 5-color mood-level palette defined in the UI/UX Spec (§1), so the chart stays visually consistent with the mood chips shown elsewhere in the app. See UI/UX Spec for details.

| Color   | Hex         | Opacity | Swatch | Status                                          |
| ------- | ----------- | ------- | ------ | ----------------------------------------------- |
| "Green" | `#22C55E`\* | 75%     | 🟢     | ⚠️ Proposed fix — pending designer confirmation |
| Red     | `#FF1F11`   | 75%     | 🔴     | Confirmed                                       |
| Blue    | `#3686FF`   | 75%     | 🔵     | Confirmed                                       |
| Orange  | `#FF5C00`   | 75%     | 🟠     | Confirmed                                       |

> \* **Not yet final.** The original export had "Green" mapped to `#8B4CFC` (Primary Purple), which is clearly a naming/export error. `#22C55E` is only a _suggested placeholder_ (a saturated green in a similar style to the other 3 chart colors) — a designer still needs to confirm the intended hex value before this is locked in.

### 1.3 Text Colors

| Color          | Hex       | Opacity | Swatch        | Suggested use case                    |
| -------------- | --------- | ------- | ------------- | ------------------------------------- |
| Text Primary   | `#100F11` | 100%    | ⚫            | Headings, main content                |
| Text Secondary | `#100F11` | 74%     | ⚫ (lighter)  | Secondary content, descriptions       |
| Text Tertiary  | `#100F11` | 64%     | ⚫ (lightest) | Placeholders, captions                |
| Accent Yellow  | `#E8B50E` | 100%    | 🟡            | Emphasis, mild warnings               |
| Accent Red     | `#FC4C4C` | 100%    | 🔴            | Errors, warnings, destructive actions |

### 1.4 Gradient Colors

| Name       | Stops (Hex — Opacity)                                                  | Swatch |
| ---------- | ---------------------------------------------------------------------- | ------ |
| Gradient 1 | `#EED3F2` (100%) → `#EED3F2` (100%)                                    | 🌸     |
| Gradient 2 | `#C3FFD4` (100%) → `#CFCCFB` (100%) → `#EFF9F2` (100%)                 | 🌈     |
| Gradient 3 | `#BACFFF` (67%) → `#FFCEB7` (100%)                                     | 🔵🟠   |
| Gradient 4 | `#D0CFE9` (34%) → `#FFCEB7` (100%) → `#DF2771` (55%) → `#BAE6FF` (67%) | 🌅     |

> Gradient 1 has 2 stops with the same color/opacity — still unconfirmed whether this is intentional (a solid color stored as a 2-point gradient) or whether a stop was lost during export. **Not changed in this revision** — needs designer input, not something that can be safely assumed.

---

## 2. Typography

### 2.1 Font

**Inter** (primary) with **Plus Jakarta Sans** as an approved alternative — used throughout the entire product, for both headings and body text.

> **Changed in this revision:** the previous value, "Pangram," was placeholder demo text left over from a template (it's the standard sample word used to preview typefaces, not a real font family) and conflicted with the UI/UX Spec, which already specified Inter / Plus Jakarta Sans. This has been corrected to match. If a different font was actually intended, update both this file and the UI/UX Spec together so they stay in sync.

### 2.2 Headings

| Level     | Size | Weight |
| --------- | ---- | ------ |
| Heading 1 | 24px | Bold   |
| Heading 2 | 18px | Medium |
| Heading 3 | 14px | Medium |

### 2.3 Body Text

| Level      | Size | Available Weight(s)   |
| ---------- | ---- | --------------------- |
| Sub text 1 | 16px | Regular, Medium, Bold |
| Sub text 2 | 14px | Regular, Medium       |
| Sub text 3 | 12px | Regular               |

---

## 3. Token Usage Guidelines

- **Colors:** Use only the tokens already defined instead of mixing new colors, to ensure consistency across the entire product. For text, use exactly the 3 opacity levels of `#100F11` (100% / 74% / 64%) to convey information hierarchy (primary / secondary / tertiary), rather than creating separate gray colors.
- **Chart colors:** Only use the group of 4 colors from section 1.2 for **generic analytics charts** (see scope note above), keeping the default 75% opacity so charts aren't overly bright when displaying a lot of data at once. The mood trend chart uses the separate mood-level palette instead — see UI/UX Spec.
- **Gradient:** Prefer for decorative areas (card backgrounds, hero sections); avoid using as a background for text since contrast is unstable across the color stops.
- **Typography:** Heading 1–3 are used for content hierarchy structure (page title → section title → sub-section). Sub text 1–3 are used for body content, labels, and captions — choose the weight that fits the level of emphasis needed (Bold for emphasis, Regular for normal content).

---

## 4. Items to Confirm

- [ ] Confirm the final "Green" hex code in Chart colors — `#22C55E` in this revision is a placeholder only, not a confirmed value.
- [ ] Confirm whether Gradient 1 is intentionally 2 stops of the same color, or whether data was lost during export from Figma/design tool.
- [ ] Add contrast checks (WCAG AA) between Text Colors and the actual backgrounds they'll be used on, especially for 64% opacity (Text Tertiary) on light backgrounds.
- [x] ~~Confirm whether the font name "Pangram" is a real font family~~ — Resolved in this revision: replaced with Inter / Plus Jakarta Sans to match the UI/UX Spec.

---

## Changelog (v1.0 → v1.1)

| Change                                                         | Reason                                                                                       |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Font changed from "Pangram" to Inter / Plus Jakarta Sans       | Was placeholder text; conflicted with the UI/UX Spec, which already specified the real fonts |
| Added scope note distinguishing Chart Colors from mood palette | Weekly Trend chart was ambiguous about which color set it should use                         |
| Proposed placeholder hex for "Green" chart color               | Original value duplicated Primary Purple — flagged as unresolved, not silently fixed         |
