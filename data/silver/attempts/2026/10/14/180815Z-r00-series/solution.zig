const std = @import("std");
const mem = std.mem;

pub fn slices(comptime slice_length: usize, allocator: mem.Allocator, series: []const u8) mem.Allocator.Error![][slice_length]u8 {
    comptime {
        std.debug.assert(slice_length > 0);
    }

    const num_slices = if (series.len >= slice_length) series.len - slice_length + 1 else 0;
    
    if (num_slices == 0) {
        return &{};
    }
    
    var result = try allocator.alloc([slice_length]u8, num_slices);
    
    var i: usize = 0;
    while (i < num_slices) : (i += 1) {
        mem.copy(u8, &result[i], series[i..][0..slice_length]);
    }
    
    return result;
}
