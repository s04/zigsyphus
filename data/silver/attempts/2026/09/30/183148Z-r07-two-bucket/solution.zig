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

const State = struct {
    bucket1: u64,
    bucket2: u64,
    moves: u64,
};

pub fn measure(bucket_one: u64, bucket_two: u64, goal: u64, start_bucket: BucketId) ?Result {
    if (goal > bucket_one and goal > bucket_two) {
        return null;
    }
    
    const gcd_val = gcd(bucket_one, bucket_two);
    if (goal % gcd_val != 0) {
        return null;
    }

    var visited = std.AutoHashMap([2]u64, void).init(std.heap.page_allocator);
    defer visited.deinit();

    var queue = std.ArrayList(State).init(std.heap.page_allocator);
    defer queue.deinit();

    const initial_state = State{
        .bucket1 = if (start_bucket == .one) bucket_one else 0,
        .bucket2 = if (start_bucket == .two) bucket_two else 0,
        .moves = 1,
    };

    try queue.append(initial_state);
    try visited.put([2]u64{ initial_state.bucket1, initial_state.bucket2 }, {});

    var i: usize = 0;
    while (i < queue.items.len) {
        const current = queue.items[i];
        i += 1;

        if (current.bucket1 == goal) {
            return Result{
                .moves = current.moves,
                .goal_bucket = .one,
                .other_bucket = current.bucket2,
            };
        }
        if (current.bucket2 == goal) {
            return Result{
                .moves = current.moves,
                .goal_bucket = .two,
                .other_bucket = current.bucket1,
            };
        }

        const next_moves = current.moves + 1;

        // Fill bucket 1
        if (current.bucket1 < bucket_one) {
            const next = State{ .bucket1 = bucket_one, .bucket2 = current.bucket2, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .one and next.bucket1 == 0 and next.bucket2 == bucket_two)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }

        // Fill bucket 2
        if (current.bucket2 < bucket_two) {
            const next = State{ .bucket1 = current.bucket1, .bucket2 = bucket_two, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .two and next.bucket2 == 0 and next.bucket1 == bucket_one)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }

        // Empty bucket 1
        if (current.bucket1 > 0) {
            const next = State{ .bucket1 = 0, .bucket2 = current.bucket2, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .one and next.bucket1 == 0 and next.bucket2 == bucket_two)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }

        // Empty bucket 2
        if (current.bucket2 > 0) {
            const next = State{ .bucket1 = current.bucket1, .bucket2 = 0, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .two and next.bucket2 == 0 and next.bucket1 == bucket_one)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }

        // Pour bucket 1 to bucket 2
        if (current.bucket1 > 0 and current.bucket2 < bucket_two) {
            const pour = if (current.bucket1 < bucket_two - current.bucket2) current.bucket1 else bucket_two - current.bucket2;
            const next = State{ .bucket1 = current.bucket1 - pour, .bucket2 = current.bucket2 + pour, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .one and next.bucket1 == 0 and next.bucket2 == bucket_two)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }

        // Pour bucket 2 to bucket 1
        if (current.bucket2 > 0 and current.bucket1 < bucket_one) {
            const pour = if (current.bucket2 < bucket_one - current.bucket1) current.bucket2 else bucket_one - current.bucket1;
            const next = State{ .bucket1 = current.bucket1 + pour, .bucket2 = current.bucket2 - pour, .moves = next_moves };
            const key = [2]u64{ next.bucket1, next.bucket2 };
            if (visited.get(key) == null) {
                if (!(start_bucket == .two and next.bucket2 == 0 and next.bucket1 == bucket_one)) {
                    try visited.put(key, {});
                    try queue.append(next);
                }
            }
        }
    }

    return null;
}

fn gcd(a: u64, b: u64) u64 {
    var x = a;
    var y = b;
    while (y != 0) {
        const temp = y;
        y = x % y;
        x = temp;
    }
    return x;
}
