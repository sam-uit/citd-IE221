def main():
    parser = argparse.ArgumentParser(description="CloudSkillsBoost Scraper CLI")
    subparsers = parser.add_subparsers(dest='command', help='Command to execute')

    # List command
    parser_l = subparsers.add_parser('list', aliases=['l'], help='List all paths, courses, or labs')

    # Mutually exclusive group for type
    group_type = parser_l.add_mutually_exclusive_group()
    group_type.add_argument('--paths', '-p', action='store_true', help='List all paths (default)')
    group_type.add_argument('--courses', '-c', action='store_true', help='List all courses')
    group_type.add_argument('--labs', '-l', action='store_true', help='List all labs')

    # Reload flag
    parser_l.add_argument('--reload', '-r', action='store_true', help='Reload list from remote before listing')
    parser_l.add_argument('--headless', action='store_true', help='Run the browser without a window (profile must be signed in)')

    # Mutually exclusive group for sorting
    group_sort = parser_l.add_mutually_exclusive_group()
    group_sort.add_argument('--name', '-n', action='store_true', help='Sort by name (default)')
    group_sort.add_argument('--id', '-i', action='store_true', help='Sort by ID')

    parser_l.set_defaults(func=cmd_list)

    # Fetch command (Scrape)
    parser_f = subparsers.add_parser('fetch', aliases=['f'], help='Fetch (scrape) courses/paths/labs content')
    parser_f.add_argument('--paths', '-p', nargs='+', metavar='ID', help='Fetch specific path IDs')
    parser_f.add_argument('--courses', '-c', nargs='+', metavar='ID', help='Fetch specific course IDs')
    parser_f.add_argument('--labs', '-l', nargs='+', metavar='ID', help='Fetch specific lab IDs')

    # Flags from old course/path commands
    parser_f.add_argument('--force', '-f', action='store_true', help='Force re-extraction even if data exists')
    parser_f.add_argument('--no-md', action='store_true', help='Do not generate markdown file')
    parser_f.add_argument('--toc', '-t', action='store_true', help='Table of content only (structure only)')
    parser_f.add_argument('--no-transcript', action='store_true', help='Skip video transcripts (courses only)')
    parser_f.add_argument('--cascade', action='store_true', help='After a path, fetch every course in it')
    parser_f.add_argument('--headless', action='store_true', help='Run the browser without a window (profile must be signed in)')

    parser_f.set_defaults(func=cmd_fetch)

    # Browser command
    parser_b = subparsers.add_parser('browser', aliases=['b', 'w'], help='Launch browser for manual login')
    parser_b.add_argument('--profile-folder', help='Specific webdriver profile folder', default=None)
    parser_b.set_defaults(func=cmd_browser)

    # MD command
    parser_m = subparsers.add_parser('md', help='Generate markdown output')
    parser_m.add_argument('--course', '-c', help='List of course IDs (comma-separated)', default=None)
    parser_m.add_argument('--lab', '-l', help='List of lab IDs (comma-separated)', default=None)
    parser_m.add_argument('--path', '-p', help='List of path IDs (comma-separated)', default=None)
    parser_m.add_argument('--toc', '-t', action='store_true', help='Table of content only (structure only)')
    parser_m.add_argument('--no-transcript', action='store_true', help='Skip video transcripts (courses only)')
    parser_m.set_defaults(func=cmd_md)

    # Search command
    parser_s = subparsers.add_parser('search', aliases=['s'], help='Search the downloaded data')
    parser_s.add_argument('query', help='Search query')
    parser_s.add_argument('--course', '-c', action='store_true', help='Search in courses')
    parser_s.add_argument('--path', '-p', action='store_true', help='Search in paths')
    parser_s.add_argument('--lab', '-l', action='store_true', help='Search in labs')
    parser_s.add_argument('--field', '-f', help='Limit search to specific field', default=None)
    parser_s.set_defaults(func=cmd_search)

    # Reindex command
    parser_r = subparsers.add_parser('reindex', help='Rebuild the index from the JSON files')
    parser_r.set_defaults(func=cmd_reindex)

    # Parse arguments
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    # Execute the selected command
    args.func(args)
