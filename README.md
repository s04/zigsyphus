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
| 2026-06-27 | Leap (`leap`) | 1 | `openrouter/free` | pass/compiled | 9/9 | 100 | [141134Z-r01-leap](data/silver/attempts/2026/06/27/141134Z-r01-leap/solution.zig) |
| 2026-06-27 | Leap (`leap`) | 1 | `openrouter/free` | compile_error/compile_error | 0/9 | 10 | [141134Z-r00-leap](data/silver/attempts/2026/06/27/141134Z-r00-leap/solution.zig) |
| 2026-06-26 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | compile_error/compile_error | 0/5 | 10 | [142458Z-r02-collatz-conjecture](data/silver/attempts/2026/06/26/142458Z-r02-collatz-conjecture/solution.zig) |
| 2026-06-26 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | compile_error/compile_error | 0/5 | 10 | [142458Z-r01-collatz-conjecture](data/silver/attempts/2026/06/26/142458Z-r01-collatz-conjecture/solution.zig) |
| 2026-06-26 | Collatz Conjecture (`collatz-conjecture`) | 2 | `openrouter/free` | compile_error/compile_error | 0/5 | 10 | [142458Z-r00-collatz-conjecture](data/silver/attempts/2026/06/26/142458Z-r00-collatz-conjecture/solution.zig) |
| 2026-06-25 | Hello World (`hello-world`) | 1 | `openrouter/free` | pass/compiled | 1/1 | 100 | [142546Z-r00-hello-world](data/silver/attempts/2026/06/25/142546Z-r00-hello-world/solution.zig) |
| 2026-06-24 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [142836Z-r02-grains](data/silver/attempts/2026/06/24/142836Z-r02-grains/solution.zig) |
| 2026-06-24 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [142836Z-r01-grains](data/silver/attempts/2026/06/24/142836Z-r01-grains/solution.zig) |
| 2026-06-24 | Grains (`grains`) | 2 | `openrouter/free` | compile_error/compile_error | 0/10 | 10 | [142836Z-r00-grains](data/silver/attempts/2026/06/24/142836Z-r00-grains/solution.zig) |
| 2026-06-22 | Nucleotide Count (`nucleotide-count`) | 1 | `openrouter/free` | pass/compiled | 5/5 | 100 | [152514Z-r00-nucleotide-count](data/silver/attempts/2026/06/22/152514Z-r00-nucleotide-count/solution.zig) |
| 2026-06-21 | Difference of Squares (`difference-of-squares`) | 2 | `openrouter/free` | compile_error/compile_error | 0/9 | 10 | [142354Z-r02-difference-of-squares](data/silver/attempts/2026/06/21/142354Z-r02-difference-of-squares/solution.zig) |
| 2026-06-21 | Difference of Squares (`difference-of-squares`) | 2 | `openrouter/free` | compile_error/compile_error | 0/9 | 10 | [142354Z-r01-difference-of-squares](data/silver/attempts/2026/06/21/142354Z-r01-difference-of-squares/solution.zig) |
| 2026-06-21 | Difference of Squares (`difference-of-squares`) | 2 | `openrouter/free` | compile_error/compile_error | 0/9 | 10 | [142354Z-r00-difference-of-squares](data/silver/attempts/2026/06/21/142354Z-r00-difference-of-squares/solution.zig) |
| 2026-06-20 | Triangle (`triangle`) | 1 | `openrouter/free` | pass/compiled | 21/21 | 100 | [142331Z-r00-triangle](data/silver/attempts/2026/06/20/142331Z-r00-triangle/solution.zig) |
| 2026-06-19 | Sum of Multiples (`sum-of-multiples`) | 1 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [143056Z-r02-sum-of-multiples](data/silver/attempts/2026/06/19/143056Z-r02-sum-of-multiples/solution.zig) |
| 2026-06-19 | Sum of Multiples (`sum-of-multiples`) | 1 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [143056Z-r01-sum-of-multiples](data/silver/attempts/2026/06/19/143056Z-r01-sum-of-multiples/solution.zig) |
| 2026-06-19 | Sum of Multiples (`sum-of-multiples`) | 1 | `openrouter/free` | compile_error/compile_error | 0/17 | 10 | [143056Z-r00-sum-of-multiples](data/silver/attempts/2026/06/19/143056Z-r00-sum-of-multiples/solution.zig) |
| 2026-06-18 | Square Root (`square-root`) | 2 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [143427Z-r02-square-root](data/silver/attempts/2026/06/18/143427Z-r02-square-root/solution.zig) |
| 2026-06-18 | Square Root (`square-root`) | 2 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [143427Z-r01-square-root](data/silver/attempts/2026/06/18/143427Z-r01-square-root/solution.zig) |
| 2026-06-18 | Square Root (`square-root`) | 2 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [143427Z-r00-square-root](data/silver/attempts/2026/06/18/143427Z-r00-square-root/solution.zig) |

<!-- zigsyphus-results:end -->
