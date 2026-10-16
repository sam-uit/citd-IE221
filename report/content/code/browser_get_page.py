def open_page(driver, url: str, what: str = "") -> bool:
    """
    Navigate the browser to url, dealing with the sign-in redirect.
    Returns False when there is no browser or the user aborted the sign-in.
    """
    if not driver:
        print(f"(open_page) A signed-in browser is required{' for ' + what if what else ''}.")
        return False
    driver.get(url)
    return ensure_authenticated(driver, url, what)

def get_page(driver, url: str, what: str = "") -> BeautifulSoup | None:
    """
    open_page(), then hand back the rendered page as BeautifulSoup.
    """
    if not open_page(driver, url, what):
        return None
    return BeautifulSoup(driver.page_source, "html.parser")
