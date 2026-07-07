# Chính sách quyền riêng tư (Privacy Policy)

## "Daily Mood: Tracker & Diary"

**Có hiệu lực từ:** [Điền ngày phát hành chính thức]
**Phiên bản:** 1.0 — Draft, cần luật sư/chuyên gia pháp lý rà soát trước khi công bố chính thức

> ⚠️ **Lưu ý quan trọng:** Đây là bản nháp kỹ thuật dựa trên kiến trúc thực tế của app, dùng làm cơ sở soạn thảo. Đây **không phải** tư vấn pháp lý. Trước khi publish lên App Store/Google Play, nên có luật sư hoặc chuyên gia privacy compliance rà soát lại, đặc biệt nếu app nhắm đến thị trường có luật riêng (GDPR - Châu Âu, CCPA - California, Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân - Việt Nam).

---

## 1. Tóm tắt (Ngắn gọn, dễ hiểu)

**Daily Mood: Tracker & Diary** không thu thập, không lưu trữ, và không truyền bất kỳ dữ liệu cá nhân nào của bạn lên máy chủ của chúng tôi — vì đơn giản là **chúng tôi không có máy chủ nào lưu dữ liệu người dùng**. Toàn bộ nhật ký, mood, ảnh, và ghi chú của bạn chỉ tồn tại trên chính thiết bị của bạn, được mã hóa tại chỗ.

---

## 2. Dữ liệu nào được tạo ra và lưu ở đâu

| Loại dữ liệu                                   | Nơi lưu trữ                                                                                                                                                                   | Có rời khỏi thiết bị không?                                                                |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Mood score, ghi chú nhật ký                    | Database local (SQLite, mã hóa bằng SQLCipher) trên thiết bị                                                                                                                  | Không                                                                                      |
| Activity tags (mặc định + tự tạo)              | Database local trên thiết bị                                                                                                                                                  | Không                                                                                      |
| Ảnh đính kèm                                   | Thư mục file riêng trong sandbox app trên thiết bị                                                                                                                            | Không                                                                                      |
| PIN / dữ liệu sinh trắc học                    | PIN được hash và lưu trong Keystore (Android) / Keychain (iOS); sinh trắc học được xử lý hoàn toàn bởi hệ điều hành, app không bao giờ nhận hay lưu dữ liệu vân tay/khuôn mặt | Không — app không có quyền truy cập dữ liệu sinh trắc học gốc                              |
| File backup (JSON/CSV) khi bạn chủ động export | Do bạn chọn nơi lưu (Google Drive, iCloud, bộ nhớ máy, gửi qua app khác...)                                                                                                   | Chỉ khi và nơi **bạn tự chọn** để lưu — nằm ngoài phạm vi kiểm soát của app sau khi export |

## | File ghi âm giọng nói (Voice Note) | Thư mục file biệt lập trong sandbox app trên thiết bị | Không | Ứng dụng chỉ ghi âm khi bạn chủ động nhấn nút Mic trên giao diện. |

## 3. Chúng tôi KHÔNG làm gì

- Không yêu cầu tạo tài khoản, không thu thập email, số điện thoại, hay bất kỳ thông tin định danh nào.
- Không có server backend nhận hay lưu trữ dữ liệu người dùng.
- Không chia sẻ, bán, hoặc cho bên thứ ba truy cập dữ liệu nhật ký/mood của bạn.
- Không chèn quảng cáo, không dùng SDK quảng cáo hay tracking bên thứ ba (Facebook SDK, Google Ads SDK...).
- Không tự động đồng bộ dữ liệu lên bất kỳ cloud nào mà không có hành động export rõ ràng từ bạn.

---

## 4. Analytics & Crash Reporting (Nếu có, phải Opt-in)

Nếu ứng dụng có tích hợp công cụ đo lường sự ổn định (vd. crash reporting) hoặc thống kê sử dụng ẩn danh ở các phiên bản sau:

- Mặc định **tắt (opt-out by default)**, người dùng phải chủ động bật trong Settings nếu muốn.
- Dữ liệu thu thập (nếu có) sẽ **không bao giờ** bao gồm: nội dung nhật ký, ảnh, mood score cụ thể theo ngày, hay bất kỳ nội dung cá nhân nào.
- Dữ liệu ẩn danh có thể bao gồm: số lần app crash, phiên bản OS, loại thiết bị (để debug kỹ thuật) — không gắn với danh tính người dùng.

> **Trạng thái MVP hiện tại:** Chưa tích hợp analytics/crash reporting nào. Mục này áp dụng nếu được bổ sung ở version sau, và chính sách sẽ được cập nhật + thông báo rõ trong app trước khi kích hoạt.

---

## 5. Quyền của bạn đối với dữ liệu

Vì toàn bộ dữ liệu nằm trên thiết bị của bạn, bạn có toàn quyền:

