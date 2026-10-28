const std = @import("std");
const mem = std.mem;

pub const Box = union(enum) {
    none,
    one: i12,
    many: []const Box,
};

pub fn flatten(allocator: mem.Allocator, box: Box) mem.Allocator.Error![]i12 {
    // Count total number of .one values
    fn count(b: Box) usize {
        return switch (b) {
            .none => 0,
            .one => 1,
            .many => |children| blk: {
                var c: usize = 0;
                for (children) |child| {
                    c += count(child);
                }
                break :blk c;
            },
        };
    }

    const total = count(box);
    const result = try allocator.alloc(i12, total);

    // Fill result
    var idx: usize = 0;
    fn fill(b: Box) void {
        switch (b) {
            .none => {},
            .one => |v| {
                result[idx] = v;
                idx += 1;
            },
            .many => |children| {
                for (children) |child| {
                    fill(child);
                }
            },
        }
    }
    fill(box);

    return result;
}
