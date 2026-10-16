    def generate_front_matter(self) -> str:
        """
        Generate the YAML front matter for the Markdown file.

        The keys are a superset of Open Knowledge Format v0.2 (type, title,
        description, resource, tags, sources, generated) plus this tool's own
        keys (id, portal) and the legacy names existing vaults query on
        (url, date_published, topics, scraped_date). Scalars go through
        json.dumps, which is valid YAML and never breaks on a quote.
        """
        from datetime import datetime
        from skills_scraper import __version__

        scraped_ts = getattr(self, 'scrapedTime', None)
        scraped_at = datetime.fromtimestamp(scraped_ts / 1000.0) if scraped_ts else datetime.now()
        scraped_at = scraped_at.astimezone()
        date_published = getattr(self, 'datePublished', None) or None
        topics = getattr(self, 'topics', None) or []
        description = self.description or ""

        lines = ["---"]
        lines.append(f"id: {yaml_scalar(self.id)}")
        lines.append(f"title: {yaml_scalar(self.name)}")
        lines.append(f"type: {self.type}")
        lines.append("portal: public")
        if description:
            lines.append(f"description: {yaml_scalar(first_sentence(description))}")
        lines.append(f"resource: {self.url}")
        if topics:
            lines.append(f"tags: {yaml_list(topics)}")
        lines.append("sources:")
        lines.append(f"  - resource: {self.url}")
        lines.append(f"    title: {yaml_scalar(f'Google Skills {self.type.lower()} {self.id}')}")
        lines.append("    author: Google Cloud")
        if date_published:
            lines.append(f"    last_modified: {date_published}")
        lines.append("generated:")
        lines.append(f"  by: skills-scraper/{__version__}")
        lines.append(f"  at: {scraped_at.isoformat(timespec='seconds')}")
        # Legacy names, kept so existing vault queries keep working.
        lines.append(f"url: {self.url}")
        if date_published:
            lines.append(f"date_published: {date_published}")
        if hasattr(self, 'topics'):
            lines.append(f"topics: {yaml_list(topics)}")
        lines.append(f"scraped_date: {scraped_at.strftime('%Y-%m-%d')}")
        lines.append("---")
        return "\n".join(lines)
