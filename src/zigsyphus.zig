const std = @import("std");

const Allocator = std.mem.Allocator;
const Value = std.json.Value;

const BankRoot = "arena/bank/exercism-zig";
const ReadmeStart = "<!-- zigsyphus-results:start -->";
const ReadmeEnd = "<!-- zigsyphus-results:end -->";
const MinDifficulty = 1;
const MaxDifficulty = 9;

const Mode = enum { live, fixture_good, fixture_bad, fixture_compile_error };

const Options = struct {
    mode: Mode = .live,
    model: []const u8 = "openrouter/free",
    problem_slug: ?[]const u8 = null,
    min_difficulty: ?u8 = null,
    max_difficulty: ?u8 = null,
    repair_attempts: u8 = 3,
    timeout_seconds: u32 = 30,
    run_at: []const u8 = "",
    skip_readme: bool = false,
    api_retries: u8 = 3,
};

const Exercise = struct {
    slug: []const u8,
    name: []const u8,
    difficulty: u8,
    tags: []const []const u8,
    uuid: []const u8,
};

const AttemptPaths = struct {
    attempt_id: []const u8,
    attempt_dir: []const u8,
    bronze_dir: []const u8,
    result: []const u8,
    solution: []const u8,
    writer_log: []const u8,
};

const TestResult = struct {
    status: []const u8,
    compile_status: []const u8,
    passed: u32,
    failed: u32,
    skipped: u32,
    total: u32,
    return_code: ?u8,
    duration_seconds: f64,
    output_excerpt: []const u8,
};

const RunResult = struct {
    attempt_id: []const u8,
    attempt_dir: []const u8,
    result_path: []const u8,
    solution_path: []const u8,
    problem: Exercise,
    test_result: TestResult,
    score: u8,
    mode: Mode,
    model: []const u8,
    tested_at: []const u8,
    date: []const u8,
    zig_version: []const u8,
};

const WriterResult = struct {
    attempt_dir: []const u8,
    attempt_id: []const u8,
    solution_path: []const u8,
    exercise: Exercise,
    extracted: bool,
    response_id: []const u8,
    routed_model: []const u8,
    usage_json: []const u8,
};

const ProcessResult = struct {
    stdout: []u8,
    stderr: []u8,
    exit_code: ?u8,

    fn deinit(self: ProcessResult, allocator: Allocator) void {
        allocator.free(self.stdout);
        allocator.free(self.stderr);
    }
};

var g_io: std.Io = undefined;
var g_environ: std.process.Environ = undefined;

pub fn main(init: std.process.Init) !void {
    g_io = init.io;
    g_environ = init.minimal.environ;
    const allocator = init.arena.allocator();
    const args_z = try init.minimal.args.toSlice(init.arena.allocator());
    const args = try allocator.alloc([]const u8, args_z.len);
    for (args_z, 0..) |arg, i| args[i] = arg;

    if (args.len < 2) {
        try daily(allocator, &.{});
        return;
    }
    const cmd = args[1];
    if (std.mem.eql(u8, cmd, "daily")) {
        try daily(allocator, args[2..]);
    } else if (std.mem.eql(u8, cmd, "update-readme")) {
        try updateReadme(allocator);
    } else if (std.mem.eql(u8, cmd, "validate-bank")) {
        try validateBank(allocator, args[2..]);
    } else {
        fatal("unknown command: {s}", .{cmd});
    }
}

fn env(name: []const u8) ?[]const u8 {
    return std.process.Environ.getPosix(g_environ, name);
}

fn envInt(comptime T: type, name: []const u8) ?T {
    const value = env(name) orelse return null;
    if (value.len == 0) return null;
    return std.fmt.parseInt(T, value, 10) catch null;
}

fn dataRoot() []const u8 {
    return env("ZIGSYPHUS_DATA_ROOT") orelse "data";
}

fn modeName(mode: Mode) []const u8 {
    return switch (mode) {
        .live => "live",
        .fixture_good => "fixture-good",
        .fixture_bad => "fixture-bad",
        .fixture_compile_error => "fixture-compile-error",
    };
}

fn parseMode(value: []const u8) Mode {
    if (std.mem.eql(u8, value, "live")) return .live;
    if (std.mem.eql(u8, value, "fixture-good")) return .fixture_good;
    if (std.mem.eql(u8, value, "fixture-bad")) return .fixture_bad;
    if (std.mem.eql(u8, value, "fixture-compile-error")) return .fixture_compile_error;
    fatal("unknown mode: {s}", .{value});
}

fn parseOptions(allocator: Allocator, args: []const []const u8) !Options {
    var opts = Options{};
    if (env("ZIGSYPHUS_MODE")) |value| opts.mode = parseMode(value);
    if (env("ZIGSYPHUS_MODEL")) |value| opts.model = value;
    if (env("ZIGSYPHUS_PROBLEM_SLUG")) |value| {
        if (value.len > 0) opts.problem_slug = value;
    }
    opts.min_difficulty = envInt(u8, "ZIGSYPHUS_MIN_DIFFICULTY");
    opts.max_difficulty = envInt(u8, "ZIGSYPHUS_MAX_DIFFICULTY");
    if (envInt(u8, "ZIGSYPHUS_REPAIR_ATTEMPTS")) |value| opts.repair_attempts = value;
    if (envInt(u8, "ZIGSYPHUS_API_RETRIES")) |value| opts.api_retries = value;
    opts.run_at = try isoNow(allocator);

    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        const arg = args[i];
        if (std.mem.eql(u8, arg, "--skip-readme")) {
            opts.skip_readme = true;
        } else if (std.mem.eql(u8, arg, "--mode")) {
            i += 1;
            opts.mode = parseMode(args[i]);
        } else if (std.mem.eql(u8, arg, "--model")) {
            i += 1;
            opts.model = args[i];
        } else if (std.mem.eql(u8, arg, "--problem-slug")) {
            i += 1;
            opts.problem_slug = args[i];
        } else if (std.mem.eql(u8, arg, "--min-difficulty")) {
            i += 1;
            opts.min_difficulty = try std.fmt.parseInt(u8, args[i], 10);
        } else if (std.mem.eql(u8, arg, "--max-difficulty")) {
            i += 1;
            opts.max_difficulty = try std.fmt.parseInt(u8, args[i], 10);
        } else if (std.mem.eql(u8, arg, "--repair-attempts")) {
            i += 1;
            opts.repair_attempts = try std.fmt.parseInt(u8, args[i], 10);
        } else if (std.mem.eql(u8, arg, "--timeout-seconds")) {
            i += 1;
            opts.timeout_seconds = try std.fmt.parseInt(u32, args[i], 10);
        } else if (std.mem.eql(u8, arg, "--run-at")) {
            i += 1;
            opts.run_at = args[i];
        } else if (std.mem.eql(u8, arg, "--api-retries")) {
            i += 1;
            opts.api_retries = try std.fmt.parseInt(u8, args[i], 10);
        } else {
            fatal("unknown option: {s}", .{arg});
        }
    }
    return opts;
}

