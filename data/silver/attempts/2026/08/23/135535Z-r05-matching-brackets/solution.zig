const std = @import("std");
const mem = std.mem;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    var buf: []u8 = try allocator.alloc(u8, s.len);
    defer allocator.free(buf);
    var stackPos: usize = 0;
    for (s) |c| {
        switch (c) {
            '(', '{', '[' => {
                const expected = switch (c) {
                    '(' => ')',
                    '{' => '}',
                    '[' => ']',
                    else => unreachable,
                };
                if (stackPos >= buf.len) {
                    return false;
                }
                buf[stackPos] = expected;
                stackPos += 1;
            },
            ')', '}', ']' => {
                if (stackPos == 0) {
                    return false;
                }
                stackPos -= 1;
                if (buf[stackPos] != c) {
                    return false;
                }
            },
            else => {},
        }
    }
    return stackPos == 0;
}
