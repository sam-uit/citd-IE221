#import "../lib.typ": *

= TÓM TẮT BÁO CÁO

Đây là Báo Cáo Đồ Án của:

#grid(
  columns: (30%, 70%),
  row-gutter: 0.5em,
  inset: (bottom: 0.5em),
  stroke: (bottom: 0.5pt + orange.lighten(60%)),
  // grid.header([*Thành Phần*], [*Nội Dung*]),
  [- Môn Học], [*IE221 -- Kỹ Thuật Lập Trình Python*],
  [- Lớp], [*IE221.F33.LT.CNTT*],
  [- Giảng Viên], [*Thạc Sĩ Nghi Hoàng Khoa*],
)

Sinh viên thực hiện:

#grid(
  columns: (30%, 70%),
  row-gutter: 0.5em,
  inset: (bottom: 0.5em),
  stroke: (bottom: 0.5pt + orange.lighten(60%)),
  // grid.header([*Họ Tên*], [*Mã Sinh Viên*]),
  [- Họ Tên], [Đinh Xuân Sâm],
  [- Mã Sinh Viên], [25410291],
)

== Tiêu Chí

Báo Cáo này được thực hiện với các tiêu chí:

- Trình bày quá trình xây dựng một công cụ thực tế sử dụng Python.
- Trình bày các khối kiến thức đã được sử dụng từ môn học IE221 trong mã nguồn.
- Cung cấp mã nguồn của công cụ như một minh chứng của quá trình.
- Cung cấp bản demo như một minh chứng cho chức năng và khả năng hoạt động.
- Cởi mở và tường minh về các nội dung đã đạt được, chưa đạt được, hoặc không triển khai.
- Trình bày chuyên nghiệp theo hướng học thuật.

== Nộp Bài

- Báo cáo: File PDF, khoảng 50 trang.
  - Vui lòng theo dõi @cai-dat-trien-khai[Chương] (#ref(<cai-dat-trien-khai>, form: "page"), gồm 20 trang) cho các nội dung về kiến thức trong môn học.
  - Các chương khác mang tính chất bổ sung hoặc/và làm rõ hơn các nội dung ở trong chương này.
- Slide: File PDF.
  - Như một bản rút gọn của báo cáo.
  - Hoàn toàn có thể bỏ qua báo cáo và vẫn trình bày đầy đủ nội dung cốt lõi.
- Demo: File hình ảnh/video đính kèm.
- Mã Nguồn: #link("https://github.com/ggcta/skills-scrapper/tree/refactor-ie221")[github.com/ggcta/skills-scrapper], nhánh `refactor-ie221`.
  - Được khởi tạo từ tháng 01/2025.
  - Và vẫn được duy trì hiện tại.
  - Hoàn toàn mở.

== Khai Báo Sử Dụng AI

- Bóc tách/chỉ ra các đoạn code đang có phản ánh các khối kiến thức của môn học để đưa vào báo cáo (xem ghi chú sau đây).
- Rà soát bộ khung nội dung báo cáo: chính tả, ngữ nghĩa (semantic).
- Thực hiện các commit chuẩn hóa ở nhánh `refactor-ie221` phục vụ cho báo cáo môn học, không thay đổi lõi logic của công cụ vốn đã ổn định.

#co-note(title: [Ghi Chú])[
  - Sinh viên sử dụng #link("https://typst.app/docs/reference/text/raw/")[`raw` của Typst] để truyền đạt nguyên bản mã nguồn.
  - Typst cho phép tải file (`load()`) trực tiếp để đảm bảo luôn có một nguồn sự thật duy nhất: có nghĩa nguồn trong code thế nào, sẽ được chuyển vào báo cáo như vậy.
  - Đây là chức năng nguyên bản của trình soạn thảo/Typesetting Typst.

```typst
#raw(load("code/model/course.py"), lang: "python", block: true)
```
]

= Tuyên Bố Miễn Trừ Trách Nhiệm

#co-warn(title: [TUYÊN BỐ MIỄN TRỪ TRÁCH NHIỆM])[
Tất cả các nội dung của Google Skills đều là sở hữu của Google hoặc/và Google Skills. Không sao chép một phần hoặc tất cả nội dung cho mục đích khác ngoài mục đích ban đầu là phục vụ đào tạo các sản phẩm/dịch vụ của Google.

Công cụ này chỉ cung cấp một cách làm việc với các nội dung trên cho mục tiêu học tập cá nhân, KHÔNG CHỊU TRÁCH NHIỆM cho bất kỳ mục đích nào khác, và mọi quyền hạn hoặc trách nhiệm liên quan đến các nội dung được tải, vui lòng tham khảo Quy Định Sử Dụng của và trực tiếp tại Google Skills.

Đồng thời, Báo Cáo này không sao chép hoặc trình bày các nội dung của các khóa học/bài học, vv.. trên Google Skills mà chỉ tập trung vào khía cạnh kỹ thuật hoặc/và cấu trúc dữ liệu đằng sau.
]
