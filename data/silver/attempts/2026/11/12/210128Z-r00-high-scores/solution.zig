pub const HighScores = struct {
    scores: []const i32,
    top_three: [3]i32,
    top_three_len: usize,

    pub fn init(scores: []const i32) HighScores {
        var top: [3]i32 = .{ 0, 0, 0 };
        var len: usize = 0;

        for (scores) |s| {
            if (len < 3) {
                top[len] = s;
                len += 1;
                var i: usize = len - 1;
                while (i > 0 and top[i] > top[i - 1]) {
                    const tmp = top[i];
                    top[i] = top[i - 1];
                    top[i - 1] = tmp;
                    i -= 1;
                }
            } else if (s > top[2]) {
                top[2] = s;
                var i: usize = 2;
                while (i > 0 and top[i] > top[i - 1]) {
                    const tmp = top[i];
                    top[i] = top[i - 1];
                    top[i - 1] = tmp;
                    i -= 1;
                }
            }
        }

        return HighScores{
            .scores = scores,
            .top_three = top,
            .top_three_len = len,
        };
    }

    pub fn latest(self: *const HighScores) ?i32 {
        if (self.scores.len == 0) return null;
        return self.scores[self.scores.len - 1];
    }

    pub fn personalBest(self: *const HighScores) ?i32 {
        if (self.scores.len == 0) return null;
        var best = self.scores[0];
        for (self.scores[1..]) |s| {
            if (s > best) best = s;
        }
        return best;
    }

    pub fn personalTopThree(self: *const HighScores) []const i32 {
        return self.top_three[0..self.top_three_len];
    }
};
