const std = @import("std");

pub fn squareRoot(radicand: usize) usize {
    if radicand == 0 {
        return 0;
    }
    var low: usize = 1;
    var high: usize = radicand;
    while (low <= high) {
        const mid = low + ((high - low) / 2);
        const mid_sq = mid * mid;
        if mid_sq == radicand {
            return mid;
        } else if mid_sq < radicand {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    return low - 1;
}
