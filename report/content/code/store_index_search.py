    def search(self, kind: str, query: str, field: str = None) -> list:
        """
        Case-insensitive substring search. name/id are answered from the
        index; any other field (or no field: the whole document) opens the
        entity file. Returns the matching documents.
        """
        needle = query.lower()
        results = []
        for entity_id, entry in self.all(kind).items():
            summary = {"id": entity_id, **entry}
            if field in ("name", "id"):
                if needle in str(summary.get(field, "")).lower():
                    results.append(summary)
                continue
            if field is None and (needle in entity_id.lower() or needle in str(entry.get("name", "")).lower()):
                results.append(summary)
                continue
            doc = read_json(self.entity_file(kind, entity_id))
            if not doc:
                continue
            haystack = doc.get(field) if field else doc
            if haystack is None:
                continue
            if isinstance(haystack, list):
                hit = any(needle in str(item).lower() for item in haystack)
            else:
                hit = needle in str(haystack).lower()
            if hit:
                results.append(summary)
        return results
