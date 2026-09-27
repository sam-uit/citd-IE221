#import "../lib.typ": *
#import "diagrams.typ": arch-diagram

= MỘT TIỆN ÍCH NHỎ

== Lịch Sử Công Cụ
<lich-su-cong-cu>

#small(size: 0.9em)[
#cols(
  // card(title: [Cuối 2024], icon: [1])[
  //   - CTA GCP JAPAC.
  //   - Self-enablement.
  // ],
  card(title: [12/2024 -- 01/2025], icon: [1])[
    - Self-enablement.
    - Những commit đầu tiên.
    - Cloud Skills Boost.
    // -  `extract_transcript()` ra đời 05/01/2025.
  ],
  card(title: [02/2026, v2.0.0], icon: [2])[
    - Giờ là skills.google.
    - CLI, interactive
    - TinyDB + JSON.
  ],
  // card(title: [07/2026 v2.2..17], icon: [4])[
  //   Site bắt đăng nhập. Lõi Go, GUI Tauri; Python được "cascade" theo.
  // ],
  card(title: [09/2026, v2.0.1], icon: [3], tint: true)[
    - Fork từ v2.0.0.
    - Cập nhật, đóng gói.
    - Môn IE221.
  ],
)
]

#v(0.8em)
#co-note(title: "Repo")[
  - Lưu tại `github.com/ggcta/skills-scrapper`.
  - Cùng một tác giả ở một vai trò khác.
]
// ]

#place(right+bottom)[
  #text(fill: gray)[ggcta = Google Cloud Technical Architect]
]

== Triết Lý Unix Trong Code
<triet-ly-unix-trong-code>

#card-grid(
  columns: 3,
  row-gutter: 0.6em,
  card(title: [PLAIN TEXT!], icon: [1])[
    JSON và Markdown thuần. `git diff` được, `jq` được, `grep` được.
  ],
  card(title: [KISS], icon: [2])[
    - `fetch`: lấy về JSON. `md`: JSON ra Markdown.
    - Không (cần) biết nhau.
  ],
  card(title: [Pipelining], icon: [3])[
    `skills-scraper list -c | grep -i Vertex`; // vòng `for` shell, cron.
  ],
  card(title: [Stateless], icon: [4])[
    - Đọc file, ghi file, thoát.
    - Không daemon, không DB.
    - Chạy lại là idempotent nhờ `datePublished`.
  ],
  card(title: [.conf], icon: [5])[
    `config.yaml` và biến môi trường `CSB_*`. Không có đường dẫn cá nhân trong code.
  ],
  card(title: [real-world], icon: [6], tint: true)[
    - ZSphere TUI, VxRail platform-service trên ESXi.
    - Thành phần nhỏ, module, stateless của hệ thống lớn.
  ],
)

== Vì Sao Chỉ Terminal
<vi-sao-chi-terminal>

#cols(
  card(title: [CLI: `skills-scraper`], icon: [T])[
    - `argparse`, subcommand, mã thoát.
    - Cho *scripting và automation*: gọi từ shell, cron, công cụ khác.
    - `list`, `fetch`, `md`, `search`, `reindex`, `browser`.
  ],
  card(title: [TUI: `xxx-tui`], icon: [U])[
    - Vòng lặp menu, màu ANSI, kiểu classic interactive.
    - Cho *tương tác*: chọn path, chọn course, làm luôn.
    - Siêu gọn, đa nền tảng, không phụ thuộc thêm.
  ],
  card(title: [!GUI, !web], icon: [G], tint: true)[
    - User: kỹ sư hệ thống trong terminal.
    - GUI là một lựa chọn.
    - Mở rộng: Desktop GUI Tauri.
  ],
)

#v(0.6em)
Hai runner, *một lõi*:
  - cả hai chỉ khởi tạo lớp trong `model/` và gọi phương thức.
  - Đổi giao diện không sửa `model/`.

== Kiến Trúc
<kien-truc>

#align(center)[
  #arch-diagram(highlight: ("model",))
  #text(size: 0.8em, fill: gray)[Phụ thuộc một chiều: runner gọi model, model gọi services, services lầm việc với file và trình duyệt (các tài nguyên).]
]
