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
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | fail/compiled | 25/31 | 78 | [172439Z-r05-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r05-variable-length-quantity/solution.zig) |
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | fail/compiled | 25/31 | 78 | [172439Z-r04-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r04-variable-length-quantity/solution.zig) |
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | fail/compiled | 25/31 | 88 | [172439Z-r03-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r03-variable-length-quantity/solution.zig) |
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | compile_error/compile_error | 0/31 | 0 | [172439Z-r02-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r02-variable-length-quantity/solution.zig) |
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | compile_error/compile_error | 0/31 | 10 | [172439Z-r01-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r01-variable-length-quantity/solution.zig) |
| 2026-09-01 | Variable Length Quantity (`variable-length-quantity`) | 5 | `openrouter/free` | compile_error/compile_error | 0/31 | 0 | [172439Z-r00-variable-length-quantity](data/silver/attempts/2026/09/01/172439Z-r00-variable-length-quantity/solution.zig) |
| 2026-08-30 | Robot Simulator (`robot-simulator`) | 4 | `openrouter/free` | pass/compiled | 18/18 | 100 | [174341Z-r01-robot-simulator](data/silver/attempts/2026/08/30/174341Z-r01-robot-simulator/solution.zig) |
| 2026-08-30 | Robot Simulator (`robot-simulator`) | 4 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [174341Z-r00-robot-simulator](data/silver/attempts/2026/08/30/174341Z-r00-robot-simulator/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 0 | [172023Z-r05-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r05-affine-cipher/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [172023Z-r04-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r04-affine-cipher/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [172023Z-r03-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r03-affine-cipher/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 0 | [172023Z-r02-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r02-affine-cipher/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 0 | [172023Z-r01-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r01-affine-cipher/solution.zig) |
| 2026-08-29 | Affine Cipher (`affine-cipher`) | 5 | `openrouter/free` | compile_error/compile_error | 0/17 | 0 | [172023Z-r00-affine-cipher](data/silver/attempts/2026/08/29/172023Z-r00-affine-cipher/solution.zig) |
| 2026-08-28 | Nth Prime (`nth-prime`) | 4 | `openrouter/free` | pass/compiled | 8/8 | 100 | [231024Z-r00-nth-prime](data/silver/attempts/2026/08/28/231024Z-r00-nth-prime/solution.zig) |
| 2026-08-27 | Line up (`line-up`) | 3 | `openrouter/free` | pass/compiled | 19/19 | 100 | [230214Z-r02-line-up](data/silver/attempts/2026/08/27/230214Z-r02-line-up/solution.zig) |
| 2026-08-27 | Line up (`line-up`) | 3 | `openrouter/free` | compile_error/compile_error | 0/19 | 10 | [230214Z-r01-line-up](data/silver/attempts/2026/08/27/230214Z-r01-line-up/solution.zig) |
| 2026-08-27 | Line up (`line-up`) | 3 | `openrouter/free` | compile_error/compile_error | 0/19 | 10 | [230214Z-r00-line-up](data/silver/attempts/2026/08/27/230214Z-r00-line-up/solution.zig) |
| 2026-08-26 | Linked List (`linked-list`) | 4 | `openrouter/free` | fail/compiled | 18/19 | 97 | [142000Z-r05-linked-list](data/silver/attempts/2026/08/26/142000Z-r05-linked-list/solution.zig) |
| 2026-08-26 | Linked List (`linked-list`) | 4 | `openrouter/free` | fail/compiled | 18/19 | 97 | [142000Z-r04-linked-list](data/silver/attempts/2026/08/26/142000Z-r04-linked-list/solution.zig) |

<!-- zigsyphus-results:end -->
