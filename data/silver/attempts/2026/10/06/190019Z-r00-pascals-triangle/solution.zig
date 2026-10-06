const std = @import("std");
const mem = std.mem;

pub fn rows(allocator: mem.Allocator, count: usize) mem.Allocator.Error![][]u128 {
    const triangle = try allocator.alloc([]u128, count);
    errdefer allocator.free(triangle);

    var i: usize = 0;
    errdefer {
        var j: usize = 0;
        while (j < i) : (j += 1) {
            allocator.free(triangle[j]);
        }
    }

    while (i < count) : (i += 1) {
        const row = try allocator.alloc(u128, i + 1);
        row[0] = 1;
        row[i] = 1;
        var j: usize = 1;
        while (j < i) : (j += 1) {
            row[j] = triangle[i - 1][j - 1] + triangle[i - 1][j];
        }
        triangle[i] = row;
    }

    return triangle;
}
