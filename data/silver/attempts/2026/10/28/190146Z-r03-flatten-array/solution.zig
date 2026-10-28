const std = @import("std");
const mem = std.mem;

pub const Box = union(enum) {
    none,
    one: i12,
    many: []const Box,
};

fn countOnes(box: Box) usize {
    return switch (box) {
        .none => 0,
        .one => 1,
        .many => |children| countMany(children),
    };
}

fn countMany(children: []const Box) usize {
    var c: usize = 0;
    for (children) |child| {
        c += countOnes(child);
    }
    return c;
}

fn fillOnes(box: Box, result: []i12, idx: *usize) void {
    switch (box) {
        .none => {},
        .one => |v| {
            result[idx.*] = v;
            idx.* += 1;
        },
        .many => |children| {
            for (children) |child| {
                fillOnes(child, result, idx);
            }
        },
    }
}

pub fn flatten(allocator: mem.Allocator, box: Box) mem.Allocator.Error![]i12 {
    const total = countOnes(box);
    const result = try allocator.alloc(i12, total);
    var idx: usize = 0;
    fillOnes(box, result, &idx);
    return result;
}