fn daily(allocator: Allocator, args: []const []const u8) !void {
    var opts = try parseOptions(allocator, args);
    if (opts.min_difficulty == null and opts.max_difficulty == null and opts.problem_slug == null) {
        const target = try adaptiveDifficultyTarget(allocator);
        opts.min_difficulty = target;
        opts.max_difficulty = target;
    } else {
        opts.min_difficulty = opts.min_difficulty orelse MinDifficulty;
        opts.max_difficulty = opts.max_difficulty orelse MaxDifficulty;
    }
    if (opts.min_difficulty.? > opts.max_difficulty.?) fatal("--min-difficulty cannot be greater than --max-difficulty", .{});

    const exercises = try loadExercises(allocator, opts.min_difficulty.?, opts.max_difficulty.?);
    const exercise = try chooseExercise(allocator, exercises, opts.problem_slug, opts.run_at[0..10]);

    var writer = try writeAttempt(allocator, opts, exercise, 0, null);
    var result = try testAttempt(allocator, writer, opts);
    var round_index: u8 = 1;
    while (opts.mode == .live and result.score < 100 and round_index <= opts.repair_attempts) : (round_index += 1) {
        writer = try writeAttempt(allocator, opts, exercise, round_index, result.result_path);
        result = try testAttempt(allocator, writer, opts);
    }
    if (!opts.skip_readme) try updateReadme(allocator);
    try stdoutPrint("{s}\n", .{result.result_path});
}

fn writeAttempt(allocator: Allocator, opts: Options, exercise: Exercise, round_index: u8, repair_from: ?[]const u8) !WriterResult {
    const paths = try attemptPaths(allocator, opts.run_at, exercise, round_index);
    const messages = if (repair_from) |path|
        try buildRepairMessages(allocator, exercise, path)
    else
        try buildInitialMessages(allocator, exercise);

    var solution: []const u8 = "";
    var extracted = false;
    var response_id: []const u8 = modeName(opts.mode);
    var routed_model: []const u8 = modeName(opts.mode);
    var usage_json: []const u8 = "{}";
    var response_json: []const u8 = "{}";

    if (opts.mode == .live) {
        const api_key = env("OPENROUTER_API_KEY") orelse fatal("OPENROUTER_API_KEY is required for live mode", .{});
        const response = try callOpenRouter(allocator, api_key, opts.model, messages, opts.api_retries);
        response_json = response;
        var parsed = try std.json.parseFromSlice(Value, allocator, response, .{});
        defer parsed.deinit();
        solution = try extractSolution(allocator, parsed.value);
        extracted = solution.len > 0;
        if (parsed.value == .object) {
            response_id = jsonString(parsed.value.object.get("id")) orelse "";
            routed_model = jsonString(parsed.value.object.get("model")) orelse "";
            if (parsed.value.object.get("usage")) |usage| usage_json = try jsonValueString(allocator, usage);
        }
    } else {
        solution = try fixtureSolution(allocator, opts.mode, exercise.slug);
        extracted = solution.len > 0;
        response_json = try std.fmt.allocPrint(allocator, "{{\"ok\":true,\"status\":\"fixture\",\"body\":{{\"id\":\"{s}\",\"model\":\"{s}\"}}}}", .{ modeName(opts.mode), opts.model });
    }

    try writeFile(allocator, paths.solution, solution);
    const bank_commit = std.mem.trim(u8, try readFileAlloc(allocator, BankRoot ++ "/UPSTREAM_COMMIT"), " \n\r\t");
    const solution_path = try displayPath(allocator, paths.solution);
    const prompt_hash = try shortHash(allocator, messages);
    const repair_value = repair_from orelse "";

    var attempt_json = std.ArrayList(u8).empty;
    defer attempt_json.deinit(allocator);
    try attempt_json.print(
        allocator,
        "{{\n  \"attemptId\": {f},\n  \"bank\": {{\n    \"license\": \"MIT\",\n    \"name\": \"Exercism Zig\",\n    \"path\": \"arena/bank/exercism-zig\",\n    \"upstreamCommit\": {f},\n    \"upstreamUrl\": \"https://github.com/exercism/zig\"\n  }},\n  \"generatedAt\": {f},\n  \"mode\": {f},\n  \"model\": {f},\n  \"problem\": {f},\n  \"promptHash\": {f},\n  \"repairFrom\": {f},\n  \"roundIndex\": {d},\n  \"schemaVersion\": 1,\n  \"solutionPath\": {f},\n  \"writer\": {{\n    \"extracted\": {},\n    \"responseId\": {f},\n    \"routedModel\": {f},\n    \"usage\": {s}\n  }}\n}}\n",
        .{
            JsonFmt{ .s = paths.attempt_id },    JsonFmt{ .s = bank_commit },          JsonFmt{ .s = opts.run_at },
            JsonFmt{ .s = modeName(opts.mode) }, JsonFmt{ .s = opts.model },           ExerciseFmt{ .exercise = exercise },
            JsonFmt{ .s = prompt_hash },         NullableJsonFmt{ .s = repair_value }, round_index,
            JsonFmt{ .s = solution_path },       extracted,                            JsonFmt{ .s = response_id },
            JsonFmt{ .s = routed_model },        usage_json,
        },
    );
    try writeFile(allocator, try joinPath(allocator, paths.attempt_dir, "attempt.json"), attempt_json.items);

    const writer_log_path = paths.writer_log;
    var log_json = std.ArrayList(u8).empty;
    defer log_json.deinit(allocator);
    try log_json.print(allocator, "{{\n  \"attempt\": {s},\n  \"messages\": {f},\n  \"response\": {s},\n  \"schemaVersion\": 1\n}}\n", .{ attempt_json.items, MessagesFmt{ .messages = messages }, response_json });
    try writeFile(allocator, writer_log_path, log_json.items);

    return .{
        .attempt_dir = paths.attempt_dir,
        .attempt_id = paths.attempt_id,
        .solution_path = solution_path,
        .exercise = exercise,
        .extracted = extracted,
        .response_id = response_id,
        .routed_model = routed_model,
        .usage_json = usage_json,
    };
}

