const std = @import("std");

pub fn clean(phrase: []const u8) ?[10]u8 {
    const allocator = std.heap.page_allocator;

    // Remove all non-digit characters
    const digits = std.mem.allocator.alloc(allocator, 10);
    var digit_count = 0;
    for (phrase) |c| {
        if c >= '0' and c <= '9' {
            if digit_count < 10 {
                digits[digit_count] = c;
                digit_count += 1;
            } else {
                std.mem.free(allocator, digits);
                return null;
            }
        }
    }
    if digit_count != 10 {
        std.mem.free(allocator, digits);
        return null;
    }

    // Check for invalid leading digits in area code or exchange code
    if digits[0] == '0' or digits[0] == '1' {
        std.mem.free(allocator, digits);
        return null;
    }
    if digits[3] == '0' or digits[3] == '1' {
        std.mem.free(allocator, digits);
        return null;
    }

    // If there are 11 digits, check if the first is '1' and adjust
    if digit_count == 11 {
        if digits[0] != '1' {
            std.mem.free(allocator, digits);
            return null;
        }
        // Shift digits to remove leading '1'
        for (0..9) |i| {
            digits[i] = digits[i + 1];
        }
        digit_count = 10;
    }

    // Ensure exactly 10 digits after processing
    if digit_count != 10 {
        std.mem.free(allocator, digits);
        return null;
    }

    return digits;
}
