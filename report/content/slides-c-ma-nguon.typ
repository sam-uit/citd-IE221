#import "../lib.typ": *
#import "diagrams.typ": class-diagram

= TRỌNG TÂM `/model/`
<ma-nguon-trong-tam-model>

== Package Và Module
<package-va-module>

#grid(
  columns: (1.1fr, 1fr),
  column-gutter: 1em,
  [
    #set text(size: 0.8em)
    ```yaml
    src/skills_scraper/
    ├── __init__.py      # __version__
    ├── config.py        # defaults < yaml < env
    ├── cli.py           # cli (Command Line Interface)
    ├── tui.py           # tui (Text User Interface)
    ├── model/           # LÕI QUAN TRỌNG
    │   ├── __init__.py  # __init__
    │   ├── base_entity.py
    │   ├── collection.py
    │   ├── path.py
    │   ├── course.py
    │   ├── courses.py
    │   ├── lab.py
    │   ├── labs.py
    │   ├── paths.py
    │   └── serialize.py
    ├── services/
    │   ├── __init__.py  # __init__
    │   ├── browser.py   # browser (Selenium)
    │   └── store.py     # store (JSON, index, atomic)
    └── utils/
        ├── __init__.py  # __init__
        └── utils.py
    ```
  ],
  [
    // #co-warn(title: "Giới Thiệu")[Cấu Trúc và Khai Báo]
    #code-file("/content/code/pyproject.toml", from: 1, to: 3, lang: "toml", size: 0.8em)
    #code-file("/content/code/pyproject.toml", from: 20, to: 26, lang: "toml", size: 0.8em)
    // #set text(size: 0.85em)
    // - `__init__.py` là mặt tiền: `from skills_scraper.model.course import Course`.
    // - Import *tuyệt đối*, không còn `sys.path.append` của v2.0.0.
    // - `uv sync` là toàn bộ bước cài; `uv run skills-scraper` là toàn bộ bước chạy.
  ],
)

== Sơ Đồ Lớp Của `model/`
<so-do-lop-cua-model>

#align(center)[#class-diagram(highlight: ("base", "collection"))]

#v(0.3em)
#small(size: 1em)[
#cols(
  card(title: [Trái: một thứ $x$], icon: [1])[`BaseEntity` biết id, tên, mô tả, đường dẫn file và cách ghi JSON, Markdown. Lớp con chỉ thêm dữ liệu riêng và cách render.],
  card(title: [Phải: danh sách $x$], icon: [2])[`Collection` là `{id: name}` cộng `fetch_catalog`. Lớp con chỉ khai `API_URL`.],
  card(title: [Composition], icon: [3])[
    - `Course` tạo `Lab` và cập nhật `Labs`;
    - `Path` giữ dict course;
    - `Topics` đọc `Courses`.
  ],
)
]

== Class Và Object
<class-va-object>

#grid(
  columns: (1.15fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[`model/base_entity.py`]
    #code-file("/content/code/base_entity_init.py", from: 1, to: 7, size: 11.5pt)
    #code-file("/content/code/base_entity_type_url.py", from: 1, to: 7, size: 11.5pt)
    // #code-file("/content/code/base_entity_type_url.py", from: 7, to: 7, size: 11.5pt)
    #code-file("/content/code/base_entity_type_url.py", from: 9, to: 22, size: 11.5pt)
    // #code-file("/content/code/base_entity_type_url.py", from: 15, to: 24, size: 11.5pt)
  ],
  [
    #set text(size: 0.85em)
    #card(title: [`@property`, không lưu mà suy ra], icon: [P])[
      `type` là `self.__class__.__name__`: lớp con *luôn có*. frontmatter có `type` "miễn phí" và thoả OKF ngay từ đầu.
    ]
    #v(0.5em)
    #card(title: [Object có trạng thái và tài nguyên], icon: [O])[
      `Course(id="892", driver=driver)`:
        - `modules`, `topics` là trạng thái; được serialize.
        - `driver` là tài nguyên, *không* được serialize.
    ]
    #v(0.5em)
    #card(title: [Xử lý ngoại lệ], icon: [!])[
      `url` throws `ValueError` cho `type` lạ (nếu có) thay vì trả về `None`.
    ]
  ],
)

