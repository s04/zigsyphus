const std = @import("std");
const mem = std.mem;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    var stack = std.ArrayList(u8).init(allocator);
    defer stack.deinit();
    
    for (s) |c| {
        if (c == '(' or c == '{' or c == '[') {
            try stack.append(c);
        } else if (c == ')' or c == '}' or c == ']') {
            if (stack.items.len == 0) return false;
            const top = stack.items[stack.items.len - 1];
            if ((c == ')' and top == '(') or (c == '}' and top == '{') or (c == ']' and top == '[')) {
                stack.items.len -= 1;
            } else {
                return false;
            }
        }
    }
    return stack.items.len == 0;
}
