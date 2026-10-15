#import "/lib.typ": *

= Cài Đặt
<cai-dat>

Mỗi mục dưới đây có ít nhất một đoạn mã thật, lấy từ repo bằng `tools/snippets.py` (như deck), kèm tên tệp và tên symbol.

== Môi Trường Phát Triển
<moi-truong-phat-trien>

#co-note[Python 3.12 (`.python-version`), uv và `uv.lock`, `pyproject.toml` với `[project.scripts]` hai entry point, ruff, pytest. Một đoạn giải thích vì sao dùng uv thay cho `venv` cộng `requirements.txt` mà bài giảng chương 01 dạy: một lệnh, tái lập, khoá phiên bản. Đoạn mã: khối `[project]` và `[project.scripts]`.]

== Package Và Module
<package-va-module>

#co-note[Chương 06. Cây `src/skills_scraper/`; `model/__init__.py` là mặt tiền export; import tuyệt đối thay cho `sys.path.append` của v2.0.0 (đoạn mã trước và sau); `__version__` đọc bằng `importlib.metadata`. Nhấn mạnh commit di chuyển thuần (`git mv`) giữ được lịch sử `git log --follow` của `course.py` về tới 2025.]

== Mô Hình Hướng Đối Tượng
<mo-hinh-huong-doi-tuong>


=== Hai Cây Kế Thừa
<hai-cay-ke-thua>

#co-note[Chương 08. Sơ đồ lớp: `Serialize` sinh ra `BaseEntity` (Path, Course, Lab) và `Collection` (Paths, Courses, Labs, Topics). Một câu: cây trái là "một thứ", cây phải là "danh sách thứ đó", cả hai tự ghi JSON nhờ `Serialize`.]

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
