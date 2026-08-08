const std = @import("std");
const mem = std.mem;

pub fn toRoman(allocator: mem.Allocator, arabicNumeral: i16) mem.Allocator.Error![]u8 {
    if (arabicNumeral < 1 or arabicNumeral > 3999) {
        return error.OutOfRange;
    }

    const values = [_]struct {
        val: i16,
        sym: []const u8,
    }{
        {.val = 1000,.sym = "M" },
        {.val = 900,.sym = "CM" },
        {.val = 500,.sym = "D" },
        {.val = 400,.sym = "CD" },
        {.val = 100,.sym = "C" },
        {.val = 90,.sym = "XC" },
        {.val = 50,.sym = "L" },
        {.val = 40,.sym = "XL" },
        {.val = 10,.sym = "X" },
        {.val = 9,.sym = "IX" },
        {.val = 5,.sym = "V" },
        {.val = 4,.sym = "IV" },
        {.val = 1,.sym = "I" },
    };

    var remaining = arabicNumeral;
    var result_buffer: [16]u8 = undefined;
    var i: usize = 0;

    for (values) |entry| {
        while (remaining >= entry.val) {
            if (i + std.mem.len(entry.sym) > result_buffer.len) {
                return error.OutOfMemory;
            }
            @memcpy(result_buffer[i.. i + std.mem.len(entry.sym)], entry.sym);
            i += std.mem.len(entry.sym);
            remaining -= entry.val;
        }
    }

    return allocator.dupe(u8, result_buffer[0..i]);
}
