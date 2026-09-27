// content/diagrams.typ: hai sơ đồ của deck, vẽ bằng Typst thuần từ dữ liệu.
//
// Vì sao không dùng typst-diagrams: package đó cố ý loại sơ đồ lớp khỏi phạm vi, và
// hai sơ đồ này chỉ cần hộp với đường nối. Ba mươi dòng mã riêng, dữ liệu tách khỏi
// cách vẽ: đổi tên một lớp là sửa một chuỗi, không vẽ lại.
//
//   nodes: id -> (x, y, label, sub)   toạ độ TÂM hộp, tính bằng cm
//   edges: (from, to)                 đường thẳng giữa hai tâm, hộp vẽ đè lên sau

#let node-w = 3.7cm
#let node-h = 1.45cm

#let diagram(
  width,
  height,
  nodes,
  edges,
  accent: rgb("#003F88"),
  size: 12pt,
  node-w: node-w,
  node-h: node-h,
  highlight: (),
) = block(width: width, height: height, {
  for (a, b) in edges {
    let na = nodes.at(a)
    let nb = nodes.at(b)
    place(line(start: (na.at(0), na.at(1)), end: (nb.at(0), nb.at(1)), stroke: 1pt + accent.lighten(30%)))
  }
  for (id, n) in nodes {
    let lit = id in highlight
    place(
      dx: n.at(0) - node-w / 2,
      dy: n.at(1) - node-h / 2,
      box(
        width: node-w,
        height: node-h,
        radius: 4pt,
        fill: if lit { accent } else { accent.lighten(92%) },
        stroke: 0.8pt + accent,
        align(center + horizon, {
          set text(size: size, fill: if lit { white } else { accent })
          text(weight: "bold")[#n.at(2)]
          if n.len() > 3 and n.at(3) != none [
            #linebreak()
            #text(size: size * 0.75, weight: "regular", font: "Google Sans Code")[#n.at(3)]
          ]
        }),
      ),
    )
  }
})

// MARK: sơ đồ lớp của model/

#let class-nodes = (
  serialize: (14cm, 0.85cm, "Serialize", "to_dict, to_json"),
  base: (7cm, 3.2cm, "BaseEntity", "id, name, description"),
  collection: (21cm, 3.2cm, "Collection", "name, url, {id: name}"),
  path: (3cm, 5.55cm, "Path", "courses"),
  course: (7cm, 5.55cm, "Course", "modules, topics"),
  lab: (11cm, 5.55cm, "Lab", "steps"),
  paths: (15.5cm, 5.55cm, "Paths", "API_URL, 50 pages"),
  courses: (19.5cm, 5.55cm, "Courses", "API_URL"),
  labs: (23.5cm, 5.55cm, "Labs", "API_URL"),
  topics: (27.5cm, 5.55cm, "Topics", "extract_topics"),
)

#let class-edges = (
  ("serialize", "base"),
  ("serialize", "collection"),
  ("base", "path"),
  ("base", "course"),
  ("base", "lab"),
  ("collection", "paths"),
  ("collection", "courses"),
  ("collection", "labs"),
  ("collection", "topics"),
)

#let class-diagram(highlight: ()) = diagram(29.5cm, 6.4cm, class-nodes, class-edges, highlight: highlight)

// MARK: kiến trúc ứng dụng

#let arch-nodes = (
  cli: (6cm, 0.85cm, "cli.py", "argparse, exit codes"),
  tui: (12cm, 0.85cm, "tui.py", "menu tuong tac"),
  model: (10cm, 3.5cm, "model/", "Path Course Lab + Collections"),
  browser: (3.5cm, 6.1cm, "services/browser.py", "Selenium, sign-in"),
  store: (14.5cm, 6.1cm, "services/store.py", "JSON + index, atomic"),
  site: (3.5cm, 8.7cm, "skills.google", "Chrome, profile"),
  data: (11cm, 8.7cm, "data/*.json", "source of truth"),
  vault: (18cm, 8.7cm, "csbmdvault/*.md", "Obsidian"),
  config: (23cm, 3.5cm, "config.py", "defaults < yaml < env"),
)

#let arch-edges = (
  ("cli", "model"),
  ("tui", "model"),
  ("model", "browser"),
  ("model", "store"),
  ("browser", "site"),
  ("store", "data"),
  ("store", "vault"),
  ("config", "model"),
)

#let arch-diagram(highlight: ()) = diagram(
  35cm,
  12cm,
  arch-nodes,
  arch-edges,
  node-w: 5cm,
  node-h: 1.45cm,
  highlight: highlight,
)
