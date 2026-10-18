#import "../lib.typ": *

= Công Cụ Sử Dụng
<cong-cu-su-dung>

== Mã Nguồn

- Python 3.12
- uv
- Selenium 4
- Beautiful Soup 4
- requests
- PyYAML
- pytest
- ruff (language server trong ZED Editor)
- Chrome
- Obsidian.

== Báo Cáo

- #link("https://typst.app")[Typst 0.15.1]: Một typesetting mã nguồn mở, thay thế cho LaTex.
  - Báo cáo và slides được với theme `uit-theme` của sinh viên.
  - Bản dòng chính (master): #link("https://github.com/sam-uit/typst-report-template")[sam-uit/typst-report-template] (đã thay đổi rất nhiều với phiên bản đang sử dụng trong báo cáo này).
  - Vốn được sử dụng tại các môn học khác như #link("https://github.com/sam-uit/ie103-project-report/tree/main/baocao")[sam-uit/ie103-project-report/tree/main/baocao]

== Khai Báo Sử Dụng AI

- Claude:
  - Hỗ trợ rà soát mã nguồn và soạn tài liệu
  - Thực hiện một số thay đổi trên nhánh `refactor-ie221`
  - Không thay đổi phần lõi `/model` đặc biệt các phần về cấu trúc và phân cấp dữ liệu.

= Nguồn Gốc Và Tư Liệu
<nguon-goc-va-tu-lieu>

== Mã Nguồn
<nguon-goc-ma-nguon>

- Kho mã nguồn (repo): #link("https://github.com/ggcta/skills-scrapper/tree/refactor-ie221")[github.com/ggcta/skills-scrapper], nhánh `refactor-ie221`.

Ứng dụng trong báo cáo là branch `refactor-ie221` của repo, tách từ tag `v2.0.0` (commit `ac49ba2`, 18/02/2026), công cụ hoàn toàn là công trình/dự án của sinh viên, bắt đầu từ 05/01/2025 dưới tên Cloud Skills Boost helper. Dòng chính (master) của repo đã chuyển sang lõi Go và giao diện Tauri (tới v2.17.0); báo cáo này chỉ xét phần Python và chỉ dùng dòng chính làm nguồn tham khảo cho các thay đổi của site.

#co-note(title: [Ghi Chú])[
  - `ggcta` (Google Cloud Technical Architect), là một tổ chức trên Github, được tạo bởi sinh viên, phục vụ cho công việc, repo ở đây nhưng vẫn dưới quyền sở hữu hoàn toàn của sinh viên.
  - Tên người đóng góp có thể là `samdx`, `samdinhgg`, hoặc `sam-uit`, đều là các username khác của sinh viên ở các vai trò khác nhau.
]

== Danh Sách Commit Refactor
<danh-sach-commit-refactor>

Đây là các commit để chuẩn hóa theo nội dung kiến thức của môn học IE221 nhưng không thay đổi về phần lõi của mã nguồn, ví dụ: database/GUI đã không sử dụng thì sẽ vẫn không thêm vào khi CLI/TUI là quá đủ cho nhu cầu ban đầu và hiện tại của công cụ. Bao gồm:

- Chuyển sang `uv` và bỏ hẳn `requirements.txt`.
- Đổi thư mục chính từ `app/` sang `src/skills_scraper` theo chuẩn đóng gói của một gói Python.
- Bỏ Web UI (vốn là một phiên bản khác của GUI) và chỉ tập trung vào CLI/TUI.
- Và một số thay đổi khác.

Theo dõi bằng cách:

```bash
git log --oneline v2.0.0..refactor-ie221
```

#figure(
```
...
f864415 drop the Flask web UI and the dead code around it
84c5d98 move app/ into src/skills_scraper, real package now
879de08 uv: pyproject + lock, bye requirements.txt
```,
  kind: raw,
  caption: [`git log --oneline v2.0.0..refactor-ie221` -- Ví Dụ Các Thay Đổi],
) <ma-git-log>

