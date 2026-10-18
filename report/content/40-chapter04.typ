#import "../lib.typ": *

= KIỂM THỬ, VẬN HÀNH VÀ BẢO TRÌ
<kiem-thu-van-hanh-va-bao-tri>

Vốn chỉ là một công cụ (scraper) và chỉ làm đúng một việc, có nghĩa công cụ chỉ tồn tại bằng cách theo đuổi yếu tố bên ngoài: một website không thuộc về mình; nên câu hỏi quan trọng hơn cần được xử lý không phải là "có chạy được không", mà là "làm sao biết nó còn chạy đúng, và khi không còn đúng thì biết là sai ở đâu".

// Trong Chương này, trả lời bằng bốn mảng: bộ test offline trên các trang đã ghi lại, tính idempotent khi chạy lại, quy trình khi nền tảng thay đổi với các thay đổi thật từ v2.0.0 tới nay, và cấu hình ba lớp cho tính di động.

== Kiểm Thử Offline
<kiem-thu-offline>

Mọi test chạy không cần mạng và không cần trình duyệt. Nguồn vào là các trang đã ghi lại từ website trong `tests/fixtures/google_skills/`, thực ra là các trang được lưu thủ công, và chỉ giữ lại phần mã nguồn html, ví dụ: trang course 72 (`course-72.html`), thẻ `ql-contents-menu`, cây `modules` đã phân tích (`course-72-modules.json`, vv..).

Test sẽ khẳng định dựa trên *cấu trúc* (schema) của dữ liệu mẫu tại thời điểm đó (có `datePublished`, mỗi activity có `id`, `type`, `title`, `href`), mà không phải là dựa trên *giá trị* (tiêu đề course, description, vv.. vì đây là các giá trị có thể thay đổi bất kỳ lúc nào), nên mẫu (fixture) không phải soi chiếu lại mỗi khi Google chỉ thay đổi các phần giá trị mà không thay đổi cấu trúc.

#datatable-data((
  headers: ([Tệp], [Kiểm tra], [Số test]),
  rows: (
    ([`test_course.py`], [- Metadata từ `ld+json`; bỏ qua khi `datePublished` không đổi; đề cương nội dung từ `ql-contents-menu`; Markdown render được mọi loại activity kể cả loại lạ; danh sách dùng dấu gạch], [5]),
    ([`test_frontmatter.py`], [- Dấu nháy trong tiêu đề vẫn là YAML hợp lệ (trong YAML rất nhạy cảm với các dấu nháy đơn/kép) ; đủ khoá OKF và alias cũ; mọi loại thực thể đều có `type`.], [3]),
    ([`test_path.py`], [- `ql-contents-menu` phân biệt lab với course; không có menu thì lùi về `ld+json`; note path liên kết lab tới `labs/`], [3]),
    ([`test_store.py`], [- `write_json` không để lại file tạm; `upsert` giữ trường cũ; `search` theo tên rồi theo nội dung file; `rebuild` bỏ qua file prompt], [4]),
  ),
  options: (index: false, align: ("left", "left", "right"), columns: ("22%", "auto", "10%")),
  caption: [Kiểm Thử -- Bộ Test Offline],
  label: "tb-tests",
))

Ví dụ với Python 3.12.14 do `uv` tải:

#figure(
```ini
$ uv sync
Using CPython 3.12.14
Creating virtual environment at: .venv
Resolved 30 packages in 0.56ms
Installed 27 packages in 3ms
$ uv run pytest -q
...............                                                          [100%]
15 passed in 0.20s
```,
  kind: raw,
  caption: [`uv sync` và `uv run pytest`],
) <ma-pytest>

Bộ test đồng thời còn là các *cảnh báo sớm*: khi nghi vấn hoặc đã biết Google đổi markup, bước đầu tiên của người bảo trì là ghi lại trang mới vào `tests/fixtures/` (thực ra là save as và chọn lưu ở dạng html không kèm theo asset, hoặc đơn giản là mở Source và copy phần chứa các selector được đề cập ở trên); test nào báo lỗi thì đó là chỗ cần sửa, và từ đó thay đổi mã nguồn trước khi thực hiện lại trên website thật.

