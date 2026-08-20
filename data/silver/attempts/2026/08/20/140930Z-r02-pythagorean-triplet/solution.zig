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
    var ptr: *Triplet = null;
    var len: usize = 0;
    var cap: usize = 0;

    for (1..(n / 3)) |a| {
        for ((a + 1)..(n - a)) |b| {
            const c = n - a - b;
            if (c <= b) {
                continue;
            }
            if (a * a + b * b == c * c) {
                if (len == cap) {
                    const newCap = if (cap == 0) 1 else cap * 2;
                    const newPtr = try allocator.alloc(Triplet, newCap);
                    if (ptr) |old| {
                        std.mem.copy(Triplet, newPtr[0..len], old[0..len]);
                        allocator.free(old);
                    }
                    ptr = newPtr;
                    cap = newCap;
                }
                ptr[len] = Triplet.init(a, b, c);
                len += 1;
            }
        }
    }

    defer allocator.free(ptr);

    if (len == 0) {
        return &[];
    } else {
        const result = try allocator.alloc(Triplet, len);
        std.mem.copy(Triplet, result, ptr[0..len]);
        return result;
    }
}
