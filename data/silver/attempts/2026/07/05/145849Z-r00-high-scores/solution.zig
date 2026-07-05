const std = @import("std");
const std_mem = std.mem;

pub const HighScores = struct {
    scores: []i32,
};

pub fn init(scores: []const i32) HighScores {
    var self = HighScores{};
    self.scores = scores;
    return self;
}

pub fn latest(self: *const HighScores) ?i32 {
    if self.scores.isEmpty {
        return 0;
    } else {
        return self.scores[^1];
    }
}

pub fn personalBest(self: *const HighScores) ?i32 {
    var max = 0;
    for (self.scores) |score| {
        if *score > max {
            max = *score;
        }
    }
    return max;
}

pub fn personalTopThree(self: *const HighScores) []const i32 {
    var sorted = self.scores.copy();
    std.sort.sortSlice(&sorted, |a, b| b - a);
    var count = sorted.len;
    if count > 3 {
        count = 3;
    }
    return std_mem.sliced(sorted, 0, count);
}
