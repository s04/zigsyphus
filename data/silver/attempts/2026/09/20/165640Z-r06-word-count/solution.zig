const std = @import("std");
const mem = std.mem;

/// Returns the counts of the words in `s`.
/// Caller owns the returned memory.
pub fn countWords(allocator: mem.Allocator, s: []const u8) !std.StringHashMap(u32) {
    var map = std.StringHashMap(u32).init(allocator);
    errdefer map.deinit();

    var current_word = std.ArrayList(u8).init(allocator);
    defer current_word.deinit();

    for (s) |c| {
        if (isWordChar(c)) {
            try current_word.append(std.ascii.toLower(c));
        } else {
            if (current_word.items.len > 0) {
                try addWord(&map, &current_word);
                current_word.clear();
            }
        }
    }
    if (current_word.items.len > 0) {
        try addWord(&map, &current_word);
    }

    return map;
}

fn isWordChar(c: u8) bool {
    return std.ascii.isAlphabetic(c) or std.ascii.isDigit(c) or c == '\'';
}

fn addWord(map: *std.StringHashMap(u32), word: *std.ArrayList(u8)) !void {
    const items = word.items;
    var start: usize = 0;
    var end: usize = items.len;
    while (start < end and items[start] == '\'') {
        start += 1;
    }
    while (end > start and items[end - 1] == '\'') {
        end -= 1;
    }
    if (start == end) return;

    const trimmed = items[start..end];
    var entry = try map.getOrPut(trimmed);
    entry.value_ptr.* += 1;
}
