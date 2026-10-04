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
        var result = try allocator.alloc(u32, 1);
        result[0] = 0;
        return result;
    }
    var value: u64 = 0;
    for (digits) |d| {
        value = value * @as(u64, input_base) + @as(u64, d);
    }
    if (value == 0) {
        var result = try allocator.alloc(u32, 1);
        result[0] = 0;
        return result;
    }
    var list = std.ArrayList(u32).init(allocator);
    defer list.deinit();
    while (value > 0) {
        var rem: u32 = @intCast(value % @as(u64, output_base));
        try list.append(rem);
        value = value / @as(u64, output_base);
    }
    var result = try allocator.alloc(u32, list.items.len);
    var i: usize = 0;
    while (i < list.items.len) : (i += 1) {
        result[list.items.len - 1 - i] = list.items[i];
    }
    return result;
}
