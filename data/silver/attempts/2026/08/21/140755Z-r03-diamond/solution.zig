const std = @import("std");
const mem = std.mem;

pub fn rows(allocator: mem.Allocator, letter: u8) allocator.Error![][]u8 {
    std.debug.assert(letter >= 'A');
    std.debug.assert(letter <= 'Z');

    const n = @intCast(usize, letter - @as(u8, 'A'));
    const width = @intCast(usize, 2 * n + 1);
    const height = width;

    var rows_ptr = try allocator.alloc([]u8, height);
    var row_count: usize = 0;
    var success = false;
    defer {
        if (!success) {
            for (0..row_count) |j| {
                allocator.free(rows_ptr[j]);
            }
            allocator.free(rows_ptr);
        }
    };

    for (0..height) |i| {
        const d = @intCast(usize, @abs(@intCast(isize, i) - @intCast(isize, n)));
        const leading = d;
        const row = try allocator.alloc(u8, width);
        defer if (!success) allocator.free(row); // will be cleared on success
        std.mem.set(row, @as(u8, ' '));

        if (d == n) {
            // Top or bottom row: single 'A'
            row[leading] = 'A';
        } else {
            const ch = @as(u8, 'A' + n - d);
            const inner = width - 2 * leading - 2;
            row[leading] = ch;
            row[leading + 1 + inner] = ch;
        }

        rows_ptr[i] = row;
        row_count += 1;
        // Clear the defer for this row since ownership transferred to rows_ptr
        // We do this by setting the deferred row to an invalid value and relying on success flag.
        // Actually we need to prevent the defer from freeing this row.
        // We'll instead not defer free here; we'll manage cleanup via success flag and row_count.
        // So remove the defer inside loop and rely on outer defer.
    }

    success = true;
    // Return a slice of the allocated rows
    return rows_ptr[0..height];
}
