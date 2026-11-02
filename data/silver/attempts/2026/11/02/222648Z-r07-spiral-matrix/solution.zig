const std = @import("std");
const mem = std.mem;

pub struct spiral_matrix {}

pub fn spiral(self: *spiral_matrix, allocator: mem.Allocator, size: u16) ![][]u16 {
    // Allocate rows
    var rows: [][]u16 = undefined;
    for (i, 0..size) |_| {
        const row = try allocator.allocSlices(u16, size);
        rows = rows ++ row;
    }

    // Handle size 0 case
    if (size == 0) {
        return rows;
    }

    // Fill the matrix in a spiral order
    var top = 0;
    var bottom = size - 1;
    var left = 0;
    var right = size - 1;
    var value: u16 = 1;

    while (top <= bottom && left <= right) {
        // Top row
        var col = left;
        while (col <= right) {
            rows[top][col] = value;
            value += 1;
            col += 1;
        }
        top += 1;

        // Right column
        var row = top;
        while (row <= bottom) {
            rows[row][right] = value;
            value += 1;
            row += 1;
        }
        right -= 1;

        // Bottom row
        if (top <= bottom) {
            var col = right;
            while (col >= left) {
                rows[bottom][col] = value;
                value += 1;
                col -= 1;
            }
            bottom -= 1;
        }

        // Left column
        if (left <= right) {
            var row = bottom;
            while (row >= top) {
                rows[row][left] = value;
                value += 1;
                row -= 1;
            }
            left += 1;
        }
    }

    return rows;
}
