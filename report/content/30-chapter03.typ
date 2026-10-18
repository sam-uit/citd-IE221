#import "../lib.typ": *
#import "diagrams.typ": *

= CÀI ĐẶT
<cai-dat>

Đây là phần nội dung chính của báo cáo, và để dễ theo dõi, cũng như bám sát các khối kiến thức của môn học IE221, sinh viên sẽ trình bày lần lượt các nội dung tương ứng.

// Mọi đoạn mã trong chương được tách trực tiếp từ branch `refactor-ie221` của kho git.

// Lần lượt: môi trường và gói (chương 01, 06), mô hình hướng đối tượng (chương 08), kiểu dữ liệu, rẽ nhánh, vòng lặp và hàm (chương 02 tới 05), xử lý ngoại lệ (chương 07); rồi tới ba mảng mà bất kỳ công cụ thu thập nào cũng phải có: phiên đăng nhập và thu thập, lưu trữ, kết xuất Markdown; và cuối cùng là hai runner trên cùng một lõi.

== Môi Trường Phát Triển
<moi-truong-phat-trien>

`uv` @uv-docs được dùng để khai báo, quản lý gói và khoá phiên bản:

- Nhất quán, có thể tái lập ở một môi trường mới bất kỳ đâu: `uv sync` từ một bản clone sạch tải đúng Python 3.12 và đúng các phiên bản trong `uv.lock`.
- Một công cụ duy nhất, `uv`, với một định dạng đánh dấu (markup) thân thiện, `toml`.

`pyproject.toml` @python-packaging khai báo tên và phiên bản của công cụ, bốn thư viện lúc chạy (selenium, beautifulsoup4, requests, pyyaml), và hai _runner_ dưới dạng console script, tức hai lệnh `skills-scraper` và `skills-scraper-tui` xuất hiện trong `PATH` sau khi cài đặt.

#code-figure(
  "/content/code/pyproject.toml",
  from: 1,
  to: 11,
  lang: "toml",
  size: 0.8em,
  caption: [`pyproject.toml` -- Tên, Phiên Bản, Các Thư Viện],
  label: "ma-pyproject-deps",
)

#code-figure(
  "/content/code/pyproject.toml",
  from: 19,
  to: 26,
  lang: "toml",
  size: 1em,
  caption: [`pyproject.toml` -- Hai Runner và Build Toolkits],
  label: "ma-pyproject-scripts",
)

`.python-version` cho `uv` biết phiên bản Python được dùng; `__init__.py` của gói đọc lại phiên bản từ metadata đã cài, nên con số này chỉ được khai ở một chỗ.

#code-figure(
  "/content/code/python-version",
  size: 0.9em,
  caption: [`.python-version`: Phiên Bản Python Tối Thiểu],
  label: "ma-init-version",
)

#code-figure(
  "/content/code/init_version.py",
  size: 0.9em,
  caption: [`__init__.py`: Phiên Bản Đọc Từ Metadata Của Gói],
  label: "ma-init-version",
)

== Package Và Module
<package-va-module>

Mã nguồn nằm trong một package `skills_scraper` dưới `src/`, cách bố trí được Python Packaging User Guide khuyến nghị để mã chỉ chạy được khi đã cài, không chạy nhầm từ thư mục làm việc. Package có ba sub-package và ba module ở gốc:

- `model`: cốt lõi, các lớp thực thể và tập hợp (Collection); là nơi biểu hiện rõ nhất của nội dung môn học.
- `services`: hai dịch vụ mà `model` cần, `browser.py` chạy trình duyệt; `store.py` ghi và đọc file.
- `utils`: tiện ích văn bản, ví dụ lọc ký tự không hợp lệ cho tên file và bỏ thẻ HTML.
- `config.py`, `cli.py`, `tui.py`: cấu hình và hai runner.

#code-figure(
  "/content/code/tree.yaml",
  lang: "yaml",
  size: 1em,
  caption: [Cây Package `src/skills_scraper/`],
  label: "ma-tree",
)

