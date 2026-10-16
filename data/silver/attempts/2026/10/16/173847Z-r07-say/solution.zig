const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub const SayError = error{
    OutOfRange,
};

pub fn say(allocator: mem.Allocator, number: i41) (mem.Allocator.Error || SayError)![]u8 {
    if (number < 0 || number > 999_999_999_999) {
        return SayError.OutOfRange;
    }
    if (number == 0) {
        return allocator.dupe(u8, "zero");
    }

    const ones = [_][]const u8{
        "", "one", "two", "three", "four", "five",
        "six", "seven", "eight", "nine", "ten",
        "eleven", "twelve", "thirteen", "fourteen", "fifteen",
        "sixteen", "seventeen", "eighteen", "nineteen",
    };
    const tens = [_][]const u8{
        "", "", "twenty", "thirty", "forty", "fifty",
        "sixty", "seventy", "eighty", "ninety",
    };
    const scales = [_][]const u8{ "", "thousand", "million", "billion" };

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    var n: u64 = @intCast(number);
    var part: u64 = 0;
    var scaleIndex: usize = 3; // billions, millions, thousands, units

    while (n > 0) : (scaleIndex -= 1) {
        part = n % 1000;
        n = n / 1000;
        if (part == 0) continue;

        var buf = std.ArrayList(u8).init(allocator);
        defer buf.deinit();

        // hundreds
        const hundreds = part / 100;
        const remainder = part % 100;
        if (hundreds > 0) {
            try buf.appendSlice(ones[hundreds]);
            try buf.appendSlice(" hundred");
        }

        // tens and ones
        if (remainder > 0) {
            if (hundreds > 0) try buf.append(' ');
            if (remainder < 20) {
                try buf.appendSlice(ones[remainder]);
            } else {
                const ten = remainder / 10;
                const one = remainder % 10;
                try buf.appendSlice(tens[ten]);
                if (one > 0) {
                    try buf.append('-');
                    try buf.appendSlice(ones[one]);
                }
            }
        }

        // append scale if not units
        if (scaleIndex > 0) {
            if (buf.items.len > 0) try buf.append(' ');
            try buf.appendSlice(scales[scaleIndex]);
        }

        // prepend to main list (if not first part, add space)
        if (list.items.len > 0) {
            try list.insert(0, ' ');
        }
        var partStr = try buf.toOwnedSlice();
        defer allocator.free(partStr);
        try list.insertSlice(0, partStr);
    }

    return list.toOwnedSlice();
}
