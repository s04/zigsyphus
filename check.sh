#!/usr/bin/env bash
set -euo pipefail

zig_bin="zig"
if [ -x .tools/zig-0.16.0/zig ]; then
  zig_bin=".tools/zig-0.16.0/zig"
fi

"$zig_bin" build
"$zig_bin" test src/zigsyphus.zig
python3 scripts/check_site.py

if command -v node >/dev/null 2>&1; then
  node --check site/app.js
fi

check_tmp="$(mktemp -d)"
trap 'rm -rf -- "$check_tmp"' EXIT

ZIGSYPHUS_DATA_ROOT="$check_tmp/good" "$zig_bin" build run -- daily \
  --mode fixture-good --problem-slug leap --repair-attempts 0 \
  --run-at 2026-01-01T00:00:00Z --skip-readme >/dev/null
ZIGSYPHUS_DATA_ROOT="$check_tmp/bad" "$zig_bin" build run -- daily \
  --mode fixture-bad --problem-slug leap --repair-attempts 0 \
  --run-at 2026-01-01T00:00:00Z --skip-readme >/dev/null

python3 - "$check_tmp" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
expected = {"good": "pass", "bad": "fail"}
for fixture, status in expected.items():
    results = list((root / fixture / "silver/attempts").glob("*/*/*/*/result.json"))
    if len(results) != 1:
        raise SystemExit(f"{fixture} fixture produced {len(results)} results")
    actual = json.loads(results[0].read_text(encoding="utf-8"))["test"]["status"]
    if actual != status:
        raise SystemExit(f"{fixture} fixture expected {status}, got {actual}")
print("fixture checks accepted")
PY
