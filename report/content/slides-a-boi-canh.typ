#import "../lib.typ": *

= BỐI CẢNH
<boi-canh>

== Một Bộ Não Thu Nhỏ
<mot-bo-nao-thu-nho>

#grid(
  columns: (auto, 1fr),
  [
    #align(center)[
      #image("images/obsidian-pkb-2nd-brain.png", height: auto)
    ],
  ],
  [
    #align(center + horizon)[
      Mỗi chấm là một *path*, *course* hoặc *lab* trên skills.google.
    ]
  ]
)

== skills.google Hôm Nay
<skills-google-hom-nay>

#small[
#cols(
  card(title: [Cloud Skills Boost], icon: [1])[
    Tên cũ, xem ẩn danh được. `ql-course-outline`, `requests` là đủ.
  ],
  card(title: [skills.google], icon: [2])[
    Đổi tên, đổi schema: `ql-contents-menu`, catalog API phân trang, hai portal.
  ],
  card(title: [02/2026], icon: [3])[
    Loại activity mới `html_bundle` (HTML5 trên Cloud Storage); rồi `badge`, `credential`.
  ],
  card(title: [07/2026], icon: [4], tint: true)[
    Trang course *bắt buộc đăng nhập*; catalog trả 403 cho request trần.
  ],
)

#v(0.8em)
#co-info(title: "Hệ quả kỹ thuật")[
  Selenium là bắt buộc: một *scraper có phiên đăng nhập*, không phải crawler. Một Chrome với profile lưu phiên, mọi trang đi qua nó.
]
]

== Phân Cấp Dữ Liệu
<phan-cap-du-lieu>

#grid(
  columns: (1.1fr, 1fr),
  column-gutter: 1.5em,
  [
    #set text(size: 0.9em)
    ```
    Portal (public | partner)
    └── Path  (learning path)
        └── Course
            └── Module
                └── Step
                    └── Activity
                        video | lab | quiz | link
                        document | html_bundle
                        badge | credential | ...
    ```
  ],
  [
    - *Lab* vừa là activity trong course, vừa là thực thể độc lập có trang riêng.
    - Một course thuộc *nhiều* path. Đó là các nút bậc cao ở giữa đồ thị.
    - Tập loại activity thuộc về Google, không thuộc về ứng dụng: hôm nay 6 loại có handler, mai có thể thêm.
    - `model/` phản chiếu đúng cây này: `Path`, `Course`, `Lab` là thực thể; `modules` là dữ liệu của `Course`.
  ],
)

== Vấn Đề
<van-de>

#text(size: 0.95em)[Site cho xem *một trang tại một thời điểm*. Bốn câu hỏi người học hỏi nhiều nhất, site không trả lời được:]

#v(0.3em)
#card-grid(
  columns: 2,
  row-gutter: 0.6em,
  card(title: [Course này thuộc path nào?], icon: [1])[
    Site: tìm ngược thủ công. Vault: *backlink* của note, tức thì.
  ],
  card(title: [Hai path chồng nhau bao nhiêu?], icon: [2])[
    Site: không có. Vault: nút chung trên *graph*, hoặc một truy vấn Dataview.
  ],
  card(title: [Transcript nào nhắc "Vertex AI Pipelines"?], icon: [3])[
    Site: không tìm trong transcript. Vault: `grep` hoặc ô tìm kiếm, offline.
  ],
  card(title: [Google đổi gì từ lần học trước?], icon: [4])[
    Site: không có changelog. Vault: `date_published` trong frontmatter và `git diff`.
  ],
)

== Obsidian Vault Là Bộ Não Thứ Hai
<obsidian-vault-la-bo-nao-thu-hai>

#grid(
  columns: (1fr, 1.2fr),
  column-gutter: 1.5em,
  [
    #set text(size: 0.85em)
    ```
    skills-vault/
    ├── public/
    │   ├── paths/      73
    │   ├── courses/   416
    │   └── labs/      824
    ├── partner/
    │   ├── paths/     181
    │   ├── courses/   899
    │   └── labs/     1209
    ├── materials/courses/<id>/   397 thư mục PDF
    ├── docs/  README.md  CONTRIBUTING.md
    ```
  ],
  [
    #set text(size: 0.9em)
    Khung *CODE* của Tiago Forte:
    - *Capture*: scraper, tự động và lặp lại được.
    - *Organize*: `paths/ courses/ labs/ materials/`, link tương đối.
    - *Distill*: `--toc`, `--no-transcript`, `<id>-prompt.json` cho LLM.
    - *Express*: ghi chú của người học, ứng dụng *không đụng tới*.

    #v(0.3em)
    #co-note(title: "Cố ý dừng ở đó")[
      Ứng dụng làm C và một phần D. O và E thuộc về Obsidian và người học. Làm một việc, làm tốt.
    ]
  ],
)

== Vô Tình Khớp Open Knowledge Format
<vo-tinh-khop-open-knowledge-format>

#text(size: 0.9em)[OKF v0.2 (GoogleCloudPlatform/open-knowledge-format) bắt buộc đúng một thứ: mọi `.md` có frontmatter YAML với `type` không rỗng.]

#v(0.2em)
#small(size: 0.8em)[
#table(
  columns: (1fr, 1fr, 1.6fr),
  stroke: (bottom: 0.5pt + luma(200), top: none, left: none, right: none),
  inset: (top: 0.4em, bottom: 0.4em),
  table.header([*Vault (v2.0.0)*], [*OKF v0.2*], [*Trạng thái*]),
  [`type: Course`], [`type` (bắt buộc)], [Có từ 2025: sinh từ tên lớp, `self.__class__.__name__`],
  [`title`], [`title`], [Khớp từ commit 1aa2f3e],
  [`url`], [`resource`], [Cùng nghĩa, khác tên],
  [`topics`], [`tags`], [Cùng hình, khác tên],
  [`description` trong thân], [`description` ở frontmatter], [Đã chuyển lên frontmatter (bản refactor)],
  [không có], [`sources`, `generated`], [Đã thêm: nguồn, `last_modified`, `skills-scraper/<version>`],
  [`paths.md`], [`index.md`, `log.md`], [Chưa: khoảng 80 dòng, việc tiếp theo],
)

#v(0.4em)
#co-succ(title: "Vì sao trùng")[Cùng một ràng buộc: một khái niệm một file, siêu dữ liệu ở đầu, thân Markdown cho người đọc, Obsidian là trình đọc mặc định.]
]
