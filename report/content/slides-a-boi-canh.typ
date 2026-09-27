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
  card(title: [Mô Hình Hóa], icon: [M], accent: ggcolors.blue)[
    - Thực thể: *Path*, *Course*, *Lab*.
    - Dữ liệu: `modules`, thuộc Course.
    - Module: `src/skills_scaper/model/`.
  ],
  card(title: [Ghi Chú], icon: [!], accent: ggcolors.orange)[
    -  *Lab*: `lab`
      - vừa là *Activity* trong *Course*
      - vừa là *thực thể* độc lập.
    - *Activity* thuộc về Google: thêm/bớt.
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

#cols(
  card(title: [Capture], icon: [C], accent: ggcolors.blue)[
    - scraper
    - tự động
    - lặp lại được.
  ],
  card(title: [Organize], icon: [O], accent: ggcolors.red)[
    - `paths/`
    - `courses/`
    - `labs/`
    // - `materials/`
    // - link tương đối.
  ],
  card(title: [Distill], icon: [D], accent: ggcolors.orange)[
    - `--toc`,
    - `--no-transcript`,
    - `<id>-prompt.json`.
  ],
  card(title: [Express], icon: [E], accent: ggcolors.green)[
    - ghi chú riêng
    - scraper *không đụng tới*.
  ],
)

#grid(
  columns: (1.3fr, 1fr),
  column-gutter: 1em,
  [
    // #set text(size: 0.85em)
    ```yaml
    skills-vault/
    ├── public/
    │   ├── paths/     # 73
    │   ├── courses/   # 416
    │   └── labs/      # 824
    ├── partner/
    │   ├── paths/     # 181
    │   ├── courses/   # 899
    │   └── labs/      # 1209
    ├── materials/courses/<id>/  # thư mục PDF
    ├── docs/  README.md  CONTRIBUTING.md
    ```
  ],
  [
    #card(title: "Trách Nhiệm", icon: [R])[
      - Scraper:
        - *C* và một phần *D*.
      - Người dùng:
        - *O* và *E*.
      // - _"Làm một việc, làm tốt việc đó"_.
      - KISS: _Keep It Simple, Stupid_.
    ]
  ]
)

    // #set text(size: 0.9em)
    // Khung *CODE* của Tiago Forte:
    // - *Capture*: scraper, tự động và lặp lại được.
    // - *Organize*: `paths/ courses/ labs/ materials/`, link tương đối.
    // - *Distill*: `--toc`, `--no-transcript`, `<id>-prompt.json` cho LLM.
    // - *Express*: ghi chú của người học, ứng dụng *không đụng tới*.

#place(right+bottom)[#link("https://fortelabs.com/blog/basboverview/")[#text(size: 1em, fill: gray)[https://fortelabs.com/blog/basboverview/]]]

== Open Knowledge Format
<vo-tinh-khop-open-knowledge-format>

#card(title: "OKF v0.2", icon: "!", accent: orange)[
  - mọi `.md` có frontmatter YAML với `type` không rỗng.
//
//   #h(1fr)
//   #small(size: 0.6em)[#link("https://github.com/GoogleCloudPlatform/open-knowledge-format")[GoogleCloudPlatform/open-knowledge-format], Aug 2026.]
]
// #v(0.2em)
// #small(size: 0.8em)[
#table(
  columns: (1fr, 1fr, 1.6fr),
  stroke: (bottom: 0.5pt + luma(200), top: none, left: none, right: none),
  inset: (top: 0.4em, bottom: 0.4em),
  table.header([*OKF v0.2*], [*Vault (v2.0.0)*], [*Trạng thái*]),
  [`type` (bắt buộc)], [`type: Course`], [Khớp, `self.__class__.__name__`],
  [`title`], [`title`], [Khớp, đổi từ `name`],
  [`resource`], [`url`], [Cùng nghĩa, khác tên],
  [`tags`], [`topics`], [Cùng nghĩa, khác tên],
  [`description` ở frontmatter], [`description` trong thân], [Đã chuyển lên frontmatter],
  [`sources`, `generated`], [không có], [Thêm: `last_modified`, `skills-scraper/<version>`],
  [`index.md`, `log.md`], [`paths.md`], [Thiếu, cần bổ sung],
)

#place(right+bottom)[
  #small(size: 0.8em)[#link("https://github.com/GoogleCloudPlatform/open-knowledge-format")[GoogleCloudPlatform/open-knowledge-format], Aug 2026.]
]

// #v(0.4em)
// #co-note(title: "Cùng một ràng buộc")[
//   - một khái niệm một file,
//   - siêu dữ liệu ở đầu,
//   - thân Markdown cho người đọc,
//   - Obsidian là trình đọc mặc định.]
// ]
