// /thesis.typ
// A Thesis Main Content File

// Import template and metadata
#import "./lib.typ": *
#set text(lang: "vi")

// TODO: Use YAML instead of Typst code
// #import "config/metadata.typ": data
#let properties = yaml("config/config.yaml")

// Phần đầu sách là CONTENT, không phải tên file.
//
// Trước đây đây là bốn cái tên và template tự `include "/content/" + tên + ".typ"`.
// Không làm vậy được nữa, và cũng không nên: theme nằm ở package `@local/uit-theme`,
// mà một package Typst chỉ đọc được file nằm trong chính nó. Chỉ tài liệu mới biết
// `content/` của nó ở đâu, nên tài liệu tự `include` rồi đưa kết quả vào.
//
// Bỏ `summary` vì nó vẫn đang rỗng; cần thì thêm một khóa `summary:` ở đây.
#let preamble = (
  summary: include "content/00-preamble-summary.typ",
  forewords: include "content/01-preamble-forewords.typ",
  acknowledgement: include "content/02-preamble-acknowledgement.typ",
  comment: include "content/03-preamble-comment.typ",
)

// document metada
#let metadata = properties.at("metadata")
#let university = metadata.at("university")
#let course = metadata.at("course")
#let instructor = metadata.at("instructor")
#let author = metadata.at("author")
#let assignment = metadata.at("assignment")

// Load acronyms
// TODO: Use abbreviations package support citation.
#let acronyms = csv("content/00-preamble-acronyms.csv")

// Show document with thesis type
#show: document.with(
    university: university,
    course: course,
    instructor: instructor,
    author: author,
    assignment: assignment,
    acronyms: acronyms,
    doc-type: "thesis",
    preamble: preamble,
    // Logo cũng là content: `image(..)` gọi từ trong package sẽ tìm trong gốc của
    // package. Tên file vẫn lấy từ tầng dữ liệu, chỉ việc ĐỌC là của tài liệu.
    logo: image("static/" + university.logo, width: 5cm),
)

// Font mã nguồn là Google Sans Code của theme (`code-font`), cùng slides và IE203;
// cỡ chữ của từng đoạn đặt tại `code-figure(size: ..)` trong `lib.typ`.

// Content goes here
#include "content/10-chapter01.typ"
#include "content/20-chapter02.typ"
#include "content/30-chapter03.typ"
#include "content/40-chapter04.typ"
#include "content/50-chapter05.typ"
// #include "content/60-chapter06.typ"

// Show appendix
#show: appendix
#include "content/90-appendixA.typ"

// Show bibliography
#show: bibliography-page
#bibliography("content/98-bibliography.yaml", title: "Tài Liệu Tham Khảo", style: "ieee", full: true)

// TODO: Glossary for the book (report/thesis)
// #show: glossary
