const std = @import("std");
const mem = std.mem;

pub fn transpose(allocator: mem.Allocator, lines: []const []const u8) mem.Allocator.Error![][]u8 {
    if (lines.len == 0) {
        return try allocator.alloc([]u8, 0);
    }

    var max_len: usize = 0;
    for (lines) |line| {
        if (line.len > max_len) max_len = line.len;
    }

    const result = try allocator.alloc([]u8, max_len);
    errdefer {
        var k: usize = 0;
        while (k < i) : (k += 1) {
            allocator.free(result[k]);
        }
        allocator.free(result);
    }

    var i: usize = 0;
    while (i < max_len) : (i += 1) {
        result[i] = try allocator.alloc(u8, lines.len);
    }

    i = 0;
    while (i < max_len) : (i += 1) {
        var j: usize = 0;
        while (j < lines.len) : (j += 1) {
            if (i < lines[j].len) {
                result[i][j] = lines[j][i];
            } else {
                result[i][j] = ' ';
            }
        }
    }

    return result;
}
