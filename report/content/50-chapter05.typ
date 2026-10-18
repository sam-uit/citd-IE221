#import "/lib.typ": *

= KẾT LUẬN
<ket-luan>

Chương cuối đối chiếu kết quả với hai bộ yêu cầu đã đặt ở chương 1 và với mười chương của môn học, nói thẳng những hạn chế còn lại tính đến ngày nộp, và nêu hướng phát triển đã được xếp thứ tự. Cột bằng chứng trong các bảng chỉ về mã, test hoặc lần chạy cụ thể, không về ý định.

== Kết Quả Đạt Được
<ket-qua-dat-duoc>

=== Đối Chiếu Với Yêu Cầu
<doi-chieu-voi-yeu-cau>

Trạng thái ghi theo ba mức: *Đạt*, *Một phần*, *Chưa*. Bằng chứng "VM" là lần chạy offline từ clone sạch trên máy ảo Linux ngày 16/10/2026 (@ma-pytest); "macOS" là lần chạy thật qua Chrome ngày 26/09/2026 (@chay-lai-va-tinh-idempotent).

#datatable-data((
  headers: ([Mã], [Trạng thái], [Bằng chứng]),
  rows: (
    ([FR-01], [Đạt], [`list -p` đọc offline (VM); `list -p -r` làm mới qua trình duyệt (macOS); `fetch_catalog` @ma-fetch-catalog-2]),
    ([FR-02], [Đạt], [`fetch -p 280 --cascade --toc` (macOS); commit `cc06f45`; `test_path.py`]),
    ([FR-03], [Đạt], [`fetch -c 892 --toc` (macOS); bốn bước của `extract_transcript` ở @phien-dang-nhap-va-thu-thap; `test_course.py`]),
    ([FR-04], [Một phần], [`fetch -l ID` được nhận nhưng in "not yet fully supported": lab chỉ được thu thập qua course chứa nó (`process_lab`, @ma-process-lab-1); `md -l` và `list -l` chạy được]),
    ([FR-05], [Đạt], [`extract_course_metadata` so `datePublished` (@ma-extract-metadata); `test_metadata_skips_when_date_published_unchanged`]),
    ([FR-06], [Đạt], [`md -c 892 --toc` sinh note ở @ma-note-mau (VM); `generate_markdown` ghi đè ở Path, Course, Lab]),
    ([FR-07], [Đạt], [`search vertex` tìm thấy path 280 và course 892 (VM); `Index.search` với `--field`]),
    ([FR-08], [Đạt], [`reindex` dựng lại `index.json` (VM)]),
    ([FR-09], [Đạt], [`process_document` tải vào `materials/courses/<id>/` với cookie của trình duyệt; commit `b4bd646` (macOS)]),
    ([FR-10], [Một phần], [`Course.generate_prompt` sinh `<id>-prompt.json`, gọi được từ TUI (`g`), chưa có lệnh CLI; tạm ngừng theo ghi chú ở @tb-fr]),
    ([FR-11], [Đạt], [`skills-scraper-tui` mở menu màu và thoát sạch (VM); @hinh-demo-tui]),
    ([NFR-01], [Đạt], [ba cơ chế ở @chay-lai-va-tinh-idempotent, có test]),
    ([NFR-02], [Đạt], [JSON UTF-8 có thụt lề, Markdown thuần; `git diff` trên vault là cách phát hiện thay đổi]),
    ([NFR-03], [Đạt], [ba lớp cấu hình ở @ma-load-settings, `config.example.yaml` có chú thích]),
    ([NFR-04], [Đạt], [`try/except` theo từng activity; loại lạ giữ nguyên và báo (@ma-process-step-2); bỏ qua course có in lý do]),
    ([NFR-05], [Đạt], [`write_text` nguyên tử (@ma-write-text); `test_write_json_leaves_no_temp_files`]),
    ([NFR-06], [Đạt], [`uv sync` rồi `pytest` xanh từ clone sạch trên hệ điều hành khác máy phát triển (@ma-pytest); `grep -rn "/Users/" src` rỗng]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("12%", "14%", "auto")),
  caption: [Trạng thái 11 yêu cầu chức năng và 6 yêu cầu phi chức năng],
  label: "tb-trang-thai-fr",
))

Hai mục "Một phần" đều có cùng một nguyên nhân: ở v2.0.0 chúng cũng chưa hoàn chỉnh, và trong phạm vi đồ án sinh viên ưu tiên làm cho những gì đã có chạy đúng với site hiện tại hơn là mở thêm tính năng. Cả hai được giữ nguyên trong mã với thông báo tường minh thay vì bị giấu đi.

=== Đối Chiếu Với Chương Bài Giảng
<doi-chieu-voi-chuong-bai-giang>

