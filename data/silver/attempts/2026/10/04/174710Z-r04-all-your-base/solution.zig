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
    if (input_base < 2) return error.InvalidInputBase;
    if (output_base < 2) return error.InvalidOutputBase;
    for (digits) |d| {
        if (d >= input_base) return error.InvalidDigit;
    }
    if (digits.len == 0) {
        var zero = try allocator.alloc(u32, 1);
        zero[0] = 0;
        return zero;
    }

    var current = std.ArrayList(u32).init(allocator);
    defer current.deinit();
    try current.appendSlice(digits);

    var result = std.ArrayList(u32).init(allocator);
    defer result.deinit();

    while (true) {
        var rem: u32 = 0;
        var quot = std.ArrayList(u32).init(allocator);
        defer quot.deinit();
        for (current.items) |d| {
            var temp: u64 = @as(u64, rem) * @as(u64, input_base) + @as(u64, d);
            var qdig = @intCast(temp / @as(u64, output_base));
            rem = @intCast(temp % @as(u64, output_base));
            try quot.append(qdig);
        }
        try result.append(rem);

        // Remove leading zeros from quotient
        while quot.items.len > 0 && quot.items[0] == 0 {
            _ = quot.removeAt(0);
        }

        if (quot.items.len == 0) {
            break;
        } else {
            current.clear();
            try current.appendSlice(quot.items);
        }
    }

    if (result.items.len == 0) {
        try result.append(0);
    }

    var out = try allocator.alloc(u32, result.items.len);
    var i: usize = 0;
    while (i < result.items.len) {
        out[i] = result.items[result.items.len - 1 - i];
        i += 1;
    }
    return out;
}