== Kế Thừa Và Đa Hình
<ke-thua-va-da-hinh>

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[`model/base_entity.py`: lớp cha]
    #code-file("/content/code/base_entity_generate_markdown.py", from: 1, to: 10, size: 11.5pt)
    #code-file("/content/code/base_entity_save_markdown.py", from: 1, to: 7, size: 11.5pt)
  ],
  [
    #text(size: 0.8em, fill: gray)[`model/lab.py`: lớp con ghi đè]
    #code-file("/content/code/lab_class.py", from: 1, to: 15, size: 11.5pt)
    #code-file("/content/code/lab_class.py", from: 19, to: 19, size: 11.5pt)
  ],
)

#v(0.3em)
#small(size: 0.85em)[
#co-info(title: "Template method")[
  `save_markdown` ở lớp cha gọi `self.generate_markdown(**kwargs)` mà không biết lớp con nào đang chạy. `Path`, `Course`, `Lab` mỗi lớp một bản. Một lệnh `md -c / -p / -l` trong CLI chạy ba nhánh chỉ khác *lớp được khởi tạo*.
]
]

== Kế Thừa Thay Cho Ba Bản Copy
<ke-thua-thay-cho-ba-ban-copy>

#grid(
  columns: (1.2fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[`model/collection.py`: một vòng phân trang cho cả ba]
    #code-file("/content/code/collection_fetch_catalog.py", from: 25, to: 33, size: 11.5pt)
    #code-file("/content/code/collection_fetch_catalog.py", from: 54, to: 57, size: 11.5pt)
  ],
  [
    #text(size: 0.8em, fill: gray)[`model/paths.py`: lớp con chỉ còn dữ liệu]
    #code-file("/content/code/paths_class.py", from: 1, to: 14, size: 11.5pt)
  ],
)

#v(0.3em)
#small(size: 0.85em)[
v2.0.0 có *ba bản* của vòng `while` này (90 dòng mỗi bản, trong `Paths`, `Courses`, `Labs`). Sau refactor: một `fetch_catalog` ở `Collection`, lớp con khai *thuộc tính lớp* `API_URL` và `MAX_PAGES`, còn `fetch_paths` giữ tên để CLI tra bằng `getattr(collection, f"fetch_{label}")`. Diff: +118 / -268.
]

== Đóng Gói Và Composition
<dong-goi-va-composition>

#grid(
  columns: (1.1fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[`BaseEntity.to_dict`: những gì ra đĩa]
    #code-file("/content/code/base_entity_to_dict.py", from: 10, to: 17, size: 11.5pt)
    #text(size: 0.8em, fill: gray)[`Course.process_lab`: một course tạo ra một lab]
    #code-file("/content/code/course_process_lab.py", from: 32, to: 41, size: 11.5pt)
  ],
  [
    #set text(size: 0.85em)
    #card(title: [Đóng gói theo quy ước], icon: [\_])[
      `_json_path`, `_md_path` là chi tiết nội bộ. `to_dict` lọc mọi khoá `_` và khoá `driver`: JSON trên đĩa không bao giờ chứa tài nguyên hay đường dẫn máy.
    ]
    #v(0.5em)
    #card(title: [Composition, idempotent], icon: [+])[
      `Course` tạo `Lab(id)`, `load_json()`; đã có tên thì bỏ qua, chưa có thì `save_json()`, `save_markdown()` rồi cập nhật `Labs`. Chạy lại không tạo trùng.
    ]
  ],
)

