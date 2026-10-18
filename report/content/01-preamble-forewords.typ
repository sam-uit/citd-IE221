#import "../lib.typ": *

= Lời Nói Đầu
<loi-noi-dau>

Google Skills (#link("https://skills.google")[skills.google]), trước đây là Google Cloud Skills Boost, là nền tảng đào tạo e-Learning chính thức của Google, bởi Google và cho các sản phẩm/dịch vụ của Google.

Vốn là nền tảng tập trung cho Google Cloud, nhưng bây giờ Google Skills đã mở rộng đối tượng sản phẩm phục vụ, và từ đó mở rộng số lượng nội dung được đăng tải, lên tới hàng trăm lộ trình học tập (path), hàng nghìn khoá học (course) và bài thực hành (lab).

Cách tổ chức của Google Skills cơ bản cũng tương tự các nền tảng e-learning khác, bao gồm: Lộ Trình Học Tập (Khóa Học) $arrow$ Các Môn Học $arrow$ Các Bài Học (Video, Bài Đọc, Bài Lab, vv..) và Các Bài Kiểm Tra (Quiz), Chứng Chỉ (Badge), vv.. rất bài bản và nhiều cấp bậc.

Phát sinh từ thực tế từ công việc cần làm việc trực tiếp với các dịch vụ của Google, cụ thể là Google Cloud, sinh viên thực hiện cũng cần sử dụng Google Skills để nhận các kiến thức liên quan về sản phẩm và dịch vụ, là một phần trong quá trình đào tạo (enablement) của công ty.

Tuy nhiên, sinh viên nhận thấy cách trình bày nội dung của Google Skills rất khó để theo dõi ở một số khía cạnh, ví dụ: Một bài học (course) hoặc bài lab có thể được sử dụng trong rất nhiều khóa học, tuy nhiên Google Skills không biểu diễn trực quan được mối quan hệ đó, khiến việc hình dung mối liên hệ kiến thức giữa các khóa học là rất khó, hoặc không thể, chỉ có thể tham gia hoặc đi qua từng khóa học để nhận ra là có môn học được dùng lại.

Đồng thời, việc bắt buộc sử dụng website để duyệt nội dung bài học, vốn chủ yếu là video youtube, không phải dạng văn bản, từ đó không hoặc khó cho phép việc ghi chú, tóm tắt, đánh dấu, vv.. về cơ bản là một cách tiếp cận không quá hiệu quả hay rất khó tham khảo lại.

Vì vậy, sinh viên đã đi đến quyết định thiết kế một công cụ nhỏ, mục đích kéo tất cả nội dung cần thiết của Google Skills về máy nội bộ, đóng gói thành các file thuần văn bản Markdown, trong một kho (vault) của Obsidian; vừa xây dựng cho mình một Kho Kiến Thức Cá Nhân (Personal Knowledge Base); vừa tạo tiền đề cho các sự mở rộng/liên kết kiến thức thậm chí bên ngoài Google Skills; hoặc/và đóng gói thành các văn bản dạng sách A4/A5, tiện lợi cho việc tra khảo hoặc đọc trên các thiết bị cầm tay (iPad/Kindle) cá nhân.

```log
* commit 1c822f5eb80d5e6350f1e170379b8cabcb3af657
| Author: samdx <18287802+samdx@users.noreply.github.com>
| Date:   Sun Jan 5 17:07:57 2025 +0800
|
|     Init the repo.
|
* commit 9eb4e75a4ffa4c01cee6c36eadc2f8ce282747fe
  Author: samdx <18287802+samdx@users.noreply.github.com>
  Date:   Sun Jan 5 17:06:54 2025 +0800

      Create .gitattributes
```

Mục tiêu đầu tiên của công cụ ban đầu hoàn toàn không có ý tưởng về việc xây dựng một Bộ Não Thứ 2 (#link("https://fortelabs.com/blog/basboverview/")[https://fortelabs.com/blog/basboverview/]), tuy nhiên có một sự vô tình trong cách triển khai, mà sau này khi OKF (Open Knowledge Format) xuất hiện, mô hình nội dung trong công cụ đã tương thích gần như hoàn toàn.

Tuy nhiên, báo cáo này chỉ tập trung vào phần kỹ thuật của công cụ, các nội dung khác liên quan về cách tổ chức kho PKB sẽ không được đề cập ở đây hoặc chỉ được nhắc qua, ví dụ: backlink hoặc graph view trong Obsidian giúp trực quan hóa mối quan hệ giữa các khóa học/môn học; cách tổ chức kho theo mô hình PARA và cách khai thác, vv..

Hi vọng với các nội dung dưới đây, sẽ đem đến một vài tham khảo có ý nghĩa cho các bạn sinh viên cùng lớp, cũng như biểu hiện được các nội dung kiến thức đã được Giảng Viên truyền đạt trong môn học IE221 tại UIT.
