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
  size: 0.85em,
  caption: [`model/serialize.py`: Gốc Của Cây Kế Thừa],
  label: "ma-serialize",
)

=== Lớp, Đối Tượng Và Thuộc Tính Suy Diễn
<lop-doi-tuong-va-thuoc-tinh-suy-dien>

`BaseEntity.__init__()` khai báo các thuộc tính nguyên bản (attributes) để định danh một thực thể: `id`, `name`, `description`.

#code-figure(
  "/content/code/base_entity_init.py",
  size: 0.85em,
  caption: [`BaseEntity.__init__()` -- Ba Thuộc Tính Định Danh],
  label: "ma-base-init",
)

Nhưng để tự nhận diện và phân loại các thực thể, `BaseEntity` khai báo các thuộc tính nội sinh (properties) với `@property`, nhờ đó việc kế thừa trở nên xuyên suốt hơn:

- `@property type` trả `self.__class__.__name__`.
- `@property url` tra bảng theo `type`, trả lại `ValueError` khi gặp một loại lạ.

#code-figure(
  "/content/code/base_entity_type_url.py",
  size: 0.85em,
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
  size: 0.85em,
  caption: [`BaseEntity.generate_markdown` -- Mặc Định Chỉ Có Frontmatter],
  label: "ma-base-generate-markdown",
)

#code-figure(
  "/content/code/base_entity_save_markdown.py",
  size: 0.85em,
  caption: [`BaseEntity.save_markdown`: gọi `generate_markdown` Của Lớp Con],
  label: "ma-base-save-markdown",
)

`model/lab.py` là lớp con nhỏ nhất, đủ để thấy toàn bộ cơ chế: `__init__` gọi `super()`, thêm hai thuộc tính riêng, rồi ghi đè `generate_markdown`.

#code-figure(
  "/content/code/lab_class.py",
  size: 0.85em,
  caption: [`model/lab.py`: lớp con kế thừa `BaseEntity` và ghi đè `generate_markdown`],
  label: "ma-lab-class",
)

Cùng cơ chế đó ở nhánh bên phải: `Collection.fetch_catalog` là một bản duy nhất, đọc `API_URL` và `MAX_PAGES` là thuộc tính lớp; `Paths`, `Courses`, `Labs` chỉ khai lại `API_URL`. Ở v2.0.0 có ba bản copy của vòng lặp phân trang này, mỗi lớp một bản.

#code-figure(
  "/content/code/courses_class.py",
  size: 0.85em,
  caption: [`model/courses.py`: lớp con chỉ khai `API_URL`, phần còn lại kế thừa],
  label: "ma-courses-class",
)

#figure(
  image("images/model-serialize-baseentity.png"),
  caption: [Hai cây kế thừa như IDE nhìn thấy trong mã thật],
) <hinh-ide-ke-thua>

=== Đóng Gói Và Kết Hợp
<dong-goi-va-ket-hop>

==== Đóng Gói

- Thuộc tính "ẩn" và động: `_json_path`, `_md_path`, `_kind` là property bắt đầu bằng `_`, suy ra từ `type` và `id`.
- `to_dict` lọc khoá bắt đầu bằng `_` và khoá `driver`, nên JSON ghi ra không chứa tài nguyên hay đường dẫn máy.
  - `driver` là tài nguyên (một cửa sổ Chrome), không phải thuộc tính của thực thể, không cần lưu giữ.
- Các thuộc tính theo dõi như `scrapedTime` được thêm vào lúc ghi.

#code-figure(
  "/content/code/base_entity_to_dict.py",
  from: 10,
  to: 17,
  size: 0.85em,
  caption: [`BaseEntity.to_dict`: cái gì được lưu ra đĩa],
  label: "ma-base-to-dict",
)

==== Kết Hợp (Composition)

`Course.process_lab` là chỗ một course tạo ra một lab và lưu lab đó, đồng thời cập nhật tập hợp `Labs`:

- `lab.load_json()` nạp file JSON của lab nếu đã có; đã có nghĩa là đã tải, bỏ qua để giữ tính idempotent.

#code-figure(
  "/content/code/course_process_lab.py",
  from: 32,
  to: 41,
  size: 0.85em,
  caption: [`Course.process_lab`: tạo `Lab`, nạp JSON, bỏ qua nếu đã có],
  label: "ma-process-lab-1",
)

