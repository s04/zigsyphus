const std = @import("std");
const mem = std.mem;

pub fn factors(allocator: mem.Allocator, value: u64) mem.Allocator.Error![]u64 {
    if (value <= 1) {
        return allocator.alloc(u64, 0);
    }

    var list = std.ArrayList(u64).init(allocator);
    var n = value;
    var d: u64 = 2;

    while (d <= n / d) : (d += 1) {
        while (n % d == 0) {
            try list.append(d);
            n /= d;
        }
    }

    if (n > 1) {
        try list.append(n);
    }

    var result = try allocator.alloc(u64, list.items.len);
    for (0..list.items.len) |i| {
        result[i] = list.items[i];
    }
    return result;
}
