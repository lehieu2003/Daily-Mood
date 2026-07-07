# UI/UX Design Specification (Revised): "Daily Mood: Tracker & Diary"

This document outlines the user interface layout, design tokens, and user experience strategy for building a high-retention, offline-first mobile application. The guiding principle is **frictionless input**: a user must be able to completely log their mood and primary context factors in under **10 seconds**.

---

## 1. Design Tokens & Visual Hierarchy

To foster emotional reflection, the visual layout utilizes soft, low-contrast pastel tones, generous white space, and smooth, playful micro-interactions — **cân bằng với yêu cầu về độ tương phản đủ để đọc được**.

### Color Palettes (Light & Dark Adaptive)

Màu semantic map trực tiếp theo **5 mức mood**. Các mã màu nền (background chip/card) giữ nguyên tông pastel, nhưng **text/icon đặt trên nền màu phải dùng màu tối hơn** để đạt tối thiểu WCAG AA (contrast ratio ≥ 4.5:1 cho text thường, ≥ 3:1 cho text lớn/icon).

| Mood Level    | Score | Emotional Mapping          | Light Mode BG           | Dark Mode BG | Text/Icon trên nền (Light) |
| ------------- | ----- | -------------------------- | ----------------------- | ------------ | -------------------------- |
| **Excellent** | 5     | Radiant, joyful, energized | `#A7F3D0` (Mint)        | `#065F46`    | `#065F46` (Emerald 800)    |
| **Good**      | 4     | Calm, satisfied, stable    | `#BAE6FD` (Sky Pastel)  | `#075985`    | `#075985` (Sky 800)        |
| **Okay**      | 3     | Neutral, passive, routine  | `#FEF08A` (Soft Yellow) | `#854D0E`    | `#854D0E` (Amber 800)      |
| **Bad**       | 2     | Anxious, tired, down       | `#FED7AA` (Soft Orange) | `#9A3412`    | `#9A3412` (Orange 800)     |
| **Awful**     | 1     | Overwhelmed, angry, sad    | `#FCA5A5` (Blush Red)   | `#991B1B`    | `#991B1B` (Red 800)        |

- **Backgrounds:** Light Mode `#F8FAFC` (Slate 50). Dark Mode `#0F172A` (Slate 900).
- **Typography:** `Inter` hoặc `Plus Jakarta Sans`.
- **QA rule:** Chạy kiểm tra contrast (vd. bằng Stark hoặc WebAIM Contrast Checker) cho mọi cặp màu text-trên-nền trước khi merge UI, không chỉ dựa vào cảm quan thiết kế.

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

- **UX Rule:** Tự động gọi `local_auth` (FaceID/Fingerprint) khi màn hình này hiển thị **lần đầu sau khi app vào foreground từ background**, không gọi lại mỗi lần widget rebuild.
- **Chống spam prompt:** Thêm cooldown — nếu biometric thất bại hoặc bị hủy, không tự động bật lại; chờ user chủ động nhấn nút `[Bio]`. Android giới hạn số lần gọi `BiometricPrompt` liên tục, nên tránh trigger tự động lặp lại.
- **App lifecycle:** Chỉ yêu cầu lại xác thực nếu app đã ở background quá một khoảng thời gian cấu hình được (vd. mặc định 1 phút), không phải mỗi lần chuyển tab/app switcher.

---

### Screen B: The Home Dashboard (Main Feed)

**Trạng thái có dữ liệu:**

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

**Trạng thái Empty (chưa có entry nào — quan trọng cho ngày đầu dùng app):**

```text
+------------------------------------------+
| [Settings]     JULY 2026       [Calendar]|
|                                          |
|                                          |
|            (illustration nhẹ nhàng)      |
|         "Chưa có ghi chú tâm trạng nào"  |
|      "Hãy bắt đầu bằng cách nhấn nút +"  |
|                                          |
|                    ↓                     |
|                 (( + ))                  |  <-- Nhấn mạnh bằng animation nhẹ (pulse)
+------------------------------------------+
```