- Nếu chưa có, tải lab về rồi `lab.save_json()` cùng `lab.save_markdown()`.

#code-figure(
  "/content/code/course_process_lab.py",
  from: 56,
  to: 58,
  size: 0.85em,
  caption: [`Course.process_lab`: lưu lab vừa tải],
  label: "ma-process-lab-2",
)

- Đồng thời, đưa lab vào danh sách các lab đã biết.

#code-figure(
  "/content/code/course_process_lab.py",
  from: 60,
  to: 64,
  size: 0.85em,
  caption: [`Course.process_lab`: cập nhật tập hợp `Labs`],
  label: "ma-process-lab-3",
)

== Kiểu Dữ Liệu, Hàm Và Cấu Trúc Điều Khiển
<kieu-du-lieu-re-nhanh-vong-lap-ham>

=== Kiểu Dữ Liệu
<kieu-du-lieu>

Dữ liệu của một course là `dict` lồng ba tầng, `modules` chứa `steps` chứa `activities`, mỗi tầng là `list` của `dict`; đây cũng chính là hình dạng của file JSON, nên `json.loads` và `json.dumps` đi thẳng không cần lớp chuyển đổi. Chuỗi được xử lý bằng f-string và các phương thức `str`, ví dụ `yaml_scalar` bên dưới dùng `json.dumps` để một chuỗi bất kỳ (kể cả có dấu nháy) thành một giá trị YAML hợp lệ, vì JSON là tập con của YAML. `tuple` xuất hiện làm khoá sắp xếp trong `numeric_id`: số thì so theo giá trị, chữ thì so theo chữ và đứng sau.

#code-figure(
  "/content/code/base_entity_yaml_scalar.py",
  size: 0.85em,
  caption: [`yaml_scalar`, `yaml_list`: chuỗi thành YAML an toàn],
  label: "ma-yaml-scalar",
)

#code-figure(
  "/content/code/collection_numeric_id.py",
  size: 0.85em,
  caption: [`numeric_id`: tuple làm khoá sắp xếp, 9 < 10 < 108],
  label: "ma-numeric-id",
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
  size: 0.85em,
  caption: [`Course.process_step`: bảng dispatch theo loại activity],
  label: "ma-process-step-1",
)

#code-figure(
  "/content/code/course_process_step.py",
  from: 16,
  to: 29,
  size: 0.85em,
  caption: [`Course.process_step`: loại lạ được giữ nguyên và báo],
  label: "ma-process-step-2",
)

=== Vòng Lặp Và Hàm
<vong-lap-va-ham>

Đệ quy, vì `items` của một bài học có thể lồng nhau: `Course._parse_lesson_item()` xử lý một item rồi gọi chính nó cho các item con.

#code-figure(
  "/content/code/course_parse_lesson_item.py",
  from: 1,
  to: 15,
  size: 0.85em,
  caption: [`Course._parse_lesson_item`: đệ quy trên cây item],
  label: "ma-parse-lesson-item",
)

Lặp có ngắt: `Collection.fetch_catalog()` phân trang bằng `while True` với một "cầu chì" `MAX_PAGES`, dừng khi trang trả về rỗng hoặc vượt giới hạn; dùng khi lấy danh sách toàn bộ Path, Course, Lab có trên skills.google.

#code-figure(
  "/content/code/collection_fetch_catalog.py",
  from: 1,
  to: 5,
  size: 0.85em,
  caption: [`Collection.fetch_catalog`: chữ ký và tham số mặc định],
  label: "ma-fetch-catalog-1",
)

#code-figure(
  "/content/code/collection_fetch_catalog.py",
  from: 44,
  to: 59,
  size: 0.85em,
  caption: [`Collection.fetch_catalog`: vòng lặp phân trang có cầu chì],
  label: "ma-fetch-catalog-2",
)

Về hàm: tham số có giá trị mặc định (`force=False`, `toc_only=False`), `**kwargs` chuyển tiếp từ `save_markdown` sang `generate_markdown`, hàm trả `bool` để người gọi quyết định đi tiếp hay dừng (`extract_course_metadata`, `ensure_authenticated`), và `@staticmethod` cho hàm không cần `self` (`Path.menu_activities`).

