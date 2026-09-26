#import "../lib.typ": *
#import "diagrams.typ": arch-diagram

= MỘT TIỆN ÍCH NHỎ

== Lịch Sử Công Cụ
<lich-su-cong-cu>

#small(size: 0.8em)[
#cols(
  card(title: [Cuối 2024], icon: [1])[
    Vai *Cloud Technical Architect* GCP JAPAC. Tự enablement có hệ thống, học offline.
  ],
  card(title: [Đầu 2025], icon: [2])[
    Script Python đầu tiên, CSB thành Markdown. `extract_transcript()` ra đời 05/01/2025.
  ],
  card(title: [02/2026 v2.0.0], icon: [3])[
    CLI, interactive, web UI Flask, TinyDB song song JSON. 587 commit.
  ],
  card(title: [07/2026 v2.2..17], icon: [4])[
    Site bắt đăng nhập. Lõi Go, GUI Tauri; Python được "cascade" theo.
  ],
  card(title: [09/2026 ie221], icon: [5], tint: true)[
    Fork từ v2.0.0, *giữ Python*, cập nhật lõi, đóng gói chuẩn.
  ],
)

#v(0.8em)
#co-note(title: "Nguồn gốc")[
  Repo gốc `github.com/ggcta/skills-scrapper`: *ggcta = Google CTA*, cùng một tác giả ở một vai khác. Lịch sử git liền mạch từ 2025 tới nhánh này.
]
]

== Triết Lý Unix Trong Mã
<triet-ly-unix-trong-ma>

#card-grid(
  columns: 3,
  row-gutter: 0.6em,
  card(title: [Làm một việc], icon: [1])[
    `fetch` lấy về JSON. `md` từ JSON ra Markdown. Hai lệnh không biết nhau.
  ],
  card(title: [Văn bản là giao diện], icon: [2])[
    JSON và Markdown thuần. `git diff` được, `jq` được, `grep` được.
  ],
  card(title: [Ghép được], icon: [3])[
    `skills-scraper list -c | grep Vertex`, vòng `for` shell, cron.
  ],
  card(title: [Không trạng thái], icon: [4])[
    Đọc file, ghi file, thoát. Không daemon, không DB. Chạy lại là idempotent nhờ `datePublished`.
  ],
  card(title: [Cấu hình là dữ liệu], icon: [5])[
    `config.yaml` và biến môi trường `CSB_*`. Không có đường dẫn cá nhân trong mã.
  ],
  card(title: [Nghề], icon: [6], tint: true)[
    ZSphere TUI, VxRail platform-service trên ESXi: thành phần nhỏ, module, stateless của hệ thống lớn.
  ],
)

== Vì Sao Chỉ Terminal
<vi-sao-chi-terminal>

#cols(
  card(title: [CLI: `skills-scraper`], icon: [\$])[
    - `argparse`, subcommand, mã thoát.
    - Cho *script và automation*: gọi từ shell, cron, công cụ khác.
    - `list`, `fetch`, `md`, `search`, `reindex`, `browser`.
  ],
  card(title: [TUI: `skills-scraper-tui`], icon: [>])[
    - Vòng lặp menu, màu ANSI, kiểu classic interactive.
    - Cho *tương tác*: chọn path, chọn course, làm luôn.
    - Siêu gọn, đa nền tảng, không phụ thuộc thêm.
  ],
  card(title: [Không GUI, không web], icon: [x], tint: true)[
    - Người dùng của công cụ là kỹ sư hệ thống ngồi trong terminal.
    - Chương 09 (tkinter) là kỹ năng đã học; *chọn không dùng* là quyết định.
    - GUI thật đã có ở nhánh Tauri; báo cáo này là về lõi.
  ],
)

#v(0.6em)
#text(size: 0.85em)[Hai runner, *một lõi*: cả hai chỉ khởi tạo lớp trong `model/` và gọi phương thức. Đổi giao diện không sửa `model/`.]

== Kiến Trúc
<kien-truc>

#align(center)[#arch-diagram(highlight: ("model",))]

#text(size: 0.8em, fill: gray)[Phụ thuộc một chiều: runner gọi model, model gọi services, services chạm file và trình duyệt. Không tầng nào gọi ngược lên.]
