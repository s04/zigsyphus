const std = @import("std");

pub fn primes(buffer: []u32, limit: u12) []u32 {
    if (limit < 2) {
        return buffer[0..0];
    }

    var is_composite = std.mem.zeroes([4096]bool)[0..@as(usize, limit) + 1];

    var count: usize = 0;

    var i: u12 = 2;
    while (i <= limit) : (i += 1) {
        if (!is_composite[i]) {
            if (count < buffer.len) {
                buffer[count] = i;
                count += 1;
            }

            if (i *% i <= limit) {
                var j: u12 = i *% i;
                while (j <= limit) : (j +%= i) {
                    is_composite[j] = true;
                }
            }
        }
    }

    return buffer[0..count];
}
