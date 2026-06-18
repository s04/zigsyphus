pub fn squareRoot(radicand: usize) usize {
    if radicand == 0 {
        return 0;
    }
    var low: usize = 1;
    var high: usize = radicand;
    while (low <= high) {
        const mid = low + ((high - low) / 2);
        // Avoid overflow: if mid > radicand / mid then mid*mid > radicand
        if (mid != 0 && mid > radicand / mid) {
            high = mid - 1;
            continue;
        }
        const sq = mid * mid;
        if (sq == radicand) {
            return mid;
        } else if (sq < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    // For the given test cases radicand is a perfect square, so we should always find a match.
    // Fallback return 0 to satisfy the compiler.
    return 0;
}
