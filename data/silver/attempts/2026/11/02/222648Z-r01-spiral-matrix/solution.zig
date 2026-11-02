const std = @import("std");
const mem = std.mem;

pub fn spiral(allocator: mem.Allocator, size: u16) mem.Allocator.Error![][]u16 {
    // Handle the empty spiral case: allocate an empty slice of slices.
    if (size == 0) {
        const rows = try allocator.alloc([]u16, 0);
        return rows;
    }

    // Allocate the outer slice (array of row slice headers).
    const rows = try allocator.alloc([]u16, size);

    // Allocate each row and initialise with 0.
    for (0..size) |i| {
        const row = try allocator.alloc(u16, size);
        // Zero-initialise the row.
        for (0..size) |j| {
            row[j] = 0;
        }
        rows[i] = row;
    }

    // Directions: right, down, left, up.
    const dr: [4]i32 = [4]i32{ 0, 1, 0, -1 };
    const dc: [4]i32 = [4]i32{ 1, 0, -1, 0 };

    var r: u16 = 0;
    var c: u16 = 0;
    var dir: usize = 0; // start moving right

    const total = size * size;
    for (1..total) |step| {
        rows[r][c] = @intCast(step);

        // Try to move in the current direction.
        var nr = @as(i32, @intCast(r)) + dr[dir];
        var nc = @as(i32, @intCast(c)) + dc[dir];

        // If next cell is out of bounds or already filled, turn clockwise.
        if (nr < 0 or nr >= @as(i32, @intCast(size)) or
            nc < 0 or nc >= @as(i32, @intCast(size)) or
            rows[@intCast(nr)][@intCast(nc)] != 0) {
            dir = (dir + 1) % 4;
            nr = @as(i32, @intCast(r)) + dr[dir];
            nc = @as(i32, @intCast(c)) + dc[dir];
        }

        r = @intCast(nr);
        c = @intCast(nc);
    }

    // Fill the last cell.
    rows[r][c] = @intCast(total);

    return rows;
}
