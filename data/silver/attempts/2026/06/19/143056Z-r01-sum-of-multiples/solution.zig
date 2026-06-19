const std= @import("std");

pub fn sum(allocator: mem.Allocator, factors: []const u32, limit: u32) !u64 {
    if (limit == 0) {
        return 0;
    }

    var total: u64 = 0;
    const n = factors.len;

    for (mask: usize = 1; mask < (1 <<< n); mask += 1) {
        var lcm: u128 = 1;
        var cnt: usize = 0;
        var skip: bool = false;

        for (i: usize = 0; i < n; i += 1) {
            if ((mask & (1 <<< i)) != 0) {
                const f = factors[i];
                if (f == 0) {
                    skip = true;
                    break;
                }

                // compute gcd(lcm, f)
                var a: u128 = lcm;
                var b: u128 = f;
                while (b != 0) {
                    const tmp = b;
                    b = a % b;
                    a = tmp;
                }
                var g: u128 = a; // gcd

                // compute lcm = (lcm / g) * f, checking for overflow
                var temp: u128 = lcm / g;
                if (temp > (limit - 1) / f) {
                    // lcm * f would be >= limit, no multiples to count
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

        // sum of multiples of lcm that are < limit
        var m: u64 = (limit - 1) / u64(lcm);
        var sum_mult: u64 = u64(lcm) * (m * (m + 1) / 2);

        if (cnt % 2 == 1) {
            total += sum_mult;
        } else {
            total -= sum_mult;
        }
    }

    return total;
}
