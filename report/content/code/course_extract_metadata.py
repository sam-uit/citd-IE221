    def extract_course_metadata(self, course_html, force=False) -> bool:
        """
        Extract course metadata such as description, objectives, and topics.
        """

        try:
            course_ld_json_element = course_html.select_one(COURSE_LD_JSON)
            meta_element = course_html.select_one(COURSE_META_DESCRIPTION)

            if not course_ld_json_element or not meta_element:
                raise NoSuchElementException("(extract_course_metadata) meta_element not found.")

            course_ld_json_text = course_ld_json_element.string
            course_description = self.clean_text(meta_element['content'])
            course_description = re.sub(r'\s{2,}', '\n\n', course_description)
            course_description = course_description.strip()

            course_objectives_json = json.loads(course_ld_json_text)
            datePublished = course_objectives_json.get('datePublished')

            # If the course has the same datePublished, return False and not continue.
            if not force and datePublished == self.datePublished:
                print(f"(extract_course_metadata) Course {self.id} already extracted. datePublished: {datePublished}\n")
                return False

            self.id = course_objectives_json.get('@id').split('/')[-1]
            self.name = course_objectives_json.get('name').strip()
            self.description = course_description
            self.datePublished = course_objectives_json.get('datePublished')
            self.topics = course_objectives_json.get('about')
            self.objectives = course_objectives_json.get('teaches')

            return True
        except Exception as error:
            print(f"(extract_course_metadata) Error: {error}")
            return False
