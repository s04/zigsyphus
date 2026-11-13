pub fn primes(buffer: []u32, limit: u12) []u32 {
    if (limit < 2) {
        return buffer[0..0];
    }

    const lim: u32 = @intCast(limit);
    var composite: [4096]bool = undefined;
    for (&composite) |*c| {
        c.* = false;
    }

    var count: usize = 0;
    var n: u32 = 2;
    while (n <= lim) : (n += 1) {
        if (!composite[n]) {
            if (count < buffer.len) {
                buffer[count] = n;
            }
            count += 1;
            var multiple: u32 = n * n;
            while (multiple <= lim) : (multiple += n) {
                composite[multiple] = true;
            }
        }
    }

    const written: usize = @min(count, buffer.len);
    return buffer[0..written];
}
