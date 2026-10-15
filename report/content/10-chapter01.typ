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

#co-note(title: [Ghi Chú])[
  - Lab vừa là một hoạt động trong Course vừa là một thực thể độc lập, đôi khi được tham chiếu trực tiếp bởi Path, điều này đôi lúc tạo nên sự phức tạp trong logic của việc liên kết các thực thể.
  - Tập các loại hoạt động (*Activity*) thuộc về Google chứ không thuộc về ứng dụng: Google Skills có thể thay đổi các loại hoặc động bất kỳ lúc nào, hiện tại thường là sẽ thêm mới dựa theo cách triển khai nội dung của các khóa học/môn học mới.
]

