const std = @import("std");

pub fn truncate(phrase: []const u8) []const u8 {
    var byte_index: usize = 0;
    var codepoint_count: usize = 0;

    while (byte_index < phrase.len and codepoint_count < 5) {
        const slice = phrase[byte_index..];
        const cp = std.unicode.utf8Decode(slice) catch break;
        _ = cp;
        
        // Determine the length of the current UTF-8 codepoint manually
        // based on the leading byte to avoid non-existent std.unicode.utf8DecodeLen
        const first_byte = slice[0];
        const len: usize = if (first_byte & 0x80 == 0)
            1
        else if (first_byte & 0xE0 == 0xC0)
            2
        else if (first_byte & 0xF0 == 0xE0)
            3
        else if (first_byte & 0xF8 == 0xF0)
            4
        else
            1; // Should not happen in valid UTF-8

        byte_index += len;
        codepoint_count += 1;
    }

    return phrase[0..byte_index];
}