== Mô Hình Hướng Đối Tượng
<mo-hinh-huong-doi-tuong>

=== Hai Cây Kế Thừa
<hai-cay-ke-thua>

Hai nhánh kế thừa xuất phát từ cùng một điểm, `Serialize`, là lớp biết biến một đối tượng thành dạng thân thiện với JSON.

#figure(
  class-diagram-report(highlight: ("base", "collection")),
  caption: [`model/` -- `Serialize` và Sơ Đồ Lớp ],
) <hinh-so-do-lop>

Trong đó:

- Trái: *thực thể $x$* cụ thể, ở đây là Path, Course, Lab.
  - `BaseEntity` biết id, tên, mô tả, đường dẫn file và cách ghi JSON, Markdown. Lớp con chỉ thêm dữ liệu riêng và cách render.
- Phải: *danh sách của $x$*, ở đây là tập hợp của Path, Course, Lab.
  - `Collection` là `{id: name}` cộng `fetch_catalog` (kéo danh sách của một loại).
  - Lớp con chỉ khai `API_URL` (danh sách các Path/Course/Lab có các URL khác nhau).
- *Kết hợp*:
  - #text(fill: gray)[`Portal` cho biết các `Path` khả dụng (không triển khai ở bản IE221).]
  - `Path` cho biết danh sách các khoá học (`Course`).
  - `Course` tạo `Lab` và cập nhật `Labs`.
  - `Topics` đọc thuộc tính của `Courses`, `Path`, `Lab`.

`Serialize` thực ra rất đơn giản:

- #text(fill: blue)[`to_dict`]: chuyển đối tượng thành từ điển, vốn thân thiện với JSON.
- #text(fill: orange)[`to_json`]: chuỗi JSON của từ điển đó, chức năng cốt lõi mà các lớp kế thừa dùng trực tiếp.

#code-figure(
  "/content/code/serialize.py",
  size: 0.8em,
  caption: [`model/serialize.py`: Gốc Của Cây Kế Thừa],
  label: "ma-serialize",
)

#figure(
  image("images/model-serialize-baseentity.png"),
  caption: [Hai Cây Kế Thừa Trong Mã Nguồn],
) <hinh-ide-ke-thua>

=== Lớp, Đối Tượng Và Thuộc Tính Suy Diễn
<lop-doi-tuong-va-thuoc-tinh-suy-dien>

`BaseEntity.__init__()` khai báo các thuộc tính nguyên bản (attributes) để định danh một thực thể: `id`, `name`, `description`.

#code-figure(
  "/content/code/base_entity_init.py",
  size: 0.8em,
  caption: [`BaseEntity.__init__()` -- Ba Thuộc Tính Định Danh],
  label: "ma-base-init",
)

Nhưng để tự nhận diện và phân loại các thực thể, `BaseEntity` khai báo các thuộc tính nội sinh (properties) với `@property`, nhờ đó việc kế thừa trở nên xuyên suốt hơn:

- `@property type` trả `self.__class__.__name__`.
- `@property url` tra bảng theo `type`, trả lại `ValueError` khi gặp một loại lạ.

#code-figure(
  "/content/code/base_entity_type_url.py",
  size: 0.8em,
  caption: [`BaseEntity.type` và `BaseEntity.url`],
  label: "ma-base-type-url",
)

#co-note(title: [Hệ Quả])[
  Loại (`type`) của một thực thể không cần lưu sẵn mà tự suy ra, nên lớp con không thể thiếu nó; từ đó frontmatter theo chuẩn OKF luôn có `type` (gần như) miễn phí, không cần kiểm lại.
]

=== Kế Thừa Và Đa Hình
<ke-thua-va-da-hinh>

Kế Thừa và Đa Hình xuất hiện ở nhiều nơi trong mã nguồn, ví dụ là cặp `generate_markdown` và `save_markdown`:

