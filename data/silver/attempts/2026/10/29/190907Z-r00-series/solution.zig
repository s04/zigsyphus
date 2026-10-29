const std = @import("std");
const mem = std.mem;

pub fn slices(comptime slice_length: usize, allocator: mem.Allocator, series: []const u8) mem.Allocator.Error![][slice_length]u8 {
    comptime {
        std.debug.assert(slice_length > 0);
    }

    if (slice_length > series.len) {
        return try allocator.alloc([slice_length]u8, 0);
    }

    const count = series.len - slice_length + 1;
    var result = try allocator.alloc([slice_length]u8, count);

    var i: usize = 0;
    while (i < count) : (i += 1) {
        mem.copy([slice_length]u8, result[i], series[i..][0..slice_length]);
    }

    return result;
}
