const std = @import("std");
const mem = std.mem;

pub fn annotate(allocator: mem.Allocator, garden: []const []const u8) mem.Allocator.Error![][]u8 {
    if (garden.len == 0) {
        return try allocator.alloc([]u8, 0);
    }

    const rows = garden.len;
    const cols = garden[0].len;

    var result = try allocator.alloc([][]u8, rows);
    errdefer allocator.free(result);

    for (0..rows) |r| {
        result[r] = try allocator.alloc(u8, cols);
        errdefer {
            for (0..r) |i| {
                allocator.free(result[i]);
            }
        }
    }

    const offsets = [_]isize{ -1, 0, 1 };

    for (0..rows) |r| {
        for (0..cols) |c| {
            if (garden[r][c] == '*') {
                result[r][c] = '*';
                continue;
            }

            var count: u8 = 0;
            for (offsets) |di| {
                for (offsets) |dj| {
                    if (di == 0 and dj == 0) continue;
                    const nr = @as(isize, @intCast(r)) + di;
                    const nc = @as(isize, @intCast(c)) + dj;
                    if (nr >= 0 and nr < @as(isize, rows) and nc >= 0 and nc < @as(isize, cols)) {
                        if (garden[@intCast(nr)][@intCast(nc)] == '*') {
                            count += 1;
                        }
                    }
                }
            }

            if (count == 0) {
                result[r][c] = ' ';
            } else {
                result[r][c] = '0' + count;
            }
        }
    }

    return result;
}