- `generate_markdown`: có bản mặc định ở lớp cha và được ghi đè (override) ở Path, Course, Lab.
- `save_markdown`: ở lớp cha gọi `self.generate_markdown(**kwargs)` mà không cần biết lớp con nào đang chạy (_template method_).

#code-figure(
  "/content/code/base_entity_generate_markdown.py",
  from: 1,
  to: 10,
  size: 0.8em,
  caption: [`BaseEntity.generate_markdown` -- Mặc Định Chỉ Có Frontmatter],
  label: "ma-base-generate-markdown",
)

#code-figure(
  "/content/code/base_entity_save_markdown.py",
  size: 0.8em,
  caption: [`BaseEntity.save_markdown`: gọi `generate_markdown` Của Lớp Con],
  label: "ma-base-save-markdown",
)

=== generate_markdown

`model/lab.py` là lớp con nhỏ nhất, đủ để thấy toàn bộ cơ chế: `__init__` gọi `super()`, thêm hai thuộc tính riêng, rồi ghi đè `generate_markdown`.

// #raw(read("/content/code/lab_class.py"), lang: "python", block: true)

`Lab` kế thừa `BaseEntity`:

#code-figure(
  "/content/code/lab_class.py",
  size: 0.8em,
  from: 1,
  to: 15,
  caption: [`model/lab.py` -- Kế Thừa `BaseEntity`],
  label: "ma-lab-class",
)

Và ghi đè `generate_markdown`:

#code-figure(
  "/content/code/lab_class.py",
  size: 0.8em,
  from: 19,
  caption: [`model/lab.py` -- Ghi Đè `generate_markdown`],
  label: "ma-lab-class",
)

=== fetch_catalog

Cùng cơ chế đó ở nhánh bên phải: `Collection.fetch_catalog()` là một bản duy nhất, đọc `API_URL` và `MAX_PAGES` là thuộc tính lớp; `Paths`, `Courses`, `Labs` chỉ khai lại `API_URL`. Ở v2.0.0 có ba bản copy của vòng lặp phân trang này, mỗi lớp một bản.

#code-figure(
  "/content/code/courses_class.py",
  size: 0.8em,
  caption: [`model/courses.py` -- Lớp Con Chỉ Khai `API_URL`],
  label: "ma-courses-class",
)

=== Đóng Gói Và Kết Hợp
<dong-goi-va-ket-hop>

==== Đóng Gói

- Thuộc tính "ẩn" và động: `_json_path`, `_md_path`, `_kind` là property bắt đầu bằng `_`, suy ra từ `type` và `id`.
- `to_dict()` lọc khoá bắt đầu bằng `_` và khoá `driver`, nên JSON ghi ra không chứa tài nguyên hay đường dẫn máy.
  - `driver` là tài nguyên (một cửa sổ Chrome), không phải thuộc tính của thực thể, không cần lưu giữ.
- Các thuộc tính theo dõi như `scrapedTime` được thêm vào lúc ghi file JSON.

#code-figure(
  "/content/code/base_entity_to_dict.py",
  from: 10,
  to: 17,
  size: 0.8em,
  caption: [`BaseEntity.to_dict()` -- Lưu Gì Ra File JSON],
  label: "ma-base-to-dict",
)

==== Kết Hợp (Composition)

`Course.process_lab()` là chỗ một course tạo ra một lab và lưu lab đó, đồng thời cập nhật tập hợp `Labs`:

- `lab.load_json()` nạp file JSON của lab nếu đã có; đã có nghĩa là đã tải, bỏ qua để giữ tính nguyên vẹn như thế (idempotent).

#code-figure(
  "/content/code/course_process_lab.py",
  from: 32,
  to: 41,
  size: 0.8em,
  caption: [`Course.process_lab()` -- Tạo `Lab`, Nạp JSON],
  label: "ma-process-lab-1",
)

