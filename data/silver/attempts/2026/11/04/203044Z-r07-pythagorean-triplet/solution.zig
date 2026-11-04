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
    var count: usize = 0;
    var a: usize = 1;
    while (a < n / 3) : (a += 1) {
        var b: usize = a + 1;
        while (b < (n - a) / 2) : (b += 1) {
            const c: usize = n - a - b;
            if (a * a + b * b == c * c) {
                count += 1;
            }
        }
    }

    const buf = try allocator.alloc(Triplet, count);
    var i: usize = 0;
    var x: usize = 1;
    while (x < n / 3) : (x += 1) {
        var y: usize = x + 1;
        while (y < (n - x) / 2) : (y += 1) {
            const z: usize = n - x - y;
            if (x * x + y * y == z * z) {
                buf[i] = Triplet.init(x, y, z);
                i += 1;
            }
        }
    }

    return buf;
}