== Xử Lý Ngoại Lệ
<xu-ly-ngoai-le>

#co-note(title: [Nguyên Tắc])[
  Một _activity_ hỏng không làm hỏng cả _course_ trong quá trình `fetch`; một ngắt giữa chừng không để lại nửa file; mọi lỗi đều được báo, không có lỗi im lặng.
]

Các ngoại lệ gặp trong mã thuộc ba nhóm:

- Của thư viện: `NoSuchElementException` (Selenium) khi trang thiếu phần tử mong đợi, `json.JSONDecodeError` khi danh mục không phải JSON, `OSError` khi ghi file.
- Của Python: `KeyboardInterrupt` và `EOFError` khi người dùng dừng ở bước đăng nhập, `KeyError` khi tra bảng trình duyệt, `ValueError` khi `type` lạ.
- Bắt rộng có chủ ý: mỗi `process_*` của một activity nằm trong `try/except Exception` riêng và in lỗi kèm tên phương thức, để course đi tiếp sang activity kế. Bản IE221 không định nghĩa lớp ngoại lệ riêng; phần thử lại khi mất mạng (P10 ở @bang-port-tu-dong-chinh) là hướng phát triển.

`services/store.py` ghi file nguyên tử (atomic): ghi vào file tạm cùng thư mục, `fsync`, rồi `os.replace`; nếu có lỗi hoặc Ctrl+C giữa chừng thì xoá file tạm và ném lại ngoại lệ, không bao giờ để lại "nửa" file.

#code-figure(
  "/content/code/store_write_text.py",
  from: 1,
  to: 20,
  size: 0.85em,
  caption: [`store.write_text`: ghi nguyên tử với `try/except/raise`],
  label: "ma-write-text",
)

`services/browser.py` xử lý trường hợp người dùng bỏ dở thao tác đăng nhập: `input()` bị ngắt bằng Ctrl+C hay Ctrl+D được bắt và trả `False`, người gọi dừng tường minh.

#code-figure(
  "/content/code/browser_ensure_authenticated.py",
  from: 10,
  to: 23,
  size: 0.85em,
  caption: [`browser.ensure_authenticated`: bắt `KeyboardInterrupt`, `EOFError`],
  label: "ma-ensure-authenticated",
)

`BaseEntity.save_json` bắt `OSError` của bước ghi và chỉ cập nhật chỉ mục khi ghi xong, nên chỉ mục không bao giờ trỏ tới một file không tồn tại.

#code-figure(
  "/content/code/base_entity_json.py",
  from: 10,
  to: 24,
  size: 0.85em,
  caption: [`BaseEntity.save_json`: ghi trước, cập nhật chỉ mục sau],
  label: "ma-save-json",
)

== Phiên Đăng Nhập Và Thu Thập
<phien-dang-nhap-va-thu-thap>

Từ đầu 2026, trang course trên skills.google chuyển hướng về trang đăng nhập nếu không có phiên; vì vậy mọi trang đều đi qua một trình duyệt Chrome (hoặc Edge) do Selenium @selenium-docs điều khiển, `requests` chỉ còn dùng để tải tài liệu PDF với cookie lấy từ trình duyệt. Toàn bộ việc này nằm trong `services/browser.py`, khoảng một trăm dòng, với ba hàm công khai:

- `launch_browser` mở trình duyệt trên một _profile_ cố định (`.webdriver_profiles` theo mặc định), nên phiên đăng nhập được giữ qua các lần chạy: đăng nhập một lần, những lần sau đi thẳng. Một danh sách cờ dùng chung cho Chrome và Edge; `--headless=new` khi profile đã đăng nhập.
- `ensure_authenticated` là *chỗ duy nhất* chờ người dùng: nếu URL hiện tại chứa `sign_in` thì in hướng dẫn, chờ Enter, tải lại trang, lặp tới khi qua được hoặc người dùng bỏ. Ở v2.0.0 có sáu khối `input()` rải trong `course.py`.
- `get_page` gói hai bước trên và trả về cây `BeautifulSoup` @bs4-docs của trang đã render; `model/` chỉ gọi hàm này, không biết Selenium.

#code-figure(
  "/content/code/browser_launch_browser.py",
  from: 11,
  to: 28,
  size: 0.85em,
  caption: [`browser.launch_browser`: tra bảng trình duyệt, cờ dùng chung, profile cố định],
  label: "ma-launch-browser",
)

