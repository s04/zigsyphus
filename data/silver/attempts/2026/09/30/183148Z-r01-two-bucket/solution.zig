const std = @import("std");

pub const BucketId = enum {
    one,
    two,
};

pub const Result = struct {
    moves: u64,
    goal_bucket: BucketId,
    other_bucket: u64,
};

pub fn measure(bucket_one: u64, bucket_two: u64, goal: u64, start_bucket: BucketId) ?Result {
    if (goal > bucket_one and goal > bucket_two) {
        return null;
    }
    if (goal == 0) {
        return Result{ .moves = 0, .goal_bucket = .one, .other_bucket = 0 };
    }

    const max_states = (bucket_one + 1) * (bucket_two + 1);
    var visited = std.ArrayList(bool).init(std.heap.page_allocator);
    defer visited.deinit();
    try visited.resize(max_states);
    for (visited.items) |*v| v.* = false;

    const State = struct {
        a: u64,
        b: u64,
        moves: u64,
    };

    var queue = std.ArrayList(State).init(std.heap.page_allocator);
    defer queue.deinit();

    const start_state: State = if (start_bucket == .one)
        State{ .a = bucket_one, .b = 0, .moves = 1 }
    else
        State{ .a = 0, .b = bucket_two, .moves = 1 };

    const start_index = start_state.a * (bucket_two + 1) + start_state.b;
    visited.items[start_index] = true;
    try queue.append(start_state);

    while (queue.items.len > 0) {
        const current = queue.pop();
        if (current.a == goal) {
            return Result{ .moves = current.moves, .goal_bucket = .one, .other_bucket = current.b };
        }
        if (current.b == goal) {
            return Result{ .moves = current.moves, .goal_bucket = .two, .other_bucket = current.a };
        }

        const next_states = [_]State{
            // Fill bucket one
            if (current.a < bucket_one) State{ .a = bucket_one, .b = current.b, .moves = current.moves + 1 } else State{ .a = current.a, .b = current.b, .moves = 0 },
            // Fill bucket two
            if (current.b < bucket_two) State{ .a = current.a, .b = bucket_two, .moves = current.moves + 1 } else State{ .a = current.a, .b = current.b, .moves = 0 },
            // Empty bucket one
            if (current.a > 0) State{ .a = 0, .b = current.b, .moves = current.moves + 1 } else State{ .a = current.a, .b = current.b, .moves = 0 },
            // Empty bucket two
            if (current.b > 0) State{ .a = current.a, .b = 0, .moves = current.moves + 1 } else State{ .a = current.a, .b = current.b, .moves = 0 },
            // Pour one -> two
            if (current.a > 0 and current.b < bucket_two) {
                const pour = @min(current.a, bucket_two - current.b);
                State{ .a = current.a - pour, .b = current.b + pour, .moves = current.moves + 1 }
            } else State{ .a = current.a, .b = current.b, .moves = 0 },
            // Pour two -> one
            if (current.b > 0 and current.a < bucket_one) {
                const pour = @min(current.b, bucket_one - current.a);
                State{ .a = current.a + pour, .b = current.b - pour, .moves = current.moves + 1 }
            } else State{ .a = current.a, .b = current.b, .moves = 0 },
        };

        for (next_states) |next| {
            if (next.moves == 0) continue;

            // Check forbidden state: start_bucket empty AND other bucket full
            const forbidden = if (start_bucket == .one)
                (next.a == 0 and next.b == bucket_two)
            else
                (next.a == bucket_one and next.b == 0);

            if (forbidden) continue;

            const idx = next.a * (bucket_two + 1) + next.b;
            if (!visited.items[idx]) {
                visited.items[idx] = true;
                try queue.append(next);
            }
        }
    }

    return null;
}
