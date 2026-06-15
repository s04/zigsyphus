#!/usr/bin/env python3
"""Validate Exercism Zig examples against the configured Zig binary."""

from __future__ import annotations

import argparse
import csv

from arena_common import GOLD, exercise_paths, load_exercises, read_text, run_zig_test, zig_version


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--min-difficulty", type=int, default=1)
    parser.add_argument("--max-difficulty", type=int, default=9)
    parser.add_argument("--timeout-seconds", type=int, default=30)
    args = parser.parse_args()

    rows = []
    for exercise in load_exercises(args.min_difficulty, args.max_difficulty):
        solution = read_text(exercise_paths(exercise["slug"])["example"])
        result = run_zig_test(exercise["slug"], solution, args.timeout_seconds)
        rows.append(
            {
                "difficulty": exercise["difficulty"],
                "name": exercise["name"],
                "passed": result["passed"],
                "slug": exercise["slug"],
                "status": result["status"],
                "total": result["total"],
                "zigVersion": zig_version(),
            }
        )
        print(f"{exercise['slug']}: {result['status']} {result['passed']}/{result['total']}")

    GOLD.mkdir(parents=True, exist_ok=True)
    with (GOLD / "bank-validation.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)

    failed = [row for row in rows if row["status"] != "pass"]
    print(f"validated={len(rows)} failed={len(failed)}")
    return 0 if not failed else 1


if __name__ == "__main__":
    raise SystemExit(main())
