// /lib.typ
// Cửa duy nhất cho `content/`: theme của package cộng bộ nạp file của tài liệu.
//
// Một package Typst chỉ đọc được file nằm trong chính nó, nên mọi `yaml(..)`,
// `read(..)`, `image(..)` của tài liệu phải ở phía tài liệu. File này là phía đó
// và là chỗ duy nhất trong repo biết `/content/...` nghĩa là gì. Xem
// `citd-IE203/report/lib.typ` cho bản đầy đủ; ở đây chỉ giữ những gì deck cần.

#import "@local/uit-theme:0.4.2": *

#let ggcolors = (
  blue: rgb("#174EA6"),
  red: rgb("#A50E0E"),
  orange: rgb("#E37400"),
  green: rgb("#0D652D"),
)

// MARK: Nạp dữ liệu

#let load-data(path, id: none) = {
  let raw = if path.ends-with(".yaml") or path.ends-with(".yml") { yaml(path) } else if (
    path.ends-with(".json")
  ) { json(path) } else if path.ends-with(".csv") { csv(path) } else {
    panic("không hỗ trợ định dạng của " + path)
  }
  if id == none { raw } else if type(raw) == dictionary and id in raw { raw.at(id) } else { raw }
}

#let datatable-file(path, id: none, ..args) = datatable-data(load-data(path, id: id), ..args)
#let datatable-slide(path, id: none, ..args) = datatable-slide-data(load-data(path, id: id), ..args)

// MARK: Mã nguồn thật trên slide
//
// `content/code/*.py` do `tools/snippets.py` bóc từ repo skills-google-scrapper, không
// gõ tay. `from:`/`to:` cắt theo số dòng của file đã bóc, để một hàm dài chỉ hiện phần
// đang nói tới. `size:` vì 20pt của body là quá to cho mã.
#let code-file(path, from: 1, to: none, lang: "python", size: 13pt) = {
  let lines = read(path).split("\n")
  let stop = if to == none { lines.len() } else { calc.min(to, lines.len()) }
  let body = lines.slice(from - 1, stop).join("\n")
  set text(size: size)
  raw(body, lang: lang, block: true)
}

// MARK: cỡ chữ có phạm vi
//
// Một `#set text(..)` đặt trần trong slide không dừng ở slide đó: Touying gom nội dung
// của cả section, nên 0.85em nhân dồn 0.85 x 0.85 x ... và tới slide thứ tư chữ còn
// một nửa, kể cả tiêu đề trên thanh header. Hàm này là một phạm vi: set chỉ sống bên
// trong ngoặc.
#let small(body, size: 0.85em) = {
  set text(size: size)
  body
}
