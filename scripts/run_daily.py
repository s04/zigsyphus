#!/usr/bin/env python3
"""Run the daily Zigsyphus writer/tester pipeline."""

from __future__ import annotations

import argparse
import os
import subprocess
import time
from datetime import UTC, datetime
from pathlib import Path

from arena_common import REPO_ROOT, read_json


def run(args: list[str], env: dict[str, str] | None = None) -> str:
    completed = subprocess.run(
        args,
        cwd=REPO_ROOT,
        env={**os.environ, **(env or {})},
        text=True,
        capture_output=True,
        check=True,
    )
    return completed.stdout.strip().splitlines()[-1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", default=os.getenv("ZIGSYPHUS_MODE", "live"))
    parser.add_argument("--model", default=os.getenv("ZIGSYPHUS_MODEL", "openrouter/free"))
    parser.add_argument("--problem-slug", default=os.getenv("ZIGSYPHUS_PROBLEM_SLUG"))
    parser.add_argument("--min-difficulty", default=os.getenv("ZIGSYPHUS_MIN_DIFFICULTY", "4"))
    parser.add_argument("--max-difficulty", default=os.getenv("ZIGSYPHUS_MAX_DIFFICULTY", "9"))
    parser.add_argument("--repair-attempts", type=int, default=int(os.getenv("ZIGSYPHUS_REPAIR_ATTEMPTS", "2")))
    parser.add_argument("--timeout-seconds", type=int, default=30)
    parser.add_argument("--run-at", default=datetime.now(UTC).replace(microsecond=0).isoformat().replace("+00:00", "Z"))
    parser.add_argument("--skip-readme", action="store_true")
    parser.add_argument("--api-retries", type=int, default=int(os.getenv("ZIGSYPHUS_API_RETRIES", "3")))
    args = parser.parse_args()

    shared = [
        "--mode", args.mode,
        "--model", args.model,
        "--min-difficulty", str(args.min_difficulty),
        "--max-difficulty", str(args.max_difficulty),
        "--run-at", args.run_at,
    ]
    if args.problem_slug:
        shared.extend(["--problem-slug", args.problem_slug])

    attempt_dir = Path(
        run(
            [
                "python3",
                "scripts/arena_writer.py",
                *shared,
                "--round-index",
                "0",
                "--api-retries",
                str(args.api_retries),
            ]
        )
    )
    result_path = Path(run(["python3", "scripts/arena_tester.py", "--attempt-dir", str(attempt_dir), "--timeout-seconds", str(args.timeout_seconds)]))
    result = read_json(result_path)

    round_index = 1
    while args.mode == "live" and result["score"] < 100 and round_index <= args.repair_attempts:
        time.sleep(1)
        attempt_dir = Path(
            run(
                [
                    "python3",
                    "scripts/arena_writer.py",
                    *shared,
                    "--round-index",
                    str(round_index),
                    "--repair-from",
                    str(result_path),
                    "--api-retries",
                    str(args.api_retries),
                ]
            )
        )
        result_path = Path(run(["python3", "scripts/arena_tester.py", "--attempt-dir", str(attempt_dir), "--timeout-seconds", str(args.timeout_seconds)]))
        result = read_json(result_path)
        round_index += 1

    if not args.skip_readme:
        run(["python3", "scripts/update_readme.py"])
    print(result_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
