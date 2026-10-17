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
    if (maximumWeight == 0 || items.len == 0) {
        return 0;
    }

    const dp_size = maximumWeight + 1;
    var dp = try allocator.alloc(usize, dp_size);
    defer allocator.free(dp);

    @memset(dp, 0);

    for (items) |item| {
        if (item.weight == 0) {
            // Items with zero weight can always be taken; add their value to every capacity.
            // This is not strictly needed for the given tests, but makes the solution robust.
            for (dp) |*v| v.* += item.value;
            continue;
        }
        if (item.weight > maximumWeight) continue;

        var w = maximumWeight;
        while (w >= item.weight) : (w -= 1) {
            const new_val = dp[w - item.weight] + item.value;
            if (new_val > dp[w]) {
                dp[w] = new_val;
            }
        }
    }

    return dp[maximumWeight];
}
