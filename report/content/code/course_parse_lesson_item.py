    def _parse_lesson_item(self, item: dict) -> str:
        """
        Parse a single item from the lesson data into Markdown/HTML.
        """
        # Based on observed structure, items have 'heading', 'paragraph', 'list', etc.
        # This is a best-effort parser.

        # Check for nested items (some structures might be recursive or wrapped)
        if 'items' in item:
             sub_content = []
             for sub in item['items']:
                 parsed = self._parse_lesson_item(sub)
                 if parsed:
                     sub_content.append(parsed)
             return "\n\n".join(sub_content)

        if 'heading' in item:
            # Clean heading: remove HTML tags if any, add markdown headers
            heading_text = self._html_to_markdown(item['heading'])
            # If the cleaned text doesn't look like a header, force it to be one (h4)
            if not heading_text.startswith('#'):
                return f"#### {heading_text}"
            return heading_text

        if 'paragraph' in item:
            return self._html_to_markdown(item['paragraph'])

        if 'list' in item:
            return self._html_to_markdown(item['list'])

        if 'image' in item:
             src = item['image'].get('src')
             alt = item['image'].get('alt', 'Image')
             if src:
                 return f"![{alt}]({src})"

        return None