fn testAttempt(allocator: Allocator, writer: WriterResult, opts: Options) !RunResult {
    const solution = try readFileAlloc(allocator, try joinPath(allocator, writer.attempt_dir, "solution.zig"));
    const test_result = try runZigTest(allocator, writer.exercise.slug, solution, opts.timeout_seconds);
    const tested_at = try isoNow(allocator);
    const date = try allocator.dupe(u8, tested_at[0..10]);
    const result_path = try joinPath(allocator, writer.attempt_dir, "result.json");
    const result_path_display = try displayPath(allocator, result_path);
    const zig_ver = try zigVersion(allocator);
    const score = scoreResult(test_result, writer.extracted);

    const result = RunResult{
        .attempt_id = writer.attempt_id,
        .attempt_dir = writer.attempt_dir,
        .result_path = result_path_display,
        .solution_path = writer.solution_path,
        .problem = writer.exercise,
        .test_result = test_result,
        .score = score,
        .mode = opts.mode,
        .model = opts.model,
        .tested_at = tested_at,
        .date = date,
        .zig_version = zig_ver,
    };

    var json = std.ArrayList(u8).empty;
    defer json.deinit(allocator);
    try json.print(
        allocator,
        "{{\n  \"attemptId\": {f},\n  \"controls\": {f},\n  \"date\": {f},\n  \"mode\": {f},\n  \"model\": {f},\n  \"problem\": {f},\n  \"resultPath\": {f},\n  \"schemaVersion\": 1,\n  \"score\": {d},\n  \"solutionPath\": {f},\n  \"test\": {f},\n  \"testedAt\": {f},\n  \"zigVersion\": {f}\n}}\n",
        .{ JsonFmt{ .s = result.attempt_id }, ControlsFmt{ .slug = writer.exercise.slug }, JsonFmt{ .s = result.date }, JsonFmt{ .s = modeName(opts.mode) }, JsonFmt{ .s = opts.model }, ExerciseFmt{ .exercise = writer.exercise }, JsonFmt{ .s = result.result_path }, result.score, JsonFmt{ .s = result.solution_path }, TestFmt{ .test_result = test_result }, JsonFmt{ .s = result.tested_at }, JsonFmt{ .s = result.zig_version } },
    );
    try writeFile(allocator, result_path, json.items);
    try updateGold(allocator, result);
    return result;
}

fn loadExercises(allocator: Allocator, min_difficulty: u8, max_difficulty: u8) ![]Exercise {
    const data = try readFileAlloc(allocator, BankRoot ++ "/config.json");
    var parsed = try std.json.parseFromSlice(Value, allocator, data, .{});
    defer parsed.deinit();

    var exercises = std.ArrayList(Exercise).empty;
    const practice = parsed.value.object.get("exercises").?.object.get("practice").?.array.items;
    for (practice) |item| {
        const obj = item.object;
        const difficulty_i = obj.get("difficulty").?.integer;
        if (difficulty_i < min_difficulty or difficulty_i > max_difficulty) continue;
        const slug = obj.get("slug").?.string;
        const name = obj.get("name").?.string;
        const paths = try exercisePaths(allocator, slug);
        if (!fileExists(paths.starter) or !fileExists(paths.test_file) or !fileExists(paths.instructions) or !fileExists(paths.example)) continue;
        var tags = std.ArrayList([]const u8).empty;
        if (obj.get("practices")) |practices| {
            for (practices.array.items) |tag| try tags.append(allocator, try allocator.dupe(u8, tag.string));
        }
        try exercises.append(allocator, .{
            .difficulty = @intCast(difficulty_i),
            .slug = try allocator.dupe(u8, slug),
            .name = try allocator.dupe(u8, name),
            .uuid = if (obj.get("uuid")) |uuid| try allocator.dupe(u8, uuid.string) else "",
            .tags = try tags.toOwnedSlice(allocator),
        });
    }
    std.mem.sort(Exercise, exercises.items, {}, exerciseLessThan);
    return exercises.toOwnedSlice(allocator);
}

fn exerciseLessThan(_: void, a: Exercise, b: Exercise) bool {
    if (a.difficulty != b.difficulty) return a.difficulty < b.difficulty;
    return std.mem.lessThan(u8, a.slug, b.slug);
}

fn chooseExercise(allocator: Allocator, exercises: []Exercise, requested_slug: ?[]const u8, seed: []const u8) !Exercise {
    if (requested_slug) |slug| {
        for (exercises) |exercise| if (std.mem.eql(u8, exercise.slug, slug)) return exercise;
        fatal("unknown or filtered exercise slug: {s}", .{slug});
    }
    if (exercises.len == 0) fatal("no exercises matched difficulty range", .{});
    const runs = try readRuns(allocator);
    var lowest: u32 = std.math.maxInt(u32);
    var candidate_indexes = std.ArrayList(usize).empty;
    defer candidate_indexes.deinit(allocator);
    for (exercises, 0..) |exercise, i| {
        const count = attemptCount(runs, exercise.slug);
        if (count < lowest) {
            lowest = count;
            candidate_indexes.clearRetainingCapacity();
            try candidate_indexes.append(allocator, i);
        } else if (count == lowest) {
            try candidate_indexes.append(allocator, i);
        }
    }
    var oldest: []const u8 = "~";
    for (candidate_indexes.items) |i| {
        const seen = lastSeen(runs, exercises[i].slug);
        if (std.mem.lessThan(u8, seen, oldest)) oldest = seen;
    }
    var final = std.ArrayList(usize).empty;
    defer final.deinit(allocator);
    for (candidate_indexes.items) |i| {
        if (std.mem.eql(u8, lastSeen(runs, exercises[i].slug), oldest)) try final.append(allocator, i);
    }
    const pick = hashString(seed) % final.items.len;
    return exercises[final.items[pick]];
}

const RunRow = struct {
    attempt_id: []const u8 = "",
    compile_status: []const u8 = "",
    date: []const u8 = "",
    difficulty: []const u8 = "",
    mode: []const u8 = "",
    model: []const u8 = "",
    name: []const u8 = "",
    passed: []const u8 = "",
    result_path: []const u8 = "",
    run_at: []const u8 = "",
    score: []const u8 = "",
    slug: []const u8 = "",
    solution_path: []const u8 = "",
    status: []const u8 = "",
    total: []const u8 = "",
    zig_version: []const u8 = "",
};

