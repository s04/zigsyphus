const std = @import("std");
const mem = std.mem;

fn isWordChar(c: u8) bool {
    return std.ascii.isAlphabetic(c) or std.ascii.isDigit(c) or c == '\'';
}

pub fn countWords(allocator: mem.Allocator, s: []const u8) !std.StringHashMap(u32) {
    var map = std.StringHashMap(u32).init(allocator);
    errdefer map.deinit();

    var i: usize = 0;
    while (i < s.len) {
        // Skip separators (non-word characters)
        while (i < s.len and !isWordChar(s[i])) {
            i += 1;
        }
        if (i >= s.len) break;

        const start = i;
        while (i < s.len and isWordChar(s[i])) {
            i += 1;
        }
        var word = s[start..i];

        // Strip leading apostrophes
        while (word.len > 0 and word[0] == '\'') {
            word = word[1..];
        }
        // Strip trailing apostrophes
        while (word.len > 0 and word[word.len - 1] == '\'') {
            word = word[0 .. word.len - 1];
        }

        if (word.len == 0) continue;

        // Convert to lowercase and allocate a copy
        const word_lower = try allocator.alloc(u8, word.len);
        errdefer allocator.free(word_lower);
        for (word) |c, j| {
            word_lower[j] = std.ascii.toLower(c);
        }

        // Update count in map
        if (map.get(word_lower)) |count| {
            count.* += 1;
            allocator.free(word_lower); // key already exists, free our copy
        } else {
            try map.put(word_lower, 1); // map takes ownership of word_lower
        }
    }

    return map;
}
