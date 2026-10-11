const std = @import("std");
const mem = std.mem;

/// Encodes `plaintext` using the square code. Caller owns the returned memory.
pub fn ciphertext(allocator: mem.Allocator, plaintext: []const u8) mem.Allocator.Error![]u8 {
    // Count normalized characters (alphanumeric, lowercased).
    var n: usize = 0;
    for (plaintext) |c| {
        if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) {
            n += 1;
        }
    }

    if (n == 0) {
        return allocator.dupe(u8, "");
    }

    // Compute rectangle dimensions: c columns, r rows.
    // c = smallest integer such that c*c >= n.
    var c: usize = 1;
    while (c * c < n) {
        c += 1;
    }
    const r = (n + c - 1) / c;

    // Allocate normalized buffer padded to r*c with spaces.
    const total = r * c;
    var normalized = try allocator.alloc(u8, total);
    defer allocator.free(normalized);

    var i: usize = 0;
    for (plaintext) |ch| {
        if (std.ascii.isAlphabetic(ch) or std.ascii.isDigit(ch)) {
            normalized[i] = std.ascii.toLower(ch);
            i += 1;
        }
    }
    // Fill remaining positions with spaces.
    var j: usize = i;
    while (j < total) : (j += 1) {
        normalized[j] = ' ';
    }

    // Output: c chunks of r characters, separated by spaces.
    const out_len = c * r + (c - 1);
    var output = try allocator.alloc(u8, out_len);

    var out_i: usize = 0;
    var col: usize = 0;
    while (col < c) : (col += 1) {
        if (col > 0) {
            output[out_i] = ' ';
            out_i += 1;
        }
        var row: usize = 0;
        while (row < r) : (row += 1) {
            output[out_i] = normalized[row * c + col];
            out_i += 1;
        }
    }

    return output;
}
