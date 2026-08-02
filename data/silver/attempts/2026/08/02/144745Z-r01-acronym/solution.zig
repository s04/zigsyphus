const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var cleaned = std.ArrayList(u8).init(allocator);
    defer cleaned.deinit();

    for (words) |c| {
        if (c == '-') {
            try cleaned.append(' ');
        } else if (!std.ascii.isAlphabetic(c) and c != ' ') {
            // Skip punctuation
        } else {
            try cleaned.append(c);
        }
    }

    var acronym = std.ArrayList(u8).init(allocator);
    var start: ?usize = null;

    for (cleaned.items, 0..) |c, i| {
        if (c == ' ') {
            if (start != null) {
                const idx = start.?;
                try acronym.append(std.ascii.toUpper(cleaned.items[idx]));
                start = null;
            }
        } else {
            if (start == null) {
                start = i;
            }
        }
    }

    if (start != null) {
        const idx = start.?;
        try acronym.append(std.ascii.toUpper(cleaned.items[idx]));
    }

    return acronym.toOwnedSlice();
}