- Nếu chưa có, tải lab về rồi `lab.save_json()` cùng `lab.save_markdown()`.

#code-figure(
  "/content/code/course_process_lab.py",
  from: 56,
  to: 58,
  size: 0.8em,
  caption: [`Course.process_lab()` -- Lưu `Lab` Vừa Tải],
  label: "ma-process-lab-2",
)

- Đồng thời, đưa lab vào danh sách các lab đã biết.

#code-figure(
  "/content/code/course_process_lab.py",
  from: 60,
  to: 64,
  size: 0.8em,
  caption: [`Course.process_lab()` -- Cập Nhật Tập Hợp `Labs`],
  label: "ma-process-lab-3",
)

== Kiểu Dữ Liệu, Hàm Và Cấu Trúc Điều Khiển
<kieu-du-lieu-re-nhanh-vong-lap-ham>

=== Kiểu Dữ Liệu
<kieu-du-lieu>

Dữ liệu của một `Course` là `dict` (từ điển) lồng ba tầng: `modules` chứa `steps` chứa `activities`. Mỗi tầng là `list` (danh sách) của `dict`; đây cũng chính là hình dạng của file JSON, nên `json.loads` và `json.dumps` là nạp và xuất dữ liệu trực tiếp không cần lớp chuyển đổi.

#code-figure(
  "/content/code/course_init.py",
  size: 0.8em,
  caption: [`Course.__init__()` -- Kiểu Dữ Liệu],
  label: "code-course-init",
)

=== Cấu Trúc Điều Khiển
<cau-truc-dieu-khien>

Rẽ nhánh bằng `dict` (data-driven) thay cho chuỗi `if/elif`: `Course.process_step()` tra bảng `handlers` theo `activity['type']`.

- Gặp loại dữ liệu lạ (ví dụ Google mới thêm `badge`, `credential`) thì giữ nguyên dữ liệu thô, không xử lý và in thông báo.
  - Đây là chỗ thể hiện sự "trung thực" về hành vi và sự tham gia của con người: tường minh, có giới hạn, không phỏng đoán.

#code-figure(
  "/content/code/course_process_step.py",
  from: 1,
  to: 15,
  size: 0.8em,
  caption: [`Course.process_step()` -- Bảng `handlers`],
  label: "ma-process-step-1",
)

#code-figure(
  "/content/code/course_process_step.py",
  from: 16,
  to: 29,
  size: 0.8em,
  caption: [`Course.process_step()` -- Loại Lạ Được Giữ Nguyên và Thông Báo],
  label: "ma-process-step-2",
)

=== Vòng Lặp Và Hàm
<vong-lap-va-ham>

Đệ quy, vì `items` của một bài học có thể lồng nhau: `Course._parse_lesson_item()` xử lý một item rồi gọi chính nó cho các item con.

#code-figure(
  "/content/code/course_parse_lesson_item.py",
  from: 1,
  to: 15,
  size: 0.8em,
  caption: [`Course._parse_lesson_item()`: Lặp Đệ Quy Trên Cây _item_],
  label: "ma-parse-lesson-item",
)

Lặp có ngắt: `Collection.fetch_catalog()` phân trang bằng `while True` với một "điểm ngắt" `MAX_PAGES`, dừng khi trang trả về rỗng hoặc vượt giới hạn; dùng khi lấy danh sách toàn bộ Path, Course, Lab có trên skills.google.

#code-figure(
  "/content/code/collection_fetch_catalog.py",
  from: 1,
  to: 5,
  size: 0.8em,
  caption: [`Collection.fetch_catalog()` -- Bắt Đầu],
  label: "ma-fetch-catalog-1",
)

#code-figure(
  "/content/code/collection_fetch_catalog.py",
  from: 44,
  to: 59,
  size: 0.8em,
  caption: [`Collection.fetch_catalog()` -- Vòng Lặp Có Điểm Ngắt],
  label: "ma-fetch-catalog-2",
)

