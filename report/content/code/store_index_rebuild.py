    def upsert(self, kind: str, doc: dict) -> None:
        """
        Merge the index fields of doc into the table, keeping older values
        for fields the doc does not carry (a bare catalog entry has no dates).
        """
        entity_id = str(doc.get("id", "")).strip()
        if not entity_id:
            return
        entry = self.tables.setdefault(kind, {}).setdefault(entity_id, {})
        for field in INDEX_FIELDS:
            if doc.get(field) not in (None, ""):
                entry[field] = doc[field]

    def rebuild(self) -> dict:
        """
        Rebuild every table from data/<kind>/*.json. Returns counts per kind.
        """
        self.tables = {kind: {} for kind in KINDS}
        for kind in KINDS:
            for entity_file in sorted((self.data_dir / kind).glob("*.json")):
                if entity_file.name.endswith("-prompt.json"):
                    continue
                doc = read_json(entity_file)
                if isinstance(doc, dict):
                    doc.setdefault("id", entity_file.stem)
                    self.upsert(kind, doc)
        self.save()
        return {kind: len(table) for kind, table in self.tables.items()}
