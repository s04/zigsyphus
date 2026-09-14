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
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [184945Z-r07-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r07-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [184945Z-r06-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r06-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 0 | [184945Z-r05-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r05-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [184945Z-r04-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r04-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 10 | [184945Z-r03-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r03-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 0 | [184945Z-r02-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r02-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 0 | [184945Z-r01-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r01-rail-fence-cipher/solution.zig) |
| 2026-09-14 | Rail Fence Cipher (`rail-fence-cipher`) | 6 | `openrouter/free` | compile_error/compile_error | 0/6 | 0 | [184945Z-r00-rail-fence-cipher](data/silver/attempts/2026/09/14/184945Z-r00-rail-fence-cipher/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [170204Z-r07-book-store](data/silver/attempts/2026/09/13/170204Z-r07-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [170204Z-r06-book-store](data/silver/attempts/2026/09/13/170204Z-r06-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 0 | [170204Z-r05-book-store](data/silver/attempts/2026/09/13/170204Z-r05-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 0 | [170204Z-r04-book-store](data/silver/attempts/2026/09/13/170204Z-r04-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [170204Z-r03-book-store](data/silver/attempts/2026/09/13/170204Z-r03-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [170204Z-r02-book-store](data/silver/attempts/2026/09/13/170204Z-r02-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 10 | [170204Z-r01-book-store](data/silver/attempts/2026/09/13/170204Z-r01-book-store/solution.zig) |
| 2026-09-13 | Book Store (`book-store`) | 7 | `openrouter/free` | compile_error/compile_error | 0/18 | 0 | [170204Z-r00-book-store](data/silver/attempts/2026/09/13/170204Z-r00-book-store/solution.zig) |
| 2026-09-12 | Flower Field (`flower-field`) | 6 | `openrouter/free` | pass/compiled | 13/13 | 100 | [162706Z-r00-flower-field](data/silver/attempts/2026/09/12/162706Z-r00-flower-field/solution.zig) |
| 2026-09-11 | Series (`series`) | 5 | `openrouter/free` | pass/compiled | 8/8 | 100 | [170716Z-r00-series](data/silver/attempts/2026/09/11/170716Z-r00-series/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r07-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r07-piecing-it-together/solution.zig) |
| 2026-09-10 | Piecing It Together (`piecing-it-together`) | 6 | `openrouter/free` | compile_error/compile_error | 0/8 | 0 | [170704Z-r06-piecing-it-together](data/silver/attempts/2026/09/10/170704Z-r06-piecing-it-together/solution.zig) |

<!-- zigsyphus-results:end -->
