#import "../lib.typ": *

= MÔ TẢ BÀI TOÁN
<mo-ta-bai-toan>

Trong chương này, sinh viên thực hiện sẽ trình bày ngữ cảnh, bài toán cần giải quyết, và các câu hỏi đặt vấn đề cho một công cụ. Từ đó, khoanh vùng phạm vi các mục tiêu cần thực hiện cũng như các nội dung được và không được đề cập trong báo cáo này.

== Bối Cảnh
<boi-canh>

=== Giới Thiệu Google Skills
<google-skills-va-nhung-thay-doi-gan-day>

Như đã đề cập, Google Skills (skills.google), trước đây là Google Cloud Skills Boost, là nền tảng đào tạo chính thức của Google Cloud, gồm hàng trăm lộ trình học (path), hàng nghìn khoá học (course) và bài thực hành (lab).

Trong khoảng hai năm, từ cuối 2024 đến đầu 2026, nền tảng đã có những thay đổi trong cả định hướng hoạt động và trong bộ nội dung được triển khai, và từ đó ảnh hưởng trực tiếp tới cách thu thập nội dung, ví dụ: từ một nền tảng mở, Google Skills bây giờ đã yêu cầu phải có tài khoản đăng nhập để có thể xem nội dung môn học, từ đó một hệ quả kỹ thuật phát sinh: thư viện `requests` không còn đủ, việc thu thập phải đi qua một phiên trình duyệt đã đăng nhập (Selenium), vì vậy công cụ đã thay đổi hành vi đáng kể so với ngày đầu tiên được tạo dựng.

=== Phân Cấp Dữ Liệu
<phan-cap-du-lieu>

Để phục vụ cho đăng tải nội dung tới nhiều tệp người dùng, cũng như nhiều tệp sản phẩm, phân cấp dữ liệu trên Google Skills có thể tóm tắt như bảng dưới đây.

#datatable-data((
  columns: (5%, 15%, auto),
  headers: ([Cấp], [Thực thể], [Ghi chú]),
  rows: (
    ([1], [*Portal*], [Bao gồm _public_ và _partner_; báo cáo này chỉ đề cập _public_ portal vì _partner_ là dành cho đối tác của Google, và cần có tài khoản riêng.]),
    ([2], [*Path*], [Lộ Trình, chứa nhiều Course và Lab theo thứ tự.]),
    ([3], [*Course*], [Khoá Học, có mô tả, mục tiêu, chủ đề và từng chương.]),
    ([4], [*Module*], [Chương, thuộc Khoá Học, sẽ có từng bài học cụ thể.]),
    ([5], [*Step*], [Các Bước/Phần trong chương.]),
    ([6], [*Activity*], [Các Bài Học, có thể là video, lab, quiz, pdf hoặc html, hoặc loại nội dung bất kỳ nào khác.]),
  ),
  options: (index: false, align: ("right", "left", "left"), columns: ("8%", "15%", "auto")),
  caption: [Google Skills -- Phân Cấp Dữ Liệu],
  label: "tb-phan-cap",
))

Mô hình phân cấp có thể được trực quan hóa đơn giản như sau:

