const std = @import("std");

pub fn truncate(phrase: []const u8) []const u8 {
    const codepoints = try std.mem.parseUtf8(phrase);
    const max_bytes = 5 * 4;
    const buffer = try std.heap.page_allocator.alloc(u8, max_bytes);
    var written: usize = 0;
    var i: usize = 0;
    for (codepoints) |cp| {
        if (i >= 5) break;
        const bytes = @utf8FromCodepoint(cp.codepoint);
        buffer[written..written + bytes.len] = bytes;
        written += bytes.len;
        i += 1;
    }
    return buffer[0..written];
}
