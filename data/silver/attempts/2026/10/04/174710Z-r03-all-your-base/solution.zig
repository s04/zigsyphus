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

    var quot_buf = try allocator.alloc(u32, digits.len);
    defer allocator.free(quot_buf);
    var list = std.ArrayList(u32).init(allocator);
    defer list.deinit();

    var remaining = digits;
    while (true) {
        var rem: u32 = 0;
        var j: usize = 0;
        for (remaining) |d| {
            var temp: u64 = @as(u64, rem) * @as(u64, input_base) + @as(u64, d);
            var qdig = @intCast(@trunc(temp / @as(u64, output_base)));
            rem = @intCast(temp % @as(u64, output_base));
            if (j > 0 || qdig != 0) {
                quot_buf[j] = qdig;
                j += 1;
            }
        }
        try list.append(rem);
        if (j == 0) {
            break;
        } else {
            remaining = quot_buf[0..j];
        }
    }

    if (list.items.len == 0) {
        try list.append(0);
    }

    var res = try allocator.alloc(u32, list.items.len);
    var i: usize = 0;
    while (i < list.items.len) {
        res[i] = list.items[list.items.len - 1 - i];
        i += 1;
    }
    return res;
}
