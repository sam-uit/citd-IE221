def cmd_reindex(args):
    """Rebuild data/index.json from the entity files"""
    counts = Index().rebuild()
    for kind, count in counts.items():
        print(f"{kind:>8}: {count}")
