const std = @import("std");
const mem = std.mem;

pub fn annotate(allocator: mem.Allocator, garden: []const []const u8) mem.Allocator.Error![][]u8 {
    const rows = garden.len;
    if (rows == 0) {
        return try allocator.alloc([]u8, 0);
    }

    var result = try allocator.alloc([]u8, rows);
    var allocated_rows: usize = 0;
    errdefer {
        for (0..allocated_rows) |i| {
            allocator.free(result[i]);
        }
        allocator.free(result);
    }

    for (0..rows) |r| {
        const row_len = garden[r].len;
        var new_row = try allocator.alloc(u8, row_len);

        for (0..row_len) |c| {
            const cell = garden[r][c];
            if (cell == '*') {
                new_row[c] = '*';
            } else {
                var count: usize = 0;

                var dr: i2 = -1;
                while (dr <= 1) : (dr += 1) {
                    const nr = @intCast(isize, r) + @intCast(isize, dr);
                    if (nr < 0 or @as(usize, nr) >= rows) continue;
                    const nr_u = @as(usize, nr);
                    const target_row_len = garden[nr_u].len;

                    var dc: i2 = -1;
                    while (dc <= 1) : (dc += 1) {
                        if (dr == 0 and dc == 0) continue;
                        const nc = @intCast(isize, c) + @intCast(isize, dc);
                        if (nc < 0 or @as(usize, nc) >= target_row_len) continue;
                        if (garden[nr_u][@as(usize, nc)] == '*') {
                            count += 1;
                        }
                    }
                }

                new_row[c] = if (count == 0) ' ' else '0' + @intCast(u8, count);
            }
        }

        result[r] = new_row;
        allocated_rows = r + 1;
    }

    return result;
}
