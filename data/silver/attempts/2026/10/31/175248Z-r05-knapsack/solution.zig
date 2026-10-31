const std = @import("std");
const mem = std.mem;

pub const Item = struct {
    weight: usize,
    value: usize,
    pub fn init(weight: usize, value: usize) Item {
        return Item{ .weight = weight, .value = value };
    }
};

pub fn maximumValue(allocator: mem.Allocator, maximumWeight: usize, items: []const Item) !usize {
    const dp = try allocator.alloc(usize, maximumWeight + 1);
    defer allocator.free(dp);
    // Initialize dp array to 0
    for (dp) |*cell| {
        cell.* = 0;
    }
    for (items) |item| {
        const w = item.weight;
        if (w <= maximumWeight) {
            var i: usize = maximumWeight;
            while (i >= w) : (i -= 1) {
                const candidate = dp[i - w] + item.value;
                if (candidate > dp[i]) {
                    dp[i] = candidate;
                }
            }
        }
    }
    return dp[maximumWeight];
}
