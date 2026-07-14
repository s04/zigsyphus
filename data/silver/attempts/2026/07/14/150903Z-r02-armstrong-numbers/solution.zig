pub fn isArmstrongNumber(num: u128) bool {
    if (num == 0) {
        return true;
    }

    // count digits
    var digits: usize = 0;
    var temp = num;
    while (temp != 0) {
        digits += 1;
        temp /= 10;
    }

    // compute sum of digit^digits
    var sum: u128 = 0;
    var remaining = num;
    const MaxU128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    while (remaining != 0) {
        const digit = remaining % 10;
        const digit_pow = int_pow(digit, digits);
        if (sum > MaxU128 - digit_pow) return false;
        sum += digit_pow;
        remaining /= 10;
    }

    return sum == num;
}

fn int_pow(base: u128, exp: usize) u128 {
    var result: u128 = 1;
    var i: usize = 0;
    while (i < exp) {
        result *= base;
        i += 1;
    }
    return result;
}
