#import "/lib.typ": *

= HÔM NAY, DEMO, MỞ RỘNG
<hom-nay-demo-mo-rong>

== Site Đổi, Mã Đổi Theo
<site-doi-ma-doi-theo>

#datatable-slide("/content/tables/tb-site-changes.yaml")

#v(0.3em)
#text(size: 0.8em, fill: gray)[Mỗi dòng dẫn một commit ở dòng chính (v2.1.0 tới v2.14.0): đây là *port có nguồn*, không phải viết lại. 16 commit trên `refactor-ie221`, mỗi commit một thay đổi logic, thân commit nói vì sao.]

== Demo
<demo>

#small(size: 0.75em)[
#table(
  columns: (auto, 1fr, 1.5fr, 1.5fr),
  stroke: (bottom: 0.5pt + luma(200), top: none, left: none, right: none),
  inset: (top: 0.45em, bottom: 0.45em),
  align: (center, left, left, left),
  table.header([*Phút*], [*Bước*], [*Lệnh*], [*Điều cần thấy*]),
  [0:00], [Danh mục offline], [`skills-scraper list -p`], [đọc từ `data/`, không mạng, không DB],
  [0:45], [Cào một course], [`skills-scraper fetch -c 892 --toc`], [Chrome mở với profile đã đăng nhập; chạy lần hai: `datePublished` không đổi thì bỏ qua],
  [2:30], [Sinh Markdown], [`skills-scraper md -c 892`, mở Obsidian], [frontmatter, module, quiz callout; local graph và backlink của course 892],
  [4:00], [TUI], [`skills-scraper-tui`, chọn path 280], [cùng lõi, giao diện khác, `model/` không đổi],
  [5:00], [Automation], [`for id in 892 72; do skills-scraper md -c $id --toc; done`; `jq '.topics' data/courses/892.json`; `git diff --stat`], [ghép được với shell, jq, git],
  [6:00], [Tuỳ chọn], [hỏi plugin AI trong Obsidian], [vault đã là kho tri thức cho agent],
)

#v(0.4em)
#text(fill: gray)[*Dự phòng:* chỉ bước 2 cần mạng và đăng nhập, mọi bước khác chạy từ file; có bản ghi màn hình của bước 2 nếu mạng hỏng.]
]

== Mở Rộng Và Kêu Gọi Contributor
<mo-rong-va-keu-goi-contributor>

#small(size: 0.85em)[
#cols(
  card(title: [Một portal mới là gì], icon: [1])[
    URL và selector trong `config.py`, một lớp con của `Course`/`Path` ghi đè parser. Phần còn lại *không biết Google*.
  ],
  card(title: [Ứng viên], icon: [2])[
    - AWS Skill Builder (login, course/module/lesson).
    - NVIDIA DLI, Coursera, Udemy.
    - Microsoft Learn: *không cần scrape*, Markdown mở trên GitHub, chỉ cần clone và render.
  ],
  card(title: [AI agent trong vault], icon: [3], tint: true)[
    - Hôm nay: plugin Obsidian (Copilot, Smart Connections, MCP) đọc vault.
    - `<id>-prompt.json` đã là đầu vào cho LLM.
    - Bundle OKF (`index.md`, `log.md`) cho agent ngoài Obsidian.
  ],
)

#v(0.6em)
Điều kiện để nhận contributor, đã có: entry point rõ, `uv sync` từ clone sạch, fixture HTML trong `tests/` để sửa parser mà không cần tài khoản, `CONTRIBUTING.md`.
]

== Hạn Chế, Nói Thẳng
<han-che-noi-thang>

#card-grid(
  columns: 3,
  row-gutter: 0.6em,
  card(title: [Cần người], icon: [1])[Phiên đăng nhập thật nên không chạy không người trông; headless chỉ sau khi profile đã đăng nhập.],
  card(title: [Phụ thuộc site], icon: [2])[Transcript phụ thuộc phụ đề của site; selector đổi là một test đỏ và một commit.],
  card(title: [Tên file theo title], icon: [3])[Đổi tên là gãy link; `<id>-<slug>.md` là việc tiếp theo.],
  card(title: [Checkbox tiến độ], icon: [4])[Bị ghi đè khi regenerate; `--keep-progress` chưa có.],
  card(title: [`print()` trong `model/`], icon: [5])[Giữ như v2.0.0 ở đợt này; `logging` là đợt sau.],
  card(title: [Nội dung của Google], icon: [6], tint: true)[Vault công khai chỉ nên chứa cấu trúc (`--toc --no-transcript`); transcript và materials để riêng.],
)

== Nối Các Chấm
<noi-cac-cham>

#grid(
  columns: (1.5fr, 1fr),
  column-gutter: 1em,
  align(center + horizon)[#image("/content/images/obsidian-pkb-2nd-brain.png", height: 13cm)],
  [
    #set text(size: 0.9em)
    - Mỗi chấm là một *object* của một lớp trong `model/`.
    - Mỗi cạnh là một link tương đối do `generate_markdown` ghi ra.
    - Cả bộ não là đầu ra của *hai lệnh terminal* chạy lặp lại.

    #v(1em)
    #text(size: 1.1em, weight: "bold")[Một ứng dụng nhỏ, đúng một việc, để bộ não lớn tự mọc.]
  ],
)

== Phụ Lục: Chương Bài Giảng Và Mã
<phu-luc-chuong-bai-giang-va-ma>

#datatable-slide("/content/tables/tb-lecture-map.yaml")
