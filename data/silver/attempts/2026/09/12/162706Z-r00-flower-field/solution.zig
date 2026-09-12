const std = @import("std");
const mem = std.mem;

pub fn annotate(allocator: mem.Allocator, garden: []const []const u8) mem.Allocator.Error![][]u8 {
    const result = try allocator.alloc([]u8, garden.len);
    errdefer allocator.free(result);

    var completed_rows: usize = 0;
    errdefer {
        var row: usize = 0;
        while (row < completed_rows) : (row += 1) {
            allocator.free(result[row]);
        }
    }

    const row_offsets = [_]isize{ -1, 0, 1 };
    const column_offsets = [_]isize{ -1, 0, 1 };

    while (completed_rows < garden.len) : (completed_rows += 1) {
        const output = try allocator.alloc(u8, garden[completed_rows].len);
        @memcpy(output, garden[completed_rows]);

        for (0..garden[completed_rows].len) |column| {
            if (garden[completed_rows][column] != ' ') continue;

            var flower_count: u8 = 0;
            for (row_offsets) |row_offset| {
                const neighbor_row = @as(isize, @intCast(completed_rows)) + row_offset;
                if (neighbor_row < 0 or neighbor_row >= @as(isize, @intCast(garden.len))) continue;

                for (column_offsets) |column_offset| {
                    const neighbor_column = @as(isize, @intCast(column)) + column_offset;
                    if (neighbor_column < 0 or neighbor_column >= @as(isize, @intCast(garden[completed_rows].len))) continue;

                    if (garden[@intCast(neighbor_row)][@intCast(neighbor_column)] == '*') {
                        flower_count += 1;
                    }
                }
            }

            if (flower_count > 0) {
                output[column] = @as(u8, '0' + flower_count);
            }
        }

        result[completed_rows] = output;
    }

    return result;
}
