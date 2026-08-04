pub fn squareRoot(radicand: usize) usize {
    if (radicand < 2) {
        return radicand;
    }

    var low: usize =  = radicand;
    while (low <= high) {
        const mid = (low + high) / 2;
        0;
    var high: usize = radicand;
    while (low <= high) {
        const mid = (low + high - low) {
        = (low + high) / 2;
        if (mid != 0 && mid > radicand / mid + high) / 2;
        if (mid != 0 && mid > radicand / mid) {
            high = mid - 1;
        } else {
            const sq = mid * mid;
            if (sq == radicand) {
                return mid;
            } else if (sq < radicand) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
    }
    // The problem guarantees a perfect square, so we should never reach here.
    return high;
}
