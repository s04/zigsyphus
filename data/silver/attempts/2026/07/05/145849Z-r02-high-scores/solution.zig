const std = @import("std");

pub const HighScores = struct {
    scores: []i32,
};

pub fn init(scores: []const i32) HighScores {
    var self = HighScores{};
    self.scores = scores;
    return self;
}

pub fn latest(self: *const HighScores) ?i32 {
    if (self.scores.len == 0) {
        return null;
    } else {
        return self.scores[^1];
    }
}

pub fn personalBest(self: *const HighScores) ?i32 {
    if (self.scores.len == 0) {
        return null;
    }
    var max = self.scores[0];
    for (self.scores) |s| {
        if (s > max) {
            max = s;
        }
    }
    return max;
}

pub fn personalTopThree(self: *const HighScores) []const i32 {
    const std_heap = std.heap;
    var list = std_heap.ArrayList(i32).init(self.scores.len);
    defer list.deinit();

    for (self.scores) |s| {
        list.items.append(s) catch unreachable;
    }

    std.sort.sort(&list.items, struct {
        fn lessThan(ctx: void, a: i32, b: i32) bool {
            _ = ctx;
            return a > b;
        }
    }.lessThan);

    const take = @min(list.items.len, 3);
    return list.items[0..take];
}
