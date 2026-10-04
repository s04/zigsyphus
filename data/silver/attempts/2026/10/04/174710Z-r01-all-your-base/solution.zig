const std = @import("std");
const mem = std.mem;

pub const ConversionError = error{
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit,
};

/// Converts `digits` from `input_base` to `output_base`, returning a slice of digits.
/// Caller owns the returned memory.
pub fn convert(
    allocator: mem.Allocator,
    digits: []const u32,
    input_base: u32,
    output_base: u32,
) (mem.Allocator.Error || ConversionError)![]u32 {
    // Validate bases
    if (input_base < 2) return error.InvalidInputBase;
    if (output_base < 2) return error.InvalidOutputBase;

    // Validate digits
    for (digits) |d| {
        if (d >= input_base) return error.InvalidDigit;
    }

    // Compute integer value using u128
    var value: u128 = 0;
    for (digits) |d| {
        value = value * @as(u128, input_base) + @as(u128, d);
    }

    // Convert value to output base
    if (value == 0) {
        const result = try allocator.alloc(u32, 1);
        result[0] = 0;
        return result;
    }

    // Determine number of digits needed
    var n = value;
    var count: usize = 0;
    while (n > 0) {
        n /= @as(u128, output_base);
        count += 1;
    }

    const result = try allocator.alloc(u32, count);
    var i = count - 1;
    var temp = value;
    while (temp > 0) {
        const rem = @as(u32, temp % @as(u128, output_base));
        result[i] = rem;
        temp /= @as(u128, output_base);
        i -= 1;
    }

    return result;
}
