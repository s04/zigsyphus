const std = @import("std");
const mem = std.mem;

pub const Triplet = struct {
    a: usize,
    b: usize,
    c: usize,

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return .{
            .a = a,
            .b = b,
            .c = c,
        };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) mem.Allocator.Error![]Triplet {
    var list = std.ArrayList(Triplet).init(allocator);
    defer list.deinit();

    for (1..(n / 3)) |a| {
        for ((a + 1)..(n - a)) |b| {
            const c = n - a - b;
            if (c <= b) {
                continue;
            }
            if (a * a + b * b == c * c) {
                try list.append(Triplet.init(a, b, c));
            }
        }
    }

    return list.toOwnedSlice();
}
