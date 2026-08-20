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

    // a must be less than n/3 because a < b < c and a+b+c = n
    for (a) in 1..(n / 3) {
        // b must be greater than a; c will be computed as n - a - b
        for (b) in (a + 1)..(n - a) {
            const c = n - a - b;
            // ensure ordering b < c
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
