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
    if self.scores.len == 0 {
        return null;
    } else {
        return self.scores[^1];
    }
}

pub fn personalBest(self: *const HighScores) ?i32 {
    if self.scores.len == 0 {
        return null;
    }
    var max = self.scores[0];
    for (self.scores) |s| {
        if *s > max {
            max = *s;
        }
    }
    return max;
}

pub fn personalTopThree(self: *const HighScores) []const i32 {
    // Copy scores into a mutable list
    const std_heap = std.heap;
    var list = try std_heap.ArrayList(i32).init(self.scores.len);
    defer list.deinit();

    for (self.scores) |s| {
        try list.items.append(s);
    }

    // Sort descending
    std.sort.sort(&list.items, |a, b| b - a);

    // Return up to three elements
    const take = min(list.items.len, 3);
    return list.items[0:take];
}
