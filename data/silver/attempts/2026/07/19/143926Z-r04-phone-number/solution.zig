const std = @import("std");

pub fn clean(phrase: []const u8)?[10]u8 {
    var digits: [11]u8 = undefined;
    var digit_count: usize = 0;

    for (phrase) |c| {
        if (c >= '0' and c <= '9') {
            if (digit_count < 11) {
                digits[digit_count] = c;
                digit_count += 1;
            } else {
                // More than 11 digits found
                return null;
            }
        } else if (c!= ' and c!= '(' and c!= ')' and c!= '-' and c!= '.' and c!= '+' && c!= '.') {
            // If we encounter any character that is not a digit, space, or allowed punctuation,
            // the instructions imply we should check if it's a valid character for the input.
            // However, the tests "invalid with letters" and "invalid with punctuations" 
            // suggest that if any non-digit, non-space, non-standard-punctuation character 
            // is present, it might be invalid.
            // Let's refine: the problem says "removing punctuation". 
            // If a character is not a digit and not one of the allowed separators, it's invalid.
            if (c!= ' and c!= '(' and c!= ')' and c!= '-' and c!= '.' and c!= '+') {
                return null;
            }
        }
    }

    // Check for invalid characters like '@', ':', '!', etc.
    // The test "invalid with punctuations" uses "@:!-".
    // Let's re-evaluate: the loop above only allows specific chars.
    // Let's check the phrase for any character that is not a digit, space, or allowed punctuation.
    for (phrase) |c| {
        const is_digit = (c >= '0' and c <= '9');
        const is_allowed_punct = (c == ' or c == '(' or c == ')' or c == '-' or c == '.' or c == '+');
        if (!is_digit and!is_allowed_punct) {
            return null;
        }
    }

    if (digit_count!= 10 and digit_count!= 11) {
        return null;
    }

    if (digit_count == 11) {
        // NANP: 1 NXX NXX XXXX
        if (digits[0]!= '1') {
            return null;
        }
        // N is 2-9
        if (digits[1] < '2' or digits[1] > '9') {
            return null;
        }
        // X is 0-9
        // Exchange code (digits 4,5,6) NXX
        if (digits[4] < '2' or digits[4] > '9') {
            return null;
        }
        var result: [10]u8 = undefined;
        for (0..10) |i| {
            result[i] = digits[i + 1];
        }
        return result;
    } else {
        // 10 digits: NXX NXX XXXX
        // Area code (digits 0,1,2) NXX
        if (digits[0] < '2' or digits[0] > '9') {
            return null;
        }
        // Exchange code (digits 3,4,5) NXX
        if (digits[3] < '2' or digits[3] > '9') {
            return null;
        }
        var result: [10]u8 = undefined;
        for (0..10) |i| {
            result[i] = digits[i];
        }
        return result;
    }
}
