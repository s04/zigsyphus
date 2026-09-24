const std = @import("std");
const mem = std.mem;

pub const SayError = error{
    OutOfRange,
};

const ones = [_][]const u8{
    "zero",      "one",       "two",       "three",     "four",
    "five",      "six",       "seven",     "eight",     "nine",
    "ten",       "eleven",    "twelve",    "thirteen",  "fourteen",
    "fifteen",   "sixteen",   "seventeen", "eighteen",  "nineteen",
};

const tens = [_][]const u8{
    "", "", "twenty", "thirty", "forty",
    "fifty", "sixty", "seventy", "eighty", "ninety",
};

const scales = [_]struct {
    name: []const u8,
    value: u64,
}{
    .{ .name = "billion", .value = 1_000_000_000 },
    .{ .name = "million", .value = 1_000_000 },
    .{ .name = "thousand", .value = 1_000 },
};

pub fn say(allocator: mem.Allocator, number: i41) (mem.Allocator.Error || SayError)![]u8 {
    if (number < 0 or number > 999_999_999_999) {
        return SayError.OutOfRange;
    }

    const n: u64 = @intCast(number);

    if (n == 0) {
        return try allocator.dupe(u8, "zero");
    }

    var buf: std.ArrayList(u8) = .empty;
    defer buf.deinit(allocator);

    var rem = n;
    var first = true;

    for (scales) |scale| {
        if (rem >= scale.value) {
            const chunk = rem / scale.value;
            rem %= scale.value;
            if (!first) {
                try buf.append(allocator, ' ');
            }
            first = false;
            try appendChunk(allocator, &buf, chunk);
            try buf.append(allocator, ' ');
            try buf.appendSlice(allocator, scale.name);
        }
    }

    if (rem > 0) {
        if (!first) {
            try buf.append(allocator, ' ');
        }
        try appendChunk(allocator, &buf, rem);
    }

    return try buf.toOwnedSlice(allocator);
}

fn appendChunk(allocator: mem.Allocator, buf: *std.ArrayList(u8), n: u64) mem.Allocator.Error!void {
    if (n == 0) return;

    if (n >= 100) {
        try buf.appendSlice(allocator, ones[n / 100]);
        try buf.appendSlice(allocator, " hundred");
        const r = n % 100;
        if (r > 0) {
            try buf.append(allocator, ' ');
            try appendChunk(allocator, buf, r);
        }
    } else if (n >= 20) {
        try buf.appendSlice(allocator, tens[n / 10]);
        const r = n % 10;
        if (r > 0) {
            try buf.append(allocator, '-');
            try buf.appendSlice(allocator, ones[r]);
        }
    } else {
        try buf.appendSlice(allocator, ones[n]);
    }
}
