#!/usr/bin/env python3
"""Generate a Zig attempt with OpenRouter or deterministic fixtures."""

from __future__ import annotations

import argparse
import json
import os
import re
import time
from datetime import datetime
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from arena_common import (
    BANK_ROOT,
    REPO_ROOT,
    attempt_paths,
    choose_exercise,
    display_path,
    exercise_paths,
    iso_z,
    load_exercises,
    read_text,
    stable_hash,
    utc_now,
    write_json,
    write_text,
)


OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
DEFAULT_MODEL = "openrouter/free"
DEFAULT_SYSTEM_PROMPT = (
    "You are Zigsyphus, a daily competitive-programming automaton condemned to "
    "roll one Zig solution uphill until the deterministic tests judge it. "
    "Return only a single fenced ```zig code block containing the full replacement "
    "solution file. Match the starter file's public API exactly. Do not edit tests. "
    "Do not include prose, markdown commentary, apologies, or explanations outside "
    "the code block."
)


def build_initial_messages(exercise: dict[str, Any]) -> list[dict[str, str]]:
    paths = exercise_paths(exercise["slug"])
    system = os.getenv("ZIGSYPHUS_SYSTEM_PROMPT", DEFAULT_SYSTEM_PROMPT)
    user = f"""
Exercise: {exercise['name']} ({exercise['slug']})
Difficulty: {exercise['difficulty']}/9

Instructions:
{read_text(paths['instructions'])}

Starter file:
```zig
{read_text(paths['starter'])}
```

Tests that will be run with `zig test`:
```zig
{read_text(paths['test'])}
```
"""
    return [{"role": "system", "content": system}, {"role": "user", "content": user}]


def build_repair_messages(
    exercise: dict[str, Any],
    previous_solution: str,
    result: dict[str, Any],
) -> list[dict[str, str]]:
    base = build_initial_messages(exercise)
    feedback = result.get("test", {}).get("outputExcerpt", "")
    base.append(
        {
            "role": "assistant",
            "content": f"```zig\n{previous_solution}\n```",
        }
    )
    base.append(
        {
            "role": "user",
            "content": (
                "The deterministic tester rejected that solution. Repair it and "
                "return only the full replacement Zig file.\n\n"
                f"Status: {result.get('test', {}).get('status')}\n"
                f"Passed: {result.get('test', {}).get('passed')}/"
                f"{result.get('test', {}).get('total')}\n\n"
                f"Compiler/test output:\n{feedback}"
            ),
        }
    )
    return base


def call_openrouter(
    api_key: str,
    messages: list[dict[str, str]],
    model: str,
    retries: int,
) -> dict[str, Any]:
    payload = {
        "max_tokens": 12000,
        "messages": messages,
        "model": model,
        "temperature": 0.2,
    }
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": os.getenv("OPENROUTER_REFERER", "https://github.com/s04/zigsyphus"),
        "X-OpenRouter-Title": os.getenv("OPENROUTER_TITLE", "The Myth of Zigsyphus"),
    }
    body = json.dumps(payload).encode("utf-8")
    last_error: dict[str, Any] = {"ok": False, "error": "not attempted"}
    for attempt in range(1, retries + 1):
        request = Request(OPENROUTER_URL, data=body, headers=headers, method="POST")
        try:
            with urlopen(request, timeout=120) as response:
                return {
                    "attempt": attempt,
                    "body": json.loads(response.read().decode("utf-8")),
                    "headers": dict(response.headers.items()),
                    "ok": True,
                    "status": response.status,
                }
        except HTTPError as exc:
            error_body = exc.read().decode("utf-8", errors="replace")
            last_error = {
                "attempt": attempt,
                "body": error_body[:4000],
                "error": str(exc),
                "ok": False,
                "status": exc.code,
            }
            if exc.code not in {408, 409, 425, 429, 500, 502, 503, 504}:
                break
            retry_after = exc.headers.get("Retry-After")
            delay = int(retry_after) if retry_after and retry_after.isdigit() else 2**attempt
            time.sleep(min(delay, 60))
        except URLError as exc:
            last_error = {"attempt": attempt, "error": str(exc), "ok": False, "status": "url_error"}
            time.sleep(min(2**attempt, 30))
    return last_error


