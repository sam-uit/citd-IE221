def ensure_authenticated(driver, url: str, what: str = "") -> bool:
    """
    If the page redirected to sign-in, ask the user to sign in (in the visible
    browser window) and retry until the page loads or the user gives up.
    Returns True when the requested page is showing.
    """
    if not driver:
        return False

    while "sign_in" in driver.current_url:
        suffix = f" for {what}" if what else ""
        print(f"\n\033[93m[!] Authentication required{suffix}.\033[0m")
        print("Please sign in to the browser window if you haven't.")
        try:
            input("Press Enter after you have signed in and the page is loaded... ")
        except (KeyboardInterrupt, EOFError):
            print("\n\033[91mAborted authentication.\033[0m")
            return False
        driver.get(url)

        if "sign_in" in driver.current_url:
            print("\n\033[91m[!] Still on the sign-in page. Finish signing in before pressing Enter.\033[0m")
    return True
