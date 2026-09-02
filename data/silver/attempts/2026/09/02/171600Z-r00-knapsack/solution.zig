const std = @import("std");
const mem = std.mem;

pub const Item = struct {
    weight: usize,
    value: usize,
    pub fn init(weight: usize, value: usize) Item {
        return .{ .weight = weight, .value = value };
    }
};

pub fn maximumValue(allocator: mem.Allocator, maximumWeight: usize, items: []const Item) !usize {
    if (maximumWeight == 0) {
        return 0;
    }

    var dp = try allocator.alloc(usize, maximumWeight + 1);
    defer allocator.free(dp);
    std.mem.set(dp, 0);

    for (items) |item| {
        const w = item.weight;
        const v = item.value;
        if (w > maximumWeight) {
            continue;
        }
        var i: usize = maximumWeight;
        while (i >= w) : (i -= 1) {
            const candidate = dp[i - w] + v;
            if (candidate > dp[i]) {
                dp[i] = candidate;
            }
        }
    }

    return dp[maximumWeight];
}
