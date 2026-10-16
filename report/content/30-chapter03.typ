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
  - `Collection` là `{id: name}` cộng `fetch_catalog`. Lớp con chỉ khai `API_URL`.
- *Kết Hợp*:
  - #text(fill: gray)[`Portal` cho biết các `Path` khả dụng.]
  - `Path` cho biết danh sách các khóa học (`Course`).
  - `Course` tạo `Lab` và cập nhật `Labs`.
  - `Topics` đọc thuộc tính của `Courses`/`Path`/`Lab`.

`Serialize` thực ra rất đơn giản, `serialize.py`:

- `to_dict`: Chuyển đối tượng thành dạng Từ Điển, vốn thân thiện với JSON.
- `to_json`: Lưu JSON: đây là chức năng cốt lõi mà các lớp kế thừa sẽ cần và dùng trực tiếp.

#code-file("/content/code/serialize.py", lang: "python", size: 0.8em)

=== Lớp, Đối Tượng Và Thuộc Tính Suy Diễn
<lop-doi-tuong-va-thuoc-tinh-suy-dien>

#co-note[`BaseEntity.__init__`; `@property type` trả `self.__class__.__name__`; `@property url` tra bảng theo `type`, ném `ValueError` khi lạ. Ý giảng: `type` không lưu mà suy ra nên lớp con không thể quên khai, và đó là lý do frontmatter OKF có `type` miễn phí. Đối tượng: `Course(id="892", driver=driver)` có trạng thái (modules, topics) và một tài nguyên (driver) không được tuần tự hoá.]

=== Kế Thừa Và Đa Hình
<ke-thua-va-da-hinh>

#co-note[`class Course(BaseEntity)` với `super().__init__`; `generate_markdown` mặc định ở lớp cha và ghi đè ở Path, Course, Lab; `save_markdown` là template method. `Collection.fetch_catalog` với `API_URL`, `MAX_PAGES` là thuộc tính lớp mà `Paths` ghi đè (commit `ae21659`, kế thừa thay cho ba bản sao).]

=== Đóng Gói Và Kết Hợp
<dong-goi-va-ket-hop>

#co-note[Quy ước `_json_path`, `_md_path`; `to_dict` lọc khoá bắt đầu bằng `_` và `driver`, nên JSON trên đĩa không chứa tài nguyên hay đường dẫn máy. Composition: `Course.process_lab` tạo `Lab`, gọi `load_json`, có rồi thì bỏ qua (idempotent), chưa có thì lưu và cập nhật `Labs`.]

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
