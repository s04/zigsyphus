const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) mem.Allocator.Error![]u8 {
    const n = words.len;
    if (n == 0) {
        return []u8{};
    }

    const outer = try allocator.alloc(u8, n * @SizeOf([]u8));
    const slice_array = @ptrCast([]u8, outer);
    var slices = slice_array[0..n];

    for (0..words.len - 1, 0..) |i| {
        const word = words[i];
        const next = words[i + 1];
        const line = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ word, next });
        slices[i] = line;
    }

    const final_line = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{words[0]});
    slices[n - 1] = final_line;

    return slices;
}
