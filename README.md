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
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r07-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r07-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r06-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r06-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r05-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r05-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r04-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r04-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r03-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r03-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 10 | [170704Z-r02-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r02-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r01-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r01-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r00-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r00-piecing-it-together/solution.zig) |
| 2026-09-08 | OCR Numbers (`ocr-numbers`) | 5 | `openrouter/free` | pass/compiled | 17/17 | 100 | [172254Z-r02-ocr-numbers](data/silver/attempts/2026/09/08/172254Z-r02-ocr-numbers/solution.zig) |
| 2026-09-08 | OCR Numbers (`ocr-numbers`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [172254Z-r01-ocr-numbers](data/silver/attempts/2026/09/08/172254Z-r01-ocr-numbers/solution.zig) |
| 2026-09-08 | OCR Numbers (`ocr-numbers`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 0 | [172254Z-r00-ocr-numbers](data/silver/attempts/2026/09/08/172254Z-r00-ocr-numbers/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 0 | [182108Z-r07-change](data/silver/attempts/2026/09/07/182108Z-r07-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r06-change](data/silver/attempts/2026/09/07/182108Z-r06-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r05-change](data/silver/attempts/2026/09/07/182108Z-r05-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r04-change](data/silver/attempts/2026/09/07/182108Z-r04-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r03-change](data/silver/attempts/2026/09/07/182108Z-r03-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r02-change](data/silver/attempts/2026/09/07/182108Z-r02-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 10 | [182108Z-r01-change](data/silver/attempts/2026/09/07/182108Z-r01-change/solution.zig) |
| 2026-09-07 | Change (`change`) | 6 | `openrouter/free` | compile_error/compile_error | 0/13 | 0 | [182108Z-r00-change](data/silver/attempts/2026/09/07/182108Z-r00-change/solution.zig) |
| 2026-09-06 | Meetup (`meetup`) | 5 | `openrouter/free` | pass/compiled | 97/97 | 100 | [162409Z-r01-meetup](data/silver/attempts/2026/09/06/162409Z-r01-meetup/solution.zig) |

<!-- zigsyphus-results:end -->
