    @property
    def driver(self):
        """The signed-in browser, launched on first use and reused after that."""
        if self._driver is None:
            print("\n\033[35mLaunching the browser...\033[0m\n")
            self._driver = launch_browser()
        return self._driver

    def close(self):
        """Quit the browser if one was launched."""
        if self._driver is not None:
            self._driver.quit()
            self._driver = None
