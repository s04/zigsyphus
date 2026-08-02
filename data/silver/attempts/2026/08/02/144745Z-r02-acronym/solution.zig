const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var word_count: usize = 0;
    var in_word = false;

    for (words) |c| {
        if (std.ascii.isAlphabetic(c)) {
            if (!in_word) {
                word_count += 1;
                in_word = true;
            }
        } else if (c == ' ' or c == '-') {
            in_word = false;
        }
    }

    const result = try allocator.alloc(u8, word_count);

    var idx: usize = 0;
    in_word = false;

    for (words) |c| {
        if (std.ascii.isAlphabetic(c)) {
            if (!in_word) {
                result[idx] = std.ascii.toUpper(c);
                idx += 1;
                in_word = true;
            }
        } else if (c == ' ' or c == '-') {
            in_word = false;
        }
    }

    return result;
}
