    def process_step(self, step) -> None:
        """
        Process each step in a module.
        """

        # One handler per activity kind. The set of kinds belongs to the site, not to us:
        # a kind we have never seen (badge, credential, ...) is kept as-is and logged.
        handlers = {
            "video": self.process_video,
            "lab": self.process_lab,
            "quiz": self.process_quiz,
            "link": self.process_link,
            "html_bundle": self.process_link,
            "document": self.process_document,
        }

        for activity in step['activities']:
            # Fix HREF if it is a session URL
            if activity.get('href') and '/course_sessions/' in activity['href']:
                 activity['href'] = re.sub(r'/course_sessions/[^/]+', f'/course_templates/{self.id}', activity['href'])

            activity_type = activity['type']
            activity_full_url = f"{BASE_URL}{activity['href']}"

            handler = handlers.get(activity_type)
            if handler:
                handler(activity, activity_full_url)
            else:
                print(f"(process_step) •-> {activity_type}: {activity['id']:>6} - {activity['title']} (kept as-is, no handler)")
