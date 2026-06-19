const mem = std.mem;

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    if (limit == 0) {
        return 0;
    }

    var total: u64 = 0;
    const n = factors.len;

    // Iterate over all non-empty subsets of factors using bitmask
    for (mask: usize = 1; mask < (1 << n); mask += 1) {
        var lcm: u128 = 1;
        var cnt: usize = 0;
        var skip: bool = false;

        // Compute LCM for the current subset
        for (i: usize = 0; i < n; i += 1) {
            if ((mask & (1 << i)) != 0) {
                const f = factors[i];
                if (f == 0) {
                    skip = true;
                    break;
                }

                // Compute GCD(lcm, f)
                var a: u128 = lcm;
                var b: u128 = f;
                while (b != 0) {
                    const tmp = b;
                    b = a % b;
                    a = tmp;
                }
                var g: u128 = a; // gcd

                // Compute new LCM = (lcm / g) * f, checking for overflow
                var temp: u128 = lcm / g;
                if (temp > (limit - 1) / f) {
                    // Multiplying would exceed the limit, no need to consider this subset
                    skip = true;
                    break;
                }
                lcm = temp * f;
                cnt += 1;
            }
        }

        if (skip) {
            continue;
        }

        // Sum of multiples of lcm that are < limit
        var m: u64 = (limit - 1) / u64(lcm);
        var sum_mult: u64 = u64(lcm) * (m * (m + 1) / 2);

        // Inclusion-Exclusion principle
        if (cnt % 2 == 1) {
            total += sum_mult;
        } else {
            total -= sum_mult;
        }
    }

    return total;
}
