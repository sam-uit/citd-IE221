def write_text(path, text: str) -> None:
    """
    Write UTF-8 text atomically: tmp file in the same folder, fsync, then
    os.replace(). A Ctrl+C can never leave half a file behind.
    """
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=path.parent, prefix=".tmp-")
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as textfile:
            textfile.write(text)
            textfile.flush()
            os.fsync(textfile.fileno())
        os.replace(tmp, path)
    except BaseException:
        try:
            os.remove(tmp)
        except OSError:
            pass
        raise
