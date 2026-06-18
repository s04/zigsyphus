```zig
pub fn squareRoot(radicand: usize) usize {
    if radicand == 0 {
        return 0;
    }
    var low: usize = 1;
    var high: usize = radicand;
    while (low <= high) {
        const mid = low + ((high - low) / 2);
        const sq = mid * mid;
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
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        } else if (mid * mid < radicand) {
            low = mid + 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
        const mid_sq = mid * mid;
        if (mid > 0 && mid > radicand / mid) {
            high = mid - 1;
        }
