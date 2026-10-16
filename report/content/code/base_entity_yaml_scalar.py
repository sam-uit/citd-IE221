def yaml_scalar(value) -> str:
    """A string as a valid, fully escaped YAML scalar (JSON strings are YAML)."""
    return json.dumps(str(value) if value is not None else "", ensure_ascii=False)

def yaml_list(values) -> str:
    """A flow-style YAML list of strings, [] when empty."""
    return "[" + ", ".join(yaml_scalar(v) for v in values) + "]"
