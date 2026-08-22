pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

/// Asserts that `n` is nonzero.
pub fn classify(n: u64) Classification {
    var sum: u64 = 0;
    var i: u64 = 1;
    while (i <= n / i) {
        if (n % i == 0) {
            if (i != n) {
                sum += i;
            }
            const j = n / i;
            if (j != i and j != n) {
                sum += j;
            }
        }
        i += 1;
    }
    if (sum < n) {
        return Classification.deficient;
    } else if (sum == n) {
        return Classification.perfect;
    } else {
        return Classification.abundant;
    }
}
