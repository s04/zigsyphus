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
        return try allocator.dupe("zero");
    }

    return try sayRecursive(allocator, number);
}

fn sayRecursive(allocator: mem.Allocator, number: i41) (mem.Allocator.Error)![]u8 {
    var parts = std.ArrayList([]const u8).init(allocator);
    defer parts.deinit();

    var remaining = number;

    const billions = remaining / 1_000_000_000;
    if (billions > 0) {
        try parts.append(try sayUnderThousand(allocator, billions));
        try parts.append("billion");
        remaining = remaining % 1_000_000_000;
    }

    const millions = remaining / 1_000_000;
    if (millions > 0) {
        try parts.append(try sayUnderThousand(allocator, millions));
        try parts.append("million");
        remaining = remaining % 1_000_000;
    }

    const thousands = remaining / 1_000;
    if (thousands > 0) {
        try parts.append(try sayUnderThousand(allocator, thousands));
        try parts.append("thousand");
        remaining = remaining % 1_000;
    }

    if (remaining > 0) {
        try parts.append(try sayUnderThousand(allocator, remaining));
    }

    return try joinParts(allocator, parts.items);
}

fn sayUnderThousand(allocator: mem.Allocator, number: i41) (mem.Allocator.Error)![]const u8 {
    var parts = std.ArrayList([]const u8).init(allocator);
    defer parts.deinit();

    const hundreds = number / 100;
    if (hundreds > 0) {
        try parts.append(try sayBasic(allocator, hundreds));
        try parts.append("hundred");
    }

    const remainder = number % 100;
    if (remainder > 0) {
        if (parts.items.len > 0) {
            try parts.append("-");
        }
        try parts.append(try sayBasic(allocator, remainder));
    }

    return try joinParts(allocator, parts.items);
}

fn sayBasic(allocator: mem.Allocator, number: i41) (mem.Allocator.Error)![]const u8 {
    const basic = [_][]const u8{
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
        "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
    };

    if (number >= 0 and number <= 19) {
        return try allocator.dupe(basic[number]);
    } else if (number >= 20 and number <= 90 and (number % 10 == 0)) {
        return try allocator.dupe(basic[number / 10 + 18]);
    }

    return "";
}

fn joinParts(allocator: mem.Allocator, parts: []const []const u8) (mem.Allocator.Error)![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    for (parts) |part| {
        try result.appendSlice(part);
    }

    return try result.toOwnedSlice();
}
