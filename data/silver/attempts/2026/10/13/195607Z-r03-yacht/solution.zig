pub const Category = enum {
    ones,
    twos,
    threes,
    fours,
    fives,
    sixes,
    full_house,
    four_of_a_kind,
    little_straight,
    big_straight,
    choice,
    yacht,
};

pub fn score(dice: [5]u3, category: Category) u32 {
    var freq: [6]u3 = [6]u3{0, 0, 0, 0, 0, 0};
    for (dice) |die| {
        freq[die - 1] += 1;
    }

    switch (category) {
        .ones => return @intCast(freq[0]) * 1,
        .twos => return @intCast(freq[1]) * 2,
        .threes => return @intCast(freq[2]) * 3,
        .fours => return @intCast(freq[3]) * 4,
        .fives => return @intCast(freq[4]) * 5,
        .sixes => return @intCast(freq[5]) * 6,
        .full_house => {
            var count_two: u3 = 0;
            var count_three: u3 = 0;
            for (freq) |f| {
                if (f == 2) count_two += 1;
                if (f == 3) count_three += 1;
            }
            if (count_three == 1 and count_two == 1) {
                var sum: u32 = 0;
                for (dice) |d| sum += d;
                return sum;
            }
            return 0;
        },
        .four_of_a_kind => {
            for (freq, 0..) |f, i| {
                if (f >= 4) {
                    return @as(u32, @intCast(i + 1)) * 4;
                }
            }
            return 0;
        },
        .little_straight => {
            if (freq[0] == 1 and freq[1] == 1 and freq[2] == 1 and freq[3] == 1 and freq[4] == 1) {
                return 30;
            }
            return 0;
        },
        .big_straight => {
            if (freq[1] == 1 and freq[2] == 1 and freq[3] == 1 and freq[4] == 1 and freq[5] == 1) {
                return 30;
            }
            return 0;
        },
        .choice => {
            var sum: u32 = 0;
            for (dice) |d| sum += d;
            return sum;
        },
        .yacht => {
            for (freq) |f| {
                if (f == 5) return 50;
            }
            return 0;
        },
    }
}
