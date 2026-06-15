#!/usr/bin/env python3
"""Shared helpers for Zigsyphus."""

from __future__ import annotations

import csv
import hashlib
import json
import os
import random
import re
import shutil
import subprocess
import tempfile
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
BANK_ROOT = REPO_ROOT / "arena" / "bank" / "exercism-zig"
DATA_ROOT = Path(os.getenv("ZIGSYPHUS_DATA_ROOT", REPO_ROOT / "data")).resolve()
BRONZE = DATA_ROOT / "bronze"
SILVER = DATA_ROOT / "silver"
GOLD = DATA_ROOT / "gold"
README_START = "<!-- zigsyphus-results:start -->"
README_END = "<!-- zigsyphus-results:end -->"


def utc_now() -> datetime:
    return datetime.now(UTC).replace(microsecond=0)


def iso_z(value: datetime) -> str:
    return value.isoformat().replace("+00:00", "Z")


def snake_slug(slug: str) -> str:
    return slug.replace("-", "_")


def read_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8")


def display_path(path: Path) -> str:
    try:
        return str(path.relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def stable_hash(value: Any) -> str:
    payload = json.dumps(value, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(payload).hexdigest()


def zig_bin() -> str:
    configured = os.getenv("ZIG_BIN")
    if configured:
        return configured
    local = REPO_ROOT / ".tools" / "zig-0.16.0" / "zig"
    if local.exists():
        return str(local)
    return "zig"


def zig_version() -> str:
    try:
        completed = subprocess.run(
            [zig_bin(), "version"], text=True, capture_output=True, timeout=10
        )
    except Exception as exc:  # noqa: BLE001
        return f"unavailable: {exc}"
    return completed.stdout.strip() or completed.stderr.strip() or "unknown"


def exercise_paths(slug: str) -> dict[str, Path]:
    snake = snake_slug(slug)
    directory = BANK_ROOT / "exercises" / "practice" / slug
    return {
        "dir": directory,
        "example": directory / ".meta" / "example.zig",
        "instructions": directory / ".docs" / "instructions.md",
        "starter": directory / f"{snake}.zig",
        "test": directory / f"test_{snake}.zig",
    }


def load_exercises(min_difficulty: int = 4, max_difficulty: int = 9) -> list[dict[str, Any]]:
    config = read_json(BANK_ROOT / "config.json")
    exercises: list[dict[str, Any]] = []
    for item in config["exercises"]["practice"]:
        difficulty = int(item.get("difficulty", 0))
        slug = item["slug"]
        paths = exercise_paths(slug)
        if not min_difficulty <= difficulty <= max_difficulty:
            continue
        if not all(paths[key].exists() for key in ("starter", "test", "instructions", "example")):
            continue
        exercises.append(
            {
                "difficulty": difficulty,
                "name": item["name"],
                "slug": slug,
                "tags": item.get("practices", []),
                "uuid": item.get("uuid"),
            }
        )
    return sorted(exercises, key=lambda item: (item["difficulty"], item["slug"]))


def read_runs() -> list[dict[str, str]]:
    path = GOLD / "runs.csv"
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def choose_exercise(
    exercises: list[dict[str, Any]],
    requested_slug: str | None = None,
    seed: str | None = None,
) -> dict[str, Any]:
    if requested_slug:
        for exercise in exercises:
            if exercise["slug"] == requested_slug:
                return exercise
        raise SystemExit(f"Unknown or filtered exercise slug: {requested_slug}")

    runs = read_runs()
    attempts: dict[str, int] = {}
    last_seen: dict[str, str] = {}
    for run in runs:
        slug = run.get("slug", "")
        if not slug:
            continue
        attempts[slug] = attempts.get(slug, 0) + 1
        last_seen[slug] = max(last_seen.get(slug, ""), run.get("runAt", ""))

    lowest = min((attempts.get(item["slug"], 0) for item in exercises), default=0)
    least_attempted = [item for item in exercises if attempts.get(item["slug"], 0) == lowest]
    oldest = min((last_seen.get(item["slug"], "") for item in least_attempted), default="")
    candidates = [item for item in least_attempted if last_seen.get(item["slug"], "") == oldest]
    return random.Random(seed or datetime.now(UTC).date().isoformat()).choice(candidates)


def attempt_paths(run_at: datetime, exercise: dict[str, Any], round_index: int = 0) -> dict[str, Any]:
    date_path = run_at.strftime("%Y/%m/%d")
    stamp = run_at.strftime("%H%M%SZ")
    suffix = f"r{round_index:02d}-{exercise['slug']}"
    attempt_id = f"{run_at.date().isoformat()}-{stamp}-{suffix}"
    attempt_dir = SILVER / "attempts" / date_path / f"{stamp}-{suffix}"
    bronze_dir = BRONZE / "runs" / date_path / f"{stamp}-{suffix}"
    return {
        "attempt_dir": attempt_dir,
        "attempt_id": attempt_id,
        "bronze_dir": bronze_dir,
        "result": attempt_dir / "result.json",
        "solution": attempt_dir / "solution.zig",
        "writer_log": bronze_dir / "writer.json",
    }


def count_tests(test_file: Path) -> int:
    return len(re.findall(r"(?m)^test\s+", read_text(test_file)))


def parse_test_progress(output: str) -> dict[str, int]:
    passed = failed = skipped = 0
    for line in output.splitlines():
        if re.match(r"^\d+/\d+\s+.*\.\.\.OK\b", line):
            passed += 1
        elif re.match(r"^\d+/\d+\s+.*\.\.\.FAIL\b", line):
            failed += 1
        elif re.match(r"^\d+/\d+\s+.*\.\.\.SKIP\b", line):
            skipped += 1
    return {"failed": failed, "passed": passed, "skipped": skipped}


def run_zig_test(slug: str, solution: str, timeout_seconds: int = 30) -> dict[str, Any]:
    paths = exercise_paths(slug)
    snake = snake_slug(slug)
    total = count_tests(paths["test"])

    with tempfile.TemporaryDirectory(prefix=f"zigsyphus-{slug}-") as tmp_name:
        tmp = Path(tmp_name)
        for path in paths["dir"].iterdir():
            if path.is_file() and path.suffix == ".zig":
                shutil.copy2(path, tmp / path.name)
        write_text(tmp / f"{snake}.zig", solution)

        started = utc_now()
        try:
            completed = subprocess.run(
                [zig_bin(), "test", f"test_{snake}.zig"],
                cwd=tmp,
                text=True,
                capture_output=True,
                timeout=timeout_seconds,
            )
        except subprocess.TimeoutExpired as exc:
            output = ((exc.stdout or "") + "\n" + (exc.stderr or "")).strip()
            return {
                "compileStatus": "timeout",
                "durationSeconds": timeout_seconds,
                "failed": total,
                "outputExcerpt": output[:8000],
                "passed": 0,
                "returnCode": None,
                "skipped": 0,
                "status": "timeout",
                "total": total,
            }

    duration = max((utc_now() - started).total_seconds(), 0.0)
    output = (completed.stdout + "\n" + completed.stderr).strip()
    progress = parse_test_progress(output)
    if completed.returncode == 0:
        status = "pass"
        compile_status = "compiled"
        passed = total
        failed = 0
    elif progress["passed"] or progress["failed"] or progress["skipped"]:
        status = "fail"
        compile_status = "compiled"
        passed = progress["passed"]
        failed = max(progress["failed"], total - passed - progress["skipped"])
    else:
        status = "compile_error"
        compile_status = "compile_error"
        passed = 0
        failed = total

    return {
        "compileStatus": compile_status,
        "durationSeconds": round(duration, 3),
        "failed": failed,
        "outputExcerpt": output[:8000],
        "passed": passed,
        "returnCode": completed.returncode,
        "skipped": progress["skipped"],
        "status": status,
        "total": total,
    }


def score_result(test: dict[str, Any], extracted: bool = True) -> int:
    score = 10 if extracted else 0
    if test.get("compileStatus") == "compiled":
        score += 30
    total = int(test.get("total") or 0)
    passed = int(test.get("passed") or 0)
    if total:
        score += round(60 * passed / total)
    return max(0, min(100, int(score)))


def append_or_replace_csv(path: Path, rows: list[dict[str, Any]], key_fields: list[str]) -> None:
    if not rows:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    existing: list[dict[str, str]] = []
    fieldnames = list(rows[0].keys())
    if path.exists():
        with path.open("r", encoding="utf-8", newline="") as handle:
            reader = csv.DictReader(handle)
            existing = list(reader)
            if reader.fieldnames:
                fieldnames = list(dict.fromkeys([*reader.fieldnames, *fieldnames]))

    keys = {tuple(str(row.get(field, "")) for field in key_fields) for row in rows}
    kept = [
        row for row in existing
        if tuple(str(row.get(field, "")) for field in key_fields) not in keys
    ]
    kept.extend({key: "" if value is None else value for key, value in row.items()} for row in rows)
    kept.sort(key=lambda row: tuple(str(row.get(field, "")) for field in key_fields))

    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in kept:
            writer.writerow({field: row.get(field, "") for field in fieldnames})
