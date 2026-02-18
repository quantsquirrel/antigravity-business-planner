import json
from pathlib import Path


def find_project_root():
    """Find the project root by traversing up from this script's location.

    Path: scripts/ -> skills/ -> .agent/ -> project root
    """
    script_path = Path(__file__).resolve()
    return script_path.parent.parent.parent.parent


def load_ideas(ideas_dir):
    """Scan output/ideas/*/idea.json and return list of idea dicts.

    Each dict includes the original idea.json data plus 'dir_path' pointing
    to the idea's directory.
    """
    ideas_dir = Path(ideas_dir)
    if not ideas_dir.exists():
        return []

    ideas = []
    for child in sorted(ideas_dir.iterdir()):
        if child.is_dir():
            idea_file = child / "idea.json"
            if idea_file.exists():
                try:
                    with open(idea_file, "r", encoding="utf-8") as f:
                        data = json.load(f)
                    data["dir_path"] = str(child)
                    ideas.append(data)
                except (json.JSONDecodeError, OSError):
                    continue
    return ideas


def _status_label(status):
    """Return Korean label for status."""
    mapping = {
        "go": "Go",
        "pivot": "Pivot",
        "pivot-optimize": "Pivot",
        "pivot-review": "Pivot",
        "drop": "Drop",
    }
    return mapping.get(status, status or "미평가")
