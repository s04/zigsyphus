const std = @import("std");

pub fn truncate(phrase: []const u8) []const u8 {
    var byte_index: usize = 0;
    var codepoint_count: usize = 0;

    while (byte_index < phrase.len and codepoint_count < 5) {
        var cp: u21 = 0;
        const len = std.unicode.utf8Decode(phrase[byte_index..], &cp);
        if (len == 0) break; // malformed UTF‑8, stop processing
        byte_index += len;
        codepoint_count += 1;
    }

    return phrase[0..byte_index];
}
