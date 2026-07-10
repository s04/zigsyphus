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
| 2026-07-10 | Eliud's Eggs (`eliuds-eggs`) | 2 | `openrouter/free` | pass/compiled | 4/4 | 100 | [155725Z-r01-eliuds-eggs](data/silver/attempts/2026/07/10/155725Z-r01-eliuds-eggs/solution.zig) |
| 2026-07-10 | Eliud's Eggs (`eliuds-eggs`) | 2 | `openrouter/free` | compile_error/compile_error | 0/4 | 10 | [155725Z-r00-eliuds-eggs](data/silver/attempts/2026/07/10/155725Z-r00-eliuds-eggs/solution.zig) |
| 2026-07-09 | Protein Translation (`protein-translation`) | 3 | `openrouter/free` | compile_error/compile_error | 0/30 | 10 | [161301Z-r02-protein-translation](data/silver/attempts/2026/07/09/161301Z-r02-protein-translation/solution.zig) |
| 2026-07-09 | Protein Translation (`protein-translation`) | 3 | `openrouter/free` | compile_error/compile_error | 0/30 | 10 | [161301Z-r01-protein-translation](data/silver/attempts/2026/07/09/161301Z-r01-protein-translation/solution.zig) |
| 2026-07-09 | Protein Translation (`protein-translation`) | 3 | `openrouter/free` | compile_error/compile_error | 0/30 | 10 | [161301Z-r00-protein-translation](data/silver/attempts/2026/07/09/161301Z-r00-protein-translation/solution.zig) |
| 2026-07-08 | Hamming (`hamming`) | 2 | `openrouter/free` | pass/compiled | 9/9 | 100 | [155143Z-r00-hamming](data/silver/attempts/2026/07/08/155143Z-r00-hamming/solution.zig) |
| 2026-07-07 | RNA Transcription (`rna-transcription`) | 1 | `openrouter/free` | pass/compiled | 6/6 | 100 | [160406Z-r00-rna-transcription](data/silver/attempts/2026/07/07/160406Z-r00-rna-transcription/solution.zig) |
| 2026-07-06 | Isogram (`isogram`) | 1 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [164015Z-r02-isogram](data/silver/attempts/2026/07/06/164015Z-r02-isogram/solution.zig) |
| 2026-07-06 | Isogram (`isogram`) | 1 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [164015Z-r01-isogram](data/silver/attempts/2026/07/06/164015Z-r01-isogram/solution.zig) |
| 2026-07-06 | Isogram (`isogram`) | 1 | `openrouter/free` | compile_error/compile_error | 0/14 | 10 | [164015Z-r00-isogram](data/silver/attempts/2026/07/06/164015Z-r00-isogram/solution.zig) |
| 2026-07-05 | High Scores (`high-scores`) | 2 | `openrouter/free` | compile_error/compile_error | 0/8 | 10 | [145849Z-r02-high-scores](data/silver/attempts/2026/07/05/145849Z-r02-high-scores/solution.zig) |
| 2026-07-05 | High Scores (`high-scores`) | 2 | `openrouter/free` | compile_error/compile_error | 0/8 | 10 | [145849Z-r01-high-scores](data/silver/attempts/2026/07/05/145849Z-r01-high-scores/solution.zig) |
| 2026-07-05 | High Scores (`high-scores`) | 2 | `openrouter/free` | compile_error/compile_error | 0/8 | 10 | [145849Z-r00-high-scores](data/silver/attempts/2026/07/05/145849Z-r00-high-scores/solution.zig) |
| 2026-07-04 | Secret Handshake (`secret-handshake`) | 3 | `openrouter/free` | compile_error/compile_error | 0/11 | 10 | [145032Z-r02-secret-handshake](data/silver/attempts/2026/07/04/145032Z-r02-secret-handshake/solution.zig) |
| 2026-07-04 | Secret Handshake (`secret-handshake`) | 3 | `openrouter/free` | compile_error/compile_error | 0/11 | 10 | [145032Z-r01-secret-handshake](data/silver/attempts/2026/07/04/145032Z-r01-secret-handshake/solution.zig) |
| 2026-07-04 | Secret Handshake (`secret-handshake`) | 3 | `openrouter/free` | compile_error/compile_error | 0/11 | 10 | [145032Z-r00-secret-handshake](data/silver/attempts/2026/07/04/145032Z-r00-secret-handshake/solution.zig) |
| 2026-07-03 | Resistor Color Trio (`resistor-color-trio`) | 2 | `openrouter/free` | pass/compiled | 14/14 | 100 | [153441Z-r00-resistor-color-trio](data/silver/attempts/2026/07/03/153441Z-r00-resistor-color-trio/solution.zig) |
| 2026-07-01 | Bottle Song (`bottle-song`) | 3 | `openrouter/free` | compile_error/compile_error | 0/7 | 10 | [142546Z-r02-bottle-song](data/silver/attempts/2026/07/01/142546Z-r02-bottle-song/solution.zig) |
| 2026-07-01 | Bottle Song (`bottle-song`) | 3 | `openrouter/free` | compile_error/compile_error | 0/7 | 10 | [142546Z-r01-bottle-song](data/silver/attempts/2026/07/01/142546Z-r01-bottle-song/solution.zig) |
| 2026-07-01 | Bottle Song (`bottle-song`) | 3 | `openrouter/free` | compile_error/compile_error | 0/7 | 10 | [142546Z-r00-bottle-song](data/silver/attempts/2026/07/01/142546Z-r00-bottle-song/solution.zig) |

<!-- zigsyphus-results:end -->