// Về hàm: tham số có giá trị mặc định (`force=False`, `toc_only=False`), `**kwargs` chuyển tiếp từ `save_markdown()` sang `generate_markdown()`, hàm trả `bool` để người gọi quyết định đi tiếp hay dừng (`extract_course_metadata()`, `ensure_authenticated()`), và `@staticmethod` cho hàm không cần `self` (`Path.menu_activities()`).

== Xử Lý Ngoại Lệ
<xu-ly-ngoai-le>

#co-note(title: [Nguyên Tắc])[
  Một _activity_ hỏng không làm hỏng cả _course_ trong quá trình `fetch`; một ngắt giữa chừng không để lại nửa file; mọi lỗi đều được thông báo rõ ràng, không có lỗi im lặng.
]

Các ngoại lệ gặp trong mã thuộc ba nhóm:

- Của thư viện: `NoSuchElementException` (Selenium) khi trang thiếu phần tử selector được mong đợi; `json.JSONDecodeError` khi danh mục không phải JSON; `OSError` khi ghi file.
- Của Python: `KeyboardInterrupt` và `EOFError` khi người dùng dừng ở bước đăng nhập; `KeyError` khi tra bảng trình duyệt; `ValueError` khi `type` lạ.
- `try` và `catch` có chủ ý: mỗi `process_*` của một activity nằm trong `try/except Exception` riêng và in lỗi kèm tên phương thức, để course đi tiếp sang activity kế.

`services/store.py` ghi file nguyên tử (atomic): ghi vào file tạm cùng thư mục, `fsync`, rồi `os.replace`; nếu có lỗi hoặc Ctrl+C giữa chừng thì xoá file tạm và trả lại ngoại lệ, không bao giờ để lại "nửa" file.

#code-figure(
  "/content/code/store_write_text.py",
  from: 1,
  to: 20,
  size: 0.8em,
  caption: [`store.write_text()` -- Ghi Nguyên Tử Với `try/except/raise`],
  label: "ma-write-text",
)

`services/browser.py` xử lý trường hợp người dùng bỏ dở thao tác đăng nhập: `input()` bị ngắt bằng Ctrl+C hay Ctrl+D được bắt và trả về `False`, thông báo rõ ràng.

#code-figure(
  "/content/code/browser_ensure_authenticated.py",
  from: 10,
  to: 23,
  size: 0.8em,
  caption: [`browser.ensure_authenticated()` -- `KeyboardInterrupt`, `EOFError`],
  label: "ma-ensure-authenticated",
)

`BaseEntity.save_json` có `OSError` của bước ghi và chỉ cập nhật chỉ mục khi ghi xong, nên chỉ mục không bao giờ trỏ tới một file không tồn tại.

#code-figure(
  "/content/code/base_entity_json.py",
  from: 10,
  to: 24,
  size: 0.8em,
  caption: [`BaseEntity.save_json()` -- Ghi File Trước, Cập Nhật Chỉ Mục Sau],
  label: "ma-save-json",
)

== Phiên Đăng Nhập Và Thu Thập
<phien-dang-nhap-va-thu-thap>

Từ đầu 2026, trang Course trên skills.google chuyển hướng về trang đăng nhập nếu chưa đăng nhập; vì vậy mọi trang đều đi qua một trình duyệt Chrome (hoặc Edge) do Selenium @selenium-docs điều khiển, `requests` chỉ còn dùng để tải tài liệu PDF với cookie lấy từ trình duyệt. Thay đổi này được cập nhật ở phiên bản v2.0.0 của nhánh chính (_master_) trong kho git.

Toàn bộ việc này nằm trong `services/browser.py`, với ba hàm công khai:

- `launch_browser()` mở trình duyệt trên một _profile_ cố định (`.webdriver_profiles` theo mặc định), nên phiên đăng nhập được giữ qua các lần chạy: đăng nhập một lần, những lần sau mở trực tiếp. Một danh sách cờ dùng chung cho Chrome và Edge.
- `ensure_authenticated()` chờ người dùng: nếu URL hiện tại chứa `sign_in` thì in hướng dẫn, chờ Enter, tải lại trang, lặp tới khi hoàn thành hoặc người dùng hủy bỏ.
- `get_page()` gói hai bước trên và trả về cây `BeautifulSoup` @bs4-docs của trang đã render; `model/` chỉ gọi hàm này, không (cần) biết Selenium.

#code-figure(
  "/content/code/browser_launch_browser.py",
  from: 11,
  to: 28,
  size: 0.8em,
  caption: [`browser.launch_browser()` -- Khởi Chạy Trình Duyệt],
  label: "ma-launch-browser",
)

#code-figure(
  "/content/code/browser_get_page.py",
  size: 0.8em,
  caption: [`browser.open_page()`, `browser.get_page()` -- Duyệt Trang],
  label: "ma-get-page",
)

Việc thu thập một course (`Course.extract_transcript()`) đi theo bốn bước, mỗi bước là một phương thức:

+ `extract_course_metadata()` đọc khối `ld+json` của trang: `@id`, `name`, `datePublished`, `about` (topics), `teaches` (objectives); mô tả lấy từ `meta[name=description]`.
+ `extract_course_outline()` đọc đề cương từ thẻ `ql-contents-menu`, cho ra cây `modules` → `steps` → `activities`.
+ `process_step()` cho từng step, xử lý theo loại activity (@ma-process-step-1): video thì lấy transcript YouTube, lab thì tạo `Lab`, quiz thì lấy câu hỏi, document thì tải file, link và html_bundle thì giữ URL.
+ `save_json()` để lưu file JSON rồi `save_markdown()` để lưu file Markdown.

Quy tắc bỏ qua nằm ở bước đầu: nếu `datePublished` trên trang bằng giá trị đã lưu trong JSON và không có `--force` trong lệnh gọi, phương thức in lý do và trả về `False`, `course` dừng tại đó; đây là FR-05: nếu chạy lại trên cùng một Path/Course/Lab đã tồn tại thì kết quả vẫn là nguyên bản (idempotent).

#code-figure(
  "/content/code/course_extract_metadata.py",
  from: 18,
  to: 31,
  size: 0.8em,
  caption: [`Course.extract_course_metadata()` -- Bỏ Qua Theo `datePublished`],
  label: "ma-extract-metadata",
)

Với path, `Path.fetch_data()` đọc `ql-contents-menu[modules]` của trang path làm nguồn sự thật, vì `href` ở đó phân biệt `/course_templates/<id>` (course) với `/focuses/<id>` (lab), còn `ld+json.hasPart` chỉ dùng để bổ sung tên và mô tả; `fetch -p ID --cascade` sau đó lần lượt thu thập từng course trong path.

== Lưu Trữ
<luu-tru>

Không có cơ sở dữ liệu. Mỗi thực thể là một file JSON và file đó là nguồn sự thật (SSOT); mọi thứ khác đều dẫn xuất và dựng lại được.

#code-figure(
  "/content/code/store.txt",
  size: 0.8em,
  lang: "ini",
  caption: [`data/` -- Mỗi Thực Thể Một File],
  label: "ma-data-tree",
)

`services/store.py` cung cấp đúng những gì `model/` cần:

- `write_text()`, `write_json()`, `read_json()`: đọc ghi UTF-8, ghi luôn nguyên tử (@ma-write-text).

#code-figure(
  "/content/code/store_write_text.py",
  size: 0.8em,
  caption: [`store.write_text()` -- Lưu File],
  label: "code-storage-write-text",
)

// `BaseEntity.load_json` chỉ là `self.__dict__.update(data)`: đối tượng Python và file JSON có cùng hình dạng (@ma-save-json), nên không cần tầng ORM hay schema riêng. Ở v2.0.0, TinyDB (`database.json`) chạy song song với các file JSON; bản này bỏ TinyDB vì hai nguồn sự thật phải được giữ đồng bộ mà không đem lại gì hơn một `index.json` dựng lại được trong một giây.

