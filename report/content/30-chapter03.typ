#import "../lib.typ": *
#import "diagrams.typ": *

= Cài Đặt
<cai-dat>

== Môi Trường Phát Triển
<moi-truong-phat-trien>

`uv` được sử dụng để khai báo, quản lý gói, và khóa phiên bản:

- Nhất quán, có thể tái lập ở một môi trường mới bất kỳ đâu.
- Một công cụ duy nhất, `uv` và với một định dạng đánh dấu (markup) thân thiện, `toml`.

`pyproject.toml` được khai báo như sau:

- Tên của công cụ, và phiên bản.

#code-file("/content/code/pyproject.toml", from: 1, to: 3, lang: "toml", size: 1em)

- Các _runner_ tương ứng.

#code-file("/content/code/pyproject.toml", from: 20, to: 26, lang: "toml", size: 1em)

`.python-version`:

- Cho biết phiên bản Python được sử dụng.

#code-file("/content/code/python-version", lang: "toml", size: 1em)

== Package Và Module
<package-va-module>

Cấu trúc cây dưới đây cho biết cách tổ chức gói và module trong mã nguồn của công cụ:

- Một package.
- Các modules chính:
  - `model`: cốt lõi, chứa nội dung chính.
  - `services`: các dịch vụ, ở đây là chạy trình duyệt và lưu files.
  - `utils`: các tiện ích, ví dụ lọc ký tự không Unicode và chuyển đổi.

#code-file("/content/code/tree.yaml", lang: "yaml", size: 1em)

== Mô Hình Hướng Đối Tượng
<mo-hinh-huong-doi-tuong>


=== Hai Cây Kế Thừa
<hai-cay-ke-thua>

Hai nhánh kế thừa xuất phát từ cùng một điểm: `Serialize`: thân thiện với JSON.

#align(center)[#class-diagram-report(highlight: ("base", "collection"))]

Trong đó:

- Trái: *thực thể $x$* cụ thể: Ở đây là Path/Course/Lab.
  - `BaseEntity` biết id, tên, mô tả, đường dẫn file và cách ghi JSON, Markdown. Lớp con chỉ thêm dữ liệu riêng và cách render.
- Phải: *danh sách của $x$*: Ở đây là chuỗi/tập hợp của Path/Course/Lab.
  - `Collection` là `{id: name}` cộng `fetch_catalog` (kéo danh sách của một loại).
  - Lớp con chỉ khai `API_URL`.
- *Kết Hợp*:
  - #text(fill: gray)[`Portal` cho biết các `Path` khả dụng (không triển khai ở bản IE221).]
  - `Path` cho biết danh sách các khóa học (`Course`).
  - `Course` tạo `Lab` và cập nhật `Labs`.
  - `Topics` đọc thuộc tính của `Courses`/`Path`/`Lab`.

`Serialize` thực ra rất đơn giản, `serialize.py`:

- #text(fill: blue)[`to_dict`]: Chuyển đối tượng thành dạng Từ Điển, vốn thân thiện với JSON.
- #text(fill: orange)[`to_json`]: Lưu JSON, đây là chức năng cốt lõi mà các lớp kế thừa sẽ cần và dùng trực tiếp.

#code-file("/content/code/serialize.py", lang: "python", size: 0.8em)

=== Lớp, Đối Tượng Và Thuộc Tính Suy Diễn
<lop-doi-tuong-va-thuoc-tinh-suy-dien>

`BaseEntity.__init__()` khai báo các thuộc tính nguyên bản (attributes) để định danh một lớp/thực thể: `id`, `name`, `description`.

#code-file("/content/code/base_entity_init.py", lang: "python", size: 0.8em)

Nhưng để tự động nhận diện và phân loại các thực thể, `BaseEntity` khai báo các thuộc tính nội sinh (properties) với `@property`, từ đó giúp việc kế thừa trở nên xuyên suốt hơn:

- `@property type` trả `self.__class__.__name__`.
- `@property url` tra bảng theo `type`, trả về `ValueError` khi có kết quả lạ.

#code-file("/content/code/base_entity_type_url.py", lang: "python", size: 0.8em)

#co-note(title: [Hệ Quả])[
Loại (`type`) của một thực thể không cần được lưu sẵn mà tự suy ra nên lớp con không thể thiếu, và từ đó frontmatter theo chuẩn của OKF luôn có `type` (gần như) miễn phí, không cần kiểm lại.
]

=== Kế Thừa Và Đa Hình
<ke-thua-va-da-hinh>

Kế Thừa và Đa Hình được biểu hiện ở nhiều nơi trong code base, như ví dụ dưới đây.

- `generate_markdown` mặc định ở lớp cha và được ghi đè (override) ở Path, Course, Lab như ví dụ sau đây.

`model/base_entity.py`: lớp cha.

- `generate_markdown`:

#code-file(
  "/content/code/base_entity_generate_markdown.py",
  from: 1,
  to: 10,
  size: 0.8em
)

- `save_markdown`:
 - `save_markdown` ở lớp cha gọi `self.generate_markdown(**kwargs)` mà không (cần) biết lớp con nào đang chạy.

#code-file("/content/code/base_entity_save_markdown.py", from: 1, to: 11, size: 0.8em)

`model/lab.py`: lớp con kế thừa và ghi đè `generate_markdown`.

#code-file("/content/code/lab_class.py", size: 0.8em)
// #code-file("/content/code/lab_class.py", from: 19, to: 19, size: 0.8em)

Hình ảnh biểu hiện trong code base thực tế:

