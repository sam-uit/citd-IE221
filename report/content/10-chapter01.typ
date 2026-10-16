#import "/lib.typ": *

= Mô Tả Bài Toán
<mo-ta-bai-toan>


== Bối Cảnh
<boi-canh>


=== Google Skills và những thay đổi gần đây
<google-skills-va-nhung-thay-doi-gan-day>

Như đã đề cập, Google Skills (skills.google), trước đây là Google Cloud Skills Boost) là nền tảng đào tạo chính thức của Google Cloud, gồm hàng trăm lộ trình học (path), hàng nghìn khoá học (course) và bài thực hành (lab).

Trong khoảng hai năm, từ cuối 2024 đến đầu 2026, nền tảng đã có những thay đổi trong cả định hướng hoạt động và trong bộ nội dung được triển khai, và từ đó ảnh hưởng trực tiếp tới cách thu thập nội dung, ví dụ: từ một nền tảng mở, Google Skills bây giờ đã yêu cầu phải có tài khoản đăng nhập để có thể xe nội dung môn học, từ đó một hệ quả kỹ thuật phát sinh: thư viện `requests` không còn đủ, việc thu thập phải đi qua một phiên trình duyệt đã đăng nhập (Selenium), vì vậy công cụ sẽ cần thực hiện thêm việc quản lý phiên thay vì chỉ kéo nội dung như trước.

=== Phân Cấp Dữ Liệu
<phan-cap-du-lieu>

#datatable-data((
  columns: (5%, 15%, auto),
  headers: ([Cấp], [Thực thể], [Ghi chú]),
  rows: (
    ([1], [*Portal*], [Bao gồm _public_ và _partner_; báo cáo này chỉ đề cập _public_ portal vì _partner_ là dành cho đối tác của Google, và cần có tài khoản riêng.]),
    ([2], [*Path*], [Lộ Trình, chứa nhiều Course và Lab theo thứ tự.]),
    ([3], [*Course*], [Khoá Học, có mô tả, mục tiêu, chủ đề và từng chương.]),
    ([4], [*Module*], [Chương của khoá học, sẽ có từng bài học cụ thể.]),
    ([5], [*Step*], [Các bước trong chương.]),
    ([6], [*Activity*], [Các bài học, có thể là video, lab, quiz, pdf hoặc html, hoặc loại nội dung bất kỳ nào khác.]),
  ),
  options: (index: false, align: ("right", "left", "left"), columns: ("8%", "15%", "auto")),
))

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

#co-note(title: [Ghi Chú])[
  - Lab vừa là một hoạt động trong Course vừa là một thực thể độc lập, đôi khi được tham chiếu trực tiếp bởi Path, điều này đôi lúc tạo nên sự phức tạp trong logic của việc liên kết các thực thể.
  - Tập các loại hoạt động (*Activity*) thuộc về Google chứ không thuộc về ứng dụng: Google Skills có thể thay đổi các loại hoặc động bất kỳ lúc nào, hiện tại thường là sẽ thêm mới dựa theo cách triển khai nội dung của các khóa học/môn học mới.
]

== Vấn Đề Cần Giải Quyết
<van-de-can-giai-quyet>

Nền tảng cho xem một trang tại một thời điểm. Bốn câu hỏi người học hay đặt ra nhất lại không trả lời được trên bản thân trang độc lập đó, trong khi chúng là tính năng có sẵn của Obsidian khi nội dung là Markdown liên kết:

#datatable-data((
  headers: ([Câu hỏi], [Trên skills.google], [Trong vault Obsidian]),
  rows: (
    ([Course này *thuộc những path* nào?], [phải tìm ngược từng path], [backlink của note]),
    ([Hai path *chồng lấn bao nhiêu* course?], [không có], [graph view, truy vấn]),
    ([Transcript nào *nhắc tới một khái niệm*?], [khó tìm trong transcript], [tìm toàn văn, offline]),
    ([Course này *thay đổi gì* từ lần học trước?], [không có lịch sử], [`date_published` và `git diff`]),
  ),
  options: (index: false, align: ("left", "left", "left"), columns: ("1fr", "auto", "auto")),
))

Quy trình hiện tại của người học trên Google Skills: duyệt danh mục, mở từng khoá, xem video, ghi chú tay. Nội dung nằm rải rác qua video, quiz, lab, tài liệu; không có bản xuất, không có bản offline, không tìm kiếm xuyên khoá. Có một sự rời rạc trong một hệ thống được thiết kế trông rất chặt chẽ.

== Mục Tiêu Đề Tài
<muc-tieu-de-tai>

Mục tiêu đầu tiên, công cụ thực tiễn:

- Xây dựng một ứng dụng/công cụ Python dòng lệnh.
- Thu thập Path, Course, Lab từ skills.google vào kho JSON (file-based database).
- Sinh ra một vault Markdown dùng được ngay trong Obsidian
- Cung cấp hai giao diện terminal (CLI cho tự động hoá, TUI cho tương tác).

Mục tiêu thứ hai, về mặt học thuật, là dùng chính ứng dụng này làm chứng cứ cho các kiến thức của môn học: *module* và *package*, *lớp* và *đối tượng*, *kế thừa*, xử lý ngoại lệ, vv...

== Phạm Vi Ứng Dụng
<pham-vi>

=== Bao Gồm

- Public portal;
- Ba loại thực thể chính: Path, Course, Lab;
- Activity: transcript video, quiz, lab, link, tài liệu PDF, html_bundle;
- Kết xuất JSON và Markdown;
- Hai runner terminal: CLI, TUI (Terminal User Interface).

=== Không Bao Gồm

- Partner Portal (sinh viên không còn quyền truy cập);
- Chạy Lab;
- Quản lý tài khoản, mua khoá học;
- Giao diện đồ hoạ và Cơ Sở Dữ Liệu (lý do sẽ được trình bày ở @triet-ly-va-thiet-ke[Chương] (#ref(<triet-ly-va-thiet-ke>, form: "page")).

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
))

== Tổng Kết Chương 1
<tong-ket-chuong-1>

Chương này mô tả bài toán thực tế của sinh viên, và từ đó phát sinh nhu cầu cần giải quyết, vì vậy là một công cụ thực tế, và từ đó có những đặc thù nhất định mà không hoàn toàn sử dụng hết mọi kiến thức của môn học. Chương 2 sẽ trình bày Triết lý và Thiết kế để trả lời bài toán đó bằng một ứng dụng nhỏ.