// == Bảng Port Từ Dòng Chính
// <bang-port-tu-dong-chinh>
//
// Mười ba việc được xác định khi đọc dòng chính (v2.1.0 tới v2.17.0) để đưa về Python; cột trạng thái đối chiếu với branch tại HEAD `45c7d0a`.
//
// #datatable-data((
//   headers: ([Mã], [Nội dung], [Trạng thái], [Commit]),
//   rows: (
//     ([P1], [cấu hình bằng `config.yaml` và biến môi trường, bỏ đường dẫn cá nhân], [đã làm], [`bc4179f`]),
//     ([P2], [mọi trang qua trình duyệt, đăng nhập một chỗ], [đã làm], [`9cc37c4`]),
//     ([P3], [dispatch activity, thêm `html_bundle`, giữ loại lạ], [đã làm], [`9cfcd03`]),
//     ([P4], [path đọc từ `ql-contents-menu`], [đã làm], [`1167943`]),
//     ([P5], [cờ Chrome mới, tái dùng profile], [đã làm], [`4e2e383`]),
//     ([P6], [frontmatter hợp lệ, khoá OKF], [đã làm], [`23d5a63`]),
//     ([P7], [ghi tệp nguyên tử], [đã làm], [`b4bd646`]),
//     ([P8], [JSON là nguồn sự thật, bỏ TinyDB], [đã làm], [`14ee352`]),
//     ([P9], [tài liệu vào `materials/courses/<id>/`], [đã làm], [`b4bd646`]),
//     ([P10], [thử lại khi mất mạng], [chưa], [---]),
//     ([P11], [tái dùng Chrome qua `debuggerAddress`], [chưa], [---]),
//     ([P12], [fetch path lan xuống course và lab], [đã làm], [`cc06f45`]),
//     ([P13], [xoá mã chết (Flask, `data_management.py`, `tasks/`)], [đã làm], [`f864415`]),
//   ),
//   options: (index: false, align: ("left", "left", "left", "left"), columns: ("8%", "auto", "14%", "14%")),
//   caption: [Mười ba việc port từ dòng chính và commit thực hiện],
//   label: "tb-port",
// ))

== Kịch Bản Demo
<kich-ban-demo>

Sinh viên khuyến nghị một kịch bản demo gồm năm bước như dưới đây, 5 tới 7 phút, theo thứ tự offline trước, mạng sau, và nếu kết nối mạng hay đăng nhập có vấn đề thì phần cốt lõi vẫn được thể hiện.

#datatable-data((
  headers: ([Bước], [Lệnh], [Điều cần chỉ ra]),
  rows: (
    ([1], [`uv run skills-scraper list -p`], [đọc offline từ `data/`, không mở trình duyệt]),
    ([2], [`uv run skills-scraper md -c 892 --toc`], [note sinh ra trong vault, frontmatter OKF, mở trong Obsidian thấy backlink tới path]),
    ([3], [`uv run skills-scraper fetch -c 892 --toc`], [phiên đăng nhập một lần, log từng activity; chạy lại lần hai thì bỏ qua và in lý do]),
    ([4], [`uv run skills-scraper-tui`], [cùng lõi, giao diện khác; thoát bằng `q`, Chrome đóng theo]),
    ([5], [vòng `for` shell, `jq`, `git diff --stat` (@ma-ghep-shell)], [ghép được với công cụ khác mà không cần API]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("8%", "40%", "52%")),
  caption: [Phụ Lục -- Kịch Bản Demo],
  label: "tb-demo",
))

== Chạy Từ Bản Nộp Bài
<chay-tu-ban-nop>

Giải nén, rồi trong thư mục gốc của repo:

#figure(
```bash
# Python 3.12, thư viện, hai lệnh skills-scraper*
uv sync

# 15 test offline, không cần kết nối mạng
uv run pytest

# help
uv run skills-scraper --help

# sinh một note từ dữ liệu mẫu trong repo
CSB_DATA=docs/samples/data CSB_VAULT=/tmp/vault \
  uv run skills-scraper md -c 892 --toc

# tuỳ chọn: nơi đặt data/ và vault
cp config.example.yaml config.yaml

# mở Chrome, đăng nhập một lần
uv run skills-scraper list -p -r
```,
  kind: raw,
  caption: [Phụ Lục -- Các Lệnh Để Chạy Từ Bản Nộp Kèm],
) <ma-chay-tu-ban-nop>
