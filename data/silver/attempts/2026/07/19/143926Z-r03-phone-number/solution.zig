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
        if (digits[0] != '1') {
            return null;
        }
        if (digits[1] == '0' or digits[1] == '1') {
            return null;
        }
        if (digits[4] == '0' or digits[4] == '1') {
            return null;
        }
        var result: [10]u8 = undefined;
        for (0..10) |i| {
            result[i] = digits[i + 1];
        }
        return result;
    } else {
        if (digits[0] == '0' or digits[0] == '1') {
            return null;
        }
        if (digits[3] == '0' or digits[3] == '1') {
            return null;
        }
        return digits[0..9];
    }
}
