#import "/lib.typ": *

= Kết Luận
<ket-luan>


== Kết Quả Đạt Được
<ket-qua-dat-duoc>

#co-note[Đánh dấu Đạt, Một phần, Chưa cho từng dòng sau khi chạy thật trên Mac.]
#datatable-data((
  headers: ([Mã], [Trạng thái], [Bằng chứng]),
  rows: (
    ([FR-01], [], []),
    ([FR-02], [], []),
    ([FR-03], [], []),
    ([FR-04], [], []),
    ([FR-05], [], []),
    ([FR-06], [], []),
    ([FR-07], [], []),
    ([FR-08], [], []),
    ([FR-09], [], []),
    ([FR-10], [], []),
    ([FR-11], [], []),
    ([NFR-01], [], []),
    ([NFR-02], [], []),
    ([NFR-03], [], []),
    ([NFR-04], [], []),
    ([NFR-05], [], []),
    ([NFR-06], [], []),
  ),
  options: (index: false, align: ("left", "left", "left")),
))

=== Đối Chiếu Với Chương Bài Giảng
<doi-chieu-voi-chuong-bai-giang>

#datatable-data((
  headers: ([Chương], [Nội dung], [Bằng chứng trong mã]),
  rows: (
    ([01], [Môi trường Python], [`pyproject.toml`, `.python-version`, `uv.lock`]),
    ([02], [Kiểu dữ liệu], [dict lồng module, step, activity; định dạng chuỗi; `json`]),
    ([03], [Rẽ nhánh], [dispatch theo loại activity; bỏ qua theo `datePublished`]),
    ([04], [Vòng lặp], [phân trang `while` có cầu chì; ba tầng `for`]),
    ([05], [Hàm], [tham số mặc định, `**kwargs`, `lambda`, đệ quy `_parse_lesson_item`]),
    ([06], [Module, package], [`src/skills_scraper/`, `__init__.py`, entry point]),
    ([07], [Ngoại lệ], [bắt lỗi theo activity, ghi tệp nguyên tử]),
    ([08], [Hướng đối tượng], [`Serialize`, `BaseEntity`, `Collection`, `@property`, `super()`, ghi đè]),
    ([09], [Giao diện đồ hoạ], [không dùng, có lý do (chương 2)]),
    ([10], [Cơ sở dữ liệu], [không dùng, có lý do (chương 2)]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("33.33%", "33.33%", "33.33%")),
))

== Hạn Chế
<han-che>

Cần một phiên đăng nhập thật nên không chạy hoàn toàn không người trông. Chất lượng transcript phụ thuộc phụ đề của site. Tên tệp lấy từ tiêu đề nên đổi tên là gãy liên kết. Checkbox tiến độ bị ghi đè khi sinh lại Markdown. `print()` còn trong `model/` và `input()` còn một chỗ trong `services/browser.py`. Partner portal không còn kiểm thử được. Nội dung transcript thuộc về Google: vault công khai chỉ nên chứa cấu trúc (`--toc --no-transcript`).

#co-note[Cập nhật danh sách theo trạng thái thật lúc nộp (ví dụ nếu P10 retry đã làm).]

== Hướng Phát Triển
<huong-phat-trien>

Thử lại khi mất mạng và tái dùng trình duyệt qua `debuggerAddress`. Bundle OKF đầy đủ: `index.md` mỗi thư mục, `log.md` ở gốc. Tên tệp dạng `<id>-<slug>.md`. Chuyển `print()` sang `logging`. Portal khác (AWS Skill Builder, NVIDIA DLI) bằng cấu hình và lớp con ghi đè phần phân tích trang. Dùng vault làm kho tri thức cho AI agent qua plugin Obsidian hoặc MCP, với tệp prompt JSON làm đầu vào tóm tắt.

== Kết Luận
<ket-luan>
