# Slides IE221: Google Skills Scraper

Deck báo cáo đồ án môn IE221 (Kỹ Thuật Lập Trình Python), chỉ slides, không có báo cáo. Dựng theo đúng máy móc của `citd-IE203/report`: theme `@local/uit-theme:0.4.2` (aqua), Typst 0.15 trở lên.

## Build

```bash
just snippets   # bóc mã thật từ ~/repos/gcpcta/skills-google-scrapper vào content/code/
just slides     # slides.pdf
just png        # từng trang PNG vào _review/ để soát bằng mắt
```

Biến môi trường: `TYPST` (đường dẫn binary), `UIT_THEME` (mặc định `~/repos/typst-uit-theme`, lấy font từ `fonts/` ở đó), `SCRAPER` (repo scraper).

## Bố cục

| Đường dẫn | Là gì |
|---|---|
| `slides.typ` | Tài liệu: theme, màu, bìa, mục lục, include bốn phần |
| `lib.typ` | Cửa duy nhất tới package; `code-file` đọc mã; `small` là cỡ chữ có phạm vi |
| `config/config.yaml` | Dữ liệu: trường, môn, giảng viên, tác giả, repo |
| `content/slides-a..d-*.typ` | Bốn phần: bối cảnh; ứng dụng không phải hệ thống; mã nguồn; hôm nay, demo, mở rộng |
| `content/diagrams.typ` | Sơ đồ lớp và kiến trúc, Typst thuần từ dữ liệu (typst-diagrams cố ý không làm sơ đồ lớp) |
| `content/tables/*.yaml` | Bảng: đối chiếu chương bài giảng, site đổi mã đổi theo |
| `content/code/` | Mã thật, do `tools/snippets.py` bóc bằng `ast`, không gõ tay |
| `content/images/` | Ảnh Graph view của vault |

## Bẫy đã trả giá

Một `#set text(size: ..)` đặt trần trong slide không dừng ở slide đó: Touying gom nội dung cả section nên các cỡ `em` nhân dồn, tới slide thứ tư chữ còn một nửa, kể cả tiêu đề. Dùng `#small(size: ..)[...]` của `lib.typ`, hoặc đặt `set` bên trong một ô `[...]` của grid.
