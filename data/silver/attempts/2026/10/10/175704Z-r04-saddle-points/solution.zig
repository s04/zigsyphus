const std = @import("std");
const mem = std.mem;

pub const Point = struct {
    row: u16,
    column: u16,
};

pub fn saddlePoints(comptime m: usize, comptime n: usize, allocator: mem.Allocator, matrix: [m][n]i32) mem.Allocator.Error![]Point {
    var list = std.ArrayList(Point).init(allocator);
    errdefer list.deinit();

    var row_max: [m]i32 = undefined;
    var col_min: [n]i32 = undefined;

    // Compute maximum for each row
    for (0..m) |i| {
        var max = matrix[i][0];
        for (1..n) |j| {
            if (matrix[i][j] > max) {
                max = matrix[i][j];
            }
        }
        row_max[i] = max;
    }

    // Compute minimum for each column
    for (0..n) |j| {
        var min = matrix[0][j];
        for (1..m) |i| {
            if (matrix[i][j] < min) {
                min = matrix[i][j];
            }
        }
        col_min[j] = min;
    }

    // Find saddle points
    for (0..m) |i| {
        for (0..n) |j| {
            if (matrix[i][j] == row_max[i] and matrix[i][j] == col_min[j]) {
                try list.append(Point{
                    .row = @intCast(i + 1),
                    .column = @intCast(j + 1),
                });
            }
        }
    }

    return list.toOwnedSlice();
}
