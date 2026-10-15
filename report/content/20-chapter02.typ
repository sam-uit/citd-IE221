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
- Lệnh `md` chuyển JSON thành Markdown, hai lệnh không biết nhau.
- Ba thư viện ngoài lúc chạy (selenium, beautifulsoup4, requests).
- Không daemon, không server.

#co-note(title: [Tiêu Chí])[
  - Đơn giản đến mức có thể được thay thế bất kỳ lúc nào.
  - Hiệu quả đến mức không cần phải thay thế.
]