#align(center)[
  #image("images/model-serialize-baseentity.png")
]

=== Đóng Gói Và Kết Hợp
<dong-goi-va-ket-hop>

==== Đóng Gói

  - Thuộc tính "ẩn" và động: `_json_path`, `_md_path`.
  - `to_dict` lọc khoá bắt đầu bằng `_` và `driver`, nên JSON được ghi ra sẽ không chứa tài nguyên hay đường dẫn máy.
    - `driver`: đây là tài nguyên, không phải là thuộc tính của các thực thể, không cần lưu giữ.

`BaseEntity.to_dict`: cho biết cần lưu gì ra đĩa/file JSON.

- Các thuộc tính bổ sung để theo dõi như `scrapedTime` được thêm vào.

#code-file("/content/code/base_entity_to_dict.py", from: 10, to: 17, size: 0.8em)

==== Kết Hợp (Composition)

  - `Course.process_lab` tạo `Lab`, và gọi `load_json`.
  - Nếu file JSON cho Lab đó đã tồn tại thì bỏ qua để giữ trạng thái "như vậy" (idempotent).
  - Nếu chưa có file JSON của Lab đó thì thì lưu và cập nhật `Labs` (danh sách các Lab được ghi nhận).

`Course.process_lab`: một course tạo ra một lab, và lưu lab đó với `lab.save_json()`.

- `lab.load_json()` để tải lên file JSON của lab vừa tạo, nếu có file, có nghĩa lab đó đã được tải, sẽ bỏ qua.

#code-file("/content/code/course_process_lab.py", from: 32, to: 41, size: 0.8em)

- Nếu không có, thì sẽ tải lab về, sau đó gọi `lab.save_json()` (cùng với `lab.save_markdown()`) để lưu.

#code-file("/content/code/course_process_lab.py", from: 56, to: 58, size: 0.8em)

- Đồng thời, đưa lab vào danh sách các lab đã biết.

#code-file("/content/code/course_process_lab.py", from: 60, to: 64, size: 0.8em)


== Kiểu Dữ Liệu, Rẽ Nhánh, Vòng Lặp, Hàm
<kieu-du-lieu-re-nhanh-vong-lap-ham>

#co-note[Chương 02 tới 05, mỗi chương một đoạn mã ngắn. 02: cấu trúc dict lồng `modules[].steps[].activities[]`, định dạng chuỗi. 03: dispatch dict theo loại activity trong `process_step` thay chuỗi `elif`, loại lạ giữ nguyên. 04: `while has_more` phân trang với cầu chì số trang; ba tầng `for` module, step, activity. 05: tham số mặc định và `**kwargs` của `generate_markdown`, `lambda` làm khoá sắp xếp, đệ quy `_parse_lesson_item`.]

== Xử Lý Ngoại Lệ
<xu-ly-ngoai-le>

#co-note[Chương 07. Nguyên tắc: một activity hỏng không làm hỏng cả course. Ba nhóm ngoại lệ: của thư viện (`NoSuchElementException`, `json.JSONDecodeError`, `OSError`), của Python (`KeyboardInterrupt`, `EOFError` khi bỏ đăng nhập), tự định nghĩa (nếu P10 đã làm thì `ConnectionLostError`, nếu chưa thì bỏ và ghi ở hướng phát triển). Đoạn mã chính: `services/store.py` `write_text` (ghi tệp tạm, `os.replace`, `except BaseException` dọn tệp tạm rồi `raise`).]

== Phiên Đăng Nhập Và Thu Thập
<phien-dang-nhap-va-thu-thap>

#co-note[`services/browser.py`: khởi tạo Chrome với profile tái dùng, cờ headless mới; `ensure_authenticated` là chỗ duy nhất chờ người dùng (v2.0.0 có sáu khối `input()` rải trong `course.py`). Danh mục đọc JSON trong thẻ `<pre>` do trình duyệt hiển thị. Path đọc từ `ql-contents-menu`, `ld+json` chỉ bổ sung. Quy tắc bỏ qua theo `datePublished`.]

== Lưu Trữ
<luu-tru>

#co-note[JSON mỗi thực thể là nguồn sự thật (`data/courses/892.json`); `index.json` là chỉ mục dẫn xuất, dựng lại bằng `reindex`; `search` quét chỉ mục. Ảnh chụp cấu trúc thư mục `data/`.]

== Kết Xuất Markdown
<ket-xuat-markdown>

#co-note[Frontmatter tuần tự hoá bằng `json.dumps` cho giá trị vô hướng (sửa lỗi dấu nháy của v2.0.0); khoá OKF và alias cũ; quy ước thân bài (tiêu đề module và activity, callout quiz); tài liệu PDF vào `materials/courses/<id>/`. Một note mẫu hoàn chỉnh, rút gọn transcript.]

== Hai Runner
<hai-runner>


=== Giao Diện Dòng Lệnh
<giao-dien-dong-lenh>

#co-note[Bảng lệnh lấy từ `--help` thật: `list`, `fetch`, `md`, `search`, `reindex` và cờ. Mã thoát. Một ví dụ ghép lệnh với shell, `jq`, `git`.]

=== Giao Diện Tương Tác
<giao-dien-tuong-tac>

#co-note[TUI giữ kiểu menu v2.0.0, màu ANSI; trình duyệt dùng chung khởi tạo lười và đóng khi thoát. Ảnh chụp màn hình. Ý chính: cùng lõi, giao diện khác, không sửa `model/`.]

== Tổng Kết Chương 3
<tong-ket-chuong-3>