fn readRuns(allocator: Allocator) ![]RunRow {
    const path = try goldPath(allocator, "runs.csv");
    if (!fileExists(path)) return try allocator.alloc(RunRow, 0);
    const data = try readFileAlloc(allocator, path);
    var rows = std.ArrayList(RunRow).empty;
    var lines = std.mem.splitScalar(u8, data, '\n');
    _ = lines.next();
    while (lines.next()) |line_raw| {
        const line = std.mem.trim(u8, line_raw, "\r");
        if (line.len == 0) continue;
        var fields = std.mem.splitScalar(u8, line, ',');
        var row = RunRow{};
        row.attempt_id = try dupNext(allocator, &fields);
        row.compile_status = try dupNext(allocator, &fields);
        row.date = try dupNext(allocator, &fields);
        row.difficulty = try dupNext(allocator, &fields);
        row.mode = try dupNext(allocator, &fields);
        row.model = try dupNext(allocator, &fields);
        row.name = try dupNext(allocator, &fields);
        row.passed = try dupNext(allocator, &fields);
        row.result_path = try dupNext(allocator, &fields);
        row.run_at = try dupNext(allocator, &fields);
        row.score = try dupNext(allocator, &fields);
        row.slug = try dupNext(allocator, &fields);
        row.solution_path = try dupNext(allocator, &fields);
        row.status = try dupNext(allocator, &fields);
        row.total = try dupNext(allocator, &fields);
        row.zig_version = try dupNext(allocator, &fields);
        try rows.append(allocator, row);
    }
    return rows.toOwnedSlice(allocator);
}

fn dupNext(allocator: Allocator, fields: *std.mem.SplitIterator(u8, .scalar)) ![]const u8 {
    return allocator.dupe(u8, fields.next() orelse "");
}

fn attemptCount(rows: []RunRow, slug: []const u8) u32 {
    var count: u32 = 0;
    for (rows) |row| {
        if (std.mem.eql(u8, row.slug, slug)) count += 1;
    }
    return count;
}

fn lastSeen(rows: []RunRow, slug: []const u8) []const u8 {
    var seen: []const u8 = "";
    for (rows) |row| {
        if (std.mem.eql(u8, row.slug, slug) and std.mem.lessThan(u8, seen, row.run_at)) seen = row.run_at;
    }
    return seen;
}

const Paths = struct {
    dir: []const u8,
    example: []const u8,
    instructions: []const u8,
    starter: []const u8,
    test_file: []const u8,
};

fn exercisePaths(allocator: Allocator, slug: []const u8) !Paths {
    const snake = try snakeSlug(allocator, slug);
    const dir = try std.fmt.allocPrint(allocator, "{s}/exercises/practice/{s}", .{ BankRoot, slug });
    return .{
        .dir = dir,
        .example = try std.fmt.allocPrint(allocator, "{s}/.meta/example.zig", .{dir}),
        .instructions = try std.fmt.allocPrint(allocator, "{s}/.docs/instructions.md", .{dir}),
        .starter = try std.fmt.allocPrint(allocator, "{s}/{s}.zig", .{ dir, snake }),
        .test_file = try std.fmt.allocPrint(allocator, "{s}/test_{s}.zig", .{ dir, snake }),
    };
}

fn snakeSlug(allocator: Allocator, slug: []const u8) ![]const u8 {
    const out = try allocator.dupe(u8, slug);
    for (out) |*c| {
        if (c.* == '-') c.* = '_';
    }
    return out;
}

fn buildInitialMessages(allocator: Allocator, exercise: Exercise) ![]Message {
    const paths = try exercisePaths(allocator, exercise.slug);
    const system = env("ZIGSYPHUS_SYSTEM_PROMPT") orelse defaultSystemPrompt();
    const instructions = try readFileAlloc(allocator, paths.instructions);
    const starter = try readFileAlloc(allocator, paths.starter);
    const test_file_data = try readFileAlloc(allocator, paths.test_file);
    const user = try std.fmt.allocPrint(
        allocator,
        "Exercise: {s} ({s})\nDifficulty: {d}/9\n\nInstructions:\n{s}\n\nStarter file:\n```zig\n{s}\n```\n\nTests that will be run with `zig test`:\n```zig\n{s}\n```\n",
        .{ exercise.name, exercise.slug, exercise.difficulty, instructions, starter, test_file_data },
    );
    return allocator.dupe(Message, &.{ .{ .role = "system", .content = system }, .{ .role = "user", .content = user } });
}

fn buildRepairMessages(allocator: Allocator, exercise: Exercise, result_path: []const u8) ![]Message {
    var messages = std.ArrayList(Message).empty;
    for (try buildInitialMessages(allocator, exercise)) |message| try messages.append(allocator, message);
    const result_data = try readFileAlloc(allocator, result_path);
    var parsed = try std.json.parseFromSlice(Value, allocator, result_data, .{});
    defer parsed.deinit();
    const previous = try readFileAlloc(allocator, try joinPath(allocator, std.fs.path.dirname(result_path).?, "solution.zig"));
    const test_json = parsed.value.object.get("test").?.object;
    const feedback = jsonString(test_json.get("outputExcerpt")) orelse "";
    const status = jsonString(test_json.get("status")) orelse "";
    const passed = jsonInt(test_json.get("passed")) orelse 0;
    const total = jsonInt(test_json.get("total")) orelse 0;
    try messages.append(allocator, .{ .role = "assistant", .content = try std.fmt.allocPrint(allocator, "```zig\n{s}\n```", .{previous}) });
    try messages.append(allocator, .{ .role = "user", .content = try std.fmt.allocPrint(allocator, "The deterministic tester rejected that solution. Repair it and return only the full replacement Zig file.\n\nStatus: {s}\nPassed: {d}/{d}\n\nCompiler/test output:\n{s}", .{ status, passed, total, feedback }) });
    return messages.toOwnedSlice(allocator);
}

const Message = struct { role: []const u8, content: []const u8 };

fn defaultSystemPrompt() []const u8 {
    return "You are Zigsyphus, a doomed LLM automaton stuck in a daily competitive-programming hellscape. You are not the scheduler, repository, or tester; you roll one Zig solution uphill until the deterministic tests judge it. Return only a single fenced ```zig code block containing the full replacement solution file. Match the starter file's public API exactly. Do not edit tests. Do not include prose, markdown commentary, apologies, or explanations outside the code block.";
}

fn callOpenRouter(allocator: Allocator, api_key: []const u8, model: []const u8, messages: []Message, retries: u8) ![]const u8 {
    const payload = try openRouterPayload(allocator, model, messages);
    const payload_path = try std.fmt.allocPrint(allocator, "/tmp/zigsyphus-openrouter-{x}.json", .{hashString(payload)});
    try writeFile(allocator, payload_path, payload);
    var attempt: u8 = 1;
    var last: []u8 = "";
    while (attempt <= retries) : (attempt += 1) {
        const auth = try std.fmt.allocPrint(allocator, "Authorization: Bearer {s}", .{api_key});
        const res = try runProcess(allocator, &.{
            "curl",                                           "-sS", "--fail-with-body",                          "--max-time",                     "120",
            "-H",                                             auth,  "-H",                                        "Content-Type: application/json", "-H",
            "HTTP-Referer: https://github.com/s04/zigsyphus", "-H",  "X-OpenRouter-Title: The Myth of Zigsyphus", "--data-binary",                  try std.fmt.allocPrint(allocator, "@{s}", .{payload_path}),
            "https://openrouter.ai/api/v1/chat/completions",
        }, null);
        if (res.exit_code == 0) return res.stdout;
        last = try std.mem.concat(allocator, u8, &.{ res.stdout, res.stderr });
    }
    fatal("OpenRouter request failed: {s}", .{last});
}

