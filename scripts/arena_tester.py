#!/usr/bin/env python3
"""Deterministically test a Zigsyphus attempt."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path
from typing import Any

from arena_common import (
    GOLD,
    REPO_ROOT,
    SILVER,
    append_or_replace_csv,
    display_path,
    exercise_paths,
    iso_z,
    read_json,
    read_text,
    run_zig_test,
    score_result,
    utc_now,
    write_json,
    zig_version,
)


def relative(path: Path) -> str:
    return display_path(path)


def latest_attempt_dir() -> Path:
    attempts = sorted((SILVER / "attempts").glob("*/*/*/*/attempt.json"))
    if not attempts:
        raise SystemExit("No attempts found")
    return attempts[-1].parent


def controls(slug: str, timeout_seconds: int) -> dict[str, Any]:
    good = run_zig_test(slug, read_text(exercise_paths(slug)["example"]), timeout_seconds)
    bad = run_zig_test(
        "leap",
        "pub fn isLeapYear(year: u32) bool { _ = year; return false; }\n",
        timeout_seconds,
    )
    return {
        "badFixture": {"expected": "fail", "ok": bad["status"] != "pass", "problem": "leap", "status": bad["status"]},
        "goodFixture": {"expected": "pass", "ok": good["status"] == "pass", "problem": slug, "status": good["status"]},
    }


def update_gold(result: dict[str, Any]) -> None:
    row = {
        "attemptId": result["attemptId"],
        "compileStatus": result["test"]["compileStatus"],
        "date": result["date"],
        "difficulty": result["problem"]["difficulty"],
        "mode": result["mode"],
        "model": result["model"],
        "name": result["problem"]["name"],
        "passed": result["test"]["passed"],
        "resultPath": result["resultPath"],
        "runAt": result["testedAt"],
        "score": result["score"],
        "slug": result["problem"]["slug"],
        "solutionPath": result["solutionPath"],
        "status": result["test"]["status"],
        "total": result["test"]["total"],
        "zigVersion": result["zigVersion"],
    }
    append_or_replace_csv(GOLD / "runs.csv", [row], ["attemptId"])
    runs = []
    if (GOLD / "runs.csv").exists():
        with (GOLD / "runs.csv").open("r", encoding="utf-8", newline="") as handle:
            runs = list(csv.DictReader(handle))
    summary = {
        "generatedAt": result["testedAt"],
        "latest": row,
        "recentRuns": runs[-20:],
        "runCount": len(runs),
        "schemaVersion": 1,
        "scores": [
            {
                "attemptId": item["attemptId"],
                "date": item["date"],
                "score": int(item["score"] or 0),
                "slug": item["slug"],
            }
            for item in runs[-60:]
        ],
    }
    write_json(GOLD / "summary.json", summary)


def test_attempt(attempt_dir: Path, timeout_seconds: int) -> dict[str, Any]:
    attempt = read_json(attempt_dir / "attempt.json")
    solution = read_text(attempt_dir / "solution.zig")
    slug = attempt["problem"]["slug"]
    test = run_zig_test(slug, solution, timeout_seconds)
    tested_at = utc_now()
    result_path = attempt_dir / "result.json"
    result = {
        "attemptId": attempt["attemptId"],
        "controls": controls(slug, timeout_seconds),
        "date": tested_at.date().isoformat(),
        "mode": attempt["mode"],
        "model": attempt["model"],
        "problem": attempt["problem"],
        "resultPath": relative(result_path),
        "schemaVersion": 1,
        "score": score_result(test, bool(attempt.get("writer", {}).get("extracted", True))),
        "solutionPath": attempt["solutionPath"],
        "test": test,
        "testedAt": iso_z(tested_at),
        "zigVersion": zig_version(),
    }
    write_json(result_path, result)
    update_gold(result)
    print(result_path)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--attempt-dir", type=Path)
    parser.add_argument("--latest", action="store_true")
    parser.add_argument("--timeout-seconds", type=int, default=30)
    args = parser.parse_args()
    attempt_dir = latest_attempt_dir() if args.latest else args.attempt_dir
    if not attempt_dir:
        raise SystemExit("Use --latest or --attempt-dir")
    result = test_attempt(attempt_dir, args.timeout_seconds)
    ok = result["controls"]["goodFixture"]["ok"] and result["controls"]["badFixture"]["ok"]
    return 0 if ok else 2


if __name__ == "__main__":
    raise SystemExit(main())
