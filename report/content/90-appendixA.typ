#import "/lib.typ": *

= Nguồn Gốc Và Tư Liệu
<nguon-goc-va-tu-lieu>

== Nguồn Gốc Mã Nguồn
<nguon-goc-ma-nguon>

Ứng dụng là branch `refactor-ie221` của repo `github.com/ggcta/skills-scrapper`, tách từ tag `v2.0.0` (commit `ac49ba2`, 18/02/2026), công trình trước đó của cùng tác giả, bắt đầu từ 05/01/2025 dưới tên Cloud Skills Boost helper. Dòng chính của repo đã chuyển sang lõi Go và giao diện Tauri (tới v2.17.0); báo cáo này chỉ xét phần Python và chỉ dùng dòng chính làm nguồn tham khảo cho các thay đổi của site.

Tính đến bản nộp, branch có 22 commit sau `v2.0.0`, HEAD là `45c7d0a` (27/09/2026). Phiên bản gói trong `pyproject.toml` là `2.0.1`; `CHANGELOG.md` trong repo mô tả các thay đổi dưới mốc `py/v2.1.0 (unreleased)`, tiền tố `py/` vì dòng chính đã dùng `v2.1.0` trở lên cho phần Go; tag tạm `py/v2.1.0-rc1` đặt ở commit `5e161e7`. Mã nguồn nộp kèm báo cáo là bản zip của branch này, không có `.venv`, `data/` và vault.

== Danh Sách Commit Refactor
<danh-sach-commit-refactor>

Kết quả `git log --oneline v2.0.0..refactor-ie221`, mới nhất ở trên; 16 commit đầu (24/09/2026) theo đúng kế hoạch chuẩn hoá, 6 commit sau là sửa nhỏ khi chạy thật trên macOS.

#figure(
```
45c7d0a BASE_URL
18c4a22 BASE_URL
002091f Update .gitignore
4641120 Update tui.py
28ab46e Update cli.py
8b75822 id size: 6 digit
5e161e7 docs: README for the Python line, CHANGELOG, justfile
1cddcfd tests: parsers, renderer, front matter and store, all offline
cc06f45 fetch -p ID --cascade: the path, then every course in it
b4bd646 materials under the vault, every file written atomically
14ee352 no database: JSON files are the truth, index.json is a ledger
23d5a63 frontmatter: valid YAML, OKF v0.2 superset
4e2e383 browser: one flag list, headless=new, profile reused by default
1167943 path: ql-contents-menu decides what is a course and what is a lab
9cfcd03 activities: dispatch by kind, html_bundle joins, unknown kinds survive
ae21659 catalog lists through the browser, one fetch_catalog for all three
873a315 cli: import Lab, md --lab has been a NameError since v2.0.0
9cc37c4 every page goes through the signed-in browser
bc4179f config.yaml is the new settings.py
f864415 drop the Flask web UI and the dead code around it
84c5d98 move app/ into src/skills_scraper, real package now
879de08 uv: pyproject + lock, bye requirements.txt
```,
  kind: raw,
  caption: [`git log --oneline v2.0.0..refactor-ie221`, 22 commit],
) <ma-git-log>

== Bảng Port Từ Dòng Chính
<bang-port-tu-dong-chinh>

Mười ba việc được xác định khi đọc dòng chính (v2.1.0 tới v2.17.0) để đưa về Python; cột trạng thái đối chiếu với branch tại HEAD `45c7d0a`.