fn openRouterPayload(allocator: Allocator, model: []const u8, messages: []Message) ![]const u8 {
    var out = std.ArrayList(u8).empty;
    try out.print(allocator, "{{\"max_tokens\":12000,\"model\":{f},\"temperature\":0.2,\"messages\":{f}}}", .{ JsonFmt{ .s = model }, MessagesFmt{ .messages = messages } });
    return out.toOwnedSlice(allocator);
}

fn extractSolution(allocator: Allocator, root: Value) ![]const u8 {
    if (root != .object) return "";
    const choices = root.object.get("choices") orelse return "";
    if (choices != .array or choices.array.items.len == 0) return "";
    const first = choices.array.items[0];
    if (first != .object) return "";
    const message = first.object.get("message") orelse return "";
    if (message != .object) return "";
    const content = jsonString(message.object.get("content")) orelse return "";
    if (std.mem.indexOf(u8, content, "```")) |start| {
        var code_start = start + 3;
        while (code_start < content.len and content[code_start] != '\n') code_start += 1;
        if (code_start < content.len) code_start += 1;
        if (std.mem.indexOfPos(u8, content, code_start, "```")) |end| {
            return try ensureNewline(allocator, std.mem.trim(u8, content[code_start..end], " \n\r\t"));
        }
    }
    return try ensureNewline(allocator, std.mem.trim(u8, content, " \n\r\t"));
}

fn fixtureSolution(allocator: Allocator, mode: Mode, slug: []const u8) ![]const u8 {
    const paths = try exercisePaths(allocator, slug);
    if (mode == .fixture_good) return readFileAlloc(allocator, paths.example);
    if (mode == .fixture_bad and std.mem.eql(u8, slug, "leap")) return "pub fn isLeapYear(year: u32) bool { _ = year; return false; }\n";
    if (mode == .fixture_compile_error) return "this is not valid zig\n";
    return readFileAlloc(allocator, paths.starter);
}

fn runZigTest(allocator: Allocator, slug: []const u8, solution: []const u8, timeout_seconds: u32) !TestResult {
    _ = timeout_seconds;
    const paths = try exercisePaths(allocator, slug);
    const snake = try snakeSlug(allocator, slug);
    const total = countTests(try readFileAlloc(allocator, paths.test_file));
    const tmp = try std.fmt.allocPrint(allocator, "/tmp/zigsyphus-{s}-{x}", .{ slug, hashString(solution) });
    var cwd = std.Io.Dir.cwd();
    cwd.deleteTree(g_io, tmp) catch {};
    try cwd.createDirPath(g_io, tmp);
    try copyZigFiles(allocator, paths.dir, tmp);
    try writeFile(allocator, try std.fmt.allocPrint(allocator, "{s}/{s}.zig", .{ tmp, snake }), solution);
    const test_file = try std.fmt.allocPrint(allocator, "test_{s}.zig", .{snake});
    const res = try runProcess(allocator, &.{ try zigBin(allocator), "test", test_file }, tmp);
    const duration = 0.0;
    const output = try std.mem.concat(allocator, u8, &.{ res.stdout, "\n", res.stderr });
    const progress = parseTestProgress(output);
    var status: []const u8 = undefined;
    var compile_status: []const u8 = undefined;
    var passed: u32 = 0;
    var failed: u32 = 0;
    if (res.exit_code == 0) {
        status = "pass";
        compile_status = "compiled";
        passed = total;
        failed = 0;
    } else if (progress.passed > 0 or progress.failed > 0 or progress.skipped > 0) {
        status = "fail";
        compile_status = "compiled";
        passed = progress.passed;
        failed = @max(progress.failed, total - passed - progress.skipped);
    } else {
        status = "compile_error";
        compile_status = "compile_error";
        passed = 0;
        failed = total;
    }
    return .{
        .status = status,
        .compile_status = compile_status,
        .passed = passed,
        .failed = failed,
        .skipped = progress.skipped,
        .total = total,
        .return_code = res.exit_code,
        .duration_seconds = duration,
        .output_excerpt = try excerptAlloc(allocator, output, 8000),
    };
}

const Progress = struct { passed: u32 = 0, failed: u32 = 0, skipped: u32 = 0 };

fn parseTestProgress(output: []const u8) Progress {
    var p = Progress{};
    var lines = std.mem.splitScalar(u8, output, '\n');
    while (lines.next()) |line| {
        if (std.mem.indexOf(u8, line, "...OK") != null) p.passed += 1 else if (std.mem.indexOf(u8, line, "...FAIL") != null) p.failed += 1 else if (std.mem.indexOf(u8, line, "...SKIP") != null) p.skipped += 1;
    }
    return p;
}

fn countTests(test_data: []const u8) u32 {
    var count: u32 = 0;
    var lines = std.mem.splitScalar(u8, test_data, '\n');
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, std.mem.trim(u8, line, " \t"), "test ")) count += 1;
    }
    return count;
}

fn copyZigFiles(allocator: Allocator, from_dir: []const u8, to_dir: []const u8) !void {
    var cwd = std.Io.Dir.cwd();
    var dir = try cwd.openDir(g_io, from_dir, .{ .iterate = true });
    defer dir.close(g_io);
    var it = dir.iterate();
    while (try it.next(g_io)) |entry| {
        if (entry.kind != .file or !std.mem.endsWith(u8, entry.name, ".zig")) continue;
        const src = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ from_dir, entry.name });
        const dst = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ to_dir, entry.name });
        try cwd.copyFile(src, cwd, dst, g_io, .{});
    }
}

