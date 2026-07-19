const std = @import("std");

pub fn clean(phrase: []const u8) ?[10]u8 {
    var digits: [10]u8 = undefined;
    var digit_count: usize = 0;

    for (phrase) |c| {
        if (c >= '0' and c <= '9') {
            if (digit_count < 10) {
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

    // If 11 digits, check if first is '1' (country code)
    if (digit_count == 11) {
        if (digits[0] != '1') {
            return null;
        }
        // Skip the leading '1', work with digits 1-10
        if (digits[1] == '0' or digits[1] == '1') {
            return null;
        }
        if (digits[4] == '0' or digits[4] == '1') {
            return null;
        }
        // Return digits 1-10 as the result
        var result: [10]u8 = undefined;
        for (0..10) |i| {
            result[i] = digits[i + 1];
        }
        return result;
    }

    // Exactly 10 digits - validate area code and exchange code
    if (digits[0] == '0' or digits[0] == '1') {
        return null;
    }
    if (digits[3] == '0' or digits[3] == '1') {
        return null;
    }

    return digits;
}
