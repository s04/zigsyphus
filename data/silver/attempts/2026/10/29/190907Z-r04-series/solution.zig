const std = @import("std");
const mem = std.mem;

pub fn slices(comptime slice_length: usize, allocator: mem.Allocator, series: []const u8) mem.Allocator.Error![][slice_length]u8 {
    comptime {
        std.debug.assert(slice_length > 0);
    }

    if (series.len < slice_length) {
        return allocator.alloc([slice_length]u8, 0);
    }

    const count = series.len - slice_length + 1;
    var result = try allocator.alloc([slice_length]u8, count);

    for (0..count) |i| {
        const start = i;
        const end = i + slice_length;
        @memcpy(&result[i], series[start..end]);
    }

    return result;
}
