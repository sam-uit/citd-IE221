#!/usr/bin/env python3
# Extract real code from the scraper repo into content/code/, by symbol, with ast.
# The slides then read those files, so a slide can never show code that does not exist.
#
#   python3 tools/snippets.py --repo ~/repos/gcpcta/skills-google-scrapper
import argparse
import ast
from pathlib import Path

# (output name, source file, dotted symbol or None for the whole file)
SNIPPETS = [
    ("base_entity_type_url", "src/skills_scraper/model/base_entity.py", "BaseEntity.type+url"),
    ("base_entity_init", "src/skills_scraper/model/base_entity.py", "BaseEntity.__init__"),
    ("base_entity_to_dict", "src/skills_scraper/model/base_entity.py", "BaseEntity.to_dict"),
    ("base_entity_save_markdown", "src/skills_scraper/model/base_entity.py", "BaseEntity.save_markdown"),
    ("base_entity_generate_markdown", "src/skills_scraper/model/base_entity.py", "BaseEntity.generate_markdown"),
    ("lab_class", "src/skills_scraper/model/lab.py", "Lab"),
    ("course_init", "src/skills_scraper/model/course.py", "Course.__init__"),
    ("course_process_step", "src/skills_scraper/model/course.py", "Course.process_step"),
    ("course_process_lab", "src/skills_scraper/model/course.py", "Course.process_lab"),
    ("course_extract_metadata", "src/skills_scraper/model/course.py", "Course.extract_course_metadata"),
    ("course_parse_lesson_item", "src/skills_scraper/model/course.py", "Course._parse_lesson_item"),
    ("collection_fetch_catalog", "src/skills_scraper/model/collection.py", "Collection.fetch_catalog"),
    ("paths_class", "src/skills_scraper/model/paths.py", "Paths"),
    ("path_consolidate", "src/skills_scraper/model/path.py", "Path.consolidate_activities"),
    ("store_write_text", "src/skills_scraper/services/store.py", "write_text"),
    ("config_load_settings", "src/skills_scraper/config.py", "load_settings"),
    ("browser_ensure_authenticated", "src/skills_scraper/services/browser.py", "ensure_authenticated"),
    ("cli_cmd_list_getattr", "src/skills_scraper/cli.py", "cmd_list"),
    ("pyproject", "pyproject.toml", None),
]


def span(tree: ast.Module, dotted: str):
    """(first line, last line) of a class, function or method, decorators included."""
    node = tree
    for name in dotted.split("."):
        node = next(child for child in ast.iter_child_nodes(node)
                    if isinstance(child, (ast.ClassDef, ast.FunctionDef, ast.AsyncFunctionDef))
                    and child.name == name)
    first = min([node.lineno] + [d.lineno for d in node.decorator_list])
    return first, node.end_lineno


def extract(source: str, symbols: str) -> str:
    """One symbol, or several joined with + (kept in order, one blank line between)."""
    tree = ast.parse(source)
    lines = source.split("\n")
    parts = []
    for dotted in symbols.split("+"):
        # "BaseEntity.type+url": the second name shares the first's class
        if "." not in dotted and parts:
            dotted = symbols.split("+")[0].rsplit(".", 1)[0] + "." + dotted
        first, last = span(tree, dotted)
        parts.append("\n".join(lines[first - 1:last]))
    return "\n\n".join(parts).rstrip() + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True, help="path to skills-google-scrapper")
    parser.add_argument("--out", default=Path(__file__).parent.parent / "content" / "code")
    args = parser.parse_args()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    for name, rel, symbols in SNIPPETS:
        source = (Path(args.repo) / rel).read_text(encoding="utf-8")
        text = source if symbols is None else extract(source, symbols)
        suffix = Path(rel).suffix
        (out / f"{name}{suffix}").write_text(text, encoding="utf-8")
        print(f"{name}{suffix}: {text.count(chr(10))} lines from {rel}")


if __name__ == "__main__":
    main()
