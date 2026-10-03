const std = @import("std");

pub fn combinations(buffer: []u9, sum: usize, size: usize, exclude: u9) []const u9 {
    var results: usize = 0;
    var mask: u9 = 0;
    while (mask < 512) : (mask += 1) {
        if (@popCount(mask) == size) {
            if (mask & exclude == 0) {
                var current_sum: usize = 0;
                var m = mask;
                var i: u4 = 0;
                while (m != 0) {
                    if (m & 1 != 0) {
                        current_sum += @as(usize, i + 1);
                    }
                    m >>= 1;
                    i += 1;
                }
                if (current_sum == sum) {
                    buffer[results] = mask;
                    results += 1;
                }
            }
        }
    }

    std.sort.sort(u9, buffer[0..results], {}, comptime std.sort.asc(u9));

    return buffer[0..results];
}
