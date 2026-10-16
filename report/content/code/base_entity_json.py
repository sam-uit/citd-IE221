    def load_json(self):
        """
        Load the entity data from data/<kind>/<id>.json, the source of truth.
        Nothing happens when the file does not exist yet.
        """
        data = read_json(self._json_path)
        if data:
            self.__dict__.update(data)

    def save_json(self):
        """
        Write the entity to its JSON file (atomically) and update the index.
        """
        entity_data = self.to_dict()
        try:
            write_json(self._json_path, entity_data)
        except OSError as e:
            print(f"(BaseEntity.save_json) Error writing JSON to file: {self._json_path}")
            print(e)
            return

        index = Index()
        index.upsert(self._kind, entity_data)
        index.save()
