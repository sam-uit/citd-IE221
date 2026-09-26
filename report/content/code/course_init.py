    def __init__(self,
                 id: str,
                 name: str = None,
                 description: str = None,
                 datePublished: str = None,
                 objectives: list = None,
                 topics: list = None,
                 modules: list = None,
                 driver=None):
        super().__init__(id,
                         name,
                         description)
        self.datePublished = datePublished or ""
        self.objectives = objectives or []
        self.topics = topics or []
        self.modules = modules or []
        self.driver = driver
        self.external_course_data = {}
