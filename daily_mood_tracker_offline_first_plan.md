# 📋Plan: "Daily Mood: Tracker & Diary" (Offline-First, MVP-Focused)

---

## 1. Core Architecture Strategy

- **Privacy Model:** Zero-Knowledge local storage — dữ liệu được **mã hóa tại chỗ** (encryption at rest), không chỉ khóa màn hình bằng PIN/biometric.
- **Data Layer:** Reactive local streaming bằng **Drift (SQLite)**, mã hóa qua **SQLCipher** (package `sqlcipher_flutter_libs` + `drift_sqlcipher` hoặc tương đương).
- **Cloud Synchronization:** Không đưa vào MVP. Giai đoạn đầu chỉ hỗ trợ export/import file thủ công (JSON/CSV) do user tự lưu vào Drive/iCloud qua share sheet hệ thống. Cloud sync tự động sẽ là **Phase 5 (mở rộng)**.

---

## 2. Project Architecture (Feature-First)

```text
lib/
├── app/
│   ├── theme/          # Soft palettes (Pastels), system dark-mode adaptations
│   └── routes/         # GoRouter configurations (Includes Guard for LockScreen)
├── core/
│   ├── database/       # AppDatabase (Drift + SQLCipher), migrations, seed data
│   ├── security/       # Biometrics auth, encryption key management (Keystore/Keychain)
│   └── utils/          # Backup/Restore file handlers, conflict resolution, date extensions
└── features/
    ├── mood_tracker/   # Entry creation, activity tags management, calendar roll
    ├── analytics/      # Local SQL execution calculations for mood charts
    └── settings/       # PIN Setup, export/import JSON, backup history
```

---

## 3. Phased Implementation Roadmap (6 Weeks)

### 🏗️ Phase 1: Local Foundation, Encryption & Reactive DB Setup (Week 1–2)

- **Database Engineering:** Khởi tạo `AppDatabase` bằng Drift, tích hợp **SQLCipher** để mã hóa toàn bộ file `.db` ngay từ đầu (không phải thêm sau).
- **Key Management:** Lưu khóa mã hóa trong Android Keystore / iOS Keychain, không hardcode, không lưu plaintext.
- **Schema:** Viết schema tường minh cho `MoodEntries`, `Activities`, junction table `MoodEntryActivities`.
- **Data Seeding:** Tự động thêm activity tag mặc định (_Work, Exercise, Social, Sleep_) trong `beforeOpen` lifecycle hook.
- **Theme & Design Tokens:** Bảng màu pastel dịu mắt, map 5 màu accent cho 5 mức mood, hỗ trợ light/dark mode.
- **QA checkpoint:** Test DB mã hóa trên cả 2 platform, đảm bảo migration path hoạt động khi schema thay đổi.

### 📝 Phase 2: Frictionless Logging & State Logic (Week 3)

- **Local State Isolation:** `MoodFormCubit` xử lý state tạm (mood score, tag đã chọn, nội dung nhật ký) trước khi ghi DB.
- **10-Second Log Screen:** Carousel/slider chọn nhanh 5 mức mood, grid multi-select cho activity tags, text block ghi nhật ký riêng tư.
- **Main Dashboard:** Danh sách lịch sử theo Drift stream, cập nhật UI ngay khi có log mới.
- **QA checkpoint:** Test flow log entry trên thiết bị thật, kiểm tra hiệu năng khi database có nhiều bản ghi (vd. 1000+ entries).

### 📊 Phase 3: Offline Insights & Analytics (Week 4)

- **Local Metric Calculations:** Query SQL tối ưu trong DAO để tính trung bình mood theo tuần và tương quan giữa activity tag với mood.
- **Visualization Layer:** Dùng `fl_chart` cho line chart xu hướng mood, pie chart phân bố thói quen.
- **Calendar Heatmap:** Tích hợp `table_calendar` hiển thị lưới màu theo tháng.
- **QA checkpoint:** Kiểm tra độ chính xác của các phép tính thống kê với dữ liệu edge-case (ngày thiếu log, mood trùng điểm).

### 🔒 Phase 4: Biometric Lock & Manual Backup/Restore (Week 5)

- **Hardware Security Guard:** Khóa app bằng `local_auth` (FaceID/Fingerprint) hoặc PIN nội bộ.
- **JSON/CSV Export Engine:** Dùng `path_provider` + share sheet hệ thống để user tự xuất file và lưu vào Drive/iCloud/local theo ý họ.
- **Import & Conflict Resolution:** Khi restore, so sánh `updatedAt` timestamp của từng entry:
  - Nếu entry chưa tồn tại → thêm mới.
  - Nếu entry đã tồn tại và file import mới hơn → ghi đè.
  - Nếu file import cũ hơn → giữ nguyên bản hiện tại, log lại các entry bị bỏ qua để user xem.
  - Luôn tạo bản backup tự động trước khi thực hiện import, để có thể rollback nếu restore sai.
- **QA checkpoint:** Test kỹ các tình huống conflict (import file cũ, import trùng lặp, import file hỏng).

### ☁️ Phase 5 (Mở rộng — sau MVP): Cloud Sync Tự Động

- **Android:** Tích hợp `googleapis` để đồng bộ vào `drive.appdata`.
- **iOS:** Map thư mục local vào iCloud Documents để hệ điều hành tự backup.
- Chỉ triển khai sau khi MVP đã có người dùng thật dùng thử và feedback ổn định.

---

## 4. Immediate Tasks to Get Started

1. **Drift + SQLCipher Database Implementation:** Viết cấu trúc database mã hóa, entity models, và seed data mặc định.
2. **Home Dashboard & Slider UI Setup:** Viết cấu trúc UI cho màn hình log-entry slider và các component tương tác chính.

---

## Tóm tắt thay đổi so với bản trước

| Vấn đề               | Bản cũ                      | Bản sửa                                                     |
| -------------------- | --------------------------- | ----------------------------------------------------------- |
| Mã hóa dữ liệu       | Không có, chỉ khóa màn hình | Thêm SQLCipher, đúng nghĩa zero-knowledge                   |
| Timeline             | 4 tuần                      | 6 tuần, có buffer QA                                        |
| Conflict khi restore | Không đề cập                | Có chiến lược theo timestamp + auto-backup trước khi import |
| Cloud sync           | Nằm trong MVP (Phase 4)     | Đẩy ra Phase 5, MVP chỉ export/import thủ công              |
| Testing              | Không có                    | Thêm QA checkpoint cuối mỗi phase                           |
