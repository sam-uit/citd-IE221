#import "../lib.typ": *

= KẾT LUẬN
<ket-luan>

Trong Chương cuối này, sinhv viên thực hiện xin đối chiếu kết quả với hai bộ yêu cầu đã đặt ở Chương 1 so với các Chương của môn học IE221, từ đó trình bày những hạn chế còn lại tính đến ngày hôm nay, và nêu hướng phát triển về sau. Đồng thời cũng nêu lên những kinh nghiệm đúc kết được từ quá trình phát triển công cụ như một dự án cá nhân và trong góc nhìn của Thiết Kế Hệ Thống (System Design).

== Kết Quả Đạt Được
<ket-qua-dat-duoc>

=== Đối Chiếu Với Yêu Cầu
<doi-chieu-voi-yeu-cau>

Trạng thái ghi theo ba mức: *Đạt*, *Một phần*, *Chưa*.

#datatable-data((
  headers: ([Mã], [Trạng thái], [Bằng chứng]),
  rows: (
    ([FR-01], [Đạt], [`list -p` đọc offline; `list -p -r` làm mới qua trình duyệt (macOS); `fetch_catalog` (@ma-fetch-catalog-2)]),
    ([FR-02], [Đạt], [`fetch -p 280 --cascade --toc` (macOS)]),
    ([FR-03], [Đạt], [`fetch -c 892 --toc` (macOS); bốn bước của `extract_transcript` ở @phien-dang-nhap-va-thu-thap[Mục]]),
    ([FR-04], [Một phần], [`fetch -l ID` được nhận nhưng in "not yet fully supported": lab chỉ được thu thập qua course chứa nó, có nghĩa là mối quan hệ trực tiếp trong cây Tổ Chức Dữ Liệu (`process_lab`, @ma-process-lab-1); `md -l` và `list -l` chạy được]),
    ([FR-05], [Đạt], [`extract_course_metadata` so sánh `datePublished` (@ma-extract-metadata)]),
    ([FR-06], [Đạt], [`md -c 892 --toc` sinh note ở @ma-note-mau; `generate_markdown` ghi đè ở Path, Course, Lab]),
    ([FR-07], [Đạt], [`search vertex` tìm thấy path 280 và course 892]),
    ([FR-08], [Đạt], [`reindex` dựng lại `index.json`]),
    ([FR-09], [Đạt], [`process_document` tải file pdf vào `materials/courses/<id>/` với cookie của trình duyệt]),
    ([FR-10], [Một phần], [`Course.generate_prompt` sinh `<id>-prompt.json`, gọi được từ TUI (`g`), chưa có lệnh CLI; tạm ngừng theo ghi chú ở @tb-fr]),
    ([FR-11], [Đạt], [`skills-scraper-tui` mở menu màu trong Terminal và thoát không lỗi (@hinh-demo-tui)]),
    ([NFR-01], [Đạt], [ba cơ chế ở @chay-lai-va-tinh-idempotent]),
    ([NFR-02], [Đạt], [JSON UTF-8 có thụt lề, Markdown thuần; `git diff` là cách phát hiện thay đổi]),
    ([NFR-03], [Đạt], [ba lớp cấu hình ở @ma-load-settings, `config.example.yaml` có chú thích]),
    ([NFR-04], [Đạt], [`try/except` theo từng activity; loại lạ giữ nguyên và báo (@ma-process-step-2); bỏ qua course có nêu rõ lý do]),
    ([NFR-05], [Đạt], [`write_text` nguyên tử (@ma-write-text)]),
    ([NFR-06], [Đạt], [`uv sync` rồi test phải xanh từ clone sạch trên hệ điều hành khác/máy khác (@ma-pytest)]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("12%", "14%", "auto")),
  caption: [Kết Quả Đạt Được],
  label: "tb-trang-thai-fr",
))

