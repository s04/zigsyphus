<p align="center">
  <img src="assets/zigsyphus-banner.png" alt="Zigsyphus logo banner" width="820">
</p>

<p align="center">
  <em>A doomed LLM automaton stuck in a competitive-programming hellscape.</em>
</p>

<p align="center">
  <a href="https://s04.github.io/zigsyphus/">Attempt history</a>
  ·
  <a href=".github/workflows/daily.yml">Prompt</a>
  ·
  <a href="data/gold/summary.json">Latest summary</a>
</p>

---

# The Myth of Zigsyphus

Every day at `13:37` UTC, GitHub Actions picks one Exercism Zig problem, sends it through OpenRouter's `openrouter/free` model router, runs `zig test`, and commits the result. Pass/fail is logged here and published on this website.

Attempt history: https://s04.github.io/zigsyphus/

The runner is a small Zig CLI. It asks Zigsyphus for one replacement source file, copies it into the exercise, and runs the official tests.

The project uses the MIT-licensed [Exercism Zig](https://github.com/exercism/zig) practice bank. Difficulty is a small ladder: the first adaptive run starts at `1`, a pass moves the next run up one level, and any non-pass moves it down one level, clamped between `1` and `9`.

Each run has a full audit trail:

- `data/bronze/runs/`: prompt, response metadata, selected problem, and writer log.
- `data/silver/attempts/`: submitted `solution.zig`, attempt metadata, and deterministic test result.
- `data/gold/`: `runs.csv`, `summary.json`, `difficulty.json`, and dashboard-ready scoring history.

The prompt lives in `.github/workflows/daily.yml` under `ZIGSYPHUS_SYSTEM_PROMPT`. The logs also keep the routed OpenRouter model, token counts, reported cost, retry state, selected exercise, pass/fail counts, and final score.

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
./.tools/zig-0.16.0/zig build run -- daily --mode fixture-good --problem-slug leap --min-difficulty 1 --max-difficulty 9 --repair-attempts 0 --skip-readme
```

Fixture bad run:

```bash
ZIGSYPHUS_DATA_ROOT=/tmp/zigsyphus-bad \
./.tools/zig-0.16.0/zig build run -- daily --mode fixture-bad --problem-slug leap --min-difficulty 1 --max-difficulty 9 --repair-attempts 0 --skip-readme
```

Live OpenRouter run:

```bash
OPENROUTER_API_KEY=... ./.tools/zig-0.16.0/zig build run -- daily --mode live
```

## Automation

The daily workflow runs at `13:37` UTC and can also be started manually. It picks the current adaptive difficulty unless a manual difficulty range is supplied, writes one attempt, tests it, updates this README table, commits the audit log, and deploys the Pages dashboard.

Required GitHub secret:

- `OPENROUTER_API_KEY`

## Daily Attempts

<!-- zigsyphus-results:start -->

| Date | Exercise | Difficulty | Model | Status | Passed | Score | Attempt |
| --- | --- | ---: | --- | --- | ---: | ---: | --- |
| 2026-08-19 | State of Tic-Tac-Toe (`state-of-tic-tac-toe`) | 4 | `openrouter/free` | pass/compiled | 27/27 | 100 | [140751Z-r00-state-of-tic-tac-toe](data/silver/attempts/2026/08/19/140751Z-r00-state-of-tic-tac-toe/solution.zig) |
| 2026-08-18 | Sublist (`sublist`) | 3 | `openrouter/free` | pass/compiled | 18/18 | 100 | [140755Z-r00-sublist](data/silver/attempts/2026/08/18/140755Z-r00-sublist/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | fail/compiled | 12/14 | 91 | [140308Z-r05-house](data/silver/attempts/2026/08/17/140308Z-r05-house/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | fail/compiled | 12/14 | 91 | [140308Z-r04-house](data/silver/attempts/2026/08/17/140308Z-r04-house/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | fail/compiled | 12/14 | 91 | [140308Z-r03-house](data/silver/attempts/2026/08/17/140308Z-r03-house/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [140308Z-r02-house](data/silver/attempts/2026/08/17/140308Z-r02-house/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [140308Z-r01-house](data/silver/attempts/2026/08/17/140308Z-r01-house/solution.zig) |
| 2026-08-17 | House (`house`) | 4 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [140308Z-r00-house](data/silver/attempts/2026/08/17/140308Z-r00-house/solution.zig) |
| 2026-08-16 | Queen Attack (`queen-attack`) | 3 | `openrouter/free` | pass/compiled | 14/14 | 100 | [135434Z-r01-queen-attack](data/silver/attempts/2026/08/16/135434Z-r01-queen-attack/solution.zig) |
| 2026-08-16 | Queen Attack (`queen-attack`) | 3 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [135434Z-r00-queen-attack](data/silver/attempts/2026/08/16/135434Z-r00-queen-attack/solution.zig) |
| 2026-08-15 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | pass/compiled | 5/5 | 100 | [135325Z-r02-collatz-conjecture](data/silver/attempts/2026/08/15/135325Z-r02-collatz-conjecture/solution.zig) |
| 2026-08-15 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | compile_error/compile_error | 0/5 | 10 | [135325Z-r01-collatz-conjecture](data/silver/attempts/2026/08/15/135325Z-r01-collatz-conjecture/solution.zig) |
| 2026-08-15 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | compile_error/compile_error | 0/5 | 10 | [135325Z-r00-collatz-conjecture](data/silver/attempts/2026/08/15/135325Z-r00-collatz-conjecture/solution.zig) |
| 2026-08-14 | Pangram (`pangram`) | 1 | `openrouter/free` | pass/compiled | 11/11 | 100 | [143226Z-r00-pangram](data/silver/attempts/2026/08/14/143226Z-r00-pangram/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r05-grains](data/silver/attempts/2026/08/13/143838Z-r05-grains/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r04-grains](data/silver/attempts/2026/08/13/143838Z-r04-grains/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r03-grains](data/silver/attempts/2026/08/13/143838Z-r03-grains/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r02-grains](data/silver/attempts/2026/08/13/143838Z-r02-grains/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r01-grains](data/silver/attempts/2026/08/13/143838Z-r01-grains/solution.zig) |
| 2026-08-13 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [143838Z-r00-grains](data/silver/attempts/2026/08/13/143838Z-r00-grains/solution.zig) |

<!-- zigsyphus-results:end -->
