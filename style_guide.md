# Style Guide

**Version:** 1.0
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

A dedicated color set for charts, using 75% opacity to create a soft feel that doesn't compete with the main content.

| Color  | Hex       | Opacity | Swatch |
| ------ | --------- | ------- | ------ |
| Green  | `#8B4CFC` | 75%     | 🟢     |
| Red    | `#FF1F11` | 75%     | 🔴     |
| Blue   | `#3686FF` | 75%     | 🔵     |
| Orange | `#FF5C00` | 75%     | 🟠     |

> Note: the hex code for "Green" matches Primary Purple (`#8B4CFC`) in the original table — this should be double-checked to see whether it's a mistake from exporting out of the design tool, since the name says "Green" but the hex value is purple.

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

> Gradient 1 has 2 stops with the same color/opacity — needs confirmation on whether this is intentional (a solid color stored as a 2-point gradient) or whether a stop was lost during export.

---

## 2. Typography

### 2.1 Font

**Pangram** — the primary typeface used throughout the entire product, for both headings and body text.

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
- **Chart colors:** Only use the group of 4 colors from section 1.2 for charts, keeping the default 75% opacity so charts aren't overly bright when displaying a lot of data at once.
- **Gradient:** Prefer for decorative areas (card backgrounds, hero sections); avoid using as a background for text since contrast is unstable across the color stops.
- **Typography:** Heading 1–3 are used for content hierarchy structure (page title → section title → sub-section). Sub text 1–3 are used for body content, labels, and captions — choose the weight that fits the level of emphasis needed (Bold for emphasis, Regular for normal content).

---

## 4. Items to Confirm

- [ ] Confirm the "Green" hex code in Chart colors (currently duplicates Primary Purple).
- [ ] Confirm whether Gradient 1 is intentionally 2 stops of the same color, or whether data was lost during export from Figma/design tool.
- [ ] Add contrast checks (WCAG AA) between Text Colors and the actual backgrounds they'll be used on, especially for 64% opacity (Text Tertiary) on light backgrounds.
- [ ] Confirm whether the font name "Pangram" is an actual font family (Google Fonts/Adobe Fonts) or just placeholder demo text ("Pangram" is commonly used as sample text to preview a font, not a font name itself) — fill in the official font name if different.
