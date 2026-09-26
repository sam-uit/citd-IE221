    def generate_markdown(self, **kwargs) -> str:
        """
        Generate the Markdown representation of the entity.
        """

        # Convert the Path object to a dictionary
        markdown = []
        markdown.append(self.generate_front_matter())

        return "\n\n".join(markdown) + "\n"
