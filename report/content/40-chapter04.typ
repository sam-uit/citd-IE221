#import "/lib.typ": *

= Kiểm Thử, Vận Hành Và Bảo Trì
<kiem-thu-van-hanh-va-bao-tri>


== Kiểm Thử Offline
<kiem-thu-offline>

#co-note[Fixture HTML và JSON ghi lại từ site trong `tests/fixtures/`; test khẳng định trên cấu trúc, không trên tiêu đề (tiêu đề course 72 đã đổi trong bảy tháng). Kết quả `uv run pytest` (15 test, không cần mạng). Danh sách nhóm test.]

== Chạy Lại Và Tính Idempotent
<chay-lai-va-tinh-idempotent>

#co-note[Chạy `fetch -c 892` hai lần: lần hai bỏ qua vì `datePublished` không đổi và có thông báo; `--force` để ép. Lab đã có thì không tải lại. Ngắt Ctrl+C giữa chừng không để lại tệp hỏng.]

== Khi Nền Tảng Thay Đổi
<khi-nen-tang-thay-doi>

Quy trình xử lý thay đổi của site gồm ba bước: ứng dụng phát hiện và báo (log, test thất bại, dừng rõ ràng); con người đánh giá giá trị và chi phí; thay đổi được thực hiện thành một commit có nguồn. Bảng dưới là các thay đổi thật từ v2.0.0 tới nay.

#datatable-data((
  headers: ([Thay đổi của site], [Triệu chứng ở v2.0.0], [Cách xử lý], [Commit nguồn]),
  rows: (
    ([Trang course bắt buộc đăng nhập], [dừng ở trang đăng nhập hoặc lấy nhầm trang đăng nhập], [`ensure_authenticated` một chỗ], [7637ba2]),
    ([API danh mục trả 403], [`list -r` rỗng], [đọc danh mục qua trình duyệt], [61f2cbf]),
    ([Loại activity mới], [bị bỏ qua lặng lẽ], [dispatch khoan dung, giữ dữ liệu thô], [31390c6]),
    ([`ld+json.hasPart` gắn nhãn sai lab], [path trỏ sai course], [`ql-contents-menu` là nguồn sự thật], [0b3c374]),
    ([Tên có dấu nháy đơn], [frontmatter YAML hỏng], [`json.dumps` cho giá trị vô hướng], [1aa2f3e]),
  ),
  options: (index: false, align: ("left", "left", "left", "left"), columns: ("25.00%", "25.00%", "25.00%", "25.00%")),
))
#co-note[Bổ sung hash commit trên branch `refactor-ie221` tương ứng từng dòng (`git log --oneline v2.0.0..refactor-ie221`).]

== Cấu Hình Và Tính Di Động
<cau-hinh-va-tinh-di-dong>

#co-note[Ba lớp cấu hình trong `config.py` `load_settings`: mặc định, `config.yaml`, biến môi trường. Kiểm tra từ clone sạch: `uv sync`, `pytest` xanh, `grep -rn "/Users/" src` rỗng. Ghi rõ đường qua Chrome đã được kiểm chứng trên máy nào, ngày nào.]

== Tổng Kết Chương 4
<tong-ket-chuong-4>
