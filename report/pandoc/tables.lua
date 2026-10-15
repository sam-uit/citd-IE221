-- pandoc/tables.lua
-- A markdown table becomes a `datatable`, not a bare `#table`.
--
-- Why not a bare `#table`: every other table in this report comes from YAML through
-- `datatable-data`, which gives it the bold repeating header, the content-derived
-- column widths, the `bp-text` scope (so a cell can call `#impact(..)`), and the
-- figure/caption/label treatment. A markdown table emitted as a raw `#table` would
-- look like a visitor from another document — different header, different column
-- rhythm, no caption. Routing both paths through one component is also why this
-- filter computes almost nothing: widths and header styling are `datatable`'s job,
-- and it does them better than a Lua string builder can.
--
-- The filter's whole job is therefore: read Pandoc's table model, refuse the parts
-- `datatable` cannot represent, and hand over the rest.

-- Pandoc alignment -> the strings `dt-to-align` understands.
local ALIGN = {
  AlignLeft = "left",
  AlignRight = "right",
  AlignCenter = "center",
  AlignDefault = "left",
}

-- Render one cell's blocks as Typst source, to be pasted inside `[ .. ]`.
--
-- `pandoc.write` and not `pandoc.utils.stringify`: stringify flattens to plain text,
-- so bold, code spans and links would be silently dropped. (The old version called
-- stringify first and then overwrote the result — which never ran, because stringify
-- rejects a Cell outright: "table expected, got pandoc Cell". That single line made
-- *every* markdown table abort the pandoc run. It went unnoticed for as long as it
-- did because the two tables in chapter01 are commented out and hand-written as
-- `{=typst}` instead, and `just` only re-runs pandoc when the .md is newer than the
-- .typ — so the stale .typ kept the build green.)
local function cell_typst(cell)
  if #cell.contents == 0 then return "" end
  local s = pandoc.write(pandoc.Pandoc(cell.contents), "typst")
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function rows_of(row_list, out)
  for _, row in ipairs(row_list) do
    local cells = {}
    for _, cell in ipairs(row.cells) do
      -- `datatable` lays cells out positionally, one per column. A merged cell has
      -- no place in that model, and the failure mode is the bad one: every cell
      -- after it shifts left and the table still renders, wrong but plausible.
      -- Stop the build instead, and say where to go.
      if cell.col_span > 1 or cell.row_span > 1 then
        error(string.format(
          "tables.lua: ô %q gộp %d cột × %d dòng, `datatable` không biểu diễn được.\n"
          .. "  Nếu không cố ý gộp: grid table vẽ lệch một dấu `+` là pandoc suy ra "
          .. "ngay một ô gộp — xem lại hàng `+---+---+` có khớp các hàng khác không.\n"
          .. "  Nếu cố ý: viết bảng đó trong một khối {=typst} bằng `#table` kèm "
          .. "`table.cell(colspan: ..)`, hoặc đưa nó ra YAML.",
          pandoc.utils.stringify(pandoc.Pandoc(cell.contents)),
          cell.col_span, cell.row_span))
      end
      table.insert(cells, "[" .. cell_typst(cell) .. "]")
    end
    table.insert(out, "    (" .. table.concat(cells, ", ") .. "),")
  end
end

function Table(el)
  -- spec[2] is a fraction of the *line* width, or nil when the source gave no hint.
  -- Pipe tables usually give none; grid tables do, because the author drew the
  -- columns. Honour a hint when there is one and stay quiet otherwise, so
  -- `dt-auto-columns` can size from the content.
  local aligns, total = {}, 0
  for _, spec in ipairs(el.colspecs) do
    table.insert(aligns, '"' .. (ALIGN[spec[1]] or "left") .. '"')
    if spec[2] then total = total + spec[2] end
  end

  -- Normalise, because Pandoc's fractions are of its own nominal line width and a
  -- grid table narrower than that sums to less than 1. Passing them through raw
  -- would leave the table short of the text block by however much the author
  -- happened not to draw — the ratios are the intent, the absolute values are not.
  local widths, has_width = {}, total > 0
  for _, spec in ipairs(el.colspecs) do
    if spec[2] and total > 0 then
      table.insert(widths, string.format('"%.2f%%"', spec[2] / total * 100))
    else
      table.insert(widths, '"auto"')
    end
  end

  -- Header: `datatable` takes exactly one header row. Markdown pipe tables cannot
  -- express more; a grid table can, and the extra rows are demoted to body rows
  -- rather than dropped.
  local headers, body = nil, {}
  local head_rows = el.head.rows
  if #head_rows > 0 then
    local first = {}
    rows_of({ head_rows[1] }, first)
    headers = first[1]:gsub("^%s*%((.*)%),?$", "%1")
    for i = 2, #head_rows do rows_of({ head_rows[i] }, body) end
  end

  for _, b in ipairs(el.bodies) do
    rows_of(b.head, body)
    rows_of(b.body, body)
  end
  for _, f in ipairs(el.foot.rows) do rows_of({ f }, body) end

  local parts = {}
  if headers then table.insert(parts, "  headers: (" .. headers .. "),") end
  table.insert(parts, "  rows: (\n" .. table.concat(body, "\n") .. "\n  ),")

  -- A markdown table's caption is `el.caption.long`, and it may be empty.
  local cap = ""
  if el.caption and el.caption.long and #el.caption.long > 0 then
    cap = (pandoc.write(pandoc.Pandoc(el.caption.long), "typst"):gsub("^%s*(.-)%s*$", "%1"))
  end
  if cap ~= "" then table.insert(parts, "  caption: [" .. cap .. "],") end

  -- `index: false`: the YAML tables opt into an STT column because their data has no
  -- numbering of its own. Someone writing a markdown table types the numbers they
  -- want, so adding a second column of them would be a surprise.
  local opts = "index: false, align: (" .. table.concat(aligns, ", ") .. ")"
  if has_width then opts = opts .. ", columns: (" .. table.concat(widths, ", ") .. ")" end
  table.insert(parts, "  options: (" .. opts .. "),")

  return pandoc.RawBlock("typst",
    "#datatable-data((\n" .. table.concat(parts, "\n") .. "\n))")
end
