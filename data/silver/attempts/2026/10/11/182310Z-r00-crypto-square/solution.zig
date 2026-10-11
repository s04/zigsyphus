const std = @import("std");
const mem = std.mem;

/// Encodes `plaintext` using the square code. Caller owns the returned memory.
pub fn ciphertext(allocator: mem.Allocator, plaintext: []const u8) mem.Allocator.Error![]u8 {
    // Normalize: keep only alphanumeric characters, down-case.
    var normalized = std.ArrayList(u8).init(allocator);
    defer normalized.deinit();

    for (plaintext) |c| {
        if (std.ascii.isAlphanumeric(c)) {
            try normalized.append(std.ascii.toLower(c));
        }
    }

    const n = normalized.items.len;
    if (n == 0) {
        return allocator.dupe(u8, "");
    }

    // Compute rectangle dimensions: c columns, r rows.
    // c = ceil(sqrt(n)), r = ceil(n / c).
    var c: usize = 1;
    while (c * c < n) {
        c += 1;
    }
    const r = (n + c - 1) / c;

    // Pad the normalized text to fill the r x c rectangle.
    const total = r * c;
    try normalized.ensureTotalCapacity(total);
    while (normalized.items.len < total) {
        try normalized.append(' ');
    }

    // Build the output by reading down the columns, chunks separated by spaces.
    var output = std.ArrayList(u8).init(allocator);
    defer output.deinit();

    var col: usize = 0;
    while (col < c) : (col += 1) {
        if (col > 0) {
            try output.append(' ');
        }
        var row: usize = 0;
        while (row < r) : (row += 1) {
            try output.append(normalized.items[row * c + col]);
        }
    }

    return output.toOwnedSlice();
}
