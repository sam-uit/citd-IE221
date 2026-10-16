// /report.typ
// A Report Main Content File

// Import template and metadata
#import "./lib.typ": *
#import "config/metadata.typ": data

// Phần đầu sách và trang tác giả là CONTENT, không phải tên file. Xem chú thích
// cùng chỗ trong `thesis.typ` cho lý do đầy đủ.
#let preamble = (
  forewords: include "content/01-preamble-forewords.typ",
  acknowledgement: include "content/02-preamble-acknowledgement.typ",
  comment: include "content/03-preamble-comment.typ",
)

// Show document with report type
#show: document.with(
  ..data,
  doc-type: "report",
  preamble: preamble,
  author-page: include "author/author.typ",
  logo: image("static/" + data.university.logo, width: 5cm),
)

// Content goes here
#include "content/10-chapter01.typ"
#include "content/20-chapter02.typ"
#include "content/30-chapter03.typ"
#include "content/40-chapter04.typ"
#include "content/50-chapter05.typ"

// Show appendix
#show: appendix
#include "content/90-appendixA.typ"
// #include "content/91-appendixB.typ"

// Show bibliography
#show: bibliography-page
#bibliography("content/98-bibliography.yaml", title: "Tài Liệu Tham Khảo")
