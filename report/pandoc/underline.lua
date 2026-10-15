-- pandoc/underline.lua
function RawInline(el)
  -- Detect raw HTML tags
  if el.format == 'html' then
    if el.text == '<u>' then
      -- Replace <u> with Typst's #underline[
      return pandoc.RawInline('typst', '#underline[')
    elseif el.text == '</u>' then
      -- Replace </u> with the closing bracket ]
      return pandoc.RawInline('typst', ']')
    end
  end
end
