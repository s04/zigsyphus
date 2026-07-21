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
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r05-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r05-isbn-verifier/solution.zig) |
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r04-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r04-isbn-verifier/solution.zig) |
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r03-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r03-isbn-verifier/solution.zig) |
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r02-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r02-isbn-verifier/solution.zig) |
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r01-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r01-isbn-verifier/solution.zig) |
| 2026-07-21 | ISBN Verifier (`isbn-verifier`) | 3 | `openrouter/free` | compile_error/compile_error | 0/21 | 10 | [152304Z-r00-isbn-verifier](data/silver/attempts/2026/07/21/152304Z-r00-isbn-verifier/solution.zig) |
| 2026-07-20 | Resistor Color (`resistor-color`) | 2 | `openrouter/free` | pass/compiled | 4/4 | 100 | [153015Z-r01-resistor-color](data/silver/attempts/2026/07/20/153015Z-r01-resistor-color/solution.zig) |
| 2026-07-20 | Resistor Color (`resistor-color`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 10 | [153015Z-r00-resistor-color](data/silver/attempts/2026/07/20/153015Z-r00-resistor-color/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | fail/compiled | 16/18 | 93 | [143926Z-r05-phone-number](data/silver/attempts/2026/07/19/143926Z-r05-phone-number/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | fail/compiled | 16/18 | 93 | [143926Z-r04-phone-number](data/silver/attempts/2026/07/19/143926Z-r04-phone-number/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | fail/compiled | 16/18 | 93 | [143926Z-r03-phone-number](data/silver/attempts/2026/07/19/143926Z-r03-phone-number/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | fail/compiled | 16/18 | 93 | [143926Z-r02-phone-number](data/silver/attempts/2026/07/19/143926Z-r02-phone-number/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | fail/compiled | 16/18 | 93 | [143926Z-r01-phone-number](data/silver/attempts/2026/07/19/143926Z-r01-phone-number/solution.zig) |
| 2026-07-19 | Phone Number (`phone-number`) | 3 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [143926Z-r00-phone-number](data/silver/attempts/2026/07/19/143926Z-r00-phone-number/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | pass/compiled | 4/4 | 100 | [143538Z-r05-etl](data/silver/attempts/2026/07/18/143538Z-r05-etl/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 0 | [143538Z-r04-etl](data/silver/attempts/2026/07/18/143538Z-r04-etl/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 0 | [143538Z-r03-etl](data/silver/attempts/2026/07/18/143538Z-r03-etl/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 10 | [143538Z-r02-etl](data/silver/attempts/2026/07/18/143538Z-r02-etl/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 10 | [143538Z-r01-etl](data/silver/attempts/2026/07/18/143538Z-r01-etl/solution.zig) |
| 2026-07-18 | ETL (`etl`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 10 | [143538Z-r00-etl](data/silver/attempts/2026/07/18/143538Z-r00-etl/solution.zig) |

<!-- zigsyphus-results:end -->