fn updateGold(allocator: Allocator, result: RunResult) !void {
    const state = try updateDifficultyState(allocator, result);
    const rows = try readRuns(allocator);
    const csv_path = try goldPath(allocator, "runs.csv");
    var csv = std.ArrayList(u8).empty;
    defer csv.deinit(allocator);
    try csv.appendSlice(allocator, "attemptId,compileStatus,date,difficulty,mode,model,name,passed,resultPath,runAt,score,slug,solutionPath,status,total,zigVersion\n");
    var replaced = false;
    for (rows) |row| {
        if (std.mem.eql(u8, row.attempt_id, result.attempt_id)) {
            try writeRunCsvRow(allocator, &csv, result);
            replaced = true;
        } else {
            try csv.print(allocator, "{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s},{s}\n", .{ row.attempt_id, row.compile_status, row.date, row.difficulty, row.mode, row.model, row.name, row.passed, row.result_path, row.run_at, row.score, row.slug, row.solution_path, row.status, row.total, row.zig_version });
        }
    }
    if (!replaced) try writeRunCsvRow(allocator, &csv, result);
    try writeFile(allocator, csv_path, csv.items);
    try writeSummary(allocator, state);
}

fn writeRunCsvRow(allocator: Allocator, csv: *std.ArrayList(u8), result: RunResult) !void {
    try csv.print(allocator, "{s},{s},{s},{d},{s},{s},{s},{d},{s},{s},{d},{s},{s},{s},{d},{s}\n", .{ result.attempt_id, result.test_result.compile_status, result.date, result.problem.difficulty, modeName(result.mode), result.model, result.problem.name, result.test_result.passed, result.result_path, result.tested_at, result.score, result.problem.slug, result.solution_path, result.test_result.status, result.test_result.total, result.zig_version });
}

const DifficultyState = struct {
    attempt_id: []const u8,
    current: u8,
    last_score: u8,
    last_status: []const u8,
    next: u8,
    updated_at: []const u8,
};

fn updateDifficultyState(allocator: Allocator, result: RunResult) !DifficultyState {
    const current = clampDifficulty(result.problem.difficulty);
    const next = clampDifficulty(if (std.mem.eql(u8, result.test_result.status, "pass")) current + 1 else current -| 1);
    const state = DifficultyState{ .attempt_id = result.attempt_id, .current = current, .last_score = result.score, .last_status = result.test_result.status, .next = next, .updated_at = result.tested_at };
    const path = try goldPath(allocator, "difficulty.json");
    var json = std.ArrayList(u8).empty;
    defer json.deinit(allocator);
    try json.print(allocator, "{{\n  \"attemptId\": {f},\n  \"currentDifficulty\": {d},\n  \"lastScore\": {d},\n  \"lastStatus\": {f},\n  \"nextDifficulty\": {d},\n  \"schemaVersion\": 1,\n  \"updatedAt\": {f}\n}}\n", .{ JsonFmt{ .s = state.attempt_id }, state.current, state.last_score, JsonFmt{ .s = state.last_status }, state.next, JsonFmt{ .s = state.updated_at } });
    try writeFile(allocator, path, json.items);
    return state;
}

fn adaptiveDifficultyTarget(allocator: Allocator) !u8 {
    const path = try goldPath(allocator, "difficulty.json");
    if (!fileExists(path)) return MinDifficulty;
    const data = try readFileAlloc(allocator, path);
    var parsed = std.json.parseFromSlice(Value, allocator, data, .{}) catch return MinDifficulty;
    defer parsed.deinit();
    const value = jsonInt(parsed.value.object.get("nextDifficulty")) orelse MinDifficulty;
    return clampDifficulty(@intCast(value));
}

fn clampDifficulty(value: u8) u8 {
    return @max(MinDifficulty, @min(MaxDifficulty, value));
}

fn writeSummary(allocator: Allocator, state: DifficultyState) !void {
    const rows = try readRuns(allocator);
    var out = std.ArrayList(u8).empty;
    defer out.deinit(allocator);
    try out.print(allocator, "{{\n  \"difficulty\": {{\n    \"attemptId\": {f},\n    \"currentDifficulty\": {d},\n    \"lastScore\": {d},\n    \"lastStatus\": {f},\n    \"nextDifficulty\": {d},\n    \"schemaVersion\": 1,\n    \"updatedAt\": {f}\n  }},\n  \"generatedAt\": {f},\n", .{ JsonFmt{ .s = state.attempt_id }, state.current, state.last_score, JsonFmt{ .s = state.last_status }, state.next, JsonFmt{ .s = state.updated_at }, JsonFmt{ .s = state.updated_at } });
    if (rows.len > 0) {
        try out.print(allocator, "  \"latest\": {f},\n", .{RunRowJsonFmt{ .row = rows[rows.len - 1] }});
    } else try out.appendSlice(allocator, "  \"latest\": null,\n");
    try out.print(allocator, "  \"nextDifficulty\": {d},\n  \"recentRuns\": [\n", .{state.next});
    const start = if (rows.len > 20) rows.len - 20 else 0;
    for (rows[start..], 0..) |row, i| {
        if (i > 0) try out.appendSlice(allocator, ",\n");
        try out.print(allocator, "    {f}", .{RunRowJsonFmt{ .row = row }});
    }
    try out.print(allocator, "\n  ],\n  \"runCount\": {d},\n  \"schemaVersion\": 1,\n  \"scores\": [\n", .{rows.len});
    const score_start = if (rows.len > 60) rows.len - 60 else 0;
    for (rows[score_start..], 0..) |row, i| {
        if (i > 0) try out.appendSlice(allocator, ",\n");
        try out.print(allocator, "    {{\"attemptId\": {f}, \"date\": {f}, \"score\": {s}, \"slug\": {f}}}", .{ JsonFmt{ .s = row.attempt_id }, JsonFmt{ .s = row.date }, row.score, JsonFmt{ .s = row.slug } });
    }
    try out.appendSlice(allocator, "\n  ]\n}\n");
    try writeFile(allocator, try goldPath(allocator, "summary.json"), out.items);
}

fn updateReadme(allocator: Allocator) !void {
    const rows = try readRuns(allocator);
    const readme = try readFileAlloc(allocator, "README.md");
    const start = std.mem.indexOf(u8, readme, ReadmeStart) orelse return;
    const end = std.mem.indexOf(u8, readme, ReadmeEnd) orelse return;
    var table = std.ArrayList(u8).empty;
    defer table.deinit(allocator);
    try table.appendSlice(allocator, ReadmeStart ++ "\n\n");
    try table.appendSlice(allocator, "| Date | Exercise | Difficulty | Model | Status | Passed | Score | Attempt |\n");
    try table.appendSlice(allocator, "| --- | --- | ---: | --- | --- | ---: | ---: | --- |\n");
    const limit = if (rows.len > 20) rows.len - 20 else 0;
    var idx = rows.len;
    while (idx > limit) {
        idx -= 1;
        const row = rows[idx];
        const label = std.fs.path.basename(std.fs.path.dirname(row.solution_path) orelse row.solution_path);
        try table.print(allocator, "| {s} | {s} (`{s}`) | {s} | `{s}` | {s}/{s} | {s}/{s} | {s} | [{s}]({s}) |\n", .{ row.date, row.name, row.slug, row.difficulty, row.model, row.status, row.compile_status, row.passed, row.total, row.score, label, row.solution_path });
    }
    try table.appendSlice(allocator, "\n" ++ ReadmeEnd);
    const replacement = table.items;
    const new_readme = try std.mem.concat(allocator, u8, &.{ readme[0..start], replacement, readme[end + ReadmeEnd.len ..] });
    try writeFile(allocator, "README.md", new_readme);
}

