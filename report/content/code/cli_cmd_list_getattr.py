def cmd_list(args):
    """Handle list command"""
    
    # Determine type
    if args.courses:
        target_class = Courses
        label = "courses"
    elif args.labs:
        target_class = Labs
        label = "labs"
    else:
        # Default to paths or if args.paths is set
        target_class = Paths
        label = "paths"

    # Reload if requested
    if args.reload:
        print(f"Reloading {label} list from remote...")
        collection = target_class(driver=launch_browser(headless=args.headless))
        collection.load_json()
        
        # Ensure URL is up to date (specifically for Paths)
        if label == "paths":
            from skills_scraper.config import BASE_URL_PATHS
            collection.url = BASE_URL_PATHS
            
        # Fetch list (Supports Path and Courses as they have fetch implemented)
        # Labs fetch might need implementation check, but we assume pattern holds or fails gracefully.
        try:
             # Dynamically call fetch method if exists or standard naming
             # Paths.fetch_paths, Courses.fetch_courses
             # We can use getattr
             method_name = f"fetch_{label}"
             fetch_method = getattr(collection, method_name, None)
             if fetch_method:
                 if fetch_method(force=True): # reload implies force
                     print(f"{label.capitalize()} list updated.")
                 else:
                     print(f"Failed to update {label} list.")
             else:
                 print(f"Reload not supported for {label}.")
        except Exception as e:
            print(f"Error reloading {label}: {e}")
        finally:
            collection.driver.quit()

    print(f"Listing all {label}...")
    
    # Instantiate and load (reload might have updated DB)
    collection = target_class()
    collection.load_json()
    
    # Check if empty (only for Paths/Courses mostly)
    if not collection.collection:
        print(f"No {label} found locally.")
        if label == 'paths' and not args.reload:
             print("Use 'list -r -p' to fetch paths list.")
        elif label == 'courses' and not args.reload:
             print("Use 'list -r -c' to fetch courses list.")
        else:
             return

    # Determine sort
    sort_by = 'id' if args.id else 'name'
    
    collection.print_list(sort_by=sort_by)
