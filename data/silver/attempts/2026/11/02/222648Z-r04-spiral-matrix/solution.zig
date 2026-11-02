const std = @import("std");
const mem = std.mem;

pub fn spiral(allocator: mem.Allocator, size: u16) mem.Allocator.Error![][]u16 {
    if (size == 0) {
        return try allocator.alloc([]u16, 0);
    }

    const s = @as(usize, size);
    var matrix = try allocator.alloc([]u16, s);
    errdefer {
        for (matrix) |row| {
            allocator.free(row);
        }
        allocator.free(matrix);
    }

    for (0..s) |i| {
        matrix[i] = try allocator.alloc(u16, s);
    }

    var top: usize = 0;
    var bottom: usize = s - 1;
    var left: usize = 0;
    var right: usize = s - 1;
    var num: u32 = 1;
    const total = @as(u32, s) * @as(u32, s);

    while (top <= bottom && left <= right) {
        // left to right on top row
        var j = left;
        while (j <= right) : (j += 1) {
            matrix[top][j] = @intCast(num);
            num += 1;
        }
        top += 1;

        // top to bottom on right column
        var i = top;
        while (i <= bottom) : (i += 1) {
            matrix[i][right] = @intCast(num);
            num += 1;
        }
        right -= 1;

        if (top <= bottom) {
            // right to left on bottom row
            const steps = right - left + 1;
            for (0..steps) |k| {
                const col = right - k;
                matrix[bottom][col] = @intCast(num);
                num += 1;
            }
            bottom -= 1;
        }

        if (left <= right) {
            // bottom to top on left column
            const steps = bottom - top + 1;
            for (0..steps) |k| {
                const row = bottom - k;
                matrix[row][left] = @intCast(num);
                num += 1;
            }
            left += 1;
        }
    }

    return matrix;
}
