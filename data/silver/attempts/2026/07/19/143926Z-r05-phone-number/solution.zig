pub fn clean(phrase: []const u8) ?[10]u8 {
    var digits: [11]u8 = undefined;
    var count: usize = 0;

    for (phrase) |c| {
        if (c >= '0' and c <= '9') {
            if (count < 11) {
                digits[count] = c;
                count += 1;
            } else {
                return null; // too many digits
            }
        } else if (c == ' ' or c == '(' or c == ')' or c == '-' or c == '.' or c == '+') {
            // ignore allowed punctuation and whitespace
        } else {
            return null; // invalid character
        }
    }

    if (count != 10 and count != 11) {
        return null;
    }

    var start: usize = 0;
    if (count == 11) {
        if (digits[0] != '1') {
            return null;
        }
        start = 1;
    }

    // Validate area code first digit (N)
    if (digits[start] < '2' or digits[start] > '9') {
        return null;
    }

    // Validate exchange code first digit (N)
    if (digits[start + 3] < '2' or digits[start + 3] > '9') {
        return null;
    }

    var result: [10]u8 = undefined;
    for (0..10) |i| {
        result[i] = digits[start + i];
    }
    return result;
}
