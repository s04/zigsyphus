const std = @import("std");
const mem = std.mem;

pub fn rows(allocator: mem.Allocator, letter: u8) mem.Allocator.Error![][]u8 {
    const offset = @intCast(u8, letter - 'A');
    const offset_usize = @intCast(usize, offset);
    const width = 2 * offset + 1;
    const width_usize = @intCast(usize, width);
    const size = width; // number of rows equals width

    var rows = try allocator.alloc([]u8, size);
    var i: usize = 0;
    errdefer {
        for (rows[0..i]) |r| {
            allocator.free(r);
        }
        allocator.free(rows);
    };

    for (0..size) |r| {
        const r_usize = r;
        const d = if (r_usize <= offset_usize) offset_usize - r_usize else r_usize - offset_usize;
        const leading = d;
        const ch = @as(u8, 'A' + offset - @intCast(u8, d));

        var row = try allocator.alloc(u8, width);
        mem.set(u8, row, ' ');

        if (ch == 'A') {
            row[leading] = ch;
        } else {
            const inner = width_usize - 2 * leading - 2;
            row[leading] = ch;
            row[leading + 1 + inner] = ch;
        }

        rows[i] = row;
        i += 1;
    }

    return rows;
}
