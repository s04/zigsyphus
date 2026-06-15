# The Myth of Zigsyphus

Every day at `13:37` UTC, Zigsyphus rolls one Zig exercise uphill, hands it to an LLM through OpenRouter's `openrouter/free` route, runs the deterministic tests, writes down the damage, and prepares to do it again tomorrow. This is competitive programming as workplace folklore: a tiny machine for turning free model entropy into commits, charts, logs, and occasionally working code.

The joke is simple, but the audit trail is real. A writer step asks the model for a solution. A tester step, which does not care about vibes, runs `zig test` and scores what happened. If the model wins, the boulder moves. If it fails, the boulder also moves, but with stack traces.

The project uses the MIT-licensed [Exercism Zig](https://github.com/exercism/zig) practice bank. Each run has a full audit trail:

- `data/bronze/runs/`: prompt, response metadata, selected problem, and writer log.
- `data/silver/attempts/`: submitted `solution.zig`, attempt metadata, and deterministic test result.
- `data/gold/`: `runs.csv`, `summary.json`, and dashboard-ready scoring history.

The deliberately melodramatic prompt lives in the GitHub Actions workflow at `.github/workflows/daily.yml` under `ZIGSYPHUS_SYSTEM_PROMPT`, because hiding the incantation would ruin the bit. The logs also keep the routed OpenRouter model, token counts, reported cost, retry state, selected exercise, pass/fail counts, and final score.

## Local Runs

Use the pinned local Zig 0.16 binary when present:

```bash
./.tools/zig-0.16.0/zig version
```

Install it locally on Apple Silicon macOS:

```bash
mkdir -p .tools
curl -L --fail -o .tools/zig-0.16.0.tar.xz https://ziglang.org/download/0.16.0/zig-aarch64-macos-0.16.0.tar.xz
tar -C .tools -xf .tools/zig-0.16.0.tar.xz
mv .tools/zig-aarch64-macos-0.16.0 .tools/zig-0.16.0
rm .tools/zig-0.16.0.tar.xz
```

Fixture good run:

```bash
ZIGSYPHUS_DATA_ROOT=/tmp/zigsyphus-good \
python3 scripts/run_daily.py --mode fixture-good --problem-slug leap --min-difficulty 1 --max-difficulty 9 --repair-attempts 0 --skip-readme
```

Fixture bad run:

```bash
ZIGSYPHUS_DATA_ROOT=/tmp/zigsyphus-bad \
python3 scripts/run_daily.py --mode fixture-bad --problem-slug leap --min-difficulty 1 --max-difficulty 9 --repair-attempts 0 --skip-readme
```

Live OpenRouter run:

```bash
OPENROUTER_API_KEY=... python3 scripts/run_daily.py --mode live
```

## Automation

The daily workflow runs at `13:37` UTC and can also be started manually. It writes one attempt, tests it, updates this README table, commits the audit log, and deploys the Pages dashboard.

Required GitHub secret:

- `OPENROUTER_API_KEY`

## Daily Attempts

<!-- zigsyphus-results:start -->

| Date | Exercise | Difficulty | Model | Status | Passed | Score | Attempt |
| --- | --- | ---: | --- | --- | ---: | ---: | --- |

<!-- zigsyphus-results:end -->