== Kết Xuất Markdown
<ket-xuat-markdown>

Lệnh `md` (và bước cuối của `fetch`) biến JSON thành note Markdown cho Obsidian, hoàn toàn offline. Mỗi note gồm frontmatter YAML và thân bài.

Frontmatter do `BaseEntity.generate_front_matter()` sinh, là tập mở rộng (superset) của OKF v0.2 @okf-spec: các khoá OKF (`type`, `title`, `description`, `resource`, `tags`, `sources`, `generated`), hai khoá riêng của công cụ (`id`, `portal`), và các tên cũ mà vault hiện có đang truy vấn (`url`, `date_published`, `topics`, `scraped_date`).

Kết quả thật cho course 892 từ `docs/samples/data/` trong repo:

Tạo file bằng:

```bash
uv run skills-scraper md -c 892 --toc
```

Kết quả:

#code-figure(
  "/content/code/892.md",
  from: 1,
  to: 20,
  size: 0.8em,
  lang: "yaml",
  caption: [`892.md` -- Frontmatter Từ JSON],
  label: "ma-note-mau",
)

#code-figure(
  "/content/code/base_entity_front_matter.py",
  from: 21,
  to: 48,
  size: 0.75em,
  caption: [`BaseEntity.generate_front_matter()` -- Tạo Frontmatter],
  label: "code-front-matter",
)

Quy ước cấu trúc nội dung file Markdown:

- Tiêu đề cấp 1 là tên course có liên kết về trang gốc trên Google Cloud.
- Mỗi module một tiêu đề cấp 2.
- Mỗi activity một tiêu đề cấp 3 có loại và liên kết
  - Video kèm liên kết YouTube và transcript (không sinh transcript khi gọi lệnh `md` với `--toc` hoặc `--no-transcript`)
  - Quiz là callout với từng câu hỏi.
  - Tài liệu PDF được tải vào `<vault>/materials/courses/<id>/` và liên kết tương đối từ MD.
- MD của path liệt kê các course và lab của nó bằng liên kết tương đối `../courses/...`, `../labs/...`
  - Chính các liên kết này tạo nên đồ thị ở @hinh-graph-view mà không cần thiết kế trước.

== Hai Runner
<hai-runner>

Cả hai runner đều chỉ `import` từ `model/` và `services/`; không có logic nghiệp vụ nào trong `cli.py` hay `tui.py`. Thêm một runner thứ ba bất kỳ (chẳng hạn một HTTP API) sẽ không chạm/thay đổi/ảnh hưởng tới `model/`.

=== Giao Diện Dòng Lệnh
<giao-dien-dong-lenh>

`cli.py`:

// `cli.py` dùng `argparse` với một sub-parser cho mỗi lệnh, mỗi lệnh gắn một hàm `cmd_*` qua `set_defaults(func=...)`; `main()` chỉ phân tích tham số rồi gọi `args.func(args)`.

#datatable-data((
  headers: ([Lệnh], [Làm gì], [Cờ chính]),
  rows: (
    ([`list` (`l`)], [Liệt kê path, course hoặc lab từ `data/`], [`-p`/`-c`/`-l`, `-r` làm mới từ site, `-i` sắp theo id, `--headless`]),
    ([`fetch` (`f`)], [Thu thập vào `data/` và sinh Markdown], [`-p ID...`/`-c ID...`/`-l ID...`, `--cascade`, `--force`, `--toc`, `--no-transcript`, `--no-md`]),
    ([`md`], [Sinh Markdown từ JSON đã có, offline], [`-c ID,ID`/`-p ID`/`-l ID`, `--toc`, `--no-transcript`]),
    ([`search` (`s`)], [Tìm trong dữ liệu đã tải], [`QUERY`, `-c`/`-p`/`-l`, `--field name|topics|...`]),
    // ([`reindex`], [Dựng lại `data/index.json` từ các file thực thể], [---]),
    ([`browser` (`b`)], [Mở trình duyệt đã đăng nhập và chờ, để đăng nhập], [`--profile-folder`]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("15%", "40%", "auto")),
  caption: [`skills-scraper` -- `cli`],
  label: "tb-cli",
))

