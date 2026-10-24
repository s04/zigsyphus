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
        return try allocator.alloc(u64, 0);
    }

    const target_u64 = @intCast(u64, target);

    // dp[i] = minimum number of coins to make amount i, or null if impossible
    var dp = try allocator.alloc(?u64, target_u64 + 1);
    defer allocator.free(dp);

    // parent[i] = coin value used to reach amount i (for reconstruction)
    var parent = try allocator.alloc(?u64, target_u64 + 1);
    defer allocator.free(parent);

    // Initialize arrays
    for (0..dp.len) |i| {
        dp[i] = null;
        parent[i] = null;
    }
    dp[0] = @as(u64, 0);

    // Fill DP table
    for (1..=target_u64) |amount| {
        var min_coins: ?u64 = null;
        var best_coin: ?u64 = null;

        for (coins) |coin| {
            if (coin <= amount) {
                const prev = amount - coin;
                if (dp[prev] != null) {
                    const coins_needed = dp[prev].? + 1;
                    if (min_coins == null || coins_needed < min_coins.?) {
                        min_coins = coins_needed;
                        best_coin = coin;
                    }
                }
            }
        }

        dp[amount] = min_coins;
        parent[amount] = best_coin;
    }

    if (dp[target_u64] == null) {
        return error.UnreachableTarget;
    }

    // Reconstruct the coin list
    const coin_count = dp[target_u64].?;
    var result = try allocator.alloc(u64, coin_count);

    var current = target_u64;
    var i: usize = coin_count;
    while (current > 0) : (current = parent[current].?) {
        i -= 1;
        result[i] = parent[current].?;
    }

    // Sort in ascending order to match expected output
    std.sort.sort(u64, result.len, result, struct {
        fn lessThan(_: void, a: u64, b: u64) bool {
            return a < b;
        }
    }.lessThan);

    return result;
}