def extract_solution(response: dict[str, Any]) -> tuple[str, dict[str, Any]]:
    if not response.get("ok"):
        return "", {"extracted": False, "reason": "api_error"}
    try:
        choice = response["body"]["choices"][0]
        content = choice["message"]["content"]
    except (KeyError, IndexError, TypeError):
        return "", {"extracted": False, "reason": "missing_choice"}
    match = re.search(r"```(?:zig)?\s*(.*?)```", content, flags=re.DOTALL | re.IGNORECASE)
    code = match.group(1).strip() if match else content.strip()
    return code + "\n", {
        "extracted": bool(code),
        "finishReason": choice.get("finish_reason"),
        "responseId": response["body"].get("id"),
        "routedModel": response["body"].get("model"),
        "usage": response["body"].get("usage"),
    }


def fixture_solution(mode: str, slug: str) -> str:
    paths = exercise_paths(slug)
    if mode == "fixture-good":
        return read_text(paths["example"])
    if mode == "fixture-bad" and slug == "leap":
        return "pub fn isLeapYear(year: u32) bool { _ = year; return false; }\n"
    if mode == "fixture-compile-error":
        return "this is not valid zig\n"
    return read_text(paths["starter"])


def load_repair_context(path: str | None) -> tuple[dict[str, Any] | None, str | None]:
    if not path:
        return None, None
    result_path = REPO_ROOT / path if not path.startswith("/") else None
    import pathlib

    resolved = pathlib.Path(path) if result_path is None else result_path
    result = json.loads(resolved.read_text(encoding="utf-8"))
    solution = (resolved.parent / "solution.zig").read_text(encoding="utf-8")
    return result, solution


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=["live", "fixture-good", "fixture-bad", "fixture-compile-error"], default=os.getenv("ZIGSYPHUS_MODE", "live"))
    parser.add_argument("--model", default=os.getenv("ZIGSYPHUS_MODEL", DEFAULT_MODEL))
    parser.add_argument("--problem-slug", default=os.getenv("ZIGSYPHUS_PROBLEM_SLUG"))
    parser.add_argument("--min-difficulty", type=int, default=int(os.getenv("ZIGSYPHUS_MIN_DIFFICULTY", "4")))
    parser.add_argument("--max-difficulty", type=int, default=int(os.getenv("ZIGSYPHUS_MAX_DIFFICULTY", "9")))
    parser.add_argument("--round-index", type=int, default=0)
    parser.add_argument("--repair-from")
    parser.add_argument("--run-at")
    parser.add_argument("--api-retries", type=int, default=3)
    args = parser.parse_args()

    run_at = utc_now()
    if args.run_at:
        run_at = datetime.fromisoformat(args.run_at.replace("Z", "+00:00"))

    exercises = load_exercises(args.min_difficulty, args.max_difficulty)
    exercise = choose_exercise(exercises, args.problem_slug, seed=run_at.date().isoformat())
    repair_result, previous_solution = load_repair_context(args.repair_from)
    paths = attempt_paths(run_at, exercise, args.round_index)
    messages = (
        build_repair_messages(exercise, previous_solution, repair_result)
        if repair_result and previous_solution
        else build_initial_messages(exercise)
    )

    if args.mode == "live":
        api_key = os.getenv("OPENROUTER_API_KEY")
        if not api_key:
            raise SystemExit("OPENROUTER_API_KEY is required for --mode live")
        response = call_openrouter(api_key, messages, args.model, args.api_retries)
        solution, extraction = extract_solution(response)
    else:
        solution = fixture_solution(args.mode, exercise["slug"])
        response = {"body": {"id": args.mode, "model": args.model}, "ok": True, "status": "fixture"}
        extraction = {
            "extracted": bool(solution),
            "responseId": args.mode,
            "routedModel": args.mode,
        }

    write_text(paths["solution"], solution)
    attempt = {
        "attemptId": paths["attempt_id"],
        "bank": {
            "license": "MIT",
            "name": "Exercism Zig",
            "path": str(BANK_ROOT.relative_to(REPO_ROOT)),
            "upstreamCommit": read_text(BANK_ROOT / "UPSTREAM_COMMIT").strip(),
            "upstreamUrl": "https://github.com/exercism/zig",
        },
        "generatedAt": iso_z(run_at),
        "mode": args.mode,
        "model": args.model,
        "problem": exercise,
        "promptHash": stable_hash(messages)[:12],
        "repairFrom": args.repair_from,
        "roundIndex": args.round_index,
        "schemaVersion": 1,
        "solutionPath": display_path(paths["solution"]),
        "writer": extraction,
    }
    write_json(paths["attempt_dir"] / "attempt.json", attempt)
    write_json(
        paths["writer_log"],
        {
            "attempt": attempt,
            "messages": messages,
            "response": response,
            "schemaVersion": 1,
        },
    )
    print(paths["attempt_dir"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
