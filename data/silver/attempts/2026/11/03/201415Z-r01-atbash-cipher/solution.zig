const std = @import("std");
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    // First pass: filter and transform characters
    var filtered = std.ArrayList(u8).init(allocator);
    defer filtered.deinit();

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const lower = std.ascii.toLower(c);
            // Atbash: a->z, b->y, ..., z->a
            const encoded = 'z' - (lower - 'a');
            try filtered.append(encoded);
        } else if (std.ascii.isDigit(c)) {
            try filtered.append(c);
        }
        // Skip punctuation and spaces
    }

    // Second pass: group into 5-character groups
    const filtered_slice = filtered.items;
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    var count: usize = 0;
    for (filtered_slice) |c| {
        if (count > 0 && count % 5 == 0) {
            try result.append(' ');
        }
        try result.append(c);
        count += 1;
    }

    return result.toOwnedSlice();
}

/// Decodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const lower = std.ascii.toLower(c);
            // Atbash is symmetric: same transformation
            const decoded = 'z' - (lower - 'a');
            try result.append(decoded);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        }
        // Skip spaces and punctuation
    }

    return result.toOwnedSlice();
}
