const std = @import("std");
const mem = std.mem;

pub fn prime(allocator: mem.Allocator, number: usize) !usize {
    _ = allocator;
    if (number == 0) {
        return error.InvalidArgument;
    }
    if (number == 1) {
        return 2;
    }

    var count: usize = 1; // we already have prime 2
    var candidate: usize = 3;

    while (true) {
        if (isPrime(candidate)) {
            count += 1;
            if (count == number) {
                return candidate;
            }
        }
        candidate += 2; // only check odd numbers
    }
}

fn isPrime(n: usize) bool {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    var i: usize = 3;
    while (i * i <= n) : (i += 2) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}