Hai mục "Một phần" đều có cùng một nguyên nhân: ở v2.0.0 chúng cũng chưa hoàn chỉnh (chưa đủ độ cấp thiết), và trong phạm vi đồ án sinh viên ưu tiên làm cho những gì đã có chạy đúng với site hiện tại hơn là mở thêm tính năng. Cả hai được giữ nguyên trong mã nguồn với thông báo tường minh thay vì bị giấu đi trong im lặng.

=== Đối Chiếu Với Chương Bài Giảng
<doi-chieu-voi-chuong-bai-giang>

Tương tự, các kiến thức của môn học được phản ánh trong mã nguồn như các ví dụ dưới đây. Đồng thời, phần nào được bỏ qua sẽ có ghi chú _tường minh_ tương ứng.

#datatable-data((
  headers: ([Chương], [Nội dung], [Bằng chứng trong mã]),
  rows: (
    ([01 @ie221-l01], [Môi trường Python], [`pyproject.toml`, `.python-version`, `uv.lock` (@ma-pyproject-deps)]),
    ([02 @ie221-l02], [Kiểu dữ liệu], [`dict` lồng modules/steps/activities; f-string; `tuple` làm khoá sắp xếp]),
    ([03 @ie221-l03], [Rẽ nhánh], [chuyển hướng bằng `dict` theo loại activity; bỏ qua theo `datePublished` (@ma-process-step-1)]),
    ([04 @ie221-l04], [Vòng lặp], [phân trang `while` có điểm ngắt `MAX_PAGES` (@ma-fetch-catalog-2)]),
    ([05 @ie221-l05], [Hàm], [tham số mặc định, `**kwargs`, đệ quy `_parse_lesson_item` (@ma-parse-lesson-item)]),
    ([06 @ie221-l06], [Module, package], [`src/skills_scraper/` với ba sub-package, `__init__.py` @ma-tree]),
    ([07 @ie221-l07], [Ngoại lệ], [bắt ngoại lệ theo activity, `try/except/raise` khi ghi nguyên tử, `KeyboardInterrupt` (@ma-write-text)]),
    ([08 @ie221-l08], [Hướng đối tượng], [`Serialize`, `BaseEntity`, `Collection`, `@property`, `super()`, ghi đè, composition (@hinh-so-do-lop)]),
    ([09 @ie221-l09], [Giao diện đồ hoạ], [không dùng, có lý do ở @hai-quyet-dinh-khong-dung; TUI thay thế]),
    ([10 @ie221-l10], [Cơ sở dữ liệu], [không dùng, có lý do ở @hai-quyet-dinh-khong-dung; file JSON và `index.json` dựng lại được]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("10%", "22%", "auto")),
  caption: [Đối Chiếu Với Kiến Thức Môn Học],
  label: "tb-lecture-map",
))

== Hạn Chế
<han-che>

Công cụ còn những giới hạn sau, tất cả đều được nói ra trong mã nguồn hoặc tài liệu kèm repo, hoặc bản thân báo cáo này:

- Cần một phiên đăng nhập thật trên trình duyệt, nên không chạy hoàn toàn không người dùng trực tiếp; `--headless` chỉ dùng được sau khi profile đã đăng nhập và được dùng lại.
- Chưa thu thập lab độc lập (FR-04) và chưa có lệnh CLI cho tệp prompt (FR-10).
- Chưa thử lại khi mất kết nối (P10 ở @bang-port-tu-dong-chinh) vì cơ chế _tất cả hoặc không gì cả_: một lần rớt kết nối giữa `--cascade` dừng course đang chạy, chạy lại lệnh sẽ tiếp từ course đó nhờ idempotent.
- Bảo trì: Vẫn sử dụng `print()` trong `model/` thay cho `logging`.
- Chất lượng mã nguồn: `ruff check` (theo PEP 8 @pep8) còn nhiều cảnh báo, đa số về kiểu (`implicit-optional`, `blind-except`, thứ tự import), chưa có lỗi logic.
- Tên file Markdown thực tế lấy từ tiêu đề của thực thể nên khi Google đổi tiêu đề thì liên kết trong vault bị gãy (orphaned/broken); checkbox tiến độ người học tự đánh bị ghi đè khi sinh lại Markdown (cần kiểm tra sự thay đổi khi cần).
- Partner portal không còn kiểm thử được vì sinh viên không còn quyền truy cập.