#code-figure(
  "/content/code/browser_get_page.py",
  size: 0.85em,
  caption: [`browser.open_page`, `browser.get_page`: cửa duy nhất tới trang web cho `model/`],
  label: "ma-get-page",
)

Việc thu thập một course (`Course.extract_transcript`) đi theo bốn bước, mỗi bước là một phương thức:

+ `extract_course_metadata` đọc khối `ld+json` của trang: `@id`, `name`, `datePublished`, `about` (topics), `teaches` (objectives); mô tả lấy từ `meta[name=description]`.
+ `extract_course_outline` đọc đề cương từ thẻ `ql-contents-menu`, cho ra cây `modules` → `steps` → `activities`.
+ `process_step` cho từng step, dispatch theo loại activity (@ma-process-step-1): video thì lấy transcript YouTube, lab thì tạo `Lab`, quiz thì lấy câu hỏi, document thì tải file, link và html_bundle thì giữ URL.
+ `save_json` rồi `save_markdown`.

Quy tắc bỏ qua nằm ở bước đầu: nếu `datePublished` trên trang bằng giá trị đã lưu trong JSON và không có `--force`, phương thức in lý do và trả `False`, course dừng tại đó; đây là FR-05 và cũng là lý do chạy lại là idempotent.

#code-figure(
  "/content/code/course_extract_metadata.py",
  from: 18,
  to: 31,
  size: 0.85em,
  caption: [`Course.extract_course_metadata`: bỏ qua theo `datePublished`, tường minh],
  label: "ma-extract-metadata",
)

Với path, `Path.fetch_data` đọc `ql-contents-menu[modules]` của trang path làm nguồn sự thật về thành viên, vì `href` ở đó phân biệt `/course_templates/<id>` với `/focuses/<id>` (lab), còn `ld+json.hasPart` chỉ dùng để bổ sung tên và mô tả; `fetch -p ID --cascade` sau đó lần lượt thu thập từng course trong path. Danh mục (`list -r`) cũng đi qua trình duyệt: endpoint `/catalog/list?format[]=...` trả 403 cho `requests` trần, nhưng khi Chrome mở nó thì JSON nằm trong thẻ `<pre>`, `fetch_catalog` đọc thẻ đó rồi `json.loads`.

== Lưu Trữ
<luu-tru>

Không có cơ sở dữ liệu. Mỗi thực thể là một file JSON và file đó là nguồn sự thật (SSOT); mọi thứ khác đều dẫn xuất và dựng lại được.

#figure(
```
data/
├── index.json          chỉ mục dẫn xuất: {kind: {id: {name, datePublished, scrapedTime}}}
├── paths.json          tập hợp {id: name} của Paths (Collection)
├── paths/280.json      một path
├── courses/892.json    một course, đầy đủ modules/steps/activities
└── labs/<id>.json      một lab
```,
  kind: raw,
  caption: [Thư mục `data/`: một thực thể, một file],
) <ma-data-tree>

`services/store.py` cung cấp đúng những gì `model/` cần:

- `write_text`, `write_json`, `read_json`: đọc ghi UTF-8, ghi luôn nguyên tử (@ma-write-text).
- `Index`: lớp bọc `data/index.json`. `upsert` trộn ba trường chỉ mục của một document vào bảng và giữ giá trị cũ cho trường document không mang (một dòng danh mục trần chưa có ngày); `search` tìm chuỗi con không phân biệt hoa thường, trả lời từ chỉ mục khi hỏi `name`/`id`, mở file thực thể khi hỏi trường khác; `rebuild` quét `data/<kind>/*.json` và dựng lại toàn bộ, đó là lệnh `reindex`.

#code-figure(
  "/content/code/store_index_rebuild.py",
  size: 0.85em,
  caption: [`Index.upsert` và `Index.rebuild`: chỉ mục luôn dựng lại được từ file],
  label: "ma-index-rebuild",
)

`BaseEntity.load_json` chỉ là `self.__dict__.update(data)`: đối tượng Python và file JSON có cùng hình dạng (@ma-save-json), nên không cần tầng ORM hay schema riêng. Ở v2.0.0, TinyDB (`database.json`) chạy song song với các file JSON; bản này bỏ TinyDB vì hai nguồn sự thật phải được giữ đồng bộ mà không đem lại gì hơn một `index.json` dựng lại được trong một giây.

