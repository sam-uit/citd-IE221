    def save_markdown(self, **kwargs) -> None:
        """
        Save the Path data to a Markdown file.
        passes kwargs to generate_markdown
        """

        write_text(self._md_path, self.generate_markdown(**kwargs))
