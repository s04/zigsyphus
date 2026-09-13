const std = @import("std");

const discount_rates = [6]u32{ 0, 0, 5, 10, 20, 25 };

fn priceForGroup(size: u32) u32 {
    return size * 800 * (100 - discount_rates[size]) / 100;
}

fn solve(counts: [5]u32, memo: *std.AutoHashMap(u64, u32)) !u32 {
    var sorted = counts;
    std.sort.sort(u32, &sorted, {}, std.sort.desc(u32));

    if (sorted[0] == 0) return 0;

    var key: u64 = 0;
    for (sorted, 0..) |c, i| {
        key |= @as(u64, c) << (@as(u64, @intCast(i)) * 8);
    }

    if (memo.get(key)) |cached| {
        return cached;
    }

    var min_cost: u32 = std.math.maxInt(u32);

    var group_size: u32 = 1;
    while (group_size <= 5) : (group_size += 1) {
        if (sorted[group_size - 1] == 0) break;

        var new_counts = sorted;
        var i: u32 = 0;
        while (i < group_size) : (i += 1) {
            new_counts[i] -= 1;
        }

        const cost = priceForGroup(group_size) + try solve(new_counts, memo);
        if (cost < min_cost) {
            min_cost = cost;
        }
    }

    try memo.put(key, min_cost);
    return min_cost;
}

pub fn total(basket: []const u32) u32 {
    var counts = [5]u32{ 0, 0, 0, 0, 0 };
    for (basket) |book| {
        if (book >= 1 and book <= 5) {
            counts[book - 1] += 1;
        }
    }

    var memo = std.AutoHashMap(u64, u32).init(std.heap.page_allocator);
    defer memo.deinit();

    return solve(counts, &memo) catch 0;
}
