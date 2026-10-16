# Báo cáo và Slides IE221: Google Skills Scraper

Báo cáo (`thesis.typ`, 5 chương và phụ lục) và deck (`slides.typ`) của đồ án môn IE221 (Kỹ Thuật Lập Trình Python). Dựng theo đúng máy móc của `citd-IE203/report`: theme `@local/uit-theme:0.4.2` (báo cáo và aqua cho slides), Typst 0.15 trở lên, cần cả `@local/typst-bpmn:0.18.0` mà theme import. `report.typ` là bản `doc-type: report` của cùng nội dung, không nộp.

## Build

```bash
just snippets        # bóc mã thật từ ~/repos/gcpcta/skills-google-scrapper vào content/code/
just thesis          # thesis.pdf
just slides          # slides.pdf
just png thesis      # từng trang PNG vào _review/thesis/ để soát bằng mắt (mặc định: slides)
```

Biến môi trường: `TYPST` (đường dẫn binary), `UIT_THEME` (mặc định `~/repos/typst-uit-theme`, lấy font từ `fonts/` ở đó), `SCRAPER` (repo scraper).

## Bố cục

| Đường dẫn | Là gì |
|---|---|
| `thesis.typ` | Báo cáo: metadata từ `config/config.yaml`, phần đầu sách, include 5 chương, phụ lục, tham khảo |
| `slides.typ` | Deck: theme, màu, bìa, mục lục, include các phần slides |
| `lib.typ` | Cửa duy nhất tới package; `code-file` đọc mã cho slides, `code-figure` là bản có chú thích cho báo cáo; `small` là cỡ chữ có phạm vi |
| `content/01..03-preamble-*.typ`, `00-preamble-acronyms.csv` | Lời nói đầu, cảm ơn, trang nhận xét, bảng viết tắt |
| `content/10..50-chapter0N.typ`, `90-appendixA.typ` | Năm chương và phụ lục, viết tay bằng Typst (không sinh từ Markdown) |
| `content/98-bibliography.yaml` | Tham khảo (Hayagriva), gồm 10 slide bài giảng |
| `config/config.yaml` | Dữ liệu: trường, môn, giảng viên, tác giả, repo |
| `content/slides-a..d-*.typ` | Bốn phần: bối cảnh; ứng dụng không phải hệ thống; mã nguồn; hôm nay, demo, mở rộng |
| `content/diagrams.typ` | Sơ đồ lớp và kiến trúc, Typst thuần từ dữ liệu (typst-diagrams cố ý không làm sơ đồ lớp) |
| `content/tables/*.yaml` | Bảng: đối chiếu chương bài giảng, site đổi mã đổi theo |
| `content/code/` | Mã thật, do `tools/snippets.py` bóc bằng `ast`, không gõ tay; báo cáo và slides cùng đọc |
| `content/images/` | Ảnh Graph view của vault |

## Bẫy đã trả giá

Một `#set text(size: ..)` đặt trần trong slide không dừng ở slide đó: Touying gom nội dung cả section nên các cỡ `em` nhân dồn, tới slide thứ tư chữ còn một nửa, kể cả tiêu đề. Dùng `#small(size: ..)[...]` của `lib.typ`, hoặc đặt `set` bên trong một ô `[...]` của grid.

Quy ước trình bày (theo IE203): tên chương viết HOA, một đoạn dẫn mở chương, mục cuối là "Kết Chương"; mọi bảng, hình và đoạn mã đều là `figure` có caption và label để lên ba danh sách ở đầu sách; mã trong báo cáo dùng `code-figure`, không dùng raw block gõ tay.
