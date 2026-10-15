#import "/lib.typ": *

= Triết Lý Và Thiết Kế
<triet-ly-va-thiet-ke>


== Một Ứng Dụng, Không Phải Một Hệ Thống
<mot-ung-dung-khong-phai-mot-he-thong>

Công cụ được thiết kế dưới góc nhìn của kỹ sư hệ thống: một thành phần nhỏ, đúng một việc, ghép được với các công cụ khác, mà không phải là một "hệ thống" hay một nền tảng hoàn toàn độc lập. Năm nguyên tắc dưới đây quyết định mọi lựa chọn trong các chương sau.

=== Làm Một Việc Và Làm Tốt
<don-gian-lam-mot-viec-va-lam-tot>

#co-note(title: [_KISS_: Keep It Simple, Stupid])[
  - Làm một việc, và làm thật tốt việc đó.
  - Hoàn toàn có thể kết hợp với các công cụ khác để tạo thành một luồng công việc.
  - Dễ dàng được thay thế mà không ảnh hưởng đến tổng thể.
]

Ứng dụng chỉ thu thập và chuẩn hoá.

- Lệnh `fetch` đưa nội dung về JSON.
- Lệnh `md` chuyển JSON thành Markdown, hai lệnh không (cần) biết nhau.
- Ba thư viện ngoài lúc chạy (selenium, beautifulsoup4, requests).
- Không daemon, không server.

=== Đơn Giản Để Luôn Thay Thế Được
<don-gian-de-luon-thay-the-duoc>

Thứ bền nhất không phải công cụ mà là dữ liệu nó để lại. JSON và Markdown thuần vẫn đọc được khi công cụ không còn tồn tại.

Dự án đã tự chứng minh: dòng chính của repo thay lõi Python bằng lõi Go (thử nghiệm) mà vault không đổi định dạng. Một công cụ khoá dữ liệu của người dùng vào chính nó thì không phải là khó thay thế, mà biến dữ liệu thành con tin.

#co-note(title: [Tiêu Chí])[
  - Đơn giản đến mức có thể được thay thế bất kỳ lúc nào.
  - Hiệu quả đến mức không cần phải thay thế.
]

=== Là Một Phần Của Hệ Thống
<la-mot-phan-cua-he-thong>

Ứng dụng giao tiếp bằng tệp văn bản và mã thoát, nên ghép được với `grep`, `jq`, `git`, `cron`, Obsidian và các plugin AI mà không cần API riêng. Đồ thị khoảng 3.600 note trong vault không được thiết kế trước: nó hình thành từ các liên kết tương đối mà mỗi note tự ghi ra.

#image("images/obsidian-pkb-2nd-brain.png")

#co-info(title: [Emergence])[Nguyên Lý Đột Sinh (Emergence) -- một phần "ngốc nghếch" của một hệ thống _thông minh_.]

=== Tường Minh
<tuong-minh>

- Cấu hình nằm trong biến môi trường và tệp `config.yaml` văn bản thuần, có tệp mẫu trong repo.
- Mỗi note Markdown tự khai nó được sinh bởi phiên bản nào, từ trang nào, trang đó sửa lần cuối khi nào đều được nêu rõ tường minh.
- Khi bỏ qua một `course` vì course đó không đổi, ứng dụng nêu rõ ra là đã bỏ qua và vì lý do gì.

