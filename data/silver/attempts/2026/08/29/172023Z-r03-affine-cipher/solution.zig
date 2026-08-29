const std = @import("std");
const mem = std.mem;

pub const AffineCipherError = error{
    NotCoprime,
};

fn gcd(a: u8, b: u8) u8 {
    var x = a;
    var y = b;
    while (y != 0) {
        const tmp = y;
        y = x % y;
        x = tmp;
    }
    return x;
}

fn mod_positive(a: i32, m: i32) i32 {
    var r = a % m;
    if (r < 0) {
        r += m;
    }
    return r;
}

pub fn encode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (gcd(a, 26) != 1) {
        return error.NotCoprime;
    }

    var transformed = std.ArrayList(u8).init(allocator);
    defer transformed.deinit();

    for (phrase) |c| {
        if (std.ascii.isLetter(c)) {
            const lower = std.ascii.toLower(c);
            const i = @intCast(i32, lower) - @intCast(i32, 'a');
            const e = (a * i + b) % 26;
            const out_char = @as(u8, 'a' + @intCast(u8, e));
            try transformed.append(out_char);
        } else if (std.ascii.isDigit(c)) {
            try transformed.append(c);
        } else {
            // skip punctuation and spaces
        }
    }

    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    for (transformed.items) |*ch, i| {
        try result.append(*ch);
        if ((i + 1) % 5 == 0 && (i + 1) != transformed.items.len) {
            try result.append(' ');
        }
    }

    return result.toOwnedSlice();
}

pub fn decode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (gcd(a, 26) != 1) {
        return error.NotCoprime;
    }

    // compute modular multiplicative inverse of a modulo 26
    var inv: u8 = 0;
    for (0..26) |x| {
        if ((a * @intCast(u16, x)) % 26 == 1) {
            inv = @intCast(u8, x);
            break;
        }
    }

    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    for (phrase) |c| {
        if (c == ' ') {
            continue;
        }
        if (std.ascii.isLetter(c)) {
            const lower = std.ascii.toLower(c);
            const y = @intCast(i32, lower) - @intCast(i32, 'a');
            const tmp = mod_positive(y - @intCast(i32, b), 26);
            const x = (inv * @intCast(i32, tmp)) % 26;
            const out_char = @as(u8, 'a' + @intCast(u8, x));
            try result.append(out_char);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        } else {
            // skip punctuation
        }
    }

    return result.toOwnedSlice();
}