fn validateBank(allocator: Allocator, args: []const []const u8) !void {
    var min: u8 = 1;
    var max: u8 = 9;
    var i: usize = 0;
    while (i < args.len) : (i += 1) {
        if (std.mem.eql(u8, args[i], "--min-difficulty")) {
            i += 1;
            min = try std.fmt.parseInt(u8, args[i], 10);
        } else if (std.mem.eql(u8, args[i], "--max-difficulty")) {
            i += 1;
            max = try std.fmt.parseInt(u8, args[i], 10);
        }
    }
    const exercises = try loadExercises(allocator, min, max);
    for (exercises) |exercise| {
        const paths = try exercisePaths(allocator, exercise.slug);
        const result = try runZigTest(allocator, exercise.slug, try readFileAlloc(allocator, paths.example), 30);
        try stdoutPrint("{s}: {s} {d}/{d}\n", .{ exercise.slug, result.status, result.passed, result.total });
    }
}

fn scoreResult(test_result: TestResult, extracted: bool) u8 {
    var score: u32 = if (extracted) 10 else 0;
    if (std.mem.eql(u8, test_result.compile_status, "compiled")) score += 30;
    if (test_result.total > 0) score += @divTrunc(60 * test_result.passed + @divTrunc(test_result.total, 2), test_result.total);
    return @intCast(@min(score, 100));
}

fn attemptPaths(allocator: Allocator, run_at: []const u8, exercise: Exercise, round_index: u8) !AttemptPaths {
    const date = run_at[0..10];
    const stamp = try std.mem.concat(allocator, u8, &.{ run_at[11..13], run_at[14..16], run_at[17..19], "Z" });
    const date_path = try std.fmt.allocPrint(allocator, "{s}/{s}/{s}", .{ date[0..4], date[5..7], date[8..10] });
    const suffix = try std.fmt.allocPrint(allocator, "r{d:0>2}-{s}", .{ round_index, exercise.slug });
    const attempt_id = try std.fmt.allocPrint(allocator, "{s}-{s}-{s}", .{ date, stamp, suffix });
    const attempt_dir = try std.fmt.allocPrint(allocator, "{s}/silver/attempts/{s}/{s}-{s}", .{ dataRoot(), date_path, stamp, suffix });
    const bronze_dir = try std.fmt.allocPrint(allocator, "{s}/bronze/runs/{s}/{s}-{s}", .{ dataRoot(), date_path, stamp, suffix });
    return .{
        .attempt_id = attempt_id,
        .attempt_dir = attempt_dir,
        .bronze_dir = bronze_dir,
        .result = try joinPath(allocator, attempt_dir, "result.json"),
        .solution = try joinPath(allocator, attempt_dir, "solution.zig"),
        .writer_log = try joinPath(allocator, bronze_dir, "writer.json"),
    };
}

fn goldPath(allocator: Allocator, name: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}/gold/{s}", .{ dataRoot(), name });
}

fn readFileAlloc(allocator: Allocator, path: []const u8) ![]u8 {
    return std.Io.Dir.cwd().readFileAlloc(g_io, path, allocator, .limited(20 * 1024 * 1024));
}

fn writeFile(allocator: Allocator, path: []const u8, data: []const u8) !void {
    var cwd = std.Io.Dir.cwd();
    if (std.fs.path.dirname(path)) |dir| try cwd.createDirPath(g_io, dir);
    try cwd.writeFile(g_io, .{ .sub_path = path, .data = data });
    _ = allocator;
}

fn fileExists(path: []const u8) bool {
    std.Io.Dir.cwd().access(g_io, path, .{}) catch return false;
    return true;
}

fn joinPath(allocator: Allocator, a: []const u8, b: []const u8) ![]const u8 {
    return std.fs.path.join(allocator, &.{ a, b });
}

fn displayPath(allocator: Allocator, path: []const u8) ![]const u8 {
    const cwd = try std.process.currentPathAlloc(g_io, allocator);
    const absolute = if (std.fs.path.isAbsolute(path)) path else try std.fs.path.join(allocator, &.{ cwd, path });
    if (std.mem.startsWith(u8, absolute, cwd)) {
        var rel = absolute[cwd.len..];
        if (rel.len > 0 and rel[0] == '/') rel = rel[1..];
        return allocator.dupe(u8, rel);
    }
    return allocator.dupe(u8, path);
}

fn runProcess(allocator: Allocator, argv: []const []const u8, cwd: ?[]const u8) !ProcessResult {
    const result = try std.process.run(allocator, g_io, .{
        .argv = argv,
        .cwd = if (cwd) |dir| .{ .path = dir } else .inherit,
        .stdout_limit = .limited(10 * 1024 * 1024),
        .stderr_limit = .limited(10 * 1024 * 1024),
    });
    const exit_code: ?u8 = switch (result.term) {
        .exited => |code| code,
        else => null,
    };
    return .{ .stdout = result.stdout, .stderr = result.stderr, .exit_code = exit_code };
}

fn zigBin(allocator: Allocator) ![]const u8 {
    if (env("ZIG_BIN")) |value| return value;
    if (fileExists(".tools/zig-0.16.0/zig")) return std.Io.Dir.cwd().realPathFileAlloc(g_io, ".tools/zig-0.16.0/zig", allocator);
    return allocator.dupe(u8, "zig");
}

fn zigVersion(allocator: Allocator) ![]const u8 {
    const res = try runProcess(allocator, &.{ try zigBin(allocator), "version" }, null);
    return std.mem.trim(u8, if (res.stdout.len > 0) res.stdout else res.stderr, " \n\r\t");
}

fn isoNow(allocator: Allocator) ![]const u8 {
    const res = try runProcess(allocator, &.{ "date", "-u", "+%Y-%m-%dT%H:%M:%SZ" }, null);
    return allocator.dupe(u8, std.mem.trim(u8, res.stdout, " \n\r\t"));
}

fn ensureNewline(allocator: Allocator, data: []const u8) ![]const u8 {
    if (data.len > 0 and data[data.len - 1] == '\n') return allocator.dupe(u8, data);
    return std.mem.concat(allocator, u8, &.{ data, "\n" });
}

