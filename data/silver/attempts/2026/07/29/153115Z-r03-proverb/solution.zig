const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn recite(allocator: mem.Allocator, words: []const []const u8) mem.Allocator.Error![][]u8 {
    if (words.len == 0) {
        return allocator.alloc([][]u8, 0);
    }
    const result = try allocator.alloc([][]u8, words.len);
    var i: usize = 0;
    errdefer {
        if (i < words.len) {
            for (result[0..i]) |line| {
                allocator.free(line);
            }
            allocator.free(result);
        }
    };
    for (words[0..words.len-1], 0..) |word, idx| {
        const next = words[idx+1];
        const line = try fmt.allocPrint(allocator, "For want of a {s} the {s} was lost.\n", .{ word, next });
        result[i] = line;
        i += 1;
    }
    const last = try fmt.allocPrint(allocator, "And all for the want of a {s}.\n", .{ words[0] });
    result[i] = last;
    i += 1;
    return result;
}
