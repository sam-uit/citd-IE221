def main():
    """Entry point for the interactive (TUI) mode."""

    # Create the OUTPUT FOLDERS if they do not exist
    if not OUTPUT_FOLDER_NAME.exists():
        OUTPUT_FOLDER_NAME.mkdir(parents=True, exist_ok=True)

    # Create the DATA FOLDERS if they do not exist
    if not DATA_FOLDER_NAME.exists():
        DATA_FOLDER_NAME.mkdir(parents=True, exist_ok=True)

    # STARTING THE PROGRAM
    # https://talyian.github.io/ansicolors/
    # https://en.wikipedia.org/wiki/ANSI_escape_code
    app_title = "CloudSkillsBoost Automation Script"

    print()
    print("\033[45m"
          f"{app_title:^87}"
          "\033[0m")
    print()

    # Create an instance of CloudSkillsBoost and start interactive mode
    cloud_skills_boost = CloudSkillsBoost()
    try:
        cloud_skills_boost.interactive_mode()
    finally:
        cloud_skills_boost.close()

    sys.exit(0)
