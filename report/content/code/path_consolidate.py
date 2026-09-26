    def consolidate_activities(self, path_data: dict, path_html) -> dict:
        """
        Build the path's activity list from two sources.

        The ld+json ``hasPart`` labels every entry ``Course`` and points a
        standalone lab at an unrelated course_templates id, so its URLs cannot
        be trusted. The page's ``ql-contents-menu`` is authoritative for order
        and kind: a top-level ``/focuses/<id>`` href is a lab, anything else is
        a course. The ld+json only supplies the course id when the menu href is
        a session deep-link, and a cleaner name.
        """
        ld_by_name: dict[str, dict] = {}
        for part in path_data.get('hasPart', []):
            name = part["name"].strip()
            ld_by_name[name.lower()] = {"id": part['url'].split('/')[-1], "name": name}

        menu = self.menu_activities(path_html)
        activities: dict[str, dict] = {}

        if not menu:
            # No contents menu (unusual): labs cannot be told apart, courses still resolve.
            for part in path_data.get('hasPart', []):
                course_id = part['url'].split('/')[-1]
                activities[course_id] = {
                    "id": course_id,
                    "type": "Course",
                    "name": part["name"].strip(),
                    "url": part["url"].strip(),
                }
            return activities

        for activity in menu:
            title = (activity.get("title") or "").strip()
            href = activity.get("href") or ""
            ld_hit = ld_by_name.get(title.lower())
            name = ld_hit["name"] if ld_hit else title

            focus_match = re.match(r'^/focuses/(\d+)', href)
            if focus_match:
                lab_id = focus_match.group(1)
                activities[lab_id] = {
                    "id": lab_id,
                    "type": "lab",
                    "name": name,
                    "url": f"{BASE_URL}{href}",
                }
                continue

            template_match = re.search(r'/course_templates/(\d+)', href)
            if template_match:
                course_id = template_match.group(1)
            elif ld_hit:
                course_id = ld_hit["id"]
            else:
                print(f"(consolidate_activities) Skipping unresolvable activity: {title}")
                continue
            activities[course_id] = {
                "id": course_id,
                "type": "Course",
                "name": name,
                "url": f"{BASE_URL_COURSES}/{course_id}",
            }
        return activities
