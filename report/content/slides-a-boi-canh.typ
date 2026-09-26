#import "../lib.typ": *

= BỐI CẢNH
<boi-canh>

== Một Bộ Não Thu Nhỏ -- A Vault
<mot-bo-nao-thu-nho>

#grid(
  columns: (auto, 1fr),
  [
    #align(center)[
      #image("images/obsidian-pkb-2nd-brain.png", height: auto)
    ]
  ],
  [
    #align(center + horizon)[
      Mỗi chấm là một *path*, *course* hoặc *lab* trên skills.google.
    ]
  ]
)

== skills.google -- Tiểu Sử
<skills-google>

#co-note(title: "Giới Thiệu")[
  - Một portal e-learning: _"Bởi Google và cho Google."_
]

// #small[
#cols(
  card(title: [Cloud Skills Boost], icon: [1], accent: ggcolors.blue)[
    - #link("https://cloudskillsboost.google/")[_cloudskillsboost.google_]
    // - Tên cũ.
    - Tập trung Google Cloud.
    - Không cần tài khoản.
    - `ql-course-outline`.
  ],
  card(title: [Google Skills], icon: [2], accent: ggcolors.red)[
    - #link("https://skills.google/")[_skills.google_]
    // - Tên mới.
    - Phục vụ nhiều sản phẩm của Google.
    - Phải có tài khoản đăng nhập.
    - `ql-contents-menu`.
  ],
  // card(title: [02/2026], icon: [3])[
  //   Loại activity mới `html_bundle` (HTML5 trên Cloud Storage); rồi `badge`, `credential`.
  // ],
  // card(title: [07/2026], icon: [4], tint: true)[
  //   Trang course *bắt buộc đăng nhập*; catalog trả 403 cho request trần.
  // ],
)

// #v(0.8em)
#co-warn(title: "Hệ quả kỹ thuật")[
  - Công cụ phải có *phiên đăng nhập*, mọi _request_ đi qua nó, (_scraper_, không phải _crawler_).
  // - Một trình duyệt với profile lưu phiên, mọi _request_ đi qua nó.
]
// ]

== Phân Cấp Dữ Liệu
<phan-cap-du-lieu>

```
Portal (public | partner)
└─ Path (learning path)
  └─ Course
    └─ Module
      └─ Step
        └─ Activity
          └─ video | lab        | quiz        |
          └─ link  | document   | html_bundle |
          └─ badge | credential | ...
```

#cols(
  card(title: [Ghi Chú], icon: [!], accent: ggcolors.orange)[
    -  *Lab*: `lab`
      - vừa là *Activity* trong *Course*
      - vừa là *thực thể* độc lập.
    - *Activity* thuộc về Google: thêm/bớt.
  ],
  card(title: [Mô Hình Hóa], icon: [M], accent: ggcolors.blue)[
    - Thực thể: *Path*, *Course*, *Lab*.
    - Dữ liệu: `modules`, thuộc Course.
    - Module: `src/skills_scaper/model/`.
  ]
)

// #grid(
//   columns: (1.1fr, 1fr),
//   column-gutter: 1.5em,
//   [
//     // #set text(size: 0.9em)
//     ```
//     Portal (public | partner)
//     └── Path (learning path)
//         └── Course
//             └── Module
//                 └── Step
//                     └── Activity
//                         video | lab | quiz | link
//                         document | html_bundle
//                         badge | credential | ...
//     ```
//   ],
//   [
//     - *Lab* vừa là activity trong course, vừa là thực thể độc lập có trang riêng.
//     - Một course thuộc *nhiều* path. Đó là các nút bậc cao ở giữa đồ thị.
//     - Tập loại activity thuộc về Google, không thuộc về ứng dụng: hôm nay 6 loại có handler, mai có thể thêm.
//     - `model/` phản chiếu đúng cây này: `Path`, `Course`, `Lab` là thực thể; `modules` là dữ liệu của `Course`.
//   ],
// )

== Vấn Đề -- Khó Nắm Bối Cảnh
<van-de>

// Site chỉ cho xem *một trang tại một thời điểm*.

// #v(0.3em)
#card-grid(
  columns: 2,
  // row-gutter: 0.6em,
  row-gutter: - 0.2em,
  card(title: [Course này thuộc Path nào?], icon: [1], accent: ggcolors.blue)[
    - Site:
      - dò tìm ngược thủ công.
      - có khi không tìm được.
    - Vault: *backlink* của note, tức thì.
  ],
  card(title: [Hai Path trùng nhau bao nhiêu?], icon: [2], accent: ggcolors.red)[
    - Site: không có / không rõ.
    - Vault:
      - nút chung trên *graph*, hoặc
      - một truy vấn Dataview.
  ],
  card(title: [Ở đâu nói "Vertex AI Pipelines"?], icon: [3], accent: ggcolors.orange)[
    - Site: không tìm trong transcript.
    - Vault: offline
      - `grep` hoặc
      - ô tìm kiếm.
  ],
  card(title: [Google đổi gì từ lần học trước?], icon: [4], accent: ggcolors.green)[
    - Site: không có changelog.
    - Vault:
      - `date_published` (property);
      - `git diff`.
  ],
)

#align(right)[
#text(
  size: 0.8em,
  fill: gradient.linear(..ggcolors.values()),
    [_Có thể bạn đã biết. Color Palette của Google._]
  )
]

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