// #code-figure(
//   "/content/code/cli_main.py",
//   from: 1,
//   to: 23,
//   size: 0.8em,
//   caption: [`cli.main`: sub-parser `list` với hai nhóm loại trừ lẫn nhau],
//   label: "ma-cli-main",
// )
//
// #code-figure(
//   "/content/code/cli_cmd_reindex.py",
//   size: 0.8em,
//   caption: [`cli.cmd_reindex`: một lệnh CLI là một hàm gọi vào `services`],
//   label: "ma-cli-reindex",
// )

Vì giao tiếp bằng file và mã thoát, CLI ghép được với shell và các công cụ khác mà không cần API riêng, ví dụ thu thập mọi course của một path rồi xem site đã đổi gì so với lần trước:

#figure(
```bash
uv run skills-scraper fetch -p 280 --cascade --toc
jq -r '.courses | keys[]' data/paths/280.json | while read id; do
  uv run skills-scraper md -c "$id" --toc
done
git -C csbmdvault diff --stat
```,
  kind: raw,
  caption: [CLI -- Kết Hợp Với `jq`, `while` của Shell và `git`],
) <ma-ghep-shell>

#figure(
  image("images/demo-cli.png"),
  caption: [`skills-scraper` Trong Terminal],
) <hinh-demo-cli>

=== Giao Diện Tương Tác
<giao-dien-tuong-tac>

`tui.py`:
  - Menu số và chữ.
  - Màu ANSI.
  - Vòng lặp `while` đọc `input()` và rẽ nhánh theo lựa chọn:
    - `c` một course
    - `p` một path
    - `l` danh sách
    - `h` tất cả course
    - `w` mở trình duyệt
    - `q` thoát.

Trình duyệt dùng chung: `CloudSkillsBoost.driver` là một `@property` khởi tạo lười (lazy), chỉ mở Chrome khi lựa chọn đầu tiên cần, và `close()` đóng nó trong khối `finally` của `main()`, nên thoát bằng `q` hay Ctrl+C đều không để lại tiến trình Chrome mồ côi (orphaned/zoombie).

#code-figure(
  "/content/code/tui_driver.py",
  size: 0.8em,
  caption: [`CloudSkillsBoost.driver()` -- Khởi Tạo Trình Duyệt],
  label: "ma-tui-driver",
)

#code-figure(
  "/content/code/tui_main.py",
  from: 18,
  to: 30,
  size: 0.8em,
  caption: [`tui.main` -- `try/finally` -- Đóng Trình Duyệt Khi Thoát],
  label: "ma-tui-main",
)

#figure(
  image("images/demo-tui.png"),
  caption: [`skills-scraper-tui` -- Cùng Lõi `model` -- Khác Giao Diện],
) <hinh-demo-tui>

== Kết Chương
<ket-chuong-3>

Chương 3 trình bày về các nội dung kiến thức của môn học IE221 dựa trên mã nguồn đã có sẵn của kho git, đặc biệt trên branch `refactor-ie221` từ các phần cơ bản nhất như gói và module với `uv` và `src/` (@ma-tree); tính kế thừa qua 2 cây kế thừa từ `Serialize` (@hinh-so-do-lop); kiểu dữ liệu lồng, phân nhánh bằng `dict`, đệ quy và vòng lặp có điều kiện thoát; bắt và xử lý ngoại lệ, vv... và từ đó, Chương 4 sẽ trả lời thêm câu hỏi: làm sao biết tất cả những điều trên vẫn đúng khi site đổi.
