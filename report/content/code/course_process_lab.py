    def process_lab(self, activity, url) -> None:
        """
        Process a lab activity.
        """

        print(f"(process_lab) •-> Lab: {activity['id']:>6} - {activity['title']}")
        
        # Force use of Template URL to ensure consistent HTML structure (and access to outline)
        # Session URL might be different or require enrollment context which changes structure.
        # Template URL (Catalog view) usually exposes the outline.
        # Format: /course_templates/<course_id>/labs/<lab_id>
        # We need to construct absolute URL.
        template_url = f"{BASE_URL}/course_templates/{self.id}/labs/{activity['id']}"
        # print(f"(process_lab) Using template URL: {template_url}")

        try:
            lab_page_html = get_page(self.driver, template_url, f"lab {activity['id']}")
            if lab_page_html is None:
                return

            lab_review_lab_id_element = lab_page_html.select_one(LAB_REVIEW_LAB_ID)
            lab_content_outline_element = lab_page_html.select_one(LAB_CONTENT_OUTLINE)

            if lab_review_lab_id_element:
                lab_id = lab_review_lab_id_element["value"].strip()
            else:
                # Fallback to activity ID if element not found
                # print(f"(process_lab) [Warning] lab_review_lab_id not found. Using activity ID {activity['id']}")
                lab_id = activity['id']

            # Create a Lab instance for the lab_id
            lab = Lab(
                id=lab_id
            )
            # Load the lab data from JSON even it's empty
            lab.load_json()

            # If the lab.name does exist, that means the lab has been extracted already.
            if lab.name:
                print(f"(process_lab) •-• [+] Existed: {lab.id} - {lab.name}")
                return False

            # If the lab.name doesn't exist, the lab is new, continue.
            lab_steps = {}
            if lab_content_outline_element:
                for a_tag in lab_content_outline_element.find_all('a'):
                    step = a_tag['href'].strip('#step')
                    text = a_tag.text
                    lab_steps[step] = text

            # Set the lab's attributes.
            lab.name = activity['title'].strip()
            lab.description = self.clean_text(activity.get('description', ''))
            lab.steps = lab_steps

            # Save the lab to files.
            lab.save_json()
            lab.save_markdown()

            # Add the lab to the Labs Collection
            labs_collection = Labs(name='Labs Collection')
            labs_collection.load_json()
            labs_collection.collection[lab_id] = lab.name
            labs_collection.save_json()

            print(f"(process_lab) •-• [+]")
        except Exception as error:
            print(f"(process_lab) Error: {error}")