- **UX Rule:** Không hiển thị chart/line trend rỗng gây cảm giác lỗi. Thay vào đó, hiện illustration + copy ngắn khuyến khích hành động đầu tiên.
- Sau khi user có ≥ 3 entries, mới bắt đầu hiển thị Weekly Trend chart (dưới 3 điểm dữ liệu, chart không có ý nghĩa thống kê).

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
|    [ + Photo Image ]  [ 🎤 Record Voice ]|  <-- Thêm nút Ghi âm giọng nói
+------------------------------------------+
```

**Flow chi tiết cho "Add Custom Tag":**

- Khi nhấn `[+ Add Custom Tag]`, hiện bottom sheet nhỏ gồm: ô nhập tên tag (giới hạn **20 ký tự**, không cho emoji để tránh vỡ layout chip-wrap) + dropdown chọn category có sẵn (`Health`, `Life`, hoặc `Other`).
- Tag mới lưu vào bảng `Activities` với cờ `isCustom = true`, để phân biệt với tag mặc định khi hiển thị thống kê sau này.
- Giới hạn tối đa **30 custom tags** để tránh danh sách chip quá dài gây rối UI; khi đạt giới hạn, ẩn nút thêm và hiện gợi ý "Xóa bớt tag ít dùng trong Settings".

**Lưu ý về ảnh đính kèm (mục 4):**

- Ảnh **không lưu dưới dạng blob trong SQLite** — lưu file thực tế vào thư mục local qua `path_provider` (vd. `/app_documents/mood_photos/{entryId}.jpg`), DB chỉ lưu **đường dẫn tương đối** (relative path), không lưu absolute path (tránh vỡ reference khi app update hoặc đổi container ID).
- Khi export/backup JSON, ảnh được đóng gói riêng (zip kèm JSON) hoặc convert base64 nếu file nhỏ — cần quyết định rõ ở Phase 4 (Backup/Restore) để tránh JSON phình to hoặc mất ảnh khi restore.
- Nén ảnh trước khi lưu (vd. resize về max 1080px cạnh dài, quality ~80%) để không làm phình dung lượng app theo thời gian.

**Lưu ý về các tệp tin đa phương tiện đính kèm (Ảnh & Ghi âm):**

- Ảnh và file ghi âm giọng nói **không lưu dưới dạng blob trong SQLite**.
- Toàn bộ file thực tế được lưu vào bộ nhớ cục bộ của sandbox app thông qua `path_provider`:
  - Ảnh: `/app_documents/mood_photos/{uuid}.jpg`
  - File ghi âm: `/app_documents/mood_voices/{uuid}.m4a` hoặc `.mp3`
- Database chỉ lưu **đường dẫn tương đối** (relative path) (Ví dụ: `mood_photos/{uuid}.jpg`, `mood_voices/{uuid}.m4a`) để đảm bảo không bị vỡ liên kết khi hệ điều hành thay đổi ID thư mục container của ứng dụng.
- Khi tiến hành ghi âm, app chỉ cho phép tối đa **3 phút** mỗi bản ghi để tối ưu dung lượng lưu trữ cục bộ.

---

## 3. Micro-Interactions & Animation Guide

- **Mood Selection Scale:** Vuốt/trượt qua các mức mood sẽ scale icon được chọn lên, làm mờ các lựa chọn khác. Màu nền theo accent color của mood được chọn sẽ morph nhẹ nhàng.
- **Tactile Feedback (`HapticFeedback`) — đã điều chỉnh để tránh gây khó chịu:**
  - Chỉ rung nhẹ (`HapticFeedback.selectionClick`) khi selector **dừng lại** ở một mood score, không rung liên tục trong lúc đang vuốt qua từng mức — tránh cảm giác rung dồn dập khi vuốt nhanh.
  - Chip tag: chỉ 1 pulse ngắn khi **kích hoạt** (chọn), không rung khi bỏ chọn, để tránh cảm giác "ồn" khi user tap nhiều chip liên tiếp.
  - Thêm toggle **"Tắt rung phản hồi"** trong Settings cho user không thích haptics.
- **Feed Interpolation:** Dùng `ScaleTransition` hoặc sliding translation khi thêm/xóa journal item để tránh giật màn hình.

---

## 4. UX Anti-Patterns to Avoid

- **No Mandatory Onboarding:** Không bắt tạo profile, nhập email, hay xem tutorial khi mở app lần đầu. Vào thẳng dashboard (ở trạng thái empty state như mô tả ở mục 2).
- **Avoid Text Entry Blocks:** Không đặt textbox trống làm interaction chính. Text chỉ là phần phụ, optional.
- **No Hidden Data Options:** Luôn có khu vực rõ ràng trong Settings để user xóa toàn bộ dữ liệu local hoặc export file, không được giấu sâu trong submenu.
- **(Mới) Tránh Prompt Mệt Mỏi:** Không nên hiện quá nhiều dialog xác nhận liên tiếp (vd. xác nhận xóa → xác nhận lần 2 → toast thông báo) — tối đa 1 lớp xác nhận cho các hành động phá hủy dữ liệu (destructive actions).

---
