#!/usr/bin/env python3
"""Update README with the ever-growing Zigsyphus run table."""

from __future__ import annotations

import csv
from pathlib import Path

from arena_common import GOLD, README_END, README_START, REPO_ROOT


README = REPO_ROOT / "README.md"


def load_rows() -> list[dict[str, str]]:
    path = GOLD / "runs.csv"
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def table(rows: list[dict[str, str]]) -> str:
    lines = [
        README_START,
        "",
        "| Date | Exercise | Difficulty | Model | Status | Passed | Score | Attempt |",
        "| --- | --- | ---: | --- | --- | ---: | ---: | --- |",
    ]
    for row in rows:
        attempt = row["solutionPath"]
        label = row["attemptId"].split("-", 3)[-1]
        lines.append(
            "| {date} | {name} (`{slug}`) | {difficulty} | `{model}` | {status}/{compileStatus} | {passed}/{total} | {score} | [{label}]({attempt}) |".format(
                attempt=attempt,
                label=label,
                **row,
            )
        )
    lines.extend(["", README_END])
    return "\n".join(lines)


def main() -> int:
    rows = load_rows()
    existing = README.read_text(encoding="utf-8") if README.exists() else "# The Myth of Zigsyphus\n"
    replacement = table(rows)
    if README_START in existing and README_END in existing:
        before = existing.split(README_START, 1)[0].rstrip()
        after = existing.split(README_END, 1)[1].lstrip()
        updated = f"{before}\n\n{replacement}\n\n{after}".rstrip() + "\n"
    else:
        updated = existing.rstrip() + "\n\n## Daily Attempts\n\n" + replacement + "\n"
    README.write_text(updated, encoding="utf-8")
    print(f"README updated with {len(rows)} arena rows")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
