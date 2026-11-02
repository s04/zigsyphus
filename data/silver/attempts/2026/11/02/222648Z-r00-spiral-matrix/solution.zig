const std = @import("std");
const mem = std.mem;

pub fn spiral(allocator: mem.Allocator, size: u16) mem.Allocator.Error![][]u16 {
    // Handle the zero‑size case directly.
    if size == 0 {
        const empty: [][]u16 = undefined;
        return empty;
    }

    // Allocate a slice that will hold the slice headers for each row.
    const rows: [][]u16 = try allocator.allocSlices(u16, size, 1);
    // Each element of `rows` will become a slice of `u16` with length = size.

    // Allocate the actual data for each row.
    for (0..size) |i| {
        const row_data: []u16 = try allocator.allocSlices(u16, size, 1);
        rows[i] = row_data; // Store the slice header.
    }

    // Direction vectors: right, down, left, up.
    const dirs: [[2]i32] = [
        {0, 1},   // →
        {1, 0},   // ↓
        {0, -1},  // ←
        {-1, 0},  // ↑
    ];

    var r: u16 = 0;          // current row index
    var c: u16 = 0;          // current column index
    var dir_idx: usize = 0;  // start moving right

    const total_steps = size * size;
    for (step: u32 in 1..total_steps) {
        // Fill the current cell.
        rows[r][c] = @u16(step);

        // Compute the next cell.
        var next_r = r + dirs[dir_idx][0];
        var next_c = c + dirs[dir_idx][1];

        // If the next cell is outside the matrix, turn clockwise.
        if (next_r < 0) or (next_r >= size) or (next_c < 0) or (next_c >= size) {
            dir_idx = (dir_idx + 1) % 4;
            next_r = r + dirs[dir_idx][0];
            next_c = c + dirs[dir_idx][1];
        }

        // Move to the next cell.
        r = @u16(next_r);
        c = @u16(next_c);
    }

    return rows;
}