== Chạy Lại Và Tính Idempotent
<chay-lai-va-tinh-idempotent>

NFR-01 là một yêu cầu phi chức năng, nhưng tập trung vào tính toàn vẹn/nhất quán của dữ liệu. Yêu cầu này cho biết nếu chạy lại cùng một lệnh $n$ lần không làm hỏng và không làm thừa (dữ liệu đã có). Ba cơ chế trong mã nguồn sau bảo đảm điều đó, mỗi cơ chế thực ra đều đã được chỉ ra ở Chương 3:

- `fetch -c 892` lần hai:
  - `extract_course_metadata` so `datePublished` trên trang với giá trị đã lưu, bằng nhau thì in `Course 892 already extracted. datePublished: 2023-11-21` và trả `False`, course dừng tại đó (@ma-extract-metadata);
  - `--force` để ép thu thập lại và thay thế nội dung, không quan trọng là `datePublished` có cùng giá trị hay không.
- Lab đã có file JSON thì `process_lab` không tải lại (@ma-process-lab-1):
  - Vì một lab xuất hiện trong nhiều course và nhiều path.
  - Giả sử lab 123 thuộc cả course ABC và XYZ, nếu đã được hoàn thành ở course ABC thì không ghi đè và khi duyệt tới course XYZ sẽ vẫn thấy là lab 123 đã được hoàn thành, làm lại lab hay không là quyền của người học, công cụ không nên và không được thay đổi bản chất tình huống.
- Ctrl+C giữa chừng:
  - Mọi file đi qua `write_text` nguyên tử (@ma-write-text).
  - Vì vậy nên trên đĩa hoặc là bản cũ nguyên vẹn hoặc là bản mới hoàn chỉnh, không bao giờ là nửa file.
  - Cơ chế kiểm tra không còn `.tmp-*` sau khi ghi, có nghĩa là việc hoàn thành ghi file không chỉ đơn giản hoàn thành ở đoạn _cuối_ (file JSON được tạo ra), mà đoạn _đầu_ (file `.tmp-*`) phải không còn tồn tại nữa.
  - Hay nói cách khác: tại bất kỳ mọi thời điểm, luôn bảo đảm chỉ có một và một _SSOT_.

Lệnh `md` thì thuần hàm sinh file, không thay đổi (và quan tâm) dữ liệu của SSOT:

- Cùng JSON vào, cùng Markdown ra.
- Chạy bao nhiêu lần cũng được và `git diff` trên vault trả về rỗng nếu dữ liệu không đổi.
- Đây cũng là một cách phát hiện site đã đổi gì: `fetch --force` rồi `git diff` vault (nếu không `git diff` trong data/json).

== Khi Nền Tảng Thay Đổi
<khi-nen-tang-thay-doi>

Quy trình xử lý thay đổi của site gồm ba bước, như đã nêu ở @con-nguoi-trong-vong-lap: ứng dụng phát hiện và báo (log, test thất bại, dừng rõ ràng); con người đánh giá giá trị và chi phí; thay đổi được thực hiện thành một commit có nguồn và lý do. Bảng dưới là các thay đổi thật của skills.google từ v2.0.0 (02/2026) tới nay, cách dòng chính (Go) đã xử lý, và commit tương ứng trên `refactor-ie221` đưa cách xử lý đó về lại Python.

