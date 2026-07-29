const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) mem.Allocator.Error![][]u8 {
    if (words.len == 0) {
        return &[_][]u8{};
    }

    const result = try allocator.alloc([]u8, words.len);

    var i: usize = 0;
    while (i < words.len - 1) : (i += 1) {
        const line = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ words[i], words[i + 1] });
        result[i] = line;
    }

    const last_line = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{words[0]});
    result[words.len - 1] = last_line;

    return result;
}