== Kết Xuất Markdown
<ket-xuat-markdown>

Lệnh `md` (và bước cuối của `fetch`) biến JSON thành note Markdown cho Obsidian, hoàn toàn offline. Mỗi note gồm frontmatter YAML và thân bài.

Frontmatter do `BaseEntity.generate_front_matter` sinh, là tập mở rộng (superset) của OKF v0.2 @okf-spec: các khoá OKF (`type`, `title`, `description`, `resource`, `tags`, `sources`, `generated`), hai khoá riêng của công cụ (`id`, `portal`), và các tên cũ mà vault hiện có đang truy vấn (`url`, `date_published`, `topics`, `scraped_date`). Mọi giá trị vô hướng đi qua `yaml_scalar` (@ma-yaml-scalar), nên tên course có dấu nháy đơn không còn làm hỏng YAML như ở v2.0.0.

#code-figure(
  "/content/code/base_entity_front_matter.py",
  from: 21,
  to: 48,
  size: 0.75em,
  caption: [`BaseEntity.generate_front_matter`: khoá OKF, khoá riêng và alias cũ],
  label: "ma-front-matter",
)

Kết quả thật cho course 892, sinh bằng `uv run skills-scraper md -c 892 --toc` từ `docs/samples/data/` trong repo, không cần mạng:

#figure(
```yaml
---
id: "892"
title: "Conversational AI on Vertex AI and Dialogflow CX"
type: Course
portal: public
description: "In this course you will learn how to use the new generative AI features in Dialogflow CX ..."
resource: https://www.skills.google/course_templates/892
sources:
  - resource: https://www.skills.google/course_templates/892
    title: "Google Skills course 892"
    author: Google Cloud
    last_modified: 2023-11-21
generated:
  by: skills-scraper/2.0.1
  at: 2026-10-16T14:16:02+00:00
url: https://www.skills.google/course_templates/892
date_published: 2023-11-21
topics: []
scraped_date: 2026-10-16
---

# [Conversational AI on Vertex AI and Dialogflow CX](https://www.skills.google/course_templates/892)

## Course Introduction

### Video - [Course Introduction](https://www.skills.google/course_templates/892/video/425551)

- [YouTube: Course Introduction](https://www.youtube.com/watch?v=JiLHQnBW92U)
```,
  kind: raw,
  caption: [Note `courses/Conversational-AI-on-Vertex-AI-and-Dialogflow-CX.md`, rút gọn],
) <ma-note-mau>

Quy ước thân bài: tiêu đề cấp 1 là tên course có liên kết về trang gốc; mỗi module một tiêu đề cấp 2; mỗi activity một tiêu đề cấp 3 có loại và liên kết; video kèm liên kết YouTube và transcript (bỏ khi `--toc` hoặc `--no-transcript`); quiz là callout với từng câu hỏi; tài liệu PDF được tải vào `<vault>/materials/courses/<id>/` và liên kết tương đối từ note. Note của path liệt kê các course và lab của nó bằng liên kết tương đối `../courses/...`, `../labs/...`; chính các liên kết này tạo nên đồ thị ở @hinh-graph-view mà không ai thiết kế trước.

== Hai Runner
<hai-runner>

Cả hai runner đều chỉ `import` từ `model/` và `services/`; không có logic nghiệp vụ nào trong `cli.py` hay `tui.py`. Thêm một runner thứ ba (chẳng hạn một HTTP API) sẽ không chạm tới `model/`.

=== Giao Diện Dòng Lệnh
<giao-dien-dong-lenh>

`cli.py` dùng `argparse` với một sub-parser cho mỗi lệnh, mỗi lệnh gắn một hàm `cmd_*` qua `set_defaults(func=...)`; `main()` chỉ phân tích tham số rồi gọi `args.func(args)`.