- **Xem** toàn bộ dữ liệu trực tiếp trong app, không giới hạn.
- **Xuất (Export)** dữ liệu bất kỳ lúc nào dưới định dạng JSON/CSV, có thể đọc được ngoài app.
- **Xóa** toàn bộ dữ liệu vĩnh viễn thông qua chức năng "Xóa toàn bộ dữ liệu" trong Settings — hành động này không thể hoàn tác vì không có bản sao nào trên server để khôi phục.
- **Gỡ ứng dụng** để xóa hoàn toàn dữ liệu khỏi thiết bị (trừ khi bạn đã bật backup hệ thống như iCloud Backup hoặc Android Auto Backup ở cấp hệ điều hành — xem mục 6).

---

## 6. Lưu ý về Backup cấp Hệ điều hành (iOS/Android)

- Nếu bạn bật **iCloud Backup** hoặc **Google Backup** ở cấp hệ điều hành (không phải tính năng riêng của app), dữ liệu app **có thể** được bao gồm trong bản sao lưu hệ thống đó, tùy theo cấu hình của bạn.
- Việc backup đó được thực hiện và bảo mật bởi Apple/Google theo chính sách riêng của họ, nằm ngoài phạm vi kiểm soát của "Daily Mood: Tracker & Diary".
- Bạn có thể tắt tính năng này riêng cho app trong Cài đặt hệ thống nếu muốn dữ liệu tuyệt đối không rời khỏi thiết bị vật lý.

---

## 7. Bảo mật dữ liệu

- Toàn bộ database được mã hóa tại chỗ bằng SQLCipher (AES-256).
- Khóa mã hóa được lưu trong Android Keystore / iOS Keychain — không lưu dưới dạng văn bản thuần (plaintext), không hardcode trong mã nguồn.
- App có thể được khóa bằng PIN hoặc sinh trắc học (FaceID/TouchID/Fingerprint) — lớp bảo vệ bổ sung ở cấp ứng dụng.
- Dù đã áp dụng các biện pháp trên, không có hệ thống nào bảo mật tuyệt đối 100%; người dùng nên tự bảo vệ thiết bị của mình (khóa màn hình, cập nhật OS thường xuyên).
- Về quyền Microphone: Ứng dụng sẽ yêu cầu quyền truy cập Micro của thiết bị. Quyền này chỉ được kích hoạt và sử dụng khi bạn chủ động nhấn vào tính năng "Ghi âm nhật ký". Tập tin âm thanh được thu âm trực tiếp và lưu hoàn toàn cục bộ trên máy của bạn, tuyệt đối không gửi về bất kỳ máy chủ nào.

---

## 8. Đối tượng sử dụng & Giới hạn về nội dung sức khỏe

- Ứng dụng dành cho **mục đích tự theo dõi cá nhân**, không phải công cụ chẩn đoán hoặc điều trị y tế/tâm lý.
- Ứng dụng **không thay thế** tư vấn từ chuyên gia y tế, tâm lý học, hoặc bác sĩ tâm thần.
- Nếu bạn đang gặp khủng hoảng tâm lý hoặc có ý nghĩ tự hại, vui lòng liên hệ ngay các đường dây hỗ trợ khẩn cấp tại khu vực của bạn hoặc người có chuyên môn.
- Ứng dụng khuyến nghị không dành cho trẻ em dưới 13 tuổi (hoặc độ tuổi tối thiểu theo luật địa phương) sử dụng độc lập mà không có sự giám sát của phụ huynh, do tính chất ghi chép nội dung cá nhân/nhật ký.

---

## 9. Thay đổi chính sách

Nếu chính sách này thay đổi (vd. khi bổ sung tính năng cloud sync ở version sau), chúng tôi sẽ:

- Thông báo rõ ràng trong app trước khi tính năng mới có hiệu lực.
- Yêu cầu xác nhận đồng ý (opt-in) nếu thay đổi liên quan đến việc dữ liệu bắt đầu rời khỏi thiết bị (vd. bật cloud sync).
- Cập nhật ngày hiệu lực ở đầu tài liệu này.

---

## 10. Liên hệ

Nếu có câu hỏi về chính sách quyền riêng tư này, vui lòng liên hệ: [Điền email/kênh liên hệ hỗ trợ chính thức]

---

## Checklist trước khi công bố chính thức (dành cho đội dev/product)

- [ ] Có luật sư/chuyên gia compliance rà soát bản draft này.
- [ ] Điền đầy đủ [ngày hiệu lực] và [thông tin liên hệ].
- [ ] Kiểm tra yêu cầu riêng của App Store (Apple Privacy Nutrition Label) và Google Play (Data Safety section) — cả hai đều yêu cầu khai báo chi tiết loại dữ liệu xử lý, kể cả khi chỉ lưu local.
- [ ] Xác nhận app không dùng bất kỳ SDK bên thứ ba nào âm thầm thu thập dữ liệu (kiểm tra kỹ các package như crash reporting, ad SDK nếu có thêm sau này).
- [ ] Nếu nhắm thị trường Việt Nam: đối chiếu với Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân.
- [ ] Nếu nhắm thị trường EU: đối chiếu với GDPR (đặc biệt là quyền "right to erasure" — app đã đáp ứng qua chức năng xóa dữ liệu local).
