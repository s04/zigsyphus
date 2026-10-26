pub const SeriesError = error{
    InvalidCharacter,
    NegativeSpan,
    InsufficientDigits,
};

pub fn largestProduct(digits: []const u8, span: i32) SeriesError!u64 {
    if (span < 0) {
        return SeriesError.NegativeSpan;
    }
    if (span == 0) {
        return 1u64;
    }

    // Validate that all characters are digits.
    for (digits) |c| {
        if (c < '0' or c > '9') {
            return SeriesError.InvalidCharacter;
        }
    }

    const n = digits.len;
    if (n < span) {
        return SeriesError.InsufficientDigits;
    }

    const spanU = @intCast(usize, span);
    var maxProd: u64 = 0;
    var found: bool = false;

    for (0..n - spanU) |i| {
        var prod: u64 = 1;
        for (0..spanU) |j| {
            const digit = digits[i + j] - '0';
            prod *= digit;
        }
        if (!found or prod > maxProd) {
            maxProd = prod;
            found = true;
        }
    }

    return maxProd;
}
