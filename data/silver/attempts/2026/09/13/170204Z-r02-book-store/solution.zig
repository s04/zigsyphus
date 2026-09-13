const std = @import("std");

pub fn total(basket: []const u32) u32 {
    var counts: [5]u32 = undefined;
    for (counts) |*c| { c.* = 0; }
    for (basket) |book| {
        if (book >= 1 and book <= 5) {
            counts[book - 1] += 1;
        }
    }
    const allocator = std.heap.page_allocator;
    var memo = std.AutoHashMap([5]u32, u32).init(allocator);
    defer memo.deinit();
    return minCost(&counts, &memo);
}

fn minCost(counts: *[5]u32, memo: *std.AutoHashMap([5]u32, u32)) u32 {
    // Base case: no books left
    var all_zero: bool = true;
    for (counts[0..]) |c| {
        if (c != 0) {
            all_zero = false;
            break;
        }
    }
    if (all_zero) return 0;

    // Memoization lookup
    if (memo.get(*counts)) |v| {
        return v.*;
    }

    var best: u32 = @intCast(@max(u32));

    // Try every non-empty subset of the 5 books (bits 0..4)
    var subset: u32 = 1;
    while (subset <= 31) : (subset += 1) {
        var feasible = true;
        var new_counts = *counts;
        var size: u32 = 0;
        var i: u32 = 0;
        while (i < 5) : (i += 1) {
            if ((subset & (1 << i)) != 0) {
                if (new_counts[i] == 0) {
                    feasible = false;
                    break;
                } else {
                    new_counts[i] -= 1;
                    size += 1;
                }
            }
        }
        if (!feasible) continue;

        var factor: u32 = switch (size) {
            1 => 100,
            2 => 95,
            3 => 90,
            4 => 80,
            5 => 75,
            else => unreachable,
        };
        var group_cost: u32 = size * 8 * factor;
        var cost = group_cost + minCost(&new_counts, memo);
        if (cost < best) best = cost;
    }

    memo.put(*counts, best) orelse unreachable;
    return best;
}