#datatable-data((
  headers: ([Lệnh], [Làm gì], [Cờ chính]),
  rows: (
    ([`list` (`l`)], [Liệt kê path, course hoặc lab từ `data/`], [`-p`/`-c`/`-l`, `-r` làm mới từ site, `-i` sắp theo id, `--headless`]),
    ([`fetch` (`f`)], [Thu thập vào `data/` và sinh Markdown], [`-p ID...`/`-c ID...`/`-l ID...`, `--cascade`, `--force`, `--toc`, `--no-transcript`, `--no-md`]),
    ([`md`], [Sinh Markdown từ JSON đã có, offline], [`-c ID,ID`/`-p ID`/`-l ID`, `--toc`, `--no-transcript`]),
    ([`search` (`s`)], [Tìm trong dữ liệu đã tải], [`QUERY`, `-c`/`-p`/`-l`, `--field name|topics|...`]),
    ([`reindex`], [Dựng lại `data/index.json` từ các file thực thể], [---]),
    ([`browser` (`b`)], [Mở trình duyệt đã đăng nhập và chờ, để đăng nhập], [`--profile-folder`]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("18%", "40%", "auto")),
  caption: [Các lệnh của `skills-scraper`, theo `--help` thật],
  label: "tb-cli",
))

#code-figure(
  "/content/code/cli_main.py",
  from: 1,
  to: 23,
  size: 0.85em,
  caption: [`cli.main`: sub-parser `list` với hai nhóm loại trừ lẫn nhau],
  label: "ma-cli-main",
)

#code-figure(
  "/content/code/cli_cmd_reindex.py",
  size: 0.85em,
  caption: [`cli.cmd_reindex`: một lệnh CLI là một hàm gọi vào `services`],
  label: "ma-cli-reindex",
)

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
  caption: [Ghép CLI với `jq`, `while` của shell và `git`],
) <ma-ghep-shell>

#figure(
  image("images/demo-cli.png"),
  caption: [`skills-scraper` chạy trong terminal],
) <hinh-demo-cli>

=== Giao Diện Tương Tác
<giao-dien-tuong-tac>

`tui.py` giữ nguyên kiểu menu của v2.0.0: menu số và chữ, màu ANSI, vòng lặp `while` đọc `input()` và rẽ nhánh theo lựa chọn (`c` một course, `p` một path, `l` danh sách, `h` tất cả course, `w` mở trình duyệt, `q` thoát). Điểm mới duy nhất là trình duyệt dùng chung: `CloudSkillsBoost.driver` là một `@property` khởi tạo lười (lazy), chỉ mở Chrome khi lựa chọn đầu tiên cần tới mạng, và `close()` đóng nó trong khối `finally` của `main()`, nên thoát bằng `q` hay Ctrl+C đều không để lại cửa sổ Chrome mồ côi.

#code-figure(
  "/content/code/tui_driver.py",
  size: 0.85em,
  caption: [`CloudSkillsBoost.driver`: trình duyệt khởi tạo lười, dùng chung cho cả phiên],
  label: "ma-tui-driver",
)

#code-figure(
  "/content/code/tui_main.py",
  from: 18,
  to: 30,
  size: 0.85em,
  caption: [`tui.main`: `try/finally` đảm bảo đóng trình duyệt khi thoát],
  label: "ma-tui-main",
)

#figure(
  image("images/demo-tui.png"),
  caption: [`skills-scraper-tui`: cùng lõi, giao diện khác],
) <hinh-demo-tui>

== Kết Chương
<ket-chuong-3>

Chương này chỉ ra trên mã thật của branch `refactor-ie221` các nội dung của môn học: gói và module với `uv` và `src/` (@ma-tree); hai cây kế thừa từ `Serialize` với `@property`, `super()` và ghi đè (@hinh-so-do-lop); kiểu dữ liệu lồng, dispatch bằng `dict`, đệ quy và vòng lặp có cầu chì; ngoại lệ được bắt ở đúng phạm vi cùng ghi file nguyên tử (@ma-write-text). Ba mảng còn lại, phiên đăng nhập đi qua một cửa duy nhất (@ma-get-page), lưu trữ bằng file JSON làm nguồn sự thật (@ma-data-tree) và kết xuất Markdown theo OKF (@ma-front-matter), tạo nên công cụ hoàn chỉnh mà hai runner (@tb-cli, @hinh-demo-tui) chỉ là hai lớp vỏ mỏng. Chương 4 trả lời câu hỏi: làm sao biết tất cả những điều trên vẫn đúng khi site đổi.
