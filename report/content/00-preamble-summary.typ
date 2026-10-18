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