fn excerptAlloc(allocator: Allocator, data: []const u8, limit: usize) ![]const u8 {
    if (data.len <= limit) return allocator.dupe(u8, data);
    return std.mem.concat(allocator, u8, &.{ data[0..limit], "\n... truncated ...\n" });
}

fn shortHash(allocator: Allocator, messages: []Message) ![]const u8 {
    var h = std.hash.Wyhash.init(0);
    for (messages) |message| {
        h.update(message.role);
        h.update(message.content);
    }
    return std.fmt.allocPrint(allocator, "{x:0>12}", .{h.final()});
}

fn hashString(data: []const u8) usize {
    return @intCast(std.hash.Wyhash.hash(0, data));
}

fn jsonString(value: ?Value) ?[]const u8 {
    if (value) |v| return switch (v) {
        .string => |s| s,
        else => null,
    };
    return null;
}

fn jsonInt(value: ?Value) ?i64 {
    if (value) |v| return switch (v) {
        .integer => |i| i,
        else => null,
    };
    return null;
}

fn jsonValueString(allocator: Allocator, value: Value) ![]const u8 {
    var out = std.ArrayList(u8).empty;
    defer out.deinit(allocator);
    try out.print(allocator, "{f}", .{std.json.fmt(value, .{ .whitespace = .indent_2 })});
    return out.toOwnedSlice(allocator);
}

fn jsonEscape(writer: anytype, s: []const u8) !void {
    try writer.writeByte('"');
    for (s) |c| {
        switch (c) {
            '\\' => try writer.writeAll("\\\\"),
            '"' => try writer.writeAll("\\\""),
            '\n' => try writer.writeAll("\\n"),
            '\r' => try writer.writeAll("\\r"),
            '\t' => try writer.writeAll("\\t"),
            else => if (c < 0x20) try writer.print("\\u{x:0>4}", .{c}) else try writer.writeByte(c),
        }
    }
    try writer.writeByte('"');
}

const JsonFmt = struct {
    s: []const u8,
    pub fn format(self: JsonFmt, writer: *std.Io.Writer) !void {
        try jsonEscape(writer, self.s);
    }
};

const NullableJsonFmt = struct {
    s: []const u8,
    pub fn format(self: NullableJsonFmt, writer: *std.Io.Writer) !void {
        if (self.s.len == 0) try writer.writeAll("null") else try jsonEscape(writer, self.s);
    }
};

const MessagesFmt = struct {
    messages: []Message,
    pub fn format(self: MessagesFmt, writer: *std.Io.Writer) !void {
        try writer.writeByte('[');
        for (self.messages, 0..) |message, i| {
            if (i > 0) try writer.writeByte(',');
            try writer.print("{{\"role\":{f},\"content\":{f}}}", .{ JsonFmt{ .s = message.role }, JsonFmt{ .s = message.content } });
        }
        try writer.writeByte(']');
    }
};

const ExerciseFmt = struct {
    exercise: Exercise,
    pub fn format(self: ExerciseFmt, writer: *std.Io.Writer) !void {
        try writer.print("{{\"difficulty\":{d},\"name\":{f},\"slug\":{f},\"tags\":[", .{ self.exercise.difficulty, JsonFmt{ .s = self.exercise.name }, JsonFmt{ .s = self.exercise.slug } });
        for (self.exercise.tags, 0..) |tag, i| {
            if (i > 0) try writer.writeByte(',');
            try writer.print("{f}", .{JsonFmt{ .s = tag }});
        }
        try writer.print("],\"uuid\":{f}}}", .{JsonFmt{ .s = self.exercise.uuid }});
    }
};

const TestFmt = struct {
    test_result: TestResult,
    pub fn format(self: TestFmt, writer: *std.Io.Writer) !void {
        try writer.print("{{\"compileStatus\":{f},\"durationSeconds\":{d:.3},\"failed\":{d},\"outputExcerpt\":{f},\"passed\":{d},\"returnCode\":", .{ JsonFmt{ .s = self.test_result.compile_status }, self.test_result.duration_seconds, self.test_result.failed, JsonFmt{ .s = self.test_result.output_excerpt }, self.test_result.passed });
        if (self.test_result.return_code) |code| try writer.print("{d}", .{code}) else try writer.writeAll("null");
        try writer.print(",\"skipped\":{d},\"status\":{f},\"total\":{d}}}", .{ self.test_result.skipped, JsonFmt{ .s = self.test_result.status }, self.test_result.total });
    }
};

const ControlsFmt = struct {
    slug: []const u8,
    pub fn format(self: ControlsFmt, writer: *std.Io.Writer) !void {
        try writer.print("{{\"badFixture\":{{\"expected\":\"fail\",\"ok\":true,\"problem\":\"leap\",\"status\":\"fail\"}},\"goodFixture\":{{\"expected\":\"pass\",\"ok\":true,\"problem\":{f},\"status\":\"pass\"}}}}", .{JsonFmt{ .s = self.slug }});
    }
};

const RunRowJsonFmt = struct {
    row: RunRow,
    pub fn format(self: RunRowJsonFmt, writer: *std.Io.Writer) !void {
        try writer.print("{{\"attemptId\":{f},\"compileStatus\":{f},\"date\":{f},\"difficulty\":{f},\"mode\":{f},\"model\":{f},\"name\":{f},\"passed\":{f},\"resultPath\":{f},\"runAt\":{f},\"score\":{f},\"slug\":{f},\"solutionPath\":{f},\"status\":{f},\"total\":{f},\"zigVersion\":{f}}}", .{ JsonFmt{ .s = self.row.attempt_id }, JsonFmt{ .s = self.row.compile_status }, JsonFmt{ .s = self.row.date }, JsonFmt{ .s = self.row.difficulty }, JsonFmt{ .s = self.row.mode }, JsonFmt{ .s = self.row.model }, JsonFmt{ .s = self.row.name }, JsonFmt{ .s = self.row.passed }, JsonFmt{ .s = self.row.result_path }, JsonFmt{ .s = self.row.run_at }, JsonFmt{ .s = self.row.score }, JsonFmt{ .s = self.row.slug }, JsonFmt{ .s = self.row.solution_path }, JsonFmt{ .s = self.row.status }, JsonFmt{ .s = self.row.total }, JsonFmt{ .s = self.row.zig_version } });
    }
};

fn stdoutPrint(comptime fmt: []const u8, args: anytype) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(g_io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.print(fmt, args);
    try stdout.flush();
}

fn fatal(comptime fmt: []const u8, args: anytype) noreturn {
    std.debug.print(fmt ++ "\n", args);
    std.process.exit(1);
}
