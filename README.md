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

Archived solutions were revalidated with isolated Zig caches on 2026-09-02 after a shared-cache bug was found. Corrected result files retain their previous verdicts under `revalidation.previous`.

## Local Runs

Run the repository, dashboard-link, and deterministic good/bad control checks:

```bash
./check.sh
```

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
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r07-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r07-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r06-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r06-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 0 | [172136Z-r05-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r05-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r04-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r04-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r03-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r03-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 0 | [172136Z-r02-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r02-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r01-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r01-intergalactic-transmission/solution.zig) |
| 2026-09-26 | Intergalactic Transmission (`intergalactic-transmission`) | 8 | `openrouter/free` | compile_error/compile_error | 0/26 | 10 | [172136Z-r00-intergalactic-transmission](data/silver/attempts/2026/09/26/172136Z-r00-intergalactic-transmission/solution.zig) |
| 2026-09-25 | Rectangles (`rectangles`) | 7 | `openrouter/free` | pass/compiled | 15/15 | 100 | [180221Z-r03-rectangles](data/silver/attempts/2026/09/25/180221Z-r03-rectangles/solution.zig) |
| 2026-09-25 | Rectangles (`rectangles`) | 7 | `openrouter/free` | compile_error/compile_error | 0/15 | 10 | [180221Z-r02-rectangles](data/silver/attempts/2026/09/25/180221Z-r02-rectangles/solution.zig) |
| 2026-09-25 | Rectangles (`rectangles`) | 7 | `openrouter/free` | compile_error/compile_error | 0/15 | 0 | [180221Z-r01-rectangles](data/silver/attempts/2026/09/25/180221Z-r01-rectangles/solution.zig) |
| 2026-09-25 | Rectangles (`rectangles`) | 7 | `openrouter/free` | compile_error/compile_error | 0/15 | 0 | [180221Z-r00-rectangles](data/silver/attempts/2026/09/25/180221Z-r00-rectangles/solution.zig) |
| 2026-09-24 | Say (`say`) | 6 | `openrouter/free` | pass/compiled | 23/23 | 100 | [175521Z-r01-say](data/silver/attempts/2026/09/24/175521Z-r01-say/solution.zig) |
| 2026-09-24 | Say (`say`) | 6 | `openrouter/free` | compile_error/compile_error | 0/23 | 0 | [175521Z-r00-say](data/silver/attempts/2026/09/24/175521Z-r00-say/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | compile_error/compile_error | 0/28 | 10 | [175537Z-r07-wordy](data/silver/attempts/2026/09/23/175537Z-r07-wordy/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | compile_error/compile_error | 0/28 | 10 | [175537Z-r06-wordy](data/silver/attempts/2026/09/23/175537Z-r06-wordy/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | fail/compiled | 27/28 | 98 | [175537Z-r05-wordy](data/silver/attempts/2026/09/23/175537Z-r05-wordy/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | compile_error/compile_error | 0/28 | 10 | [175537Z-r04-wordy](data/silver/attempts/2026/09/23/175537Z-r04-wordy/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | compile_error/compile_error | 0/28 | 10 | [175537Z-r03-wordy](data/silver/attempts/2026/09/23/175537Z-r03-wordy/solution.zig) |
| 2026-09-23 | Wordy (`wordy`) | 7 | `openrouter/free` | compile_error/compile_error | 0/28 | 10 | [175537Z-r02-wordy](data/silver/attempts/2026/09/23/175537Z-r02-wordy/solution.zig) |

<!-- zigsyphus-results:end -->
