const std = @import("std");
const mem = std.mem;

pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    _ = allocator;
    _ = s;
    var filtered = (std.ArrayList(u8)).init(allocator);
    defer filtered.deinit();

    for (s) |c| {
        if (std.ascii.isAlpha(c)) {
            const lower = std.ascii.toLower(c);
            const encoded = 'z' - (lower - 'a');
            try filtered.append(encoded);
        } else if (std.ascii.isDigit(c)) {
            try filtered.append(c);
        }
    }

    var result = (std.ArrayList(u8)).init(allocator);
    defer result.deinit();

    var count: usize = 0;
    for (filtered.items) |c| {
        if (count > 0 and count % 5 == 0) {
            try result.append(' ');
        }
        try result.append(c);
        count += 1;
    }

    return result.toOwnedSlice();
}

pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    _ = allocator;
    _ = s;
    var result = (std.ArrayList(u8)).init(allocator);
    defer result.deinit();

    for (s) |c| {
        if (std.ascii.isAlpha(c)) {
            const lower = std.ascii.toLower(c);
            const decoded = 'z' - (lower - 'a');
            try result.append(decoded);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        }
    }

    return result.toOwnedSlice();
}
