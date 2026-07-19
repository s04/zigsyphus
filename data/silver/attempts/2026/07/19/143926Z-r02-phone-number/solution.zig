const std = @import("std");

pub fn clean(phrase: []const u8) ?[10]u8 {
    var digits: [11]u8 = undefined;
    var digit_count: usize = 0;

    for (phrase) |c| {
        if (c >= '0' and c <= '9') {
            if (digit_count < 11) {
                digits[digit_count] = c;
                digit_count += 1;
            } else {
                return null;
            }
        }
    }

    if (digit_count != 10 and digit_count != 11) {
        return null;
    }

    if (digit_count == 11) {
        // country code
        if (digits[0] != '1') {
            return null;
        }
        // area code (digits[1]) and exchange code (digits[4]) must not start with 0 or 1
        if (digits[1] == '0' or digits[1] == '1') {
            return null;
        }
        if (digits[4] == '0' or digits[4] == '1') {
            return null;
        }
        // copy digits[1..10] to result
        var result: [10]u8 = undefined;
        for (0..10) |i| {
            result[i] = digits[i + 1];
        }
        return result;
    } else { // digit_count == 10
        // area code (digits[0]) and exchange code (digits[3]) must not start with 0 or 1
        if (digits[0] == '0' or digits[0] == '1') {
            return null;
        }
        if (digits[3] == '0' or digits[3] == '1') {
            return null;
        }
        // return the 10-digit array directly
        return digits[0..9];
    }
}
