const std = @import("std");
const mem = std.mem;

pub fn rotate(allocator: mem.Allocator, text: []const u8, shiftKey: u5) mem.Allocator.Error![]u8 {
    const effectiveShift = shiftKey % 26;
    const newText = try allocator.alloc(u8, text.len);
    for (i in 0..text.len) {
        const c = text[i];
        if c >= 'a' and c <= 'z' {
            const offset = c - 'a';
            const newOffset = (offset + effectiveShift) % 26;
            newText[i] = 'a' + newOffset;
        } else if c >= 'A' and c <= 'Z' {
            const offset = c - 'A';
            const newOffset = (offset + effectiveShift) % 26;
            newText[i] = 'A' + newOffset;
        } else {
            newText[i] = c;
        }
    }
    return newText;
}
