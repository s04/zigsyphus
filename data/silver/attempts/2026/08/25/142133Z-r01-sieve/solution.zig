pub fn primes(buffer: []u32, limit: u12) []u32 {
    if (limit < 2) {
        return buffer[0..0];
    }

    var is_composite_array: [4096]bool = undefined;
    for (0..is_composite_array.len) |i| {
        is_composite_array[i] = false;
    }
    var is_composite = is_composite_array[0..@as(usize, limit) + 1];

    var count: usize = 0;

    var i: u12 = 2;
    while (i <= limit) : (i += 1) {
        if (!is_composite[@as(usize, i)]) {
            if (count < buffer.len) {
                buffer[count] = i;
                count += 1;
            }

            const i_usize: usize = @as(usize, i);
            const limit_usize: usize = @as(usize, limit);
            if (i_usize <= limit_usize / i_usize) {
                var j: usize = i_usize * i_usize;
                while (j <= limit_usize) : (j += i_usize) {
                    is_composite[j] = true;
                }
            }
        }
    }

    return buffer[0..count];
}
