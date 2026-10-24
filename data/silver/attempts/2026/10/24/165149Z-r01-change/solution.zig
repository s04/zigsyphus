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
    
    // Sort coins in descending order for greedy approach
    var sorted_coins = try allocator.dupe(u64, coins);
    defer allocator.free(sorted_coins);
    
    // Sort in descending order
    std.sort.sort(u64, sorted_coins.len, sorted_coins, struct {
        fn lessThan(_: void, a: u64, b: u64) bool {
            return a > b;
        }
    }.lessThan);
    
    // Try greedy first
    var greedy_result = try allocator.alloc(u64, 0);
    defer allocator.free(greedy_result);
    
    var remaining = target_u64;
    for (sorted_coins) |coin| {
        while (remaining >= coin) {
            remaining -= coin;
            try greedy_result.append(coin);
        }
    }
    
    if (remaining == 0) {
        return greedy_result;
    }
    
    // Greedy failed, use dynamic programming
    // dp[i] = minimum coins to make amount i, or null if impossible
    var dp = try allocator.alloc(?u64, target_u64 + 1);
    defer allocator.free(dp);
    
    // parent[i] = which coin was used to reach amount i
    var parent = try allocator.alloc(?u64, target_u64 + 1);
    defer allocator.free(parent);
    
    // Initialize
    for (dp) |*d, i| {
        d.* = null;
    }
    for (parent) |*p, i| {
        p.* = null;
    }
    
    dp[0] = 0;
    
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
    
    // Reconstruct solution
    var result = try allocator.alloc(u64, 0);
    defer allocator.free(result);
    
    var current = target_u64;
    while (current > 0) : (current = parent[current].?) {
        try result.append(parent[current].?);
    }
    
    // Sort result in ascending order to match expected output
    std.sort.sort(u64, result.len, result, struct {
        fn lessThan(_: void, a: u64, b: u64) bool {
            return a < b;
        }
    }.lessThan);
    
    return result;
}
