-- pandoc/add-import.lua
-- Add import statement to the beginning of the document
function Pandoc(doc)
  local import_stmt = pandoc.RawBlock('typst', '#import "/lib.typ": *')
  table.insert(doc.blocks, 1, import_stmt)
  return doc
end
