#import "/lib.typ": *
#import "diagrams.typ": arch-diagram

= Triết Lý Và Thiết Kế
<triet-ly-va-thiet-ke>


== Một Ứng Dụng, Không Phải Một Hệ Thống
<mot-ung-dung-khong-phai-mot-he-thong>

Công cụ được thiết kế dưới góc nhìn của kỹ sư hệ thống: một thành phần nhỏ, đúng một việc, ghép được với các công cụ khác, mà không phải là một "hệ thống" hay một nền tảng hoàn toàn độc lập. Năm nguyên tắc dưới đây quyết định mọi lựa chọn trong các chương sau.

=== Làm Một Việc Và Làm Tốt
<don-gian-lam-mot-viec-va-lam-tot>

#co-note(title: [_KISS_: Keep It Simple, Stupid])[
  - Làm một việc, và làm thật tốt việc đó.
  - Hoàn toàn có thể kết hợp với các công cụ khác để tạo thành một luồng công việc.
  - Dễ dàng được thay thế mà không ảnh hưởng đến tổng thể.
]

Ứng dụng chỉ thu thập và chuẩn hoá.

- Lệnh `fetch` đưa nội dung về JSON.
- Lệnh `md` chuyển JSON thành Markdown, hai lệnh không (cần) biết nhau.
- Ba thư viện ngoài lúc chạy (selenium, beautifulsoup4, requests).
- Không daemon, không server.

=== Đơn Giản Để Luôn Thay Thế Được
<don-gian-de-luon-thay-the-duoc>

Thứ bền nhất không phải công cụ mà là dữ liệu nó để lại. JSON và Markdown thuần vẫn đọc được khi công cụ không còn tồn tại.

Dự án đã tự chứng minh: dòng chính của repo thay lõi Python bằng lõi Go (thử nghiệm) mà vault không đổi định dạng. Một công cụ khoá dữ liệu của người dùng vào chính nó thì không phải là khó thay thế, mà biến dữ liệu thành con tin.

#co-note(title: [Tiêu Chí])[
  - Đơn giản đến mức có thể được thay thế bất kỳ lúc nào.
  - Hiệu quả đến mức không cần phải thay thế.
]

=== Là Một Phần Của Hệ Thống
<la-mot-phan-cua-he-thong>

Ứng dụng giao tiếp bằng tệp văn bản và mã thoát, nên ghép được với `grep`, `jq`, `git`, `cron`, Obsidian và các plugin AI mà không cần API riêng. Đồ thị khoảng 3.600 note trong vault không được thiết kế trước: nó hình thành từ các liên kết tương đối mà mỗi note tự ghi ra.

#co-info(title: [Emergence])[Nguyên Lý Đột Sinh (Emergence) -- một phần "ngốc nghếch" của một hệ thống _thông minh_.]

=== Tường Minh
<tuong-minh>

- Cấu hình nằm trong biến môi trường và tệp `config.yaml` văn bản thuần, có tệp mẫu trong repo.
- Mỗi note Markdown tự khai nó được sinh bởi phiên bản nào, từ trang nào, trang đó sửa lần cuối khi nào đều được nêu rõ tường minh.
- Khi bỏ qua một `course` vì course đó không đổi, ứng dụng nêu rõ ra là đã bỏ qua và vì lý do gì.

=== Thêm Hay Không Thêm
<them-hay-khong-them>

Mỗi thư viện và mỗi tầng hạ tầng phải trả lời được câu hỏi "nó đóng góp được gì".

Quy ước của dự án: một thư viện chỉ được khai báo trong đúng _commit_ đầu tiên `import` nó. Cơ sở dữ liệu lớn chỉ xứng đáng khi cần hiệu năng cao, ghi đồng thời song song, hoặc xử lý phân tán; bài toán này không cần cả ba, vì vậy đây là lý do báo cáo này không sử dụng một số kiến thức nhất định trong môn học.

== Con Người Trong Vòng Lặp
<con-nguoi-trong-vong-lap>

- Câu hỏi: _nếu Google thay đổi cấu trúc website hay khoá học, ứng dụng có tự phát hiện và thay đổi theo không?_
- Câu trả lời tách làm hai vế: phát hiện thì *có*, tự thích nghi thì *không*, và đó là chủ ý thiết kế của người thực hiện.

Về phát hiện: loại _activity_ lạ được giữ nguyên dữ liệu thô và ghi log:

- Thiếu metadata hoặc đề cương thì dừng course đó và báo rõ;
- Phiên đăng nhập hết hạn thì dừng chờ người dùng;
- Bộ mẫu HTML trong `tests/` sẽ kích hoạt một thay đổi markup (của Google) thành một test thất bại (và từ đó cần xử lý tương ứng).

Về không tự thích nghi, có ba lý do.

- Một scraper tự sửa selector thực chất là *đoán*, và đoán sai sẽ ghi dữ liệu sai vào vault một cách âm thầm; _lỗi im lặng nguy hiểm hơn lỗi ồn ào_, thà để ồn ào để biết đó là gì, còn hơn để mọi thứ sai trong im lặng, đây cũng là chủ ý thiết kế.
- Có đi theo thay đổi hay không là quyết định về giá trị: nếu mục tiêu cốt lõi (lấy nội dung về) vẫn đạt, thời gian, công sức và tài nguyên tính toán bỏ ra có xứng đáng không; bản thân logic của công cụ không trả lời được câu đó, và đó là lúc con người tham gia trong "vòng lặp".

