const std = @import("std");
const mem = std.mem;

pub const AffineCipherError = error{
    NotCoprime,
};

fn gcd(x: u32, y: u32) u32 {
    var aa = x;
    var bb = y;
    while (bb != 0) {
        const t = aa % bb;
        aa = bb;
        bb = t;
    }
    return aa;
}

fn modInverse(a: u32) u32 {
    var x: u32 = 1;
    while (x < 26) : (x += 1) {
        if ((a * x) % 26 == 1) return x;
    }
    return 1;
}

/// Encodes `phrase` using the affine cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    const aa: u32 = a;
    const bb: u32 = b;
    if (gcd(aa, 26) != 1) return AffineCipherError.NotCoprime;

    var n: usize = 0;
    for (phrase) |c| {
        if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) n += 1;
    }
    const spaces: usize = if (n == 0) 0 else (n - 1) / 5;
    const out = try allocator.alloc(u8, n + spaces);
    errdefer allocator.free(out);

    var idx: usize = 0;
    var count: usize = 0;
    for (phrase) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const i: u32 = std.ascii.toLower(c) - 'a';
            const e = (aa * i + bb) % 26;
            out[idx] = 'a' + @as(u8, @intCast(e));
            idx += 1;
            count += 1;
        } else if (std.ascii.isDigit(c)) {
            out[idx] = c;
            idx += 1;
            count += 1;
        }
        if (count == 5) {
            if (idx < out.len) {
                out[idx] = ' ';
                idx += 1;
            }
            count = 0;
        }
    }
    return out;
}

/// Decodes `phrase` using the affine cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    const aa: u32 = a;
    const bb: u32 = b;
    if (gcd(aa, 26) != 1) return AffineCipherError.NotCoprime;

    const inv = modInverse(aa);

    var n: usize = 0;
    for (phrase) |c| {
        if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) n += 1;
    }
    const out = try allocator.alloc(u8, n);
    errdefer allocator.free(out);

    var idx: usize = 0;
    for (phrase) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const y: u32 = std.ascii.toLower(c) - 'a';
            const t = (y + 26 - (bb % 26)) % 26;
            const d = (inv * t) % 26;
            out[idx] = 'a' + @as(u8, @intCast(d));
            idx += 1;
        } else if (std.ascii.isDigit(c)) {
            out[idx] = c;
            idx += 1;
        }
    }
    return out;
}
