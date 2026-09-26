    def fetch_catalog(self, force: bool = False) -> bool:
        """
        Gather every item of this collection from the paged catalog API,
        read through the signed-in browser (the JSON lands in a <pre> tag).
        Returns True on success.

        :param force: If True, fetch even if the collection is not empty.
        """
        label = self.type.lower()

        if not self.API_URL:
            print(f"({self.type}.fetch_catalog) No catalog API for {label}.")
            return False

        if not force and self.collection:
            print(f"({self.type}.fetch_catalog) Collection not empty. Skipping fetch.")
            return True

        print(f"Fetching {label} from API: {self.API_URL}")

        items_found = {}
        page = 1

        try:
            while True:
                print(f"Fetching page {page}...", end='\r')
                page_html = get_page(self.driver, f"{self.API_URL}&page={page}", f"{label} page {page}")
                if page_html is None:
                    break

                # The browser renders the JSON response inside <pre>.
                pre_element = page_html.select_one("pre")
                json_text = pre_element.get_text() if pre_element else page_html.get_text()

                try:
                    data = json.loads(json_text)
                except json.JSONDecodeError:
                    print(f"\nFailed to decode JSON on page {page}")
                    break

                items = data if isinstance(data, list) else data.get("searchResults", [])
                if not items:
                    break

                for item in items:
                    title = item.get("title")
                    item_path = item.get("path")
                    if title and item_path:
                        # /paths/16?locale=en -> 16 : drop the query, keep the last segment
                        item_id = item_path.split('?')[0].split('/')[-1]
                        if item_id:
                            items_found[item_id] = title.strip()

                page += 1
                if page > self.MAX_PAGES:
                    print(f"\nReached safety limit of {self.MAX_PAGES} pages.")
                    break

            print(f"\nTotal {label} found: {len(items_found)}")

            if items_found:
                self.collection = items_found
                self.save_json()
                return True

            print(f"({self.type}.fetch_catalog) No {label} found.")
            return False

        except Exception as error:
            print(f"({self.type}.fetch_catalog) Error occurred: {error}")
            return False
