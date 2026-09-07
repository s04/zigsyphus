const std = @import("std");
const mem = std.mem;

pub const ChangeError = error{
    NegativeTarget,
    UnreachableTarget,
};

pub fn findFewestCoins(
    allocator: mem.Allocator,
    coins: []const u64,
    target: i64,
) (mem.Allocator.Error || ChangeError)![]u64 {
    if (target < 0) {
        return error.NegativeTarget;
    }
    if (target == 0) {
        return allocator.alloc(u64, 0);
    }

    const t: usize = @intCast(usize, target);
    var dp = try allocator.alloc(usize, t + 1);
    defer allocator.free(dp);
    var prev = try allocator.alloc(u64, t + 1);
    defer allocator.free(prev);

    const inf = t + 1;
    for (dp) |*x| {
        x.* = inf;
    }
    dp[0] = 0;

    for (t + 1) |amt| {
        if (amt == 0) continue;
        for (coins) |c| {
            if (c > @intCast(u64, amt)) continue;
            const prev_amt = amt - @intCast(usize, c);
            if (dp[prev_amt] + 1 < dp[amt]) {
                dp[amt] = dp[prev_amt] + 1;
                prev[amt] = c;
            }
        }
    }

    if (dp[t] == inf) {
        return error.UnreachableTarget;
    }

    var list = std.ArrayList(u64).init(allocator);
    defer list.deinit();

    var amt = t;
    while (amt > 0) {
        const coin = prev[amt];
        try list.append(coin);
        amt -= @intCast(usize, coin);
    }

    std.sort.sort(u64, list.items, {}, asc);
    return try list.toOwnedSlice();
}

fn asc(a: u64, b: u64) bool {
    return a < b;
}