Lịch sử dự án đã kiểm chứng cách làm này (chương 4): mỗi thay đổi của site là một commit có nguồn và có lý do. Mô hình triển khai: công cụ báo lỗi, người quyết định, git ghi lại lịch sử bao gồm cả lý do, cách xử lý, vv... thành một nguồn sự thật duy nhất (SSOT -- Single Source Of Truth).

== Vault Như Bộ Não Thứ Hai
<vault-nhu-bo-nao-thu-hai>

Theo khung #link("https://fortelabs.com/blog/basboverview/")[CODE (Capture, Organize, Distill, Express)], ứng dụng làm *Capture* và một phần *Distill* (`--toc`, `--no-transcript`, tệp prompt). *Organize* thuộc về Obsidian, *Express* thuộc về người học. Ứng dụng cố ý và nên dừng ở mức đó.

#datatable-data((
  headers: ([Portal], [Paths], [Courses], [Labs]),
  rows: (
    ([public], [73], [416], [824]),
    ([partner], [181], [899], [1209]),
  ),
  options: (index: false, align: ("left", "left", "left", "left")),
))

#image("images/obsidian-pkb-2nd-brain.png")

== Đối Chiếu Với Open Knowledge Format
<doi-chieu-voi-open-knowledge-format>

OKF v0.2 chỉ bắt buộc mọi tệp `.md` có frontmatter YAML đọc được với khoá `type` không được rỗng. Vault đã thoả điều này từ 2025 vì `type` được suy ra từ tên lớp. Việc trùng khớp không phải ngẫu nhiên: cả hai cùng xuất phát từ ràng buộc "một khái niệm là một tệp, siêu dữ liệu (metadata) ở đầu, thân bài cho người đọc".

#co-info(title: [Fun Fact])[
  Thực ra cách trình bày file Markdown này là kế thừa từ thời sử dụng #link("https://jekyllrb.com/")[Jekeyll].
]

#datatable-data((
  headers: ([Vault v2.0.0], [OKF v0.2], [Trạng thái]),
  rows: (
    ([`type`], [`type` (bắt buộc)], [đã có]),
    ([`title`], [`title`], [đã có]),
    ([`url`], [`resource`], [khác tên, giữ làm alias]),
    ([`topics`], [`tags`], [khác tên, giữ làm alias]),
    ([mô tả trong thân bài], [`description`], [bổ sung]),
    ([`scraped_date`], [`generated {by, at}`], [bổ sung]),
    ([`date_published`], [`sources[].last_modified`], [bổ sung]),
    ([không có], [`index.md`, `log.md`], [hướng phát triển]),
  ),
  options: (index: false, align: ("left", "left", "left")),
))

Mẫu frontmatter ví dụ:

```yaml
"id": "892"
name: "Conversational AI on Vertex AI and Dialogflow CX"
type: "Course"
url: "https://www.cloudskillsboost.google/course_templates/892"
description: "In this course you will learn how to use the new generative AI features..."
date: "2025-01-06"
datePublished: "2023-11-21",
```

== Kiến Trúc Gói
<kien-truc-goi>

```
src/skills_scraper/
  __init__.py
  config.py     cấu hình, URL, selector
  cli.py        runner dòng lệnh
  tui.py        runner tương tác
  model/        lõi: Serialize, BaseEntity, Collection và các lớp con
  services/     browser.py (phiên đăng nhập), store.py (lưu trữ)
  utils/        xử lý văn bản, ghi tệp nguyên tử
```

Hướng phụ thuộc một chiều: runner gọi `model/`, `model/` dùng `services/` và `utils/`. Toàn bộ kiến thức về skills.google nằm trong `config.py` và các phương thức phân tích trang; mô hình, lưu trữ, kết xuất và giao diện không biết Google.

#align(center)[
  #arch-diagram(highlight: ("model",))
  #text(size: 0.6em, fill: gray)[Phụ thuộc một chiều: runner gọi model, model gọi services, services lầm việc với file và trình duyệt (các tài nguyên).]
]

== Hai Quyết Định Không Dùng
<hai-quyet-dinh-khong-dung>

Không Cơ Sở Dữ Liệu (Chương 10 - IE221):

- Kho có dưới 5.000 bản ghi, Tìm Kiếm Tuyến Tính có cơ thể trả về kết quả trong mili giây.
- Tệp phẳng (flat-file) và văn bản thuần (plain text), nên đọc được bằng git và Obsidian hoặc bất kỳ công cụ nào khác.
- Không trạng thái (stateless) nên chạy ở đâu cũng được.

#co-note(title: [Ghi Chú])[Phiên bản v2.0.0 từng ghi song song JSON và TinyDB, và hiện đã bỏ TinyDB ở các phiên bản sau vì không xứng đáng để bảo trì một lúc hai nguồn sự thật trong khi không đem lại giá trị quá khác biệt.]

Không Giao Diện Đồ Hoạ (Chương 09 -- IE221):

- Người dùng mục tiêu là kỹ sư làm việc trong terminal.
- Giao diện đồ hoạ thật đã tồn tại ở nhánh Tauri (như một ví dụ về khả năng mở rộng) nhưng sẽ không được ghép vào dòng/chức năng chính.
- Báo cáo này sẽ chỉ tập trung vào phần vào lõi của công cụ (model) nơi biểu hiện rõ nhất các nội dung của chương trình học.

#co-note(title: [Ghi Chú])[Đây đều là các quyết định thiết kế có lý do và chủ đích, mà không phải là sự vô tình bỏ sót kỹ năng đã học hoặc nội dung chương trình].

== Tổng Kết Chương 2
<tong-ket-chuong-2>
