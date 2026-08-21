const std = @import("std");
const mem = std.mem;

pub fn rows(allocator: mem.Allocator, letter: u8) allocator.Error![][]u8 {
    std.debug.assert(letter >= 'A');
    std.debug.assert(letter <= 'Z');

    const n = @intCast(usize, letter - 'A');
    const width = @intCast(usize, 2 * n + 1);
    const height = width;

    var rows = try allocator.alloc([][]u8, height);
    var row_count: usize = 0;
    var success = false;

    defer {
        if (!success) {
            for (0..row_count) |i| {
                allocator.free(rows[i]);
            }
            allocator.free(rows);
        }
    }

    for (0..height) |i| {
        const d = @intCast(usize, @abs(@intCast(isize, i) - @intCast(isize, n)));
        const leading = d;
        const row = try allocator.alloc(u8, width);
        std.mem.set(row, @as(u8, ' '));

        if (d == n) {
            row[leading] = 'A';
        } else {
            const ch = @as(u8, 'A' + n - d);
            const inner = width - 2 * leading - 2;
            row[leading] = ch;
            row[leading + 1 + inner] = ch;
        }

        rows[i] = row;
        row_count += 1;
    }

    success = true;
    return rows;
}