#datatable-data((
  headers: ([Thay đổi của site], [Triệu chứng ở v2.0.0], [Cách xử lý], [Dòng chính], [`refactor-ie221`]),
  rows: (
    ([Trang course bắt buộc đăng nhập (07/2026)], [`requests.get` nhận trang sign-in, hoặc dừng chờ ở sáu chỗ], [mọi trang qua trình duyệt, `ensure_authenticated` một chỗ], [`7637ba2`], [`9cc37c4`]),
    ([API danh mục trả 403 cho request trần], [`list -r` rỗng], [đọc JSON trong `<pre>` qua trình duyệt, một `fetch_catalog` cho ba lớp], [`61f2cbf`], [`ae21659`]),
    ([Loại activity mới: `html_bundle`, `badge`, `credential`], [bị bỏ qua lặng lẽ], [dispatch bằng `dict`, loại lạ giữ nguyên và log], [`31390c6`], [`9cfcd03`]),
    ([`ld+json.hasPart` gắn nhãn lab thành Course], [path trỏ sai course], [`ql-contents-menu` là nguồn sự thật, `ld+json` chỉ bổ sung], [`0b3c374`], [`1167943`]),
    ([Tên course có dấu nháy đơn], [frontmatter YAML hỏng, Obsidian báo lỗi], [`json.dumps` cho giá trị vô hướng, `title` thay `name`], [`1aa2f3e`], [`23d5a63`]),
  ),
  options: (index: false, align: ("left", "left", "left", "left", "left"), columns: ("22%", "22%", "28%", "14%", "14%")),
  caption: [Site đổi, mã đổi theo: năm thay đổi thật và commit xử lý],
  label: "tb-site-changes",
))

Mỗi dòng của bảng là một lần con người quyết định "đáng để theo"; không có dòng nào do công cụ tự sửa. Những gì chưa theo (ví dụ partner portal, phần Lab chạy thật) cũng là quyết định có lý do và được ghi ở @han-che.

== Cấu Hình Và Tính Di Động
<cau-hinh-va-tinh-di-dong>

NFR-03 và NFR-06 được đáp ứng bằng `config.py` với ba lớp cấu hình, lớp sau ghi đè lớp trước:

+ Mặc định trong mã (`DEFAULTS`): `data/`, `csbmdvault/`, `.webdriver_profiles/`, Chrome, không headless; đủ để chạy ngay sau `uv sync`.
+ `config.yaml` (dữ liệu, không phải mã): tìm theo `$CSB_CONFIG`, rồi `./config.yaml`, rồi `./config/config.yaml`; đường dẫn tương đối tính từ thư mục chứa file, nên `vault: ../skills-vault` nghĩa là một chỗ bất kể chạy lệnh từ đâu. Repo kèm `config.example.yaml` có chú thích từng khoá.
+ Biến môi trường `CSB_DATA`, `CSB_VAULT`, `CSB_PROFILE_DIR`, `CSB_BROWSER`, `CSB_HEADLESS`: ghi đè từng khoá, tiện cho script và CI; chuỗi `"1"`, `"true"`, `"yes"`, `"on"` được hiểu là bật.

#code-figure(
  "/content/code/config_load_settings.py",
  from: 7,
  to: 30,
  size: 0.85em,
  caption: [`config.load_settings`: trộn ba lớp, đường dẫn tương đối tính từ `config.yaml`],
  label: "ma-load-settings",
)

Ở v2.0.0, `settings.py` là mã Python chứa đường dẫn tuyệt đối của máy tác giả; bản này không còn chuỗi `/Users/` nào trong `src/` (kiểm bằng `grep -rn "/Users/" src`, kết quả rỗng), nên repo chạy được trên máy khác, hệ điều hành khác mà không sửa mã. Chính nhờ vậy toàn bộ phần offline của chương này (@ma-pytest, @ma-note-mau) được kiểm trên một máy ảo Linux chỉ bằng ba biến môi trường trỏ vào `docs/samples/data`, trong khi phần cần Chrome chạy trên macOS của sinh viên.

== Kết Chương
<ket-chuong-4>

Công cụ được kiểm theo hai lớp: 15 test offline trên trang đã ghi lại (@tb-tests), chạy xanh từ clone sạch trong một phần tư giây (@ma-pytest), và một lần chạy thật qua Chrome trên macOS cho các đường cần đăng nhập. Tính idempotent đến từ ba cơ chế có trong mã và có test; việc bám theo site là một quy trình có con người ở giữa, với năm thay đổi thật đã được xử lý và ghi thành commit (@tb-site-changes); cấu hình ba lớp (@ma-load-settings) làm cho repo di động và cũng là cái cho phép kiểm thử ở một máy khác máy phát triển. Chương 5 đối chiếu tất cả với yêu cầu đã đặt ra ở chương 1 và với các chương của môn học.