#datatable-data((
  headers: ([Chương], [Nội dung], [Bằng chứng trong mã]),
  rows: (
    ([01 @ie221-l01], [Môi trường Python], [`pyproject.toml`, `.python-version`, `uv.lock`; @ma-pyproject-deps]),
    ([02 @ie221-l02], [Kiểu dữ liệu], [`dict` lồng modules/steps/activities; f-string; `tuple` làm khoá sắp xếp;]),
    ([03 @ie221-l03], [Rẽ nhánh], [dispatch bằng `dict` theo loại activity; bỏ qua theo `datePublished`; @ma-process-step-1]),
    ([04 @ie221-l04], [Vòng lặp], [phân trang `while` có cầu chì `MAX_PAGES`; ba tầng `for`; @ma-fetch-catalog-2]),
    ([05 @ie221-l05], [Hàm], [tham số mặc định, `**kwargs`, `lambda`, `@staticmethod`, đệ quy `_parse_lesson_item`; @ma-parse-lesson-item]),
    ([06 @ie221-l06], [Module, package], [`src/skills_scraper/` với ba sub-package, `__init__.py`, hai entry point; @ma-tree]),
    ([07 @ie221-l07], [Ngoại lệ], [bắt theo activity, `try/except/raise` khi ghi nguyên tử, `KeyboardInterrupt`; @ma-write-text]),
    ([08 @ie221-l08], [Hướng đối tượng], [`Serialize`, `BaseEntity`, `Collection`, `@property`, `super()`, ghi đè, composition; @hinh-so-do-lop]),
    ([09 @ie221-l09], [Giao diện đồ hoạ], [không dùng, có lý do ở @hai-quyet-dinh-khong-dung; TUI thay thế]),
    ([10 @ie221-l10], [Cơ sở dữ liệu], [không dùng, có lý do ở @hai-quyet-dinh-khong-dung; file JSON và `index.json` dựng lại được]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("16%", "24%", "auto")),
  caption: [Mười chương của IE221 và nơi chúng xuất hiện trong mã],
  label: "tb-lecture-map",
))

== Hạn Chế
<han-che>

Tính đến ngày nộp, công cụ còn những giới hạn sau, tất cả đều được nói ra trong mã hoặc tài liệu kèm repo:

- Cần một phiên đăng nhập thật nên không chạy hoàn toàn không người trông; `--headless` chỉ dùng được sau khi profile đã đăng nhập.
- Chưa thu thập lab độc lập (FR-04) và chưa có lệnh CLI cho tệp prompt (FR-10).
- Chưa thử lại khi mất mạng (P10 ở @bang-port-tu-dong-chinh): một lần rớt kết nối giữa `--cascade` dừng course đang chạy, chạy lại lệnh sẽ tiếp từ course đó nhờ idempotent.
- `print()` còn 60 chỗ trong `model/` thay cho `logging`; `ruff check` (theo PEP 8 @pep8) còn 90 cảnh báo, đa số về kiểu (`implicit-optional`, `blind-except`, thứ tự import), chưa có lỗi logic.
- Chất lượng transcript phụ thuộc phụ đề của site; tên file Markdown lấy từ tiêu đề nên khi Google đổi tiêu đề thì liên kết trong vault gãy; checkbox tiến độ người học tự đánh bị ghi đè khi sinh lại Markdown.
- Partner portal không còn kiểm thử được vì sinh viên không còn quyền truy cập.
- Nội dung transcript và tài liệu thuộc về Google: vault công khai chỉ nên chứa cấu trúc (`--toc --no-transcript`).

== Hướng Phát Triển
<huong-phat-trien>

Theo thứ tự nên làm, mỗi mục là một hoặc vài commit nhỏ trên cùng kiến trúc, không mục nào đòi sửa `model/` về căn bản:

+ Thử lại khi mất mạng (P10) và tái dùng cửa sổ Chrome đang mở qua `debuggerAddress` (P11), để `--cascade` dài hơi chạy ổn.
+ Bundle OKF đầy đủ: lệnh `index` sinh `index.md` cho mỗi thư mục và `log.md` ở gốc vault; khi đó `docs/data.md` và `docs/output.md` viết lại cho khớp mã.
+ Tên file dạng `<id>-<slug>.md` để liên kết không gãy khi đổi tiêu đề; `print()` sang `logging`; dọn các cảnh báo `ruff`.
+ Thu thập lab độc lập và lệnh `prompt` trên CLI, khép lại hai mục "Một phần".
+ Portal khác (AWS Skill Builder, NVIDIA DLI) bằng cấu hình và lớp con ghi đè phần phân tích trang, đúng cách `Paths` ghi đè `API_URL`.
+ Dùng vault làm kho tri thức cho AI agent qua plugin Obsidian hoặc MCP, với tệp prompt JSON làm đầu vào tóm tắt; đây là nơi khung CODE đi hết bước *Distill*.

== Lời Kết
<loi-ket>

Đồ án xuất phát từ một nhu cầu thật của sinh viên trong công việc và được giải bằng một công cụ nhỏ, cố ý nhỏ: thu thập nội dung Google Skills về file JSON và sinh một vault Markdown cho Obsidian, với hai runner trên cùng một lõi. Về mặt học thuật, mười chương của môn #emph[IE221 -- Kỹ Thuật Lập Trình Python] đều có chỗ đứng trong mã (@tb-lecture-map), kể cả hai chương được quyết định không dùng với lý do rõ ràng; về mặt kỹ thuật, 15 trong 17 yêu cầu đạt, hai yêu cầu còn lại đạt một phần và được nói thẳng (@tb-trang-thai-fr).

Điều sinh viên mang theo từ đồ án không phải là bản thân scraper, vốn sẽ phải đổi theo site, mà là ba thói quen: dữ liệu để lại phải sống lâu hơn công cụ, lỗi ồn ào tốt hơn lỗi im lặng, và mỗi quyết định dù là "không làm" cũng phải có lý do ghi lại được. Đó cũng là cách sinh viên đang xây các thành phần nhỏ, không trạng thái cho những hệ thống lớn hơn trong công việc hiện tại.
