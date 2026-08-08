const std = @import("std");
const mem = std.mem;

const ValueNoun = struct {
    value: u16,
    symbol: []const u8,
};

pub fn toRoman(allocator: mem.Allocator, arabicNumeral: i16) mem.Allocator.Error![]u8 {
    const value_nouns: [13]ValueNoun = .{
        { .value = 1000, .symbol = "M" },
        { .value = 900,  .symbol = "CM" },
        { .value = 500,  .symbol = "D" },
        { .value = 400,  .symbol = "CD" },
        { .value = 100,  .symbol = "C" },
        { .value = 90,   .symbol = "XC" },
        { .value = 50,   .symbol = "L" },
        { .value = 40,   .symbol = "XL" },
        { .value = 10,   .symbol = "X" },
        { .value = 9,    .symbol = "IX" },
        { .value = 5,    .symbol = "V" },
        { .value = 4,    .symbol = "IV" },
        { .value = 1,    .symbol = "I" },
    };

    var result: []u8 = try allocator.alloc(u8, 0);

    for (value_nouns) |vn| {
        while (u16(arabicNumeral) >= vn.value) {
            result = try allocator.append(result, vn.symbol);
            arabicNumeral -= vn.value;
        }
    }

    return result;
}
