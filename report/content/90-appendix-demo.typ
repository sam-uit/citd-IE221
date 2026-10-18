#import "../lib.typ": *

= DEMO

Phần DEMO được tách thành Phụ Lục để tránh loãng nội dung chính và sẽ được trình bày theo một số ví dụ như dưới đây ở bản CLI. Bản TUI cơ bản là tương tự, chỉ khác là sử dụng menu chọn từ Terminal.

- `uv sync` và test, sau đó chạy thử bản CLI:

#image("images/demo-sync-test-help.png")

- `fetch -c` tải một khóa học cụ thể: chạy trình duyệt, yêu cầu đăng nhập.

#image("images/demo-fetch-course.png")

- `md -c 892 --toc` tạo file .md chỉ chứa bộ khung nội dung (Table Of Content)

#image("images/demo-cli-md-toc.png")

- Kết quả của `md -c 892 --toc`

#image("images/demo-cli-md-toc-outcome.png")

- `list -c` liệt kê danh sách các Course đã biết.

#image("images/demo-cli-list-c.png")

- TUI: liệt kê sử dụng menu.

#image("images/demo-tui-list.png")