== Hàm Và Cấu Trúc Điều Khiển
<ham-va-cau-truc-dieu-khien>

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[Rẽ nhánh bằng dict, loại lạ thì giữ (ch. 03)]
    #code-file("/content/code/course_process_step.py", from: 8, to: 15, size: 11pt)
    #code-file("/content/code/course_process_step.py", from: 25, to: 29, size: 11pt)
  ],
  [
    #text(size: 0.8em, fill: gray)[Đệ quy thật: bài học Rise lồng `items` (ch. 05)]
    #code-file("/content/code/course_parse_lesson_item.py", from: 9, to: 15, size: 11pt)
    #text(size: 0.8em, fill: gray)[Lặp có cầu chì (ch. 04)]
    #code-file("/content/code/collection_fetch_catalog.py", from: 54, to: 57, size: 11pt)
  ],
)

#v(0.2em)
#small(size: 0.85em)[
Tham số mặc định và `**kwargs` xuyên suốt: `generate_markdown(toc_only=False, no_transcript=False, **kwargs)`. `lambda` làm khoá sắp xếp: `sorted(collection.items(), key=lambda item: item[1])`. Ba vòng `for` lồng nhau `module`, `step`, `activity` là đúng hình dạng dữ liệu.
]

== Xử Lý Ngoại Lệ
<xu-ly-ngoai-le>

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.2em,
  [
    #text(size: 0.8em, fill: gray)[`services/store.py`: ghi nguyên tử]
    #code-file("/content/code/store_write_text.py", from: 6, to: 20, size: 11pt)
  ],
  [
    #text(size: 0.8em, fill: gray)[`services/browser.py`: người dùng bỏ dở]
    #code-file("/content/code/browser_ensure_authenticated.py", from: 10, to: 19, size: 11pt)
  ],
)

#v(0.2em)
#small(size: 0.85em)[
#cols(
  card(title: [Nguyên tắc], icon: [1])[Một activity hỏng *không được giết* cả course: `process_*` bắt, log, đi tiếp. Chỉ thiếu metadata hoặc outline mới dừng.],
  card(title: [Ba nguồn ngoại lệ], icon: [2])[Thư viện (`NoSuchElementException`, `JSONDecodeError`), Python (`KeyboardInterrupt`, `EOFError`), và của mình (`ValueError` cho type lạ).],
  card(title: [`except BaseException`], icon: [3])[Dọn file tạm rồi `raise` lại: Ctrl+C không bao giờ để lại nửa file JSON.],
)
]

== Dữ Liệu Và File, Không Có CSDL
<du-lieu-va-file-khong-co-csdl>

#grid(
  columns: (1fr, 1.1fr),
  column-gutter: 1.5em,
  [
    #set text(size: 0.8em)
    ```
    data/
    ├── index.json          ledger, dựng lại được
    ├── paths/280.json
    ├── courses/892.json    nguồn sự thật
    ├── courses/892-prompt.json
    └── labs/2794.json
    csbmdvault/
    ├── paths.md  paths/  courses/  labs/
    └── materials/courses/892/*.pdf
    ```
    #v(0.3em)
    ```
    $ skills-scraper reindex
       paths: 73   courses: 416   labs: 824
    ```
  ],
  [
    #set text(size: 0.85em)
    - Dưới 5.000 bản ghi: `grep` trả lời trong mili giây.
    - File phẳng là *git-friendly*; Obsidian đọc trực tiếp, không cần export.
    - Không trạng thái: chạy ở đâu cũng được, kể cả trong CI.
    - v2.0.0 ghi song song TinyDB và JSON, đọc từ TinyDB; chính dòng chính đã đảo lại ở v2.8.0 vì *hai nguồn sự thật*.

    #v(0.3em)
    #co-warn(title: "Database?")[
      Kết nối CSDL là kỹ năng đã học. *Không dùng* ở đây là quyết định thiết kế có lý do, không phải bỏ sót: một package nhỏ, flat-file, stateless.
    ]
  ],
)
