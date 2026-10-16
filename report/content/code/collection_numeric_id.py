def numeric_id(item_id) -> tuple:
    """
    Sort key for ids: numbers by value, so 9 < 10 < 108; anything else after them, as text.
    """
    text = str(item_id)
    return (0, int(text)) if text.isdigit() else (1, text)
