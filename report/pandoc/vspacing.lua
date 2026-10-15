-- pandoc/spacing.lua

function Pandoc(doc)
  local new_blocks = {}
  
  for i, el in ipairs(doc.blocks) do
    
    -- 1. Before Header: Add blank line (unless it's the very first block)
    if el.t == "Header" and i > 1 then
      table.insert(new_blocks, pandoc.RawBlock('typst', '\n')) 
    end

    -- 2. Insert the actual element (Header, Para, etc.)
    table.insert(new_blocks, el)

    -- 3. After Header: Add blank line
    if el.t == "Header" then
      table.insert(new_blocks, pandoc.RawBlock('typst', '\n'))
    end
  end

  return pandoc.Pandoc(new_blocks, doc.meta)
end
