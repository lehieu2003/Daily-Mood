# Product Requirements Document (PRD)

## "Daily Mood: Tracker & Diary"

**Version:** 1.0
**Status:** Draft — MVP
**Loại sản phẩm:** Mobile app (iOS + Android), Offline-First

---

## 1. Tầm nhìn sản phẩm (Vision)

Một ứng dụng nhật ký tâm trạng riêng tư, không cần tài khoản, không server, giúp người dùng ghi lại cảm xúc hằng ngày trong **dưới 10 giây** và nhìn thấy được xu hướng cảm xúc của bản thân theo thời gian — mà không phải đánh đổi quyền riêng tư.

**Điểm khác biệt cốt lõi:** Zero-Knowledge, 100% offline, không quảng cáo, không theo dõi hành vi.

---

## 2. Vấn đề cần giải quyết (Problem Statement)

- Nhiều app mood tracker hiện tại yêu cầu tạo tài khoản, gửi dữ liệu lên cloud của họ, hoặc có quảng cáo/theo dõi hành vi — gây e ngại vì dữ liệu tâm trạng, nhật ký là thông tin rất nhạy cảm.
- Việc ghi nhật ký cảm xúc truyền thống (viết tay, note app) không có cấu trúc để nhìn ra xu hướng hoặc mối liên hệ giữa hoạt động và cảm xúc.
- Friction cao (phải mở app, đăng nhập, viết dài dòng) khiến user bỏ cuộc sau vài ngày.

---

## 3. Đối tượng người dùng (Target Users)

| Persona                                  | Mô tả                                                                             | Nhu cầu chính                                                   |
| ---------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **Người tự theo dõi sức khỏe tinh thần** | 20-40 tuổi, quan tâm đến wellness, có thể đang trị liệu hoặc tự quan sát bản thân | Cần dữ liệu để trao đổi với therapist hoặc tự nhận diện pattern |
| **Người bận rộn muốn ghi nhanh**         | Không có thời gian viết nhật ký dài, muốn 1 thao tác nhanh mỗi ngày               | Cần tốc độ, tối thiểu số bước                                   |
| **Người coi trọng privacy**              | Không muốn dữ liệu cá nhân rời khỏi thiết bị dưới bất kỳ hình thức nào            | Cần cam kết rõ ràng về zero-knowledge, không tài khoản          |

---

## 4. Mục tiêu & Success Metrics

| Mục tiêu                 | Chỉ số đo                                | Ngưỡng kỳ vọng (3 tháng sau launch)   |
| ------------------------ | ---------------------------------------- | ------------------------------------- |
| Giữ chân người dùng      | D7 Retention                             | ≥ 25%                                 |
| Giữ chân người dùng      | D30 Retention                            | ≥ 10%                                 |
| Mức độ dùng thường xuyên | Số entry trung bình/user/tuần            | ≥ 4 entries                           |
| Tốc độ log               | Thời gian trung bình để hoàn tất 1 entry | ≤ 10 giây (không tính phần viết note) |
| Trải nghiệm ổn định      | Crash-free session rate                  | ≥ 99.5%                               |
| Tin cậy dữ liệu          | Số ca mất dữ liệu do lỗi backup/restore  | 0                                     |

> Lưu ý: vì app không có server, các chỉ số trên chỉ đo được nếu có lớp analytics local-optional (xem mục 8), tuân thủ nguyên tắc privacy-first (opt-in, ẩn danh).

---

## 5. Phạm vi MVP (In Scope)

- Ghi mood theo 5 mức, kèm activity tags (mặc định + custom).
- Ghi chú văn bản tự do (optional) và ảnh đính kèm (optional).
- Dashboard xem lịch sử, biểu đồ xu hướng tuần, calendar heatmap tháng.
- Khóa app bằng PIN hoặc biometric.
- Mã hóa dữ liệu tại chỗ (SQLCipher).
- Export/Import dữ liệu thủ công (JSON/CSV) qua share sheet hệ thống.
- Dark mode / Light mode tự động theo hệ thống.

