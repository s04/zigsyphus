const std = @import("std");
const mem = std.mem;

fn isWordCharacter(chars: []const u8, index: usize) bool {
    const c = chars[index];

    if (std.ascii.isAlphabetic(c) or std.ascii.isDigit(c)) {
        return true;
    }
    if (c != 0x27) {
        return false;
    }

    return index > 0
        and index + 1 < chars.len
        and std.ascii.isAlphabetic(chars[index - 1])
        and std.ascii.isAlphabetic(chars[index + 1]);
}

/// Returns the counts of the words in `s`.
/// Caller owns the returned memory.
pub fn countWords(allocator: mem.Allocator, s: []const u8) !std.StringHashMap(u32) {
    var words = try std.StringHashMap(u32).init(allocator);
    defer words.deinit();

    var i: usize = 0;
    while (i < s.len) : (i += 1) {
        while (i < s.len and !isWordCharacter(s, i)) {
            i += 1;
        }
        if (i == s.len) {
            break;
        }

        const start = i;
        while (i < s.len and isWordCharacter(s, i)) {
            i += 1;
        }

        var key = try allocator.alloc(u8, i - start);
        var key_owned = false;
        errdefer if (!key_owned) {
            allocator.free(key);
        }

        for (key) |*c| {
            c.* = std.ascii.toLower(c.*);
        }

        const entry = try words.getOrPut(key);
        if (!entry.found_entry) {
            entry.value_ptr.* = 0;
        }
        entry.value_ptr.* += 1;
        key_owned = true;
    }

    return words;
}
