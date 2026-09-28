const std = @import("std");
const mem = std.mem;

pub const Pair = struct {
    first: u64,
    second: u64,
};

pub const Palindrome = struct {
    value: u64,
    factors: []Pair,
};

fn isPalindrome(n: u64) bool {
    var orig = n;
    var rev: u64 = 0;
    while (orig > 0) : (orig /= 10) {
        rev = rev * 10 + (orig % 10);
    }
    return rev == n;
}

fn hasFactorPair(allocator: mem.Allocator, value: u64, min: u64, max: u64) bool {
    _ = allocator;
    var i: u64 = min;
    while (i <= max) : (i += 1) {
        if (i > value / i) {
            break;
        }
        if (value % i == 0) {
            const j = value / i;
            if (j >= min and j <= max) {
                return true;
            }
        }
    }
    return false;
}

fn collectFactors(allocator: mem.Allocator, value: u64, min: u64, max: u64) []Pair {
    var count: usize = 0;
    var i: u64 = min;
    while (i <= max) : (i += 1) {
        if (i > value / i) {
            break;
        }
        if (value % i == 0) {
            const j = value / i;
            if (j >= min and j <= max) {
                count += 1;
            }
        }
    }
    const factors = try allocator.alloc(Pair, count);
    var idx: usize = 0;
    i = min;
    while (i <= max) : (i += 1) {
        if (i > value / i) {
            break;
        }
        if (value % i == 0) {
            const j = value / i;
            if (j >= min and j <= max) {
                factors[idx] = .{ .first = i, .second = j };
                idx += 1;
            }
        }
    }
    return factors;
}

pub fn smallest(allocator: mem.Allocator, min: u64, max: u64) mem.Allocator.Error!?Palindrome {
    if (min > max) {
        return null;
    }
    var v: u128 = @intCast(min) * @intCast(min);
    const max_v: u128 = @intCast(max) * @intCast(max);
    while (v <= max_v) : (v += 1) {
        const value: u64 = @intCast(v);
        if (isPalindrome(value)) {
            if (hasFactorPair(allocator, value, min, max)) {
                const factors = try collectFactors(allocator, value, min, max);
                return .{ .value = value, .factors = factors };
            }
        }
    }
    return null;
}

pub fn largest(allocator: mem.Allocator, min: u64, max: u64) mem.Allocator.Error!?Palindrome {
    if (min > max) {
        return null;
    }
    var v: u128 = @intCast(max) * @intCast(max);
    const min_v: u128 = @intCast(min) * @intCast(min);
    while (v >= min_v) : (v -= 1) {
        const value: u64 = @intCast(v);
        if (isPalindrome(value)) {
            if (hasFactorPair(allocator, value, min, max)) {
                const factors = try collectFactors(allocator, value, min, max);
                return .{ .value = value, .factors = factors };
            }
        }
    }
    return null;
}
