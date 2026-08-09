const std = @import("std");

pub fn truncate(phrase: []const u8) []const u8 {
    var byte_index: usize = 0;
    var codepoint_count: usize = 0;

    while (byte_index < phrase.len and codepoint_count < 5) {
        const first_byte = phrase[byte_index];
        var len: usize = 1;
        if (first_byte & 0x80 == 0) {
            // 1-byte
        } else if (first_byte & 0xE0 == 0xC0) {
            len = 2;
        } else if (first_byte & 0xF0 == 0xE0) {
            len = 3;
        } else if (first_byte & 0xF8 == 0xF0) {
            len = 4;
        } else {
            len = 1; // Invalid UTF-8, treat as 1-byte
        }

        if (byte_index + len > phrase.len) break;

        const cp_slice = phrase[byte_index..byte_index + len];
        const cp = std.unicode.utf8Decode(cp_slice) catch break;
        _ = cp;

        byte_index += len;
        codepoint_count += 1;
    }

    return phrase[0..byte_index];
}
