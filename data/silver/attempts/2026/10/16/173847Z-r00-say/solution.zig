const std = @import("std");
const mem = std.mem;

pub const SayError = error{
    OutOfRange,
};

const under20 = [_][]const u8{
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
};

const tens = [_][]const u8{
    "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
};

fn sayUnder1000(allocator: mem.Allocator, list: *std.ArrayList(u8), n: u32) !void {
    const hundreds = n / 100;
    const remainder = n % 100;
    if (hundreds > 0) {
        try list.appendSlice(under20[hundreds]);
        try list.appendSlice(" hundred");
    }
    if (remainder > 0) {
        if (hundreds > 0) {
            try list.appendSlice(" ");
        }
        if (remainder < 20) {
            try list.appendSlice(under20[remainder]);
        } else {
            const ten = remainder / 10;
            const one = remainder % 10;
            try list.appendSlice(tens[ten]);
            if (one > 0) {
                try list.appendSlice("-");
                try list.appendSlice(under20[one]);
            }
        }
    }
}

pub fn say(allocator: mem.Allocator, number: i41) (mem.Allocator.Error || SayError)![]u8 {
    if (number < 0 or number > 999_999_999_999) {
        return SayError.OutOfRange;
    }
    if (number == 0) {
        return try allocator.dupe([]const u8, "zero");
    }

    const n = @as(u64, @intCast(number));
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    const billions = n / 1_000_000_000;
    const millions = (n % 1_000_000_000) / 1_000_000;
    const thousands = (n % 1_000_000) / 1_000;
    const ones = n % 1_000;

    var first = true;
    if (billions > 0) {
        try sayUnder1000(allocator, &list, @intCast(billions));
        try list.appendSlice(" billion");
        first = false;
    }
    if (millions > 0) {
        if (!first) try list.appendSlice(" ");
        try sayUnder1000(allocator, &list, @intCast(millions));
        try list.appendSlice(" million");
        first = false;
    }
    if (thousands > 0) {
        if (!first) try list.appendSlice(" ");
        try sayUnder1000(allocator, &list, @intCast(thousands));
        try list.appendSlice(" thousand");
        first = false;
    }
    if (ones > 0) {
        if (!first) try list.appendSlice(" ");
        try sayUnder1000(allocator, &list, @intCast(ones));
    }

    return list.toOwnedSlice();
}
