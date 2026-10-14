const std = @import("std");
const mem = std.mem;

pub fn slices(comptime slice_length: usize, allocator: mem.Allocator, series: []const u8) mem.Allocator.Error![][slice_length]u8 {
    comptime {
        std.debug.assert(slice_length > 0);
    }

    if (series.len < slice_length) {
        return try allocator.alloc([slice_length]u8, 0);
    }

    const num_slices = series.len - slice_length + 1;
    var result = try allocator.alloc([slice_length]u8, num_slices);

    var i: usize = 0;
    while (i < num_slices) : (i += 1) {
        var j: usize = 0;
        while (j < slice_length) : (j += 1) {
            result[i][j] = series[i + j];
        }
    }

    return result;
}
