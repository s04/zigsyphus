const std = @import("std");
const mem = std.mem;

pub fn factors(allocator: mem.Allocator, value: u64) mem.Allocator.Error![]u64 {
    if (value <= 1) {
        return allocator.alloc(u64, 0);
    }

    // The maximum number of prime factors for a u64 is 63 (since 2^64 > u64::max).
    var result = try allocator.alloc(u64, 64);
    var count: usize = 0;

    var n = value;
    var d: u64 = 2;

    // Trial division
    while (d <= n and d * d <= n) : (d += 1) {
        while (n % d == 0) {
            result[count] = d;
            count += 1;
            n /= d;
        }
    }

    // If n > 1, the remaining n is a prime factor
    if (n > 1) {
        result[count] = n;
        count += 1;
    }

    // Shrink the slice to the actual number of factors found
    _ = allocator.realloc(result, count);
    return result[0..count];
}
