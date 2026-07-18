const std = @import("std");
const mem = std.mem;

pub fn transform(
    allocator: mem.Allocator,
    legacy: std.AutoHashMap(i5, []const u8),
) mem.Allocator.Error!std.AutoHashMap(u8, i5) {
    var result = std.AutoHashMap(u8, i5).init(allocator);

    var it = legacy.keyIterator();
    while (it.next()) |score_ptr| {
        const score = score_ptr.*;
        const letters = legacy.get(score).?;

        var i: usize = 0;
        while (i < letters.len) : (i += 1) {
            const char = letters[i];
            if (std.ascii.isAlphabetic(char)) {
                const lower = std.ascii.toLower(char);
                try result.put(lower, score);
            }
        }
    }

    return result;
}
