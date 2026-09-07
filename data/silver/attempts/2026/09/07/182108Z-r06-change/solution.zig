const std = @import("std");
const mem = std.mem;
const std_arraylist = std.arraylist;

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
        return @emptyList(u64);
    }

    const t: usize = @intCast(usize, target);

    // dp[i] = minimal number of coins to make amount i
    var dp = std_arraylist.usize.init(allocator);
    defer allocator.free(dp);
    // prev[i] = coin used to reach amount i
    var prev = std_arraylist.u64.init(allocator);
    defer allocator.free(prev);

    // initialize dp with "infinity"
    const INF: usize = t + 1;
    for (0..=t) |i| {
        dp.append(INF);
    }
    dp.set(0, 0);

    // fill dp table
    for (1..=t) |amt| {
        for (coins) |c| {
            if (c > amt) continue;
            const c_usize = @intCast(usize, c);
            const prev_amt = amt - c_usize;
            const prev_count = dp[prev_amt];
            if (prev_count + 1 < dp[amt]) {
                dp.set(amt, prev_count + 1);
                prev.set(amt, c);
            }
        }
    }

    if (dp[t] == INF) {
        return error.UnreachableTarget;
    }

    // reconstruct solution
    var list = std_arraylist.u64.init(allocator);
    var amt = t;
    while (amt > 0) {
        const coin = prev[amt];
        try list.append(coin);
        amt -= @intCast(usize, coin);
    }

    // sort ascending as required by tests
    std.sort.sort(u64, list.items, {}, asc);

    return list.items;
}

fn asc(a: u64, b: u64) bool {
    return a < b;
}
