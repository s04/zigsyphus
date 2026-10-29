const std = @import("std");
const mem = std.mem;

pub fn slices(comptime slice_length: usize, allocator: mem.Allocator, series: []const u8) mem.Allocator.Error![][slice_length]u8 {
    comptime {
        std.debug.assert(slice_length > 0);
    }

    const num_slices = if (slice_length > series.len) 0 else series.len - slice_length + 1;
    const result = try allocator.alloc([][slice_length]u8, num_slices);

    for (result, 0..) |*slice, i| {
        mem.copy(u8, slice[0..slice_length], series[i..i + slice_length]);
    }

    return result;
}
