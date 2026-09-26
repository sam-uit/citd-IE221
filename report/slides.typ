// slides.typ: deck báo cáo IE221, theme aqua của @local/uit-theme.
// Nội dung nằm ở content/slides-*.typ, cấu hình ở config/config.yaml, mã thật ở content/code/.
#import "/lib.typ": *
#import aqua: *

#let uit_logo = image("static/uit-small.png")

// Dữ liệu deck
#let properties = yaml("config/config.yaml")
#let metadata = properties.at("metadata")
#let university = metadata.at("university")
#let course = metadata.at("course")
#let author = metadata.at("author")
#let assignment = metadata.at("assignment")

// Màu: xanh UIT của IE203, giữ nguyên để hai deck cùng một nhận diện.
#let primary = rgb("#003F88")

#show: aqua-theme.with(
  aspect-ratio: "16-9-ppt",
  config-info(
    title: assignment.title,
    subtitle: assignment.subtitle,
    author: author.name + " | " + author.id,
    date: assignment.date,
    institution: university.college + " | " + course.id + " " + course.name,
  ),
  config-colors(
    primary: primary,
    primary-light: rgb("#2159A5"),
    primary-lightest: rgb("#F2F4F8"),
    neutral-lightest: rgb("#FFFFFF"),
  ),
)

// Thẻ mang màu deck, chỗ gọi không nhắc lại accent.
#let card = card.with(
  accent: primary,
  stroke: (left: 3pt + primary, rest: 0.5pt + primary),
)

#set text(font: body-font, size: 20pt)

// Khối mã: nền xám nhạt, đánh số dòng, không bao giờ tràn sang slide sau.
#show raw.where(block: true): it => align(start)[
  #block(
    radius: 6pt,
    fill: luma(245),
    inset: 0pt,
    stroke: none,
    breakable: false,
    width: 100%,
    clip: true,
  )[
    #text(font: code-font, size: 1em)[
      #grid(
        columns: (auto, 1fr),
        inset: (x, y) => if x == 0 { (top: 0.7em, bottom: 0.7em, left: 1em, right: 0.5em) } else {
          (top: 0.7em, bottom: 0.7em, left: 0.5em, right: 1em)
        },
        stroke: (x, y) => if x == 0 { (right: 0.5pt + luma(200)) } else { none },
        align: (right, left),
        text(fill: gray)[#for i in range(1, it.text.split("\n").len() + 1) [ #i \ ]],
        it,
      )
    ]
  ]
]

// Mã inline: cùng font mono, hơi nhỏ hơn chữ thường.
#show raw.where(block: false): it => text(font: code-font, size: 0.85em, it)

#set list(
  marker: move(dy: -0.1em, box(circle(radius: 0.2em, stroke: 0.2pt + rgb("#b51d69")))),
  indent: 0.5em,
)

#show heading.where(level: 3): it => [
  #set align(left)
  #set text(font: heading-font, size: 18pt, weight: "regular")
  #block(stroke: (bottom: 0.5pt + rgb("#808080")), inset: (bottom: 0.5em), below: 0.8em)[
    #smallcaps[#it.body]
  ]
]

// Bìa
#title-slide(
  title: [GOOGLE SKILLS SCRAPER],
  logo: uit_logo,
  logo-pos: top + center,
)

// Mục lục sinh từ heading, không gõ tay.
#card-outline()

#include "content/slides-a-boi-canh.typ"
#include "content/slides-b-ung-dung.typ"
#include "content/slides-c-ma-nguon.typ"
#include "content/slides-d-demo-mo-rong.typ"

== Cảm Ơn
<cam-on>

#slide(self => [
  #align(center + horizon)[
    #v(1fr)
    #text(size: 3em, weight: "bold", fill: self.colors.primary)[#upper[Xin Cảm Ơn!]]
    #v(0.5em)
    #text(size: 0.8em, fill: gray)[#metadata.repo.url #h(1em) nhánh #raw(metadata.repo.branch)]
    #v(1fr)
    #h(1fr)
    #text(fill: gray, style: "italic")[Built with Typst and #sym.suit.heart.stroked]
  ]
])
