const std = @import("std");
const mem = std.mem;

pub const Triplet = struct {
    a: usize,
    b: usize,
    c: usize,

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return Triplet{
            .a = a,
            .b = b,
            .c = c,
        };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) mem.Allocator.Error![]Triplet {
    var list = std.ArrayList(Triplet).init(allocator);
    defer list.deinit();

    var a: usize = 1;
    while (a < n / 3) : (a += 1) {
        var b: usize = a + 1;
        while (b < (n - a) / 2) : (b += 1) {
            const c: usize = n - a - b;
            if (a * a + b * b == c * c) {
                try list.append(Triplet.init(a, b, c));
            }
        }
    }

    return list.toOwnedSlice();
}
