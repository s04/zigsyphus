const std = @import("std");

pub fn truncate(phrase: []const u8) []const u8 {
    var byte_index: usize = 0;
    var codepoint_count: usize = 0;

    while (byte_index < phrase.len and codepoint_count < 5) {
        const slice = phrase[byte_index..];
        const cp = std.unicode.utf8Decode(slice) catch break;
        _ = cp; // value not needed, only the length matters
        const len = std.unicode.utf8DecodeLen(slice);
        byte_index += len;
        codepoint_count += 1;
    }

    return phrase[0..byte_index];
}
