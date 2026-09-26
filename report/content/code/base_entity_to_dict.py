    def to_dict(self):
        """
        Convert the entity's data to a dictionary.
        """
        import time

        # Convert the entity data to a dictionary, excluding private attributes
        # and adding the type and URL
        # Also exclude 'driver' as it is not serializable
        the_dict = {k: v for k, v in self.__dict__.items() if not k.startswith('_') and k != 'driver'}
        the_dict['type'] = self.type
        the_dict['url'] = self.url
        
        # Add scrapedTime (epoch in milliseconds)
        the_dict['scrapedTime'] = int(time.time() * 1000)
        
        return the_dict