#figure(
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
```,
  kind: raw,
  caption: [Google Skills -- Cây Phân Cấp Dữ Liệu],
) <ma-cay-phan-cap>

#co-note(title: [Ghi Chú])[
  - Lab vừa là một hoạt động trong Course vừa là một thực thể độc lập, đôi khi được tham chiếu trực tiếp bởi Path, điều này đôi lúc tạo nên sự phức tạp trong logic của việc liên kết các thực thể.
  - Tập các loại hoạt động (*Activity*) thuộc về Google chứ không thuộc về ứng dụng: Google Skills có thể thay đổi các loại hoạt động bất kỳ lúc nào, hiện tại thường là sẽ thêm mới dựa theo cách triển khai nội dung của các khóa học/môn học mới.
]

== Vấn Đề Cần Giải Quyết
<van-de-can-giai-quyet>

Website Google Skills cho người dùng xem một trang tại một thời điểm. Một số câu hỏi người học hay đặt ra nhất lại không trả lời được trên bản thân trang độc lập đó. Để so sánh, đây là các tính năng có sẵn của Obsidian khi nội dung là Markdown liên kết:

#datatable-data((
  headers: ([Câu hỏi], [skills.google], [Obsidian Vault]),
  rows: (
    ([Course này *thuộc những Path* nào?], [phải tìm ngược từng path], [backlink/wikilink]),
    ([Hai Path *chồng lấn* (dùng chung) *bao nhiêu* Course?], [không có], [graph view, truy vấn]),
    ([Transcript/Course nào *nhắc tới một khái niệm* cụ thể?], [khó tìm trong transcript], [tìm toàn văn, offline]),
    ([Course này đã *thay đổi gì* từ lần học trước?], [không có lịch sử], [`date_published` và `git diff`]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("1fr", "auto", "auto")),
  caption: [Một Số Câu Hỏi Thường Gặp],
  label: "tb-bon-cau-hoi",
))

Quy trình hiện tại của người học trên Google Skills: duyệt danh mục, mở từng khoá, xem video, ghi chú tay. Nội dung nằm rải rác qua video, quiz, lab, tài liệu; không có bản xuất (export) để lưu lại, không có bản offline, không tìm kiếm xuyên khoá. Có một sự rời rạc trong một hệ thống được thiết kế trông rất chặt chẽ.

== Mục Tiêu Đề Tài
<muc-tieu-de-tai>

Mục tiêu đầu tiên, công cụ thực tiễn:

- Xây dựng một ứng dụng/công cụ Python dòng lệnh.
- Thu thập Path, Course, Lab từ skills.google vào kho JSON (file-based database).
- Sinh ra một vault Markdown dùng được ngay trong Obsidian
- Cung cấp hai giao diện terminal (CLI cho tự động hoá, TUI cho tương tác).
- Hoàn toàn có thể mở rộng sang các nền tảng khác.

Mục tiêu thứ hai, về mặt học thuật:

- Là dùng chính ứng dụng này làm chứng cứ cho các kiến thức của môn học IE221: *module* và *package*, *lớp* và *đối tượng*, *kế thừa*, xử lý ngoại lệ, vv... trong Python.
- Như một tiền đề để phát triển các chức năng hay ứng dụng như _một phần của hệ thống_ vốn thường gặp trong thực tế khi các công cụ thường là một phần của một hệ sinh thái lớn với nhiều công cụ riêng lẻ.

== Phạm Vi Ứng Dụng
<pham-vi>

=== Bao Gồm

// - Public portal;
// - Ba loại thực thể chính: Path, Course, Lab;
// - Activity: transcript video, quiz, lab, link, tài liệu PDF, html_bundle;
// - Kết xuất JSON và Markdown;
// - Hai runner terminal: CLI, TUI (Terminal User Interface).

#grid(
  columns: (30%, 70%),
  row-gutter: 0.5em,
  inset: (bottom: 0.5em),
  stroke: (bottom: 0.5pt + orange.lighten(60%)),
  grid.header([*Thành Phần*], [*Nội Dung*]),
  [- Portal], [Public],
  [- Entity], [Path, Course, Lab],
  [- Activity], [video transcript, quiz, lab, link, pdf, html_bundle],
  [- Output], [JSON, Markdown],
  [- Runner], [CLI, TUI]
)

=== Không Bao Gồm

#grid(
  columns: (30%, 70%),
  row-gutter: 0.5em,
  inset: (bottom: 0.5em),
  stroke: (bottom: 0.5pt + orange.lighten(60%)),
  grid.header([*Thành Phần*], [*Nội Dung*]),
  [- Portal], [Partner (sinh viên không còn quyền truy cập)],
  [- Automation], [Chạy (hoàn thành) Lab (đây là phần thực hành trực tiếp)],
  [- Account], [Quản lý tài khoản, mua khoá học],
  [- GUI], [Không (lý do sẽ được trình bày ở @triet-ly-va-thiet-ke[Chương] (#ref(<hai-quyet-dinh-khong-dung>, form: "page"))],
  [- Database], [Không (lý do sẽ được trình bày ở @triet-ly-va-thiet-ke[Chương] (#ref(<hai-quyet-dinh-khong-dung>, form: "page"))]
)

== Yêu Cầu
<yeu-cau>


=== Yêu Cầu Chức Năng
<yeu-cau-chuc-nang>

#datatable-data((
  headers: ([Mã], [Yêu cầu]),
  rows: (
    ([FR-01], [Liệt kê danh mục `path`, `course`, `lab`; làm mới từ site hoặc đọc offline]),
    ([FR-02], [Thu thập một `path` và lan xuống các `course`, `lab` của nó]),
    ([FR-03], [Thu thập một `course` với đầy đủ `module`, `step`, `activity`]),
    ([FR-04], [Thu thập một `lab` độc lập]),
    ([FR-05], [Bỏ qua course có `datePublished` không đổi, trừ khi `--force`]),
    ([FR-06], [Sinh Markdown cho `path`, `course`, `lab`; tuỳ chọn `--toc`, `--no-transcript`]),
    ([FR-07], [Tìm kiếm theo tên (`name`), `id`, chủ đề (`topic`)]),
    ([FR-08], [Dựng lại chỉ mục từ dữ liệu JSON (`reindex`)]),
    ([FR-09], [Tải tài liệu PDF vào `materials/courses/<id>/`]),
    ([FR-10], [Sinh tệp prompt JSON cho mô hình ngôn ngữ lớn (LLM).]),
    ([FR-11], [Giao diện tương tác dạng menu (TUI)]),
  ),
  options: (index: false, align: ("left", "left"), columns: ("15%", "auto")),
  caption: [Yêu cầu chức năng],
  label: "tb-fr",
))

#co-note[FR-10: Sinh tệp prompt JSON cho mô hình ngôn ngữ lớn (LLM) để tóm tắt nội dung transcript, đã từng được đề xuất, nhưng giờ tạm ngừng xây dựng.]

=== Yêu Cầu Phi Chức Năng
<yeu-cau-phi-chuc-nang>

#datatable-data((
  headers: ([Mã], [Yêu cầu]),
  rows: (
    ([NFR-01], [Không trạng thái (stateless): mỗi lần chạy đọc tệp, ghi tệp; chạy lại là _idempotent_ (nguyên bản)]),
    ([NFR-02], [Dữ liệu và đầu ra là văn bản thuần (plain text), UTF-8, đọc được bằng `git diff`]),
    ([NFR-03], [Cấu hình tường minh qua biến môi trường và tệp văn bản (`config.yaml`)]),
    ([NFR-04], [Lỗi tường minh: một `activity` hỏng không làm hỏng cả `course`, mọi ngoại lệ đều được báo]),
    ([NFR-05], [Ghi tệp nguyên tử (`atomic`): nếu gặp ngắt giữa chừng không để lại nửa tệp lỗi]),
    ([NFR-06], [Môi trường tái lập: `uv sync` từ một bản clone sạch là có thể bắt đầu]),
  ),
  options: (index: false, align: ("left", "left"), columns: ("15%", "auto")),
  caption: [Yêu cầu phi chức năng],
  label: "tb-nfr",
))

== Kết Chương
<ket-chuong-1>

Chương này mô tả bài toán thực tế của sinh viên: nội dung học tập nằm trên một nền tảng chỉ cho xem từng trang, ngày càng đóng, và không trả lời được những câu hỏi liên kết giữa các khoá học. Nhu cầu phát sinh từ công việc, nên lời giải là một công cụ thực tế với mười một yêu cầu chức năng (@tb-fr) và sáu yêu cầu phi chức năng (@tb-nfr), có những đặc thù nhất định và không nhất thiết dùng hết mọi kiến thức của môn học. Chương 2 trình bày triết lý và các quyết định thiết kế để trả lời bài toán đó bằng một ứng dụng nhỏ.
