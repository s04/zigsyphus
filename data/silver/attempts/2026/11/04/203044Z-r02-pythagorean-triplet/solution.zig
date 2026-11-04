const std = @import("std");
const mem = std.mem;

pub const Triplet = struct {
    a: usize,
    b: usize,
    c: usize,

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return Triplet{ .a = a, .b = b, .c = c };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) error![]Triplet {
    var list = try std.ArrayList.create(allocator, 0, 0);
    for (a: usize, 1 .. n) |a| {
        if (a * 3 >= n) break;
        for (b: usize, a + 1 .. (n - a) / 2) |b| {
            const c = n - a - b;
            if (c <= b) continue;
            const lhs = @u128(a) * @u128(a) + @u128(b) * @u128(b);
            const rhs = @u128(c) * @u128(c);
            if (lhs == rhs) {
                try list.append(Triplet.init(a, b, c));
            }
        }
    }
    return list.items;
}
