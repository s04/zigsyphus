const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) mem.Allocator.Error![][]u8 {
    var list = std.ArrayList([]u8).init(allocator);
    errdefer list.deinit();

    if (words.len == 0) {
        return list.toOwnedSlice();
    }

    for (words[0..words.len-1], 0..) |word, idx| {
        const next = words[idx+1];
        const line = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ word, next });
        try list.append(line);
    }
    const last_line = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{words[0]});
    try list.append(last_line);

    return list.toOwnedSlice();
}
