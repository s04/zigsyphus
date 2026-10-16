const std = @import("std");
const mem = std.mem;

pub const SayError = error{
    OutOfRange,
};

pub fn say(allocator: mem.Allocator, number: i41) (mem.Allocator.Error || SayError)![]u8 {
    if (number < 0 or number > 999_999_999_999) {
        return error.OutOfRange;
    }
    if (number == 0) {
        return try allocator.dupe(u8, "zero");
    }

    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    var n = number;

    const billions = n / 1_000_000_000;
    if (billions > 0) {
        try appendGroup(allocator, &result, billions, "billion");
        n = n % 1_000_000_000;
    }

    const millions = n / 1_000_000;
    if (millions > 0) {
        try appendGroup(allocator, &result, millions, "million");
        n = n % 1_000_000;
    }

    const thousands = n / 1_000;
    if (thousands > 0) {
        try appendGroup(allocator, &result, thousands, "thousand");
        n = n % 1_000;
    }

    if (n > 0) {
        if result.items.len > 0 {
            try result.append(' ');
        }
        try appendUnderThousand(allocator, &result, n);
    }

    return try result.toOwnedSlice();
}

fn appendGroup(allocator: mem.Allocator, list: *std.ArrayList(u8), group: i41, suffix: []const u8) (mem.Allocator.Error)!void {
    if list.items.len > 0 {
        try list.append(' ');
    }
    try appendUnderThousand(allocator, list, group);
    try list.appendSlice(suffix);
}

fn appendUnderThousand(allocator: mem.Allocator, list: *std.ArrayList(u8), number: i41) (mem.Allocator.Error)!void {
    const hundreds = number / 100;
    if (hundreds > 0) {
        if list.items.len > 0 {
            try list.append(' ');
        }
        try list.appendSlice(sayBasic(hundreds));
        try list.appendSlice(" hundred");
    }

    const remainder = number % 100;
    if (remainder > 0) {
        if list.items.len > 0 {
            try list.append(' ');
        }

        if remainder < 20 {
            try list.appendSlice(sayBasic(remainder));
        } else {
            const tens = (remainder / 10) * 10;
            const ones = remainder % 10;
            try list.appendSlice(sayBasic(tens));
            if ones != 0 {
                try list.append('-');
                try list.appendSlice(sayBasic(ones));
            }
        }
    }
}

fn sayBasic(number: i41) []const u8 {
    const basic = [_][]const u8{
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
        "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
    };
    if (number >= 0 and number <= 19) {
        return basic[number];
    } else {
        // number is a multiple of 10 between 20 and 90
        return basic[number / 10 + 18];
    }
}
