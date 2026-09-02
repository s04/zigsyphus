#!/usr/bin/env python3
"""Validate the static dashboard and its generated data links."""

from __future__ import annotations

import csv
import json
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


REPO_ROOT = Path(__file__).resolve().parents[1]
SITE_ROOT = REPO_ROOT / "site"
EXTERNAL_SCHEMES = {"data", "http", "https", "javascript", "mailto", "tel"}
REQUIRED_FILES = ("site/index.html", "site/styles.css", "site/app.js", "data/gold/summary.json")
MAX_SITE_FILE_BYTES = 250_000


class DocumentParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.ids: list[str] = []
        self.references: list[tuple[str, str, str]] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        if values.get("id"):
            self.ids.append(values["id"] or "")
        for attribute in ("href", "src"):
            if values.get(attribute):
                self.references.append((tag, attribute, values[attribute] or ""))


def resolve_deployed_reference(source: Path, reference: str) -> Path | None:
    parsed = urlsplit(reference)
    if parsed.scheme.lower() in EXTERNAL_SCHEMES or parsed.netloc:
        return None
    if parsed.path.startswith("/"):
        raise ValueError("root-relative URL escapes the /zigsyphus/ Pages project")
    relative = unquote(parsed.path)
    if relative.startswith("data/"):
        target = REPO_ROOT / relative
    else:
        target = source if not relative else source.parent / relative
    if relative.endswith("/"):
        target /= "index.html"
    resolved = target.resolve()
    if resolved != REPO_ROOT and REPO_ROOT not in resolved.parents:
        raise ValueError("local URL escapes the repository")
    return resolved


def check_html() -> list[str]:
    errors: list[str] = []
    for path in sorted(SITE_ROOT.glob("*.html")):
        parser = DocumentParser()
        try:
            parser.feed(path.read_text(encoding="utf-8"))
            parser.close()
        except Exception as error:
            errors.append(f"{path.relative_to(REPO_ROOT)}: cannot parse HTML: {error}")
            continue
        for element_id, count in Counter(parser.ids).items():
            if count > 1:
                errors.append(f"{path.relative_to(REPO_ROOT)}: duplicate id {element_id!r}")
        for tag, attribute, reference in parser.references:
            try:
                target = resolve_deployed_reference(path, reference)
            except ValueError as error:
                errors.append(f"{path.relative_to(REPO_ROOT)}: {reference!r}: {error}")
                continue
            if target is not None and not target.exists():
                errors.append(
                    f"{path.relative_to(REPO_ROOT)}: {tag} {attribute}={reference!r}: target does not exist"
                )
    return errors


def check_generated_data() -> list[str]:
    errors: list[str] = []
    summary_path = REPO_ROOT / "data/gold/summary.json"
    try:
        summary = json.loads(summary_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        return [f"data/gold/summary.json: invalid JSON: {error}"]
    if summary.get("runCount") != len(summary.get("scores", [])) and summary.get("runCount", 0) < len(
        summary.get("scores", [])
    ):
        errors.append("data/gold/summary.json: score history exceeds runCount")

    runs_path = REPO_ROOT / "data/gold/runs.csv"
    try:
        with runs_path.open(newline="", encoding="utf-8") as handle:
            rows = list(csv.DictReader(handle))
    except OSError as error:
        return errors + [f"data/gold/runs.csv: cannot read: {error}"]
    if summary.get("runCount") != len(rows):
        errors.append(
            f"data/gold/summary.json: runCount {summary.get('runCount')!r} does not match {len(rows)} CSV rows"
        )
    for index, row in enumerate(rows, start=2):
        for field in ("resultPath", "solutionPath"):
            value = row.get(field, "")
            target = (REPO_ROOT / value).resolve()
            if not value or REPO_ROOT not in target.parents or not target.is_file():
                errors.append(f"data/gold/runs.csv:{index}: invalid {field} {value!r}")
    return errors


def check_limits() -> list[str]:
    errors = [f"{path}: required file is missing" for path in REQUIRED_FILES if not (REPO_ROOT / path).is_file()]
    for path in SITE_ROOT.rglob("*"):
        if path.is_file() and path.stat().st_size > MAX_SITE_FILE_BYTES:
            errors.append(f"{path.relative_to(REPO_ROOT)}: exceeds {MAX_SITE_FILE_BYTES} byte limit")
    return errors


def main() -> int:
    errors = check_limits() + check_html() + check_generated_data()
    if errors:
        for error in errors:
            print(error)
        return 1
    print("site and generated-data checks accepted")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
