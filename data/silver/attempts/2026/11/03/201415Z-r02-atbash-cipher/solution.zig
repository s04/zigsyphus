const std = @import("std");
const mem = std.mem;

/// Encodes `s` using the Atbash cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var filtered = std.ArrayList(u8).init(allocator);
    defer filtered.deinit();

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const lower = std.ascii.toLower(c);
            const encoded = 'z' - (lower - 'a');
            try filtered.append(encoded);
        } else if (std.ascii.isDigit(c)) {
            try filtered.append(c);
        }
    }

    const filtered_slice = filtered.items;
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    var count: usize = 0;
    for (filtered_slice) |c| {
        if (count > 0 and count % 5 == 0) {
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
            const decoded = 'z' - (lower - 'a');
            try result.append(decoded);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        }
    }

    return result.toOwnedSlice();
}
