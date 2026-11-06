pub const Classification = enum {
    deficient,
    perfect,
    abundant,
};

pub fn classify(n: u64) Classification {
    if (n == 1) {
        return Classification.deficient;
    }

    var sum: u64 = 1;
    var i: u64 = 2;

    while (i <= n / i) {
        if (n % i == 0) {
            sum += i;
            const other = n / i;
            if (other != i) {
                sum += other;
            }
        }
        i += 1;
    }

    if (sum == n) {
        return Classification.perfect;
    }
    if (sum > n) {
        return Classification.abundant;
    }
    return Classification.deficient;
}
