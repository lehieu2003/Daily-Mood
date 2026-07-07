# Style Guide

**Version:** 1.0
**Phạm vi:** Design tokens cho Colors & Typography

---

## 1. Colors

### 1.1 UI Colors

Màu chính dùng cho các thành phần giao diện (buttons, backgrounds, accents).

| Màu            | Hex       | Opacity | Swatch |
| -------------- | --------- | ------- | ------ |
| Primary Purple | `#8B4CFC` | 100%    | 🟣     |
| Pink           | `#FAD9E6` | 100%    | 🌸     |
| Lavender       | `#DED7FA` | 100%    | 🔮     |

### 1.2 Chart Colors

Bộ màu dành riêng cho biểu đồ, dùng độ mờ 75% để tạo cảm giác nhẹ nhàng, không cạnh tranh với nội dung chính.

| Màu    | Hex       | Opacity | Swatch |
| ------ | --------- | ------- | ------ |
| Green  | `#8B4CFC` | 75%     | 🟢     |
| Red    | `#FF1F11` | 75%     | 🔴     |
| Blue   | `#3686FF` | 75%     | 🔵     |
| Orange | `#FF5C00` | 75%     | 🟠     |

> Lưu ý: mã hex của "Green" trùng với Primary Purple (`#8B4CFC`) trong bảng gốc — nên kiểm tra lại xem đây có phải nhầm lẫn khi export từ design tool không, vì tên gọi "Green" nhưng mã hex lại là tím.

### 1.3 Text Colors

| Màu            | Hex       | Opacity | Swatch         | Use case gợi ý                    |
| -------------- | --------- | ------- | -------------- | --------------------------------- |
| Text Primary   | `#100F11` | 100%    | ⚫             | Tiêu đề, nội dung chính           |
| Text Secondary | `#100F11` | 74%     | ⚫ (nhạt hơn)  | Nội dung phụ, mô tả               |
| Text Tertiary  | `#100F11` | 64%     | ⚫ (nhạt nhất) | Placeholder, caption              |
| Accent Yellow  | `#E8B50E` | 100%    | 🟡             | Nhấn mạnh, cảnh báo nhẹ           |
| Accent Red     | `#FC4C4C` | 100%    | 🔴             | Lỗi, cảnh báo, destructive action |

### 1.4 Gradient Colors

| Tên        | Stops (Hex — Opacity)                                                  | Swatch |
| ---------- | ---------------------------------------------------------------------- | ------ |
| Gradient 1 | `#EED3F2` (100%) → `#EED3F2` (100%)                                    | 🌸     |
| Gradient 2 | `#C3FFD4` (100%) → `#CFCCFB` (100%) → `#EFF9F2` (100%)                 | 🌈     |
| Gradient 3 | `#BACFFF` (67%) → `#FFCEB7` (100%)                                     | 🔵🟠   |
| Gradient 4 | `#D0CFE9` (34%) → `#FFCEB7` (100%) → `#DF2771` (55%) → `#BAE6FF` (67%) | 🌅     |

> Gradient 1 có 2 stop cùng màu/cùng opacity — cần xác nhận lại đây có đúng chủ ý thiết kế (solid color được lưu dưới dạng gradient 2 điểm) hay bị thiếu 1 stop khi export.

---

## 2. Typography

### 2.1 Font

**Pangram** — kiểu chữ chính dùng xuyên suốt toàn bộ sản phẩm, cho cả heading và body text.

### 2.2 Headings

| Level     | Size | Weight |
| --------- | ---- | ------ |
| Heading 1 | 24px | Bold   |
| Heading 2 | 18px | Medium |
| Heading 3 | 14px | Medium |

### 2.3 Body Text

| Level      | Size | Weight(s) khả dụng    |
| ---------- | ---- | --------------------- |
| Sub text 1 | 16px | Regular, Medium, Bold |
| Sub text 2 | 14px | Regular, Medium       |
| Sub text 3 | 12px | Regular               |

---

## 3. Cách sử dụng token

- **Colors:** Dùng đúng token đã định nghĩa thay vì tự pha màu mới, để đảm bảo tính nhất quán qua toàn bộ sản phẩm. Với text, dùng đúng 3 cấp độ opacity của `#100F11` (100% / 74% / 64%) để thể hiện thứ bậc thông tin (primary / secondary / tertiary), thay vì tạo thêm màu xám riêng.
- **Chart colors:** Chỉ dùng nhóm 4 màu ở mục 1.2 cho biểu đồ, giữ opacity 75% mặc định để chart không bị chói khi hiển thị nhiều dữ liệu cùng lúc.
- **Gradient:** Ưu tiên dùng cho khu vực trang trí (background card, hero section), tránh dùng làm nền cho text vì độ tương phản không ổn định giữa các điểm dừng màu.
- **Typography:** Heading 1–3 dùng cho cấu trúc phân cấp nội dung (page title → section title → sub-section). Sub text 1–3 dùng cho nội dung thân bài, nhãn, và chú thích — chọn weight phù hợp với mức độ nhấn mạnh cần thiết (Bold cho nhấn mạnh, Regular cho nội dung thông thường).

---

## 4. Việc cần xác nhận thêm

- [ ] Xác nhận lại mã hex "Green" trong Chart color (hiện đang trùng với Primary Purple).
- [ ] Xác nhận Gradient 1 có đúng là 2 stop cùng màu, hay bị thiếu dữ liệu khi export từ Figma/design tool.
- [ ] Bổ sung kiểm tra contrast (WCAG AA) giữa các Text Colors và nền thực tế sẽ dùng, đặc biệt với opacity 64% (Text Tertiary) trên nền sáng.
- [ ] Xác nhận tên font "Pangram" là font family thật (Google Fonts/Adobe Fonts) hay chỉ là placeholder demo text ("Pangram" thường được dùng làm câu ví dụ hiển thị font, không phải tên font) — cần điền tên font chính thức nếu khác.
