def launch_browser(profile_folder=WEBDRIVER_PROFILE_FOLDER_NAME,
                   headless: bool = WEBDRIVER_OPTIONS_HEADLESS,
                   browser: str = WEBDRIVER_BROWSER):
    """
    Launch a Selenium WebDriver (Chrome or Edge) on a persistent profile.

    The profile folder keeps the signed-in session between runs, so the
    sign-in prompt shows up once, not every time. Pass profile_folder=None
    for a throwaway profile. Defaults come from config.yaml.
    """
    try:
        options_class, service_class, driver_class = BROWSERS[browser.lower()]
    except KeyError:
        raise ValueError(f"Unsupported browser: {browser} (chrome or edge)")

    options = options_class()
    for argument in BROWSER_ARGUMENTS:
        options.add_argument(argument)
    options.add_experimental_option("excludeSwitches", ["enable-logging", "enable-automation"])

    # The "new" headless mode is the one that behaves like a real window.
    if headless:
        options.add_argument("--headless=new")

    if profile_folder:
        options.add_argument(f"user-data-dir={os.path.abspath(profile_folder)}")

    return driver_class(service=service_class(), options=options)
