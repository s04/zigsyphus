const std = @import("std");
const mem = std.mem;

pub fn spiral(allocator: mem.Allocator, size: u16) mem.Allocator.Error![][]u16 {
    const s = @as(usize, size);
    const matrix = try allocator.alloc([]u16, s);
    
    var allocated_rows: usize = 0;
    errdefer {
        for (matrix[0..allocated_rows]) |row| {
            allocator.free(row);
        }
        allocator.free(matrix);
    }
    
    for (matrix) |*row| {
        row.* = try allocator.alloc(u16, s);
        allocated_rows += 1;
    }
    
    var num: u16 = 1;
    var top: usize = 0;
    var bottom: usize = s;
    var left: usize = 0;
    var right: usize = s;
    
    while (left < right and top < bottom) {
        var col = left;
        while (col < right) {
            matrix[top][col] = num;
            num += 1;
            col += 1;
        }
        top += 1;
        
        var row = top;
        while (row < bottom) {
            matrix[row][right - 1] = num;
            num += 1;
            row += 1;
        }
        right -= 1;
        
        if (top < bottom) {
            var col2 = right;
            while (col2 > left) {
                col2 -= 1;
                matrix[bottom - 1][col2] = num;
                num += 1;
            }
            bottom -= 1;
        }
        
        if (left < right) {
            var row2 = bottom;
            while (row2 > top) {
                row2 -= 1;
                matrix[row2][left] = num;
                num += 1;
            }
            left += 1;
        }
    }
    
    return matrix;
}
