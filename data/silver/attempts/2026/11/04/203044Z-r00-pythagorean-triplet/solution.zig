const std = @import("std");
const mem = std.mem;

pub const Triplet = struct {
    a: usize,
    b: usize,
    c: usize;

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return Triplet{ .a = a, .b = b, .c = c };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) mem.Allocator.Error![]Triplet {
    var count: usize = 0;
    var a: usize = 1;
    while (a * 3 < n) : (a += 1) {
        var b: usize = a + 1;
        while (b * 2 < n - a) : (b += 1) {
            const c = n - a - b;
            if (a * a + b * b == c * c) {
                count += 1;
            }
        }
    }

    const result = try allocator.alloc(Triplet, count);
    var i: usize = 0;
    var a2: usize = 1;
    while (a2 * 3 < n) : (a2 += 1) {
        var b2: usize = a2 + 1;
        while (b2 * 2 < n - a2) : (b2 += 1) {
            const c2 = n - a2 - b2;
            if (a2 * a2 + b2 * b2 == c2 * c2) {
                result[i] = Triplet{ .a = a2, .b = b2, .c = c2 };
                i += 1;
            }
        }
    }

    return result;
}
