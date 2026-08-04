pub fn squareRoot(radicand: usize) usize {
    if (radicand < 2) {
        return radicand;
    }

    var low: usize = 0;
    var high: usize = radicand;
    while (low <= high) {
        const mid = (low + high) / 2;
        const sq = mid * mid;
        if (sq == radicand) {
            return mid;
        } else if (sq < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    // The problem guarantees a perfect square, so this line is unreachable
    return high;
}
