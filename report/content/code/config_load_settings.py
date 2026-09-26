def load_settings() -> dict:
    """
    Merge the three layers. Relative paths in config.yaml resolve against the
    folder holding that file, so `vault: ../skills-vault` means the same thing
    no matter where the command is run from.
    """
    settings = {section: dict(values) for section, values in DEFAULTS.items()}
    base_dir = Path.cwd()

    config_file = find_config_file()
    if config_file:
        base_dir = config_file.parent
        with open(config_file, encoding="utf-8") as yamlfile:
            user = yaml.safe_load(yamlfile) or {}
        for section, values in user.items():
            if section in settings and isinstance(values, dict):
                settings[section].update(values)

    for (section, key), env_name in ENV_KEYS.items():
        if env_name in os.environ:
            settings[section][key] = os.environ[env_name]

    for key, value in settings["paths"].items():
        settings["paths"][key] = (base_dir / str(value)).resolve()

    headless = settings["browser"]["headless"]
    if isinstance(headless, str):
        settings["browser"]["headless"] = headless.strip().lower() in ("1", "true", "yes", "on")

    return settings
