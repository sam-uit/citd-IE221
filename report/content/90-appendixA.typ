#import "/lib.typ": *

= Nguồn Gốc Và Tư Liệu
<nguon-goc-va-tu-lieu>


== Nguồn Gốc Mã Nguồn
<nguon-goc-ma-nguon>

Ứng dụng là branch `refactor-ie221` của repo `github.com/ggcta/skills-scrapper`, tách từ tag `v2.0.0` (commit `ac49ba2`, 18/02/2026), công trình trước đó của cùng tác giả. Dòng chính của repo đã chuyển sang lõi Go và giao diện Tauri (tới v2.17.0); báo cáo này chỉ xét phần Python.

#co-note[Điền tag cuối cùng lúc nộp (py/v2.1.0 hay rc) và đường dẫn repo công khai nếu có.]

== Danh Sách Commit Refactor
<danh-sach-commit-refactor>

#co-note[Dán kết quả `git log --oneline v2.0.0..refactor-ie221`, 16 dòng.]

== Bảng Port Từ Dòng Chính
<bang-port-tu-dong-chinh>

#datatable-data((
  headers: ([Mã], [Nội dung], [Trạng thái]),
  rows: (
    ([P1], [cấu hình bằng biến môi trường, bỏ đường dẫn cá nhân], [đã làm]),
    ([P2], [mọi trang qua trình duyệt, đăng nhập một chỗ], [đã làm]),
    ([P3], [dispatch activity, thêm `html_bundle`, giữ loại lạ], [đã làm]),
    ([P4], [path đọc từ `ql-contents-menu`], [đã làm]),
    ([P5], [cờ Chrome mới, tái dùng profile], [đã làm]),
    ([P6], [frontmatter hợp lệ, khoá OKF], [đã làm]),
    ([P7], [ghi tệp nguyên tử], [đã làm]),
    ([P8], [JSON là nguồn sự thật, bỏ TinyDB], [đã làm]),
    ([P9], [tài liệu vào `materials/courses/<id>/`], [đã làm]),
    ([P10], [thử lại khi mất mạng], [chưa]),
    ([P11], [tái dùng Chrome qua `debuggerAddress`], [chưa]),
    ([P12], [fetch path lan xuống course và lab], [đã làm]),
    ([P13], [xoá mã chết], [đã làm]),
  ),
  options: (index: false, align: ("left", "left", "left")),
))
#co-warn[Xác nhận lại cột trạng thái với branch thật trước khi nộp.]

== Kịch Bản Demo
<kich-ban-demo>

#datatable-data((
  headers: ([Bước], [Lệnh], [Điều cần chỉ ra]),
  rows: (
    ([1], [`uv run skills-scraper list -p`], [đọc offline từ `data/`]),
    ([2], [`uv run skills-scraper fetch -c 892 --toc`], [phiên đăng nhập, log từng activity, chạy lại thì bỏ qua]),
    ([3], [`uv run skills-scraper md -c 892`], [note trong Obsidian, backlink tới path]),
    ([4], [`uv run skills-scraper-tui`], [cùng lõi, giao diện khác]),
    ([5], [vòng `for` shell, `jq`, `git diff --stat`], [ghép được với công cụ khác]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("33.33%", "33.33%", "33.33%")),
))

== Công Cụ Sử Dụng
<cong-cu-su-dung>

Python 3.12, uv, Selenium, Beautiful Soup, pytest, ruff, Obsidian, Typst 0.15, pandoc, Claude (hỗ trợ rà soát mã và soạn tài liệu).