#datatable-data((
  headers: ([Mã], [Nội dung], [Trạng thái], [Commit]),
  rows: (
    ([P1], [cấu hình bằng `config.yaml` và biến môi trường, bỏ đường dẫn cá nhân], [đã làm], [`bc4179f`]),
    ([P2], [mọi trang qua trình duyệt, đăng nhập một chỗ], [đã làm], [`9cc37c4`]),
    ([P3], [dispatch activity, thêm `html_bundle`, giữ loại lạ], [đã làm], [`9cfcd03`]),
    ([P4], [path đọc từ `ql-contents-menu`], [đã làm], [`1167943`]),
    ([P5], [cờ Chrome mới, tái dùng profile], [đã làm], [`4e2e383`]),
    ([P6], [frontmatter hợp lệ, khoá OKF], [đã làm], [`23d5a63`]),
    ([P7], [ghi tệp nguyên tử], [đã làm], [`b4bd646`]),
    ([P8], [JSON là nguồn sự thật, bỏ TinyDB], [đã làm], [`14ee352`]),
    ([P9], [tài liệu vào `materials/courses/<id>/`], [đã làm], [`b4bd646`]),
    ([P10], [thử lại khi mất mạng], [chưa], [---]),
    ([P11], [tái dùng Chrome qua `debuggerAddress`], [chưa], [---]),
    ([P12], [fetch path lan xuống course và lab], [đã làm], [`cc06f45`]),
    ([P13], [xoá mã chết (Flask, `data_management.py`, `tasks/`)], [đã làm], [`f864415`]),
  ),
  options: (index: false, align: ("left", "left", "left", "left"), columns: ("8%", "auto", "14%", "14%")),
  caption: [Mười ba việc port từ dòng chính và commit thực hiện],
  label: "tb-port",
))

== Kịch Bản Demo
<kich-ban-demo>

Năm bước, 5 tới 7 phút, theo thứ tự offline trước, mạng sau, để nếu mạng hay đăng nhập có vấn đề thì phần cốt lõi vẫn đã được thấy.

#datatable-data((
  headers: ([Bước], [Lệnh], [Điều cần chỉ ra]),
  rows: (
    ([1], [`uv run skills-scraper list -p`], [đọc offline từ `data/`, không mở trình duyệt]),
    ([2], [`uv run skills-scraper md -c 892 --toc`], [note sinh ra trong vault, frontmatter OKF, mở trong Obsidian thấy backlink tới path]),
    ([3], [`uv run skills-scraper fetch -c 892 --toc`], [phiên đăng nhập một lần, log từng activity; chạy lại lần hai thì bỏ qua và in lý do]),
    ([4], [`uv run skills-scraper-tui`], [cùng lõi, giao diện khác; thoát bằng `q`, Chrome đóng theo]),
    ([5], [vòng `for` shell, `jq`, `git diff --stat` (@ma-ghep-shell)], [ghép được với công cụ khác mà không cần API]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("8%", "40%", "auto")),
  caption: [Kịch bản demo năm bước],
  label: "tb-demo",
))

== Chạy Từ Bản Nộp
<chay-tu-ban-nop>

Giải nén, rồi trong thư mục gốc của repo:

#figure(
```bash
uv sync                                # Python 3.12, thư viện, hai lệnh skills-scraper*
uv run pytest                          # 15 test offline, không cần mạng
uv run skills-scraper --help
CSB_DATA=docs/samples/data CSB_VAULT=/tmp/vault \
  uv run skills-scraper md -c 892 --toc   # sinh một note từ dữ liệu mẫu trong repo
cp config.example.yaml config.yaml     # tuỳ chọn: nơi đặt data/ và vault
uv run skills-scraper list -p -r       # mở Chrome, đăng nhập một lần
```,
  kind: raw,
  caption: [Các lệnh để chạy từ bản zip nộp kèm],
) <ma-chay-tu-ban-nop>

== Công Cụ Sử Dụng
<cong-cu-su-dung>

Python 3.12, uv, Selenium 4, Beautiful Soup 4, requests, PyYAML, pytest, ruff, Chrome, Obsidian; báo cáo và slides soạn bằng Typst 0.15.1 với theme `uit-theme` của cùng tác giả, dựng bằng `just`; Claude (hỗ trợ rà soát mã và soạn tài liệu, mọi đoạn mã và số liệu trong báo cáo đều được kiểm lại trên repo).