== Hướng Phát Triển
<huong-phat-trien>

Theo thứ tự nên làm, mỗi mục là một hoặc vài commit nhỏ trên cùng kiến trúc, không mục nào cần phải sửa `model/` về căn bản, trừ khi Google có một sự thay lớn về Cấu Trúc Dữ Liệu của nội dung trên website.

+ Thử lại khi mất kết nối giữa chừng (P10) và tái dùng cửa sổ Chrome đang mở.
+ Bundle OKF đầy đủ: lệnh `index` sinh `index.md` cho mỗi thư mục và `log.md` ở gốc vault.
+ Tên file dạng `<id>-<slug>.md` để liên kết không gãy khi đổi tiêu đề, có nghĩa sự nhất quán đến mức các file Markdown xuất ra.
+ Đổi `print()` sang `logging` để tăng khả năng bảo trì.
+ Xử lý các cảnh báo từ `ruff check` để tăng chất lượng mã nguồn.
+ Thu thập lab độc lập và lệnh `prompt` trên CLI, hoàn thành khép lại hai mục "Một phần".
+ Portal khác (AWS Skill Builder, vv..) bằng cấu hình và lớp con ghi đè phần phân tích trang, như cách `Paths` ghi đè `API_URL`.
+ Dùng vault làm kho tri thức cho AI agent qua plugin Obsidian hoặc MCP, với tệp prompt JSON làm đầu vào tóm tắt; đây là nơi khung CODE đi hết bước *Distill*.

Tuy nhiên, sinh viên kỳ vọng một sự đóng góp từ bên ngoài hơn là tự thực hiện, vì cơ bản công cụ hiện đang phục vụ được nhu cần cá nhân nên thiếu động lực để phát triển tiếp.

== Các Bài Học Từ Dự Án

- Trên một hệ thống lớn, bản chất là sự hợp tác (collaboration) của các công cụ nhỏ qua các dịch vụ điều phối (orchestrator).
- Chia nhỏ vấn đề đến mức có thể xử lý một cách rành mạch mà không cần giải thích quá nhiều.
- "Đừng lặp lại", tái sử dụng các thành phần đã có.
- Giữ sự đơn giản, để có thể luôn luôn thay thế khi cần.
- Tạo sự hiệu quả, để không phải đầu tư (thời gian, công sức) vào việc thay thế.
- Làm gì, hoặc không làm gì, đều cần được miêu tả rõ ràng.

== Lời Kết
<loi-ket>

Đồ án xuất phát từ một nhu cầu thật của sinh viên trong công việc và được giải bằng một công cụ nhỏ, cố ý nhỏ: thu thập nội dung Google Skills về file JSON và sinh một vault Markdown cho Obsidian, với hai runner trên cùng một lõi. Về mặt học thuật, mỗi chương của môn #emph[IE221 -- Kỹ Thuật Lập Trình Python] đều được thể hiện trong mã nguồn (@tb-lecture-map), với những khối kiến thức không được sử dụng, báo cáo cũng đã trình bày các quyết định không dùng với lý do rõ ràng; về mặt kỹ thuật, 15 trong 17 yêu cầu đạt, hai yêu cầu còn lại đạt một phần và được nói thẳng (@tb-trang-thai-fr).

Điều sinh viên mang theo từ đồ án không phải là bản thân scraper, vốn sẽ phải đổi theo site, mà là ba thói quen: _dữ liệu để lại phải sống lâu hơn công cụ_, _lỗi ồn ào tốt hơn lỗi im lặng_, và _mỗi quyết định dù là "không làm" cũng phải có lý do ghi lại được_. Đó cũng là cách sinh viên học được và đang xây các thành phần nhỏ (micro), không trạng thái (stateless) cho những hệ thống lớn hơn trong công việc.