## 6. Ngoài phạm vi MVP (Out of Scope — để version sau)

- Đồng bộ cloud tự động (Google Drive / iCloud).
- Nhắc nhở thông minh (smart reminder dựa trên pattern dùng app).
- Chia sẻ dữ liệu với therapist/bên thứ ba.
- Widget màn hình chính (home screen widget).
- Đa ngôn ngữ (MVP chỉ tiếng Việt + tiếng Anh).
- Đăng nhập / tài khoản dưới bất kỳ hình thức nào.

---

## 7. User Stories chính

1. **Là một người dùng mới**, tôi muốn mở app và log mood ngay lập tức mà không cần tạo tài khoản, để tôi bắt đầu dùng mà không có rào cản.
2. **Là một người dùng hằng ngày**, tôi muốn log mood trong dưới 10 giây, để việc ghi nhật ký không trở thành gánh nặng.
3. **Là một người dùng quan tâm privacy**, tôi muốn đặt PIN/biometric để khóa app, để người khác không đọc được nhật ký của tôi nếu cầm điện thoại của tôi.
4. **Là một người dùng lâu năm**, tôi muốn xem biểu đồ xu hướng mood theo tuần/tháng, để tôi nhận ra pattern cảm xúc của mình.
5. **Là một người dùng lâu năm**, tôi muốn xem hoạt động nào tương quan với mood tốt/xấu, để tôi điều chỉnh thói quen.
6. **Là một người dùng muốn backup**, tôi muốn export toàn bộ dữ liệu ra file, để tôi tự lưu trữ theo ý mình (Drive, iCloud, máy tính...).
7. **Là một người dùng đổi điện thoại**, tôi muốn import lại file backup, để không mất lịch sử nhật ký cũ.
8. **Là một người dùng muốn xóa dữ liệu**, tôi muốn có nút xóa toàn bộ dữ liệu rõ ràng trong Settings, để tôi kiểm soát hoàn toàn thông tin của mình.

---

## 8. Cân nhắc về Privacy & Analytics

- Không thu thập dữ liệu cá nhân, không có server backend.
- Nếu có analytics (đo retention, crash report), phải là **opt-in rõ ràng**, ẩn danh hoàn toàn, không gắn với nội dung nhật ký. Đề xuất dùng công cụ crash-only (vd. Sentry ở chế độ không thu thập PII) thay vì full analytics SDK.
- Chi tiết đầy đủ nằm trong tài liệu **Privacy Policy** riêng.

---

## 9. Rủi ro & Giả định

| Rủi ro                                                          | Mức độ          | Giảm thiểu                                                                              |
| --------------------------------------------------------------- | --------------- | --------------------------------------------------------------------------------------- |
| Mất dữ liệu khi restore sai                                     | Cao             | Auto-backup trước khi import, chiến lược conflict theo timestamp (xem Data Model doc)   |
| App bị từ chối lên store vì category sức khỏe tâm thần nhạy cảm | Trung bình      | Privacy Policy rõ ràng, không claim y tế, disclaimer "không thay thế tư vấn chuyên môn" |
| User bỏ app sau vài ngày vì quên log                            | Cao             | Cân nhắc local notification nhắc nhở nhẹ nhàng (không phải MVP nhưng nên note sớm)      |
| Hiệu năng kém khi dữ liệu lớn (nhiều năm sử dụng)               | Thấp-Trung bình | Index hóa đúng cột trong SQLite, phân trang khi load lịch sử                            |

---

## 10. Câu hỏi mở (cần quyết định trước khi code)

- Có cần local notification nhắc log mood hằng ngày không? (Ảnh hưởng đến permission yêu cầu lúc onboarding)
- Giới hạn dung lượng ảnh đính kèm là bao nhiêu trước khi cảnh báo user?
- Ngôn ngữ mặc định là gì khi app không detect được locale hệ thống?
