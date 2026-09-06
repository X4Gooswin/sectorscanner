#!/usr/bin/env python3
"""Create a deterministic Sector Overview-focused extract from an X4 debug log."""

from __future__ import annotations

import argparse
from pathlib import Path

CONTEXT_BEFORE = 5
CONTEXT_AFTER = 7
MAX_SELECTED_LINES = 5000

PROJECT_TERMS = (
    "sector overview",
    "sector_overview",
    "sectorscanner",
    "sector_scanner",
    "gooswin_sector_overview",
    "md.sector_scanner",
    "ui/sector_scanner",
    "ui\\sector_scanner",
    "extensions\\sectorscanner",
    "extensions/sectorscanner",
)

ERROR_MARKERS = (
    "[=error=]",
    "[=warning=]",
    "[=critical=]",
    "lua error",
    "stack traceback",
    "error in md cue",
    "property lookup failed",
    "exception",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Deterministic Sector Overview debug filter")
    parser.add_argument("--log", required=True)
    parser.add_argument("--output", required=True)
    return parser.parse_args()


def contains_any(text: str, terms: tuple[str, ...]) -> bool:
    lower = text.lower()
    return any(term in lower for term in terms)


def main() -> None:
    args = parse_args()
    log_path = Path(args.log)
    output_path = Path(args.output)

    lines = log_path.read_text(encoding="utf-8", errors="replace").splitlines()
    project_hits = {i for i, line in enumerate(lines) if contains_any(line, PROJECT_TERMS)}

    selected: set[int] = set()
    for index in project_hits:
        start = max(0, index - CONTEXT_BEFORE)
        end = min(len(lines), index + CONTEXT_AFTER + 1)
        selected.update(range(start, end))

    # Include error/warning lines only when they are close to an already identified
    # Sector Overview context. This keeps unrelated X4/mod noise out of the extract.
    if selected:
        expanded = set(selected)
        for index, line in enumerate(lines):
            if not contains_any(line, ERROR_MARKERS):
                continue
            if any(abs(index - hit) <= 10 for hit in project_hits):
                start = max(0, index - CONTEXT_BEFORE)
                end = min(len(lines), index + CONTEXT_AFTER + 1)
                expanded.update(range(start, end))
        selected = expanded

    ordered = sorted(selected)
    truncated = len(ordered) > MAX_SELECTED_LINES
    if truncated:
        ordered = ordered[:MAX_SELECTED_LINES]

    out: list[str] = [
        "# Sector Overview Debug Filter",
        "",
        f"Source: {log_path}",
        f"Total log lines scanned: {len(lines)}",
        f"Direct Sector Overview hits: {len(project_hits)}",
        f"Selected context lines: {len(ordered)}",
        f"Truncated: {'yes' if truncated else 'no'}",
        "",
        "## Selected log context",
        "",
    ]

    if not ordered:
        out.append("No Sector Overview-relevant lines detected.")
    else:
        previous = None
        for index in ordered:
            if previous is not None and index != previous + 1:
                out.extend(["", "---", ""])
            out.append(f"L{index + 1}: {lines[index]}")
            previous = index

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
