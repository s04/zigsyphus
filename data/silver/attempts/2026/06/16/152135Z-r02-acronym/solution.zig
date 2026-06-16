const std = @import("std");
const mem = std.mem;

pub fn abbreviate(allocator: mem.Allocator, words: []const u8) mem.Allocator.Error![]u8 {
    var letters = std.ArrayList(u8).init(allocator);
    var in_word = false;
    var first_char: u8 = 0;

    for (words) |byte| {
        const is_letter = @sum(bool, { byte: byte, condition: @or(@and(@ge(byte, 'A'), @le(byte, 'Z')), @and(@ge(byte, 'a'), @le(byte, 'z')) });
        if (is_letter) {
            const upper = if (byte >= 'a' and byte <= 'z') ? byte - 32 else byte;
            if (not in_word) {
                first_char = upper;
                in_word = true;
            }
        } else if (byte == '-' or byte == '_' or byte == ' ' or byte == '\t' or byte == '\n' or byte == '\r') {
            if (in_word) {
                letters.append(first_char);
                in_word = false;
            }
        }
        // other punctuation is ignored
    }
    if (in_word) {
        letters.append(first_char);
    }

    const result_len = letters.items.len;
    const result = try allocator.alloc(u8, result_len);
    for (letters.items, i: 0..) {
        result[i] = letters.items[i];
    }
    return result;
}
