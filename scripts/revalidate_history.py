#!/usr/bin/env python3
"""Re-run archived solutions with isolated Zig caches and optionally repair derived data."""

from __future__ import annotations

import argparse
import csv
import json
import os
import re
import shutil
import subprocess
import tempfile
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
RUNS_PATH = REPO_ROOT / "data/gold/runs.csv"
SUMMARY_PATH = REPO_ROOT / "data/gold/summary.json"
DIFFICULTY_PATH = REPO_ROOT / "data/gold/difficulty.json"
CSV_FIELDS = (
    "attemptId", "compileStatus", "date", "difficulty", "mode", "model", "name", "passed",
    "resultPath", "runAt", "score", "slug", "solutionPath", "status", "total", "zigVersion",
)


def zig_binary() -> Path | str:
    pinned = REPO_ROOT / ".tools/zig-0.16.0/zig"
    return pinned if pinned.is_file() else "zig"


def count_progress(output: str, marker: str) -> int:
    return len(re.findall(rf"\.\.\.{marker}(?:\s|$)", output))


def score(test: dict[str, Any], extracted: bool) -> int:
    value = 10 if extracted else 0
    if test["compileStatus"] == "compiled":
        value += 30
    if test["total"]:
        value += (60 * test["passed"] + test["total"] // 2) // test["total"]
    return min(value, 100)


def verify(row: dict[str, str]) -> tuple[dict[str, str], dict[str, Any]]:
    slug = row["slug"]
    snake = slug.replace("-", "_")
    exercise = REPO_ROOT / "arena/bank/exercism-zig/exercises/practice" / slug
    total = int(row["total"])
    with tempfile.TemporaryDirectory(prefix="zigsyphus-revalidate-") as directory:
        workdir = Path(directory)
        for source in exercise.glob("*.zig"):
            shutil.copy2(source, workdir / source.name)
        shutil.copy2(REPO_ROOT / row["solutionPath"], workdir / f"{snake}.zig")
        try:
            result = subprocess.run(
                [str(zig_binary()), "test", f"test_{snake}.zig", "--cache-dir", ".zig-cache"],
                cwd=workdir,
                text=True,
                capture_output=True,
                timeout=30,
                check=False,
            )
            output = result.stdout + "\n" + result.stderr
            passed = count_progress(output, "OK")
            failed = count_progress(output, "FAIL")
            skipped = count_progress(output, "SKIP")
            progress = passed + failed + skipped
            if result.returncode == 0:
                status, compile_status, passed, failed = "pass", "compiled", total, 0
            elif progress:
                status, compile_status = "fail", "compiled"
                failed = max(failed, total - passed - skipped)
            else:
                status, compile_status, passed, failed = "compile_error", "compile_error", 0, total
            return_code: int | None = result.returncode
        except subprocess.TimeoutExpired as error:
            raw_stdout = error.stdout.decode() if isinstance(error.stdout, bytes) else (error.stdout or "")
            raw_stderr = error.stderr.decode() if isinstance(error.stderr, bytes) else (error.stderr or "")
            output = raw_stdout + "\n" + raw_stderr + "\nZig test exceeded 30 seconds.\n"
            status, compile_status, passed, failed, skipped = "timeout", "timeout", 0, total, 0
            return_code = None
        output = output.replace(str(REPO_ROOT), "<repo>").replace(str(workdir), "<workdir>")
        excerpt = output if len(output) <= 8000 else output[:8000] + "\n... truncated ...\n"
        return row, {
            "compileStatus": compile_status,
            "durationSeconds": 0.0,
            "failed": failed,
            "outputExcerpt": excerpt,
            "passed": passed,
            "returnCode": return_code,
            "skipped": skipped,
            "status": status,
            "total": total,
        }


def test_signature(test: dict[str, Any]) -> tuple[Any, ...]:
    return tuple(test.get(key) for key in ("status", "compileStatus", "passed", "failed", "skipped", "total"))


def write_derived_data(rows: list[dict[str, str]]) -> None:
    with RUNS_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    difficulty: dict[str, Any] | None = None
    if rows:
        latest = rows[-1]
        current = max(1, min(9, int(latest["difficulty"])))
        next_difficulty = min(9, current + 1) if latest["status"] == "pass" else max(1, current - 1)
        difficulty = {
            "attemptId": latest["attemptId"],
            "currentDifficulty": current,
            "lastScore": int(latest["score"]),
            "lastStatus": latest["status"],
            "nextDifficulty": next_difficulty,
            "schemaVersion": 1,
            "updatedAt": latest["runAt"],
        }
        DIFFICULTY_PATH.write_text(json.dumps(difficulty, indent=2) + "\n", encoding="utf-8")
    generated_at = rows[-1]["runAt"] if rows else ""
    compact = lambda value: json.dumps(value, separators=(",", ":"), ensure_ascii=False)
    lines = ["{"]
    lines.append('  "difficulty": ' + json.dumps(difficulty, indent=2).replace("\n", "\n  ") + ",")
    lines.append(f'  "generatedAt": {json.dumps(generated_at)},')
    lines.append(f'  "latest": {compact(rows[-1]) if rows else "null"},')
    lines.append(f'  "nextDifficulty": {difficulty["nextDifficulty"] if difficulty else 1},')
    lines.append('  "recentRuns": [')
    for index, row in enumerate(rows[-20:]):
        suffix = "," if index + 1 < len(rows[-20:]) else ""
        lines.append(f"    {compact(row)}{suffix}")
    lines.append("  ],")
    lines.append(f'  "runCount": {len(rows)},')
    lines.append('  "schemaVersion": 1,')
    lines.append('  "scores": [')
    scores = [
        {"attemptId": row["attemptId"], "date": row["date"], "score": row["score"], "slug": row["slug"]}
        for row in rows[-60:]
    ]
    for index, item in enumerate(scores):
        suffix = "," if index + 1 < len(scores) else ""
        lines.append(f"    {compact(item)}{suffix}")
    lines.extend(("  ]", "}"))
    SUMMARY_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="rewrite mismatched results and derived data")
    parser.add_argument("--workers", type=int, default=min(4, os.cpu_count() or 1))
    args = parser.parse_args()
    with RUNS_PATH.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        verified = list(pool.map(verify, rows))
    checked_at = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
    mismatches = 0
    for row, fresh_test in verified:
        result_path = REPO_ROOT / row["resultPath"]
        result = json.loads(result_path.read_text(encoding="utf-8"))
        if test_signature(result["test"]) == test_signature(fresh_test):
            continue
        mismatches += 1
        print(f"{row['attemptId']}: {result['test']['status']} -> {fresh_test['status']}")
        if not args.apply:
            continue
        attempt = json.loads((result_path.parent / "attempt.json").read_text(encoding="utf-8"))
        previous = {"score": result["score"], "test": result["test"]}
        result["test"] = fresh_test
        result["score"] = score(fresh_test, bool(attempt.get("writer", {}).get("extracted")))
        result["revalidation"] = {"at": checked_at, "previous": previous, "reason": "isolated Zig cache verification"}
        result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        row["compileStatus"] = fresh_test["compileStatus"]
        row["passed"] = str(fresh_test["passed"])
        row["score"] = str(result["score"])
        row["status"] = fresh_test["status"]
    if args.apply:
        write_derived_data(rows)
    print(f"verified {len(rows)} attempts; mismatches: {mismatches}; applied: {bool(args.apply)}")
    return 0 if args.apply or mismatches == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
